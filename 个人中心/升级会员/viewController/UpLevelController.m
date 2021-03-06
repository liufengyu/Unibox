//
//  UpLevelController.m
//  Unibox_iOS
//
//  Created by 刘羽 on 15/12/6.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import "UpLevelController.h"
#import "Header.h"
#import "UpLevelTableViewCell.h"
#import "RankConfModel.h"
#import "PayViewController.h"
#import "UpLevelVCodeTableViewCell.h"
#import "VCodeTableViewCell.h"
#import "VerifyTableViewCell.h"
#import "NetWork.h"
#import "AppDelegate.h"
#import "API.h"
#import "UIImageView+WebCache.h"

//typedef NS_ENUM(NSInteger, MemberLevel){
//    MemberLevelCommon = 0,
//    MemberLevelYinka,
//    MemberLevelJinka,
//    MemberLevelZuanshi
//};

@interface UpLevelController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
   // NSMutableArray *_dataArr;
    //记录选中的按钮
    UIButton *_selectedBtn;
    //记录选择的会员等级
    NSInteger level;
    NSArray *_tempArr;
    BOOL isVCode;
    
    //UITableView
    UITableView *_tb;
    //会员码编辑框
    UITextField *_cardTextField;
    //验证码编辑框
    UITextField *_pCodeTextField;
    //下一步按钮
    UIButton *_nextButton;
}
@end

@implementation UpLevelController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"升级会员";
    isVCode = NO;
    //[self configLeftBar];
    self.view.backgroundColor = kLightgray;
    
    
    //[self.rank intValue];
    
    NSArray *tempArr1 = [self.rankArr objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange([self.rank intValue], self.rankArr.count - [self.rank intValue])]];
    
    NSArray *tempArr2 = [self.rankArr objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [self.rank intValue])]];
    
    
    _tempArr = @[tempArr2,tempArr1];
    

    
    //创建UI
    [self createUI];
    
    //键盘升起和降落的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

#pragma mark 键盘升起
- (void)keyboardWillShow:(NSNotification *)noti{
    CGRect keyboardBounds;
    [[noti.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    //NSLog(@"%@",note.userInfo);
    NSNumber *duration = [noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [noti.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    //CGRect frame = [self.view convertRect:_nextButton.frame fromView:_nextButton.superview];
    CGFloat height;
    if (_cardTextField.editing) {
        CGRect frame = [self.view convertRect:_cardTextField.frame fromView:_cardTextField.superview];
        //NSLog(@"%@",NSStringFromCGRect(frame));
        height = kScreenHeight - frame.origin.y - frame.size.height - keyboardBounds.size.height;
    } else {
        CGRect frame = [self.view convertRect:_pCodeTextField.frame fromView:_pCodeTextField.superview];
        height = kScreenHeight - frame.origin.y - frame.size.height - keyboardBounds.size.height;
    }
    
    if (height < 0.0) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:[duration doubleValue]];
        [UIView setAnimationCurve:[curve intValue]];
        [UIView setAnimationDelegate:self];
        _tb.y += height;
        [UIView commitAnimations];
    }
}
#pragma mark 键盘降落
- (void)keyboardWillHide:(NSNotification *)noti{
    CGRect keyboardBounds;
    [[noti.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [noti.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    if (_tb.y != 64) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:[duration doubleValue]];
        [UIView setAnimationCurve:[curve intValue]];
        [UIView setAnimationDelegate:self];
        _tb.y = 64.0;
        [UIView commitAnimations];
    }
}

#pragma mark 创建UI
- (void)createUI{
    UITableView *tb = [[UITableView alloc]initWithFrame:CGRectMake(10, 64.0, kScreenWidth - 20, kScreenHeight - 64.0) style:UITableViewStyleGrouped];
    _tb = tb;
    tb.backgroundColor = [UIColor clearColor];
    tb.separatorStyle = UITableViewCellSeparatorStyleNone;
    tb.showsVerticalScrollIndicator = NO;
    tb.delegate = self;
    tb.dataSource = self;
    //tb.scrollEnabled = NO;
    [tb registerNib:[UINib nibWithNibName:@"UpLevelTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ULCell"];
    [tb registerNib:[UINib nibWithNibName:@"UpLevelVCodeTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ULVCell"];
    [tb registerNib:[UINib nibWithNibName:@"VCodeTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ULVCCell"];
    [tb registerNib:[UINib nibWithNibName:@"VerifyTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ULVerCell"];
    [self.view addSubview:tb];
    
//    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth - 20, 45.0)];
//    UILabel *lb = [MyControl createLabelWithFrame:CGRectMake(5, 20, 200, 20) Font:14.0 Text:@"请选择会员级别:"];
//    lb.textColor = RGB(102, 102, 102);
//    [headView addSubview:lb];
//    tb.tableHeaderView = headView;
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth - 20, 125)];
    //下一步按钮
    UIButton *nextBtn = [MyControl createButtonWithFrame:CGRectMake(0, 25, footView.width, 50) target:self SEL:@selector(nextBtnClick) title:@"下一步"];
    _nextButton = nextBtn;
    nextBtn.backgroundColor = kRed;
    [footView addSubview:nextBtn];
    //注意事项
    UILabel *lb1 = [MyControl createLabelWithFrame:CGRectMake(30, CGRectGetMaxY(nextBtn.frame) + 5, footView.width - 30, 50) Font:10.0f Text:@"会员采用年费制,支付的年费一次性扣除；有效期一年。\n免租期是指在会员有效期内，每次免费租碟时间超过时间未归还碟片则收取租金。"];
    [footView addSubview:lb1];
    
    UIImageView *iv = [MyControl createImageViewFrame:CGRectMake(0, lb1.y + (lb1.height - 17) / 2, 17.0, 17.0) imageName:@"mem-tishi"];
    [footView addSubview:iv];
    
    tb.tableFooterView = footView;
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
}

#pragma mark - tableView datasource代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == _tempArr.count) {
        if (isVCode) {
            return 3;
        } else {
            return 1;
        }
    } else if (section == 0) {
        return [[_tempArr objectAtIndex:0] count];
    } else {
        return [[_tempArr objectAtIndex:1] count];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.showCard) {
        return _tempArr.count + 1;
    } else {
        return _tempArr.count;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 67.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == _tempArr.count) {
        return 10;
    }
    return 45.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == _tempArr.count) {
        return [[UIView alloc]init];
    }
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 45.0)];
    view.backgroundColor = kLightgray;
    UILabel *lb = [MyControl createLabelWithFrame:CGRectMake(5, 20, 200, 20) Font:14.0 Text:@""];
    if (section == 0) {
        lb.text = @"请选择会员级别";
    } else if (section == 1) {
        lb.text = @"支付时使用优惠券,可享受折扣";
    }
    lb.textColor = RGB(102, 102, 102);
    [view addSubview:lb];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == _tempArr.count) {
        if (indexPath.row == 0) {
            UpLevelVCodeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ULVCell" forIndexPath:indexPath];
            if (isVCode) {
                cell.img.image = imageNamed(@"pay-arrow-s");
                cell.bottomLine.hidden = YES;
            } else {
                cell.img.image = imageNamed(@"pay-arrow");
                cell.bottomLine.hidden = NO;
            }
            
            return cell;
        } else if (indexPath.row == 1){
            VCodeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ULVCCell" forIndexPath:indexPath];
            _cardTextField = cell.cardTextField;
            _cardTextField.delegate = self;
            return cell;
        } else {
            VerifyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ULVerCell" forIndexPath:indexPath];
            //获取验证码图片，更改验证码图片
            AppDelegate *app = [UIApplication sharedApplication].delegate;
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@%@",app.host_ip,getPCode]] options:SDWebImageDownloaderHandleCookies progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.verifyImg.image = image;
                });
            }];
            
            _pCodeTextField = cell.pCodeTextField;
            _pCodeTextField.delegate = self;
            return cell;
        }
    }
    
    UpLevelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ULCell" forIndexPath:indexPath];
    [cell configUI:_tempArr[indexPath.section][indexPath.row]];
    cell.selectBtn.tag = 14100 + indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        cell.selectBtn.hidden = YES;
        cell.priceLb.hidden = YES;
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.selectBtn.selected = YES;
            _selectedBtn = cell.selectBtn;
            level = indexPath.row;
        }
    }
    if (indexPath.row == [_tempArr[indexPath.section] count] - 1) {
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 66.5, kScreenWidth - 20, 1)];
        lineView.backgroundColor = RGB(194, 194, 194);
        [cell.contentView addSubview:lineView];
    }
    
    
    
//    if (!self.showCard) {
//        if (indexPath.section == _tempArr.count) {
//            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 66.5, kScreenWidth - 20, 1)];
//            lineView.backgroundColor = RGB(194, 194, 194);
//            [cell.contentView addSubview:lineView];
//        }
//    }
    return cell;
}

#pragma mark cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == _tempArr.count) {
        isVCode = !isVCode;
//        UpLevelVCodeTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:_tempArr.count] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else if (indexPath.section == 1){
        UpLevelTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (_selectedBtn == cell.selectBtn) {
            return;
        }
        _selectedBtn.selected = NO;
        cell.selectBtn.selected = YES;
        _selectedBtn = cell.selectBtn;
        level = indexPath.row;
    }
}

#pragma mark 下一步按钮点击
- (void)nextBtnClick{
    if (isVCode) {
        NSDictionary *dic = @{
                              @"card":_cardTextField.text,
                              @"pCode":_pCodeTextField.text,
                              @"_memberId":[User objectForKey:kMemberId],
                              @"_accessToken":[User objectForKey:kAccessToken]
                              };
        AppDelegate *app = [UIApplication sharedApplication].delegate;
        [NetWork getRequest:[NSString stringWithFormat:@"http://%@%@",app.host_ip,useCard] params:dic success:^(id responseObj) {
            JGProgressHUD *hud = [[JGProgressHUD alloc]initWithStyle:JGProgressHUDStyleDark];
            hud.indicatorView = nil;
            int ret = [responseObj[@"ret"] intValue];
            if (ret == 0) {
                hud.textLabel.text = @"升级会员成功";
            } else if (ret == 1){
                hud.textLabel.text = @"验证码错误";
            } else if (ret == 2) {
                hud.textLabel.text = @"无效的会员码";
            } else if (ret == 3) {
                hud.textLabel.text = @"会员码已被使用";
            } else if (ret == 4) {
                hud.textLabel.text = @"会员码已过期";
            } else if (ret == 5) {
                hud.textLabel.text = @"当前账户无法使用该会员码";
            } else {
                hud.textLabel.text = @"系统错误";
            }
            [hud showInView:self.view];
            [hud dismissAfterDelay:1.0f animated:YES];
        } failure:^(NSError *error) {
            NSLog(@"发送请求失败");
            
        }];
        return;
    }
    
    
    NSLog(@"%ld",level);
    RankConfModel *model = _tempArr[1][level];
    NSLog(@"%@,%@", model.rankId,model.price);
    //跳转到支付页面
    PayViewController *vc = [[PayViewController alloc]init];
    vc.tobeVip = YES;
    vc.price = model.price;
    vc.rankId = model.rankId;
    //
    [self configLeftBar];
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _cardTextField) {
        [_cardTextField resignFirstResponder];
        [_pCodeTextField becomeFirstResponder];
    } else {
        [_pCodeTextField resignFirstResponder];
        [self nextBtnClick];
    }
    return YES;
}

@end
