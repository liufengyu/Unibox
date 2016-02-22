//
//  CommitViewController.m
//  Unibox_iOS
//
//  Created by 刘羽 on 16/1/6.
//  Copyright © 2016年 刘羽. All rights reserved.
//

#import "CommitViewController.h"
#import "Masonry.h"
#import "Header.h"
#import "UIImageView+WebCache.h"
#import "API.h"
#import "NetWork.h"
#import "AppDelegate.h"
#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self
@interface CommitViewController () <UITextViewDelegate>
{
    //评论输入框
    UITextView *_commText;
    //评论星级
    NSString *_score;
}
@end

@implementation CommitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"评价";
    self.view.backgroundColor = kWhite_Main;
    _score = @"0";
    //添加导航栏
    [self addNaviBar];
    
    [self setup];
}

#pragma mark 添加导航栏
- (void)addNaviBar{
    UIView *naviBar = [UIView new];
    naviBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:naviBar];
    WS(ws);
    [naviBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.equalTo(ws.view);
        make.height.equalTo(@64.0);
    }];
    
}

- (void)setup{
    WS(ws);
    UIView *bgView = [UIView new];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(ws.view);
        make.top.equalTo(ws.view).offset(74);
        make.height.equalTo(@290);
    }];
    //    80 90
    //影片图片
    UIImageView *movieImg = [UIImageView new];
    [bgView addSubview:movieImg];
    [movieImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_IP,_model.movieImg]] placeholderImage:imageNamed(@"placehold") options:SDWebImageLowPriority];
    [movieImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(10);
        make.top.equalTo(bgView).offset(15);
        make.width.equalTo(@80);
        make.height.equalTo(@90);
    }];
    
    //影片名
    UILabel *movieName = [UILabel new];
    //movieName.autoresizesSubviews = YES;
    movieName.text = _model.movieName;
    movieName.font = [UIFont systemFontOfSize:12.0];
    movieName.textColor = [UIColor blackColor];
    [bgView addSubview:movieName];
    
    UILabel *pickupLb = [UILabel new];
    pickupLb.text = @"取碟码:";
    pickupLb.font = [UIFont systemFontOfSize:12.0];
    pickupLb.textColor = [UIColor lightGrayColor];
    [bgView addSubview:pickupLb];
    
    
    UILabel *reserveTimeLb = [UILabel new];
    reserveTimeLb.text = @"下单时间:";
    reserveTimeLb.font = [UIFont systemFontOfSize:12.0];
    reserveTimeLb.textColor = [UIColor lightGrayColor];
    [bgView addSubview:reserveTimeLb];
    
    UILabel *pickupAddressLb = [UILabel new];
    pickupAddressLb.text = @"取碟位置:";
    pickupAddressLb.font = [UIFont systemFontOfSize:10.0];
    pickupAddressLb.textColor = [UIColor lightGrayColor];
    [bgView addSubview:pickupAddressLb];
    
    [movieName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(movieImg);
        make.left.equalTo(movieImg.mas_right).offset(30);
        //make.height.equalTo(pickupLb).equalTo(reserveTimeLb).equalTo(pickupAddressLb);
        make.height.equalTo(@(90/4));
        make.width.equalTo(@90);
    }];
    
    [pickupLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(movieName);
        make.top.equalTo(movieName.mas_bottom);
        make.height.equalTo(@(90/4));
    }];
    
    [reserveTimeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(movieName);
        make.top.equalTo(pickupLb.mas_bottom);
        make.height.equalTo(@(90/4));
    }];
    
    [pickupAddressLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(movieName);
        make.bottom.equalTo(movieImg.mas_bottom);
        make.height.equalTo(@(90/4));
    }];
    
    //取碟码
    UILabel *pickupCode = [UILabel new];
    pickupCode.font = [UIFont systemFontOfSize:12.0];
    pickupCode.textColor = [UIColor lightGrayColor];
    pickupCode.text = _model.pickupCode;
    [bgView addSubview:pickupCode];
    
    //下单时间
    UILabel *resTimeLb = [UILabel new];
    resTimeLb.font = [UIFont systemFontOfSize:12.0];
    resTimeLb.textColor = [UIColor lightGrayColor];
    resTimeLb.text = _model.reserveTime;
    [bgView addSubview:resTimeLb];
    
    //取碟位置
    UILabel *pupAddressLb = [UILabel new];
    pupAddressLb.font = [UIFont systemFontOfSize:10.0];
    pupAddressLb.textColor = [UIColor lightGrayColor];
    pupAddressLb.text = _model.pickupAddress;
    [bgView addSubview:pupAddressLb];
    
    [pickupCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(pickupLb.mas_right).offset(5);
        make.top.equalTo(pickupLb);
        make.height.equalTo(pickupLb);
    }];
    
    [resTimeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(reserveTimeLb.mas_right).offset(5);
        make.top.equalTo(reserveTimeLb);
        make.height.equalTo(reserveTimeLb);
    }];
    
    [pupAddressLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(pickupAddressLb.mas_right).offset(5);
        make.top.equalTo(pickupAddressLb);
        make.height.equalTo(pickupAddressLb);
    }];

    //押金
    UILabel *depLb = [UILabel new];
    depLb.textColor = kRed;
    depLb.text = _model.deposit;
    depLb.font = [UIFont systemFontOfSize:12.0];
    [bgView addSubview:depLb];
    
    UILabel *depositLb = [UILabel new];
    depositLb.textColor = [UIColor blackColor];
    depositLb.text = @"押金:";
    depositLb.font = [UIFont systemFontOfSize:12.0];
    [bgView addSubview:depositLb];
    
    [depLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView).offset(-10);
        make.top.equalTo(movieName);
        make.height.equalTo(movieName);
    }];
    
    [depositLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(depLb.mas_left).offset(-5);
        make.top.equalTo(depLb);
        make.height.equalTo(depLb);
    }];
    
    //分割线
    UIView *lineView = [UIView new];
    lineView.backgroundColor = kLightgray;
    [bgView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(bgView);
        make.top.equalTo(movieImg.mas_bottom).offset(15);
        make.height.equalTo(@1);
    }];
    
    //影片评分
    UILabel *movieMarkLb = [UILabel new];
    movieMarkLb.text = @"影片评分";
    movieMarkLb.textColor = [UIColor blackColor];
    movieMarkLb.font = [UIFont systemFontOfSize:13.0];
    [bgView addSubview:movieMarkLb];
    
    //星级图片
    UIImageView *grayStartImg = [[UIImageView alloc]initWithImage:imageNamed(@"com-graystar")];
    grayStartImg.userInteractionEnabled = YES;
    [bgView addSubview:grayStartImg];
    
    //评论星级
    UIImageView *commStar = [[UIImageView alloc]init];
    commStar.userInteractionEnabled = YES;
    commStar.backgroundColor = [UIColor clearColor];
    commStar.tag = 45000;
    [grayStartImg addSubview:commStar];
    
    
    
    [movieMarkLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(movieImg);
        make.top.equalTo(lineView.mas_bottom).offset(15);
    }];
    
    [grayStartImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView.mas_right).offset(-10);
        make.top.equalTo(movieMarkLb);
    }];
    
    [commStar mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.edges.equalTo(grayStartImg);
        make.right.equalTo(grayStartImg);
        make.top.equalTo(grayStartImg);
    }];
    
    //评论输入框
    UITextView *commText = [UITextView new];
    commText.layer.borderColor = kLightgray.CGColor;
    commText.layer.borderWidth = 1.0;
    commText.textColor = [UIColor blackColor];
    commText.font = [UIFont systemFontOfSize:12.0];
    commText.delegate = self;
    commText.returnKeyType = UIReturnKeyDone;
    _commText = commText;
    [bgView addSubview:commText];
    
    UILabel *placeholdLb = [UILabel new];
    placeholdLb.text = @"请输入想说的话,100字以内。";
    placeholdLb.textColor = kLightgray;
    placeholdLb.font = [UIFont systemFontOfSize:12.0];
    placeholdLb.tag = 44000;
    [commText addSubview:placeholdLb];
    
    [commText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(movieImg);
        make.right.equalTo(grayStartImg);
        make.top.equalTo(grayStartImg.mas_bottom).offset(20);
        make.bottom.equalTo(bgView.mas_bottom).offset(-50);
    }];
    
    [placeholdLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(commText).offset(5);
        make.top.equalTo(commText).offset(7);
    }];
    
    //发送按钮
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.backgroundColor = kRed;
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    sendButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [sendButton addTarget:self action:@selector(sendComm) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:sendButton];
    
    [sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(commText);
        make.top.equalTo(commText.mas_bottom).offset(10);
        make.width.equalTo(@50);
        make.height.equalTo(@27);
    }];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panOnStar:)];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnStar:)];
    [grayStartImg addGestureRecognizer:pan];
    [grayStartImg addGestureRecognizer:tap];
}

- (void)textViewDidChange:(UITextView *)textView{
    UILabel *placeholdLb = (UILabel *)[self.view viewWithTag:44000];
    if ([textView.text length] == 0) {
        if (placeholdLb.hidden) {
            placeholdLb.hidden = NO;
        }
    } else {
        if (placeholdLb.hidden == NO) {
            placeholdLb.hidden = YES;
        }
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    if (text.length + textView.text.length > 100) {
        return NO;
    } else {
        return YES;
    }
}

- (void)panOnStar:(UIPanGestureRecognizer *)pan{
    CGPoint point = [pan locationInView:pan.view];
    UIImageView *commStar = (UIImageView *)[self.view viewWithTag:45000];
    if (point.x <= 152.0 / 5) {
        commStar.image = imageNamed(@"com-wuxing");
        _score = @"5";
    } else if (point.x > 152.0 / 5 && point.x <= 152.0 / 5 * 2) {
        commStar.image = imageNamed(@"com-sixing");
        _score = @"4";
    } else if (point.x > 152.0 / 5 * 2 && point.x <= 152.0 / 5 * 3) {
        commStar.image = imageNamed(@"com-sanxing");
        _score = @"3";
    } else if (point.x > 152.0 / 5 * 3 && point.x <= 152.0 / 5 * 4) {
        commStar.image = imageNamed(@"com-erxing");
        _score = @"2";
    } else if (point.x > 152.0 / 5 * 4 && point.x <= 152.0) {
        commStar.image = imageNamed(@"com-yixing");
        _score = @"1";
    }
}

- (void)tapOnStar:(UITapGestureRecognizer *)tap{
    //152;
    CGPoint point = [tap locationInView:tap.view];
    UIImageView *commStar = (UIImageView *)[self.view viewWithTag:45000];
    if (point.x <= 152.0 / 5) {
        commStar.image = imageNamed(@"com-wuxing");
        _score = @"5";
    } else if (point.x > 152.0 / 5 && point.x <= 152.0 / 5 * 2) {
        commStar.image = imageNamed(@"com-sixing");
        _score = @"4";
    } else if (point.x > 152.0 / 5 * 2 && point.x <= 152.0 / 5 * 3) {
        commStar.image = imageNamed(@"com-sanxing");
        _score = @"3";
    } else if (point.x > 152.0 / 5 * 3 && point.x <= 152.0 / 5 * 4) {
        commStar.image = imageNamed(@"com-erxing");
        _score = @"2";
    } else if (point.x > 152.0 / 5 * 4 && point.x <= 152.0) {
        commStar.image = imageNamed(@"com-yixing");
        _score = @"1";
    }
}

#pragma mark 发送评论
- (void)sendComm{
    NSString *content = _commText.text;
    if (content.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示信息" message:@"评论不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if ([_score isEqualToString:@"0"]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示信息" message:@"星级不能为零星" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    NSDictionary *dic = @{
                          @"titleId":_model.titleId,
                          @"score":_score,
                          @"content":content,
                          @"rentalId":_model.rentalId,
                          @"_accessToken":[User objectForKey:kAccessToken],
                          @"_memberId":[User objectForKey:kMemberId]
                          };
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [NetWork getRequest:[NSString stringWithFormat:@"http://%@%@",app.host_ip,addComment] params:dic success:^(id responseObj) {
        NSLog(@"%@",responseObj);
        if (![responseObj[@"ret"]boolValue]) {
            JGProgressHUD *hud = [[JGProgressHUD alloc]initWithStyle:JGProgressHUDStyleDark];
            hud.indicatorView = [[JGProgressHUDSuccessIndicatorView alloc]init];
            [hud showInView:self.navigationController.view];
            [hud dismissAfterDelay:1];
            [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
        } else {
            JGProgressHUD *hud = [[JGProgressHUD alloc]initWithStyle:JGProgressHUDStyleDark];
            hud.indicatorView = [[JGProgressHUDErrorIndicatorView alloc]init];
            [hud showInView:self.navigationController.view];
            [hud dismissAfterDelay:1];
        }
    } failure:^(NSError *error) {
        //
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
