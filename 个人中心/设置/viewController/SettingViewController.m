//
//  SettingViewController.m
//  Unibox_iOS
//
//  Created by 刘羽 on 15/12/6.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import "SettingViewController.h"
#import "Header.h"
#import "NohightButton.h"
#import "TYAlertController.h"
#import "FavButton.h"
#import "SDImageCache.h"
#import "FeedbackController.h"
#import "VersionController.h"
#import "RentalNoticeController.h"
#import "ShareButton.h"
#import "Masonry.h"
#import "WXApi.h"
#import <TencentOpenAPI/TencentApiInterface.h>
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import <MessageUI/MessageUI.h>
#import "AboutusViewController.h"

@interface SettingViewController () <UITableViewDataSource, UITableViewDelegate,MFMessageComposeViewControllerDelegate>
{
    NSArray *_titleArr;
    TYAlertController *_alert;
    UITableView *_tb;
    //UIView *_shareView;
}
@end

@implementation SettingViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置";
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    [self configLeftBar];
    self.view.backgroundColor = RGB(232, 233, 232);
    _titleArr = @[@[/*@"网络设置",@"消息推送",*/@"分享给朋友",@"清除缓存"],@[/*@"意见反馈",@"版本更新",*/@"关于我们"/*,@"恢复默认设置"*/]];
    //创建ui
    [self createUI];
}

#pragma mark 创建UI
- (void)createUI{
    UITableView *tb = [[UITableView alloc]initWithFrame:CGRectMake(10, 64, kScreenWidth - 20, kScreenHeight - 64.0) style:UITableViewStyleGrouped];
    _tb = tb;
    tb.backgroundColor = [UIColor clearColor];
    tb.delegate = self;
    tb.dataSource = self;
    tb.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tb];
    
    //头视图
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tb.width, 122.0)];
    headView.backgroundColor = [UIColor clearColor];
    tb.tableHeaderView = headView;
    
    //头像
    UIImageView *touxiang = [MyControl createImageViewFrame:CGRectMake((headView.width - 64) / 2, 15, 64, 64) imageName:@"set-man"];
    [headView addSubview:touxiang];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _titleArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_titleArr[section] count];
    return [_titleArr[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *iden = @"popop";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    if (cell.contentView.subviews.count) {
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
    }
    
    //if (indexPath.section == 0 && indexPath.row == 1) {
//        NohightButton *btn = [NohightButton buttonWithType:UIButtonTypeCustom];
//        btn.frame = CGRectMake(0, 0, 65, 25);
//        [btn setBackgroundImage:imageNamed(@"set-kai") forState:UIControlStateNormal];
//        [btn setBackgroundImage:imageNamed(@"set-guan") forState:UIControlStateSelected];
//        [btn addTarget:self action:@selector(switchBtnClick:) forControlEvents:UIControlEventTouchDown];
//        cell.accessoryView = btn;
   // } else {
        cell.accessoryView = [[UIImageView alloc]initWithImage:imageNamed(@"set-access")];
    //}
   // cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _titleArr[indexPath.section][indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14.f];
    if (indexPath.row != 3) {
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 49.0, kScreenWidth - 20, 1)];
        line.backgroundColor = RGB(241, 241, 241);
        [cell.contentView addSubview:line];
    }
    if (indexPath.section == 0 && indexPath.row == 1){
        //SDImageCache *cache = [SDImageCache sharedImageCache];
       // NSLog(@"%u",[cache getSize]);
        [self calculateCache];
        UILabel *label = [MyControl createLabelWithFrame:CGRectMake(0, 0, 100, 30) Font:14.0 Text:[self calculateCache]];
        label.numberOfLines = 1;
        [label sizeToFit];
        label.x = kScreenWidth - 20 - label.width - 30;
        label.y = (50 - label.height) / 2;
        [cell.contentView addSubview:label];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //网络设置
            //分享给朋友
            [self actionSheet];
        } else if (indexPath.row == 1) {
            //消息推送
            //清除缓存
            [self showAlert:@"确认清除缓存？"];
            //            [[SDImageCache sharedImageCache] clearDisk];
        }
    } else {
//        if (indexPath.row == 0) {
//            //意见反馈
//            FeedbackController *vc = [[FeedbackController alloc]init];
//            //
//            [self.navigationController pushViewController:vc animated:YES];
//        } else if (indexPath.row == 1) {
//            //版本更新
//            VersionController *vc = [[VersionController alloc]init];
//            //
//            [self.navigationController pushViewController:vc animated:YES];
//        } else if (indexPath.row == 2) {
//            //关于我们
//        } else {
//            //恢复默认设置
//            [self showAlert:@"确认恢复默认设置？"];
//        }
        if (indexPath.row == 0) {
            //关于我们
//            RentalNoticeController *vc = [[RentalNoticeController alloc]init];
            AboutusViewController *vc = [[AboutusViewController alloc]init];
            //vc.type = NO;
            [self configLeftBar];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

//设置推送开关
- (void)switchBtnClick:(NohightButton *)btn{
    btn.selected = !btn.selected;
}

- (void)actionSheet{
    UIView *share = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 290)];
    share.backgroundColor = kWhite_Main;
    NSArray *btnArr = @[@"share-wx",@"share-pyq",@"share-qq",@"share-kongjian",@"share-paste",@"share-message"];
    UILabel *label = [UILabel new];
    label.text = @"分享UNIBOX";
    label.font = [UIFont systemFontOfSize:14.0];
    label.textColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentCenter;
    [share addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(share);
        make.top.equalTo(share).and.offset(10);
    }];
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = kLightgray;
    [share addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(10);
        make.right.and.left.equalTo(share);
        make.height.equalTo(@1);
    }];
    
    
    ShareButton *lastBtn = nil;
    
    NSNumber *width = [NSNumber numberWithFloat:kScreenWidth / 4];
    NSNumber *height = [NSNumber numberWithFloat:70.0];
    int count = 0;
    for (int i = 0; i < btnArr.count; i++) {
        ShareButton *btn = [ShareButton buttonWithType:UIButtonTypeCustom];
        //[btn setTitle:[btnArr[i] objectForKey:@"title"] forState:UIControlStateNormal];
        [btn setImage:imageNamed(btnArr[i]) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 14500 + i;
        [share addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(width);
            make.height.equalTo(height);
            if (lastBtn) {
               // NSLog(@"%f",CGRectGetMaxX(lastBtn.frame));
                if (count % 4 == 0) {
                    make.left.equalTo(share);
                    make.top.equalTo(lastBtn.mas_bottom);
                } else {
                    make.left.equalTo(lastBtn.mas_right);
                    make.top.equalTo(lastBtn);
                }
            } else {
                make.left.equalTo(share);
                make.top.equalTo(label.mas_bottom).and.offset(15);
            }
        }];
        if (i == 2 || i == 3) {
            if ([TencentApiInterface isTencentAppInstall:kIphoneQQ]) {
                lastBtn = btn;
                count++;
            } else {
                btn.hidden = YES;
            }
        } else if (i == 0 || i == 1){
            if ([WXApi isWXAppSupportApi]) {
                lastBtn = btn;
                count++;
            } else {
                btn.hidden = YES;
            }
        } else {
            lastBtn = btn;
            count++;
        }
    }
    if (count <= 3) {
        share.height -= 60;
    }
    
    
    //取消按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelShare) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.backgroundColor = [UIColor whiteColor];
    [share addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(share).and.offset(-20);
        make.width.equalTo(@(kScreenWidth));
        make.centerX.equalTo(share);
        make.height.equalTo(@40);
    }];
    
    
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:share preferredStyle:TYAlertControllerStyleActionSheet];
    _alert = alertController;
    //_alertController = alertController;
    alertController.backgoundTapDismissEnable = YES;
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)shareBtnClick:(ShareButton *)btn{
    NSInteger type = btn.tag - 14500;
    [_alert dismissViewControllerAnimated:NO completion:nil];
    [UMSocialWechatHandler setWXAppId:Wechat_AppID appSecret:Wechat_AppSecret url:@"http://www.unibox.com.cn"];
    [UMSocialQQHandler setQQWithAppId:QQ_AppID appKey:QQ_Appkey url:@"http://www.unibox.com.cn"];
    if (type == 0) {
        //微信
        [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatSession] content:@"优尼博思,7星级观影体验" image:imageNamed(@"logo") location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response) {
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功");
            }
        }];
    } else if (type == 1) {
        //朋友圈
        [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatTimeline] content:@"优尼博思,7星级观影体验" image:imageNamed(@"logo") location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response) {
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功");
            }
        }];
    } else if (type == 2) {
        //QQ
        [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToQQ] content:@"优尼博思,7星级观影体验" image:imageNamed(@"logo") location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response) {
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功");
            }
        }];
    } else if (type == 3) {
        //QQ空间
        [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToQzone] content:@"优尼博思,7星级观影体验" image:imageNamed(@"logo") location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response) {
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功");
            }
        }];
    } else if (type == 4) {
        //复制链接
        UIPasteboard *pboard = [UIPasteboard generalPasteboard];
        pboard.string = @"http://www.unibox.com.cn";
        JGProgressHUD *hud = [[JGProgressHUD alloc]initWithStyle:JGProgressHUDStyleDark];
        hud.indicatorView = [[JGProgressHUDSuccessIndicatorView alloc]init];
        hud.textLabel.text = @"复制成功";
        hud.textLabel.font = [UIFont systemFontOfSize:14.0];
        [hud showInView:self.view];
        [hud dismissAfterDelay:1.0 animated:YES];
    } else if (type == 5) {
        //短信
        if( [MFMessageComposeViewController canSendText] ){
            MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc]init];
            //controller.recipients = [NSArray arrayWithObject:@"10010"];
            controller.body = [NSString stringWithFormat:@"优尼博思,7星级的观影体验 http://www.unibox.com.cn"];
            controller.messageComposeDelegate = self;
            
            [self presentViewController:controller animated:YES completion:nil];
            
            //[[[[controller viewControllers] lastObject] navigationItem] setTitle:@""];//修改短信界面标题
        }else{
            [self alertWithTitle:@"提示信息" msg:@"设备不支持"];
        }
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    
    [controller dismissViewControllerAnimated:NO completion:nil];//关键的一句   不能为YES
    
    switch ( result ) {
        case MessageComposeResultCancelled:
            [self alertWithTitle:@"提示信息" msg:@"发送取消"];
            break;
        case MessageComposeResultFailed:// send failed
            [self alertWithTitle:@"提示信息" msg:@"发送成功"];
            break;
        case MessageComposeResultSent:
            [self alertWithTitle:@"提示信息" msg:@"发送失败"];
            break;
        default:
            break;
    }
}

- (void)alertWithTitle:(NSString *)str msg:(NSString *)msg{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:str message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark 计算缓存
- (NSString *)calculateCache{
    SDImageCache *cache = [SDImageCache sharedImageCache];
    NSUInteger size = [cache getSize];
    if (size == 0) {
        return @"0M";
    }
    NSLog(@"%lu",size);
    NSString *cacheSize = nil;
    for (int i = 0; i < 3; i++) {
        if (size / 1024) {
            size = size / 1024;
        } else {
            if (i == 0) {
                //byte
                NSLog(@"%lubyte",size);
                cacheSize = [NSString stringWithFormat:@"%lubyte", size];
            } else if (i == 1) {
                //KB
                NSLog(@"%luKB",size);
                cacheSize = [NSString stringWithFormat:@"%luKB", size];
            } else if (i == 2) {
                //M
                NSLog(@"%luM",size);
                cacheSize = [NSString stringWithFormat:@"%luM", size];
            }
            break;
        }
    }
    return cacheSize;
}

- (void)showAlert:(NSString *)str{
    UIView *alertView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 260.0, 130.0)];
    alertView.backgroundColor = [UIColor whiteColor];
    alertView.layer.cornerRadius = 5.0f;
    
    //确定label
    UILabel *sureLb = [MyControl createLabelWithFrame:CGRectMake(10, 15, 200, 20) Font:14.0 Text:str];
    [alertView addSubview:sureLb];
    
    UIButton *sureBtn = [MyControl createButtonWithFrame:CGRectMake(10, alertView.height - 50, 80, 30) target:self SEL:@selector(sureBtnClick:) title:@"是"];
    if ([str isEqualToString:@"确认清除缓存？"]) {
        sureBtn.tag = 14600;
    } else {
        sureBtn.tag = 14601;
    }
    sureBtn.layer.cornerRadius = 5.0f;
    sureBtn.backgroundColor = kRed;
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [alertView addSubview:sureBtn];
    
    UIButton *cancelBtn = [MyControl createButtonWithFrame:CGRectMake(alertView.width - 10 - 80, sureBtn.y, 80, 30) target:self SEL:@selector(cancelBtnClick) title:@"否"];
    cancelBtn.layer.cornerRadius = 5.0f;
    cancelBtn.backgroundColor = RGB(253, 111, 74);
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [alertView addSubview:cancelBtn];
    
    TYAlertController *alert = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleAlert transitionAnimation:TYAlertTransitionAnimationDropDown];
    _alert = alert;
    alert.backgoundTapDismissEnable = YES;
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark 确认清理缓存

- (void)sureBtnClick:(UIButton *)btn{
    [_alert dismissViewControllerAnimated:YES completion:nil];
    _alert = nil;
    if (btn.tag == 14600) {
        if (![[SDImageCache sharedImageCache] getSize]) {
            JGProgressHUD *hud = [[JGProgressHUD alloc]initWithStyle:JGProgressHUDStyleDark];
            hud.indicatorView = nil;
            hud.textLabel.font = [UIFont systemFontOfSize:14.0];
            hud.textLabel.text = @"暂无缓存";
            hud.position = JGProgressHUDPositionBottomCenter;
            [hud showInView:self.view];
            [hud dismissAfterDelay:1.0f animated:YES];
            return;
        }
        [[SDImageCache sharedImageCache] clearDisk];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        [_tb reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        JGProgressHUD *hud = [[JGProgressHUD alloc]initWithStyle:JGProgressHUDStyleDark];
        hud.indicatorView = nil;
        hud.textLabel.font = [UIFont systemFontOfSize:14.0];
        hud.textLabel.text = @"清除缓存成功";
        hud.position = JGProgressHUDPositionBottomCenter;
        [hud showInView:self.view];
        [hud dismissAfterDelay:1.0f animated:YES];
    }
    
}

#pragma mark 取消清理缓存
- (void)cancelBtnClick{
    [_alert dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancelShare{
    [_alert dismissViewControllerAnimated:YES];
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
