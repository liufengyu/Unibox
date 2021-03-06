//
//  TixianViewController.m
//  Unibox_iOS
//
//  Created by 刘羽 on 15/12/6.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import "TixianViewController.h"
#import "Header.h"
#import "TixianTableViewCell.h"
//#import "TopupTableViewCell.h"
#import "UIImage+Color.h"
#import "WXApi.h"
#import "NetWork.h"
#import "AppDelegate.h"
#import "API.h"
typedef NS_ENUM(NSInteger, PayWay){
    PayWayWechat,
    PayWayAlipay
};
@interface TixianViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    UIButton *_selectedBtn;
    PayWay payWay;
    UITextField *_textField;
    NSNumber *_money;
}
@end

@implementation TixianViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:kRed] forBarMetrics:UIBarMetricsDefault];
    //[self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    //self.title = @"提现";
    
    
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    self.view.backgroundColor = kWhite_Main;
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64.0)];
    bgView.backgroundColor = kRed;
    [self.view addSubview:bgView];
    //[self configLeftBar];
    
    //UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    //bgView.backgroundColor = [UIColor whiteColor];
    //[self.view addSubview:bgView];
    
    
    //获取全部可提现金额
    [self getMaxMoney];
    
    //创建uitableview
    [self createTB];
}

- (void)getMaxMoney{
    NSDictionary *dic = @{
                          @"_accessToken":[User objectForKey:kAccessToken],
                          @"_memberId":[User objectForKey:kMemberId]
                          };
    TixianViewController *__weak weakSelf = self;
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [NetWork getRequest:[NSString stringWithFormat:@"http://%@%@",app.host_ip,getMaxWithdrawMoney] params:dic success:^(id responseObj) {
        if (![responseObj[@"ret"] boolValue]) {
            _money = responseObj[@"money"];
            [weakSelf createTB];
        } else {
            [self alertMessage:@"获取用户金额失败"];
        }
    } failure:^(NSError *error) {
        //
    }];
    
}

- (void)alertMessage:(NSString *)message{
    //    JGProgressHUD *hud = [[JGProgressHUD alloc]initWithStyle:JGProgressHUDStyleDark];
    //    hud.indicatorView = nil;
    //    hud.textLabel.text = message;
    //    [hud showInView:self.view];
    //    [hud dismissAfterDelay:1.0 animated:YES];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ac = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:ac];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark 创建tableView
- (void)createTB{
    UITableView *tb = [[UITableView alloc]initWithFrame:CGRectMake(10, 64, kScreenWidth - 20, kScreenHeight - 64.0) style:UITableViewStyleGrouped];
    tb.backgroundColor = [UIColor clearColor];
    tb.separatorStyle = UITableViewCellSeparatorStyleNone;
    tb.delegate = self;
    tb.dataSource = self;
    
    [tb registerNib:[UINib nibWithNibName:@"TixianTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TXCell"];
//    [tb registerNib:[UINib nibWithNibName:@"TopupTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TUCell"];
    [self.view addSubview:tb];
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    footView.backgroundColor = [UIColor clearColor];
    
    UIButton *tixianBtn = [MyControl createButtonWithFrame:CGRectMake(0, 20, kScreenWidth - 20, 50) target:self SEL:@selector(tixianBtnClick) title:@"立即提现"];
    tixianBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    tixianBtn.backgroundColor = kRed;
    [footView addSubview:tixianBtn];
    //tb.tableFooterView = tixianBtn;
    
    UILabel *label = [MyControl createLabelWithFrame:CGRectMake(tixianBtn.x + 30, CGRectGetMaxY(tixianBtn.frame) + 10, tixianBtn.width - 30, 50) Font:10.0 Text:@"只能提现可用余额,最低提现金额为1元。\n提现金额会根据你的充值方式原路返回,1-2小时到账"];
    [label sizeToFit];
    [footView addSubview:label];
    UIImageView *iv = [MyControl createImageViewFrame:CGRectMake(0, label.y + (label.height - 17) / 2, 17.0, 17.0) imageName:@"mem-tishi"];
    [footView addSubview:iv];
    tb.tableFooterView = footView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45.0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return .5f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //if (indexPath.section == 0) {
    TixianTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TXCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textField.placeholder = [NSString stringWithFormat:@"最多可提现%.2f",[_money floatValue]];
    cell.textField.delegate = self;
    _textField = cell.textField;
    [cell.tixianBtn addTarget:self action:@selector(allBtnClick) forControlEvents:UIControlEventTouchUpInside];
    return cell;
    //}
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([toBeString intValue] > [_money intValue]) {
        
        textField.text = [_money stringValue];
        return NO;
    }
    return YES;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    if (section == 0) {
//        return [[UIView alloc]init];
//    } else {
//        UILabel *label = [MyControl createLabelWithFrame:CGRectMake(10, 0, 200, 40.0) Font:14.0 Text:@"   金额提现至"];
//        label.textColor = RGB(94, 94, 94);
//        return label;
//    }
//}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (_textField.editing) {
//        [_textField resignFirstResponder];
//    }
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_textField.editing) {
        [_textField resignFirstResponder];
    }
}

#pragma mark 提现按钮点击
- (void)tixianBtnClick{
    if (_textField.editing) {
        [_textField resignFirstResponder];
    }
    
    JGProgressHUD *hud = [[JGProgressHUD alloc]initWithStyle:JGProgressHUDStyleDark];
    hud.indicatorView = nil;
    hud.textLabel.text = @"提现中...";
    [hud showInView:self.navigationController.view];
    NSDictionary *dic = @{
                          @"_accessToken":[User objectForKey:kAccessToken],
                          @"_memberId":[User objectForKey:kMemberId],
                          @"amount":_textField.text
                          };
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [NetWork getRequest:[NSString stringWithFormat:@"http://%@%@",app.host_ip,tixian_URL] params:dic success:^(id responseObj) {
        if (![responseObj[@"ret"]boolValue]) {
            hud.textLabel.text = @"提现成功";
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            hud.textLabel.text = @"提现失败";
        }
        [hud dismissAfterDelay:1.0 animated:YES];
    } failure:^(NSError *error) {
        //
    }];
    
}

#pragma mark 全部取出按钮点击事件
- (void)allBtnClick{
    _textField.text = [_money stringValue];
    
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
