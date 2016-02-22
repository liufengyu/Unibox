//
//  TopupController.m
//  Unibox_iOS
//
//  Created by 刘羽 on 15/11/2.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import "TopupController.h"
#import "Header.h"
#import "UIImage+Color.h"
#import "Header.h"
#import "NohightButton.h"
#import "TopupTableViewCell.h"
#import "Pingpp.h"
#import "API.h"
#import "AppDelegate.h"
#import "NetWork.h"
#import "WXApi.h"

typedef NS_ENUM(NSInteger, PayWay){
    PayWayWechat,
    PayWayAlipay
    
};

@interface TopupController () <UITableViewDelegate, UITableViewDataSource>
{
    UIScrollView *_sc;
    UIScrollView *_memSc;
    //记录选择金额按钮
    NohightButton *_selectBtn;
    //选择支付方式tableView;
    UITableView *_tb;
    //记录支付方式按钮
    NohightButton *_cellSelectBtn;
    
    //记录金额
    float jine;
    
    //记录充值方式
    PayWay payway;
}
@end

@implementation TopupController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:kRed] forBarMetrics:UIBarMetricsDefault];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.navigationItem.titleView
    jine = 10.00;
    payway = PayWayWechat;
    //self.title = @"充值";
    NSLog(@"是否安装%d",[WXApi isWXAppSupportApi]);
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
   
    self.view.backgroundColor = kWhite_Main;
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64.0)];
    bgView.backgroundColor = kRed;
    [self.view addSubview:bgView];
    //[self configLeftBar];
    //创建UI
    [self createUI];
}

#pragma mark 创建UI
- (void)createUI
{
    
    
    UIScrollView *sc = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64.0)];
    sc.backgroundColor = [UIColor clearColor];
    [self.view addSubview:sc];
    //请选择充值金额
    UILabel *jeLabel = [MyControl createLabelWithFrame:CGRectMake(10, 10, 150, 30) Font:15.0f Text:@"请选择充值方式:"];
    [jeLabel sizeToFit];
    jeLabel.textColor = RGB(104, 104, 104);
    [sc addSubview:jeLabel];
    
    CGFloat width = (kScreenWidth - 40) / 3;
    CGFloat height = 70.0;
    NSArray *titArr = @[@"￥10",@"￥30",@"￥50",@"￥100",@"￥200",@"￥300"];
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 3; j++) {
            NohightButton *jeBtn = [NohightButton buttonWithType:UIButtonTypeCustom];
            jeBtn.frame = CGRectMake(10 + (width + 10) * j, CGRectGetMaxY(jeLabel.frame) + 10 + (height + 10) * i, width, height);
            [jeBtn addTarget:self action:@selector(jeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [jeBtn setTitle:titArr[i * 3 + j] forState:UIControlStateNormal];
            jeBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
            [jeBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
            [jeBtn setBackgroundImage:[UIImage imageWithColor:kRed] forState:UIControlStateSelected];
            [jeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [jeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            jeBtn.tag = 12200 + i * 10 + j;
            [sc addSubview:jeBtn];
            if (i == 0 && j == 0) {
                jeBtn.selected = YES;
                _selectBtn = jeBtn;
            }
        }
    }
    
    //支付方式
    UILabel *zfLabel = [MyControl createLabelWithFrame:CGRectMake(10, CGRectGetMaxY(jeLabel.frame) + 170, 150, 30) Font:15.f Text:@"支付方式"];
    [zfLabel sizeToFit];
    zfLabel.textColor = RGB(104, 104, 104);
    [sc addSubview:zfLabel];
    
    UITableView *tb = [[UITableView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(zfLabel.frame) + 10, kScreenWidth - 20, 130) style:UITableViewStylePlain];
    if (![WXApi isWXAppSupportApi]) {
        tb.height = 65.0;
    }
    tb.backgroundColor = [UIColor whiteColor];
    tb.delegate = self;
    tb.dataSource = self;
    tb.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tb registerNib:[UINib nibWithNibName:@"TopupTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TUCell"];
    [sc addSubview:tb];
    
    //立即支付按钮
    UIButton *payBtn = [MyControl createButtonWithFrame:CGRectMake(tb.x, CGRectGetMaxY(tb.frame) + 20, tb.width, 40) target:self SEL:@selector(payBtnClick) title:@"立即支付"];
    payBtn.backgroundColor = kRed;
    [sc addSubview:payBtn];
    
    //提示文字
    UILabel *label = [MyControl createLabelWithFrame:CGRectMake(payBtn.x + 30, CGRectGetMaxY(payBtn.frame) + 10, payBtn.width - 30, 50) Font:10.0 Text:@"充值金额用于租金和押金抵扣,可提现到支付宝或微信。\n押金：DVD 30元/张 蓝光 80元/张   租金：DVD 2元/天 蓝光 5元/天"];
    
    [label sizeToFit];
    [sc addSubview:label];
    
    UIImageView *iv = [MyControl createImageViewFrame:CGRectMake(10, label.y + (label.height - 17) / 2, 17.0, 17.0) imageName:@"mem-tishi"];
    [sc addSubview:iv];
    
    if (CGRectGetMaxY(label.frame) <= sc.height) {
        sc.contentSize = CGSizeMake(kScreenWidth, sc.height + 1);
    } else {
        sc.contentSize = CGSizeMake(kScreenWidth, CGRectGetMaxY(label.frame) + 10);
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([WXApi isWXAppSupportApi]) {
        return 2;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TopupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TUCell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.iv.image = imageNamed(@"topup-zhifubao");
        cell.titleLb.text = @"支付宝安全支付";
        cell.selectBtn.selected = YES;
        _cellSelectBtn = cell.selectBtn;
    } else {
        cell.iv.image = imageNamed(@"topup-wechat");
        cell.titleLb.text = @"微信安全支付";
        //cell.selectBtn.selected = YES;
        //_cellSelectBtn = cell.selectBtn;
    }
    cell.selectBtn.tag = indexPath.row + 14000;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //[cell.selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TopupTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.selectBtn == _cellSelectBtn) {
        return;
    }
    cell.selectBtn.selected = YES;
    _cellSelectBtn.selected = NO;
    _cellSelectBtn = cell.selectBtn;
    if (cell.selectBtn.tag - 14000) {
        payway = PayWayAlipay;
    } else {
        payway = PayWayWechat;
    }
}

#pragma mark 选择金额按钮点击
- (void)jeBtnClick:(NohightButton *)btn{
    if (btn == _selectBtn) {
        return;
    }
    btn.selected = YES;
    _selectBtn.selected = NO;
    _selectBtn = btn;
    
    jine = [[btn.titleLabel.text substringFromIndex:1] floatValue];
    //NSLog(@"%f",jine);
}

#pragma mark 支付按钮点击
- (void)payBtnClick{
    NSLog(@"%.2f,%ld",jine,payway);
    //获取支付凭证
    //AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    /*
     ** type : 类型， topup 充值， bevip，成为vip
     ** channel ： 支付方式, eg: wx, alipay_wap
     ** paymentSubject : 商品名
     ** paymentBody : 商品描述
     ** amount : 充值金额，类型为充值时要传的参数
     ** rank : vip等级，类型是成为VIP的时候要传的参数
     */
    
    TopupController *__weak weakSelf = self;
    NSString *channel = payway ? @"wx":@"alipay";
    NSDictionary *dic = @{
                          @"_memberId":[User objectForKey:kMemberId],
                          @"_accessToken":[User objectForKey:kAccessToken],
                          @"channel":channel,
                          @"paymentSubject":@"充值",
                          @"paymentBody":[NSString stringWithFormat:@"充值金额%.2f",jine],
                          @"amount":[NSString stringWithFormat:@"%.2f",jine],
                          };
    [NetWork getRequest:[NSString stringWithFormat:@"http://%@%@",app.host_ip,getCharge] params:dic success:^(id responseObj) {
        if (![responseObj[@"ret"] boolValue]) {
            [weakSelf payWith:responseObj[@"charge"]];
        }
    } failure:^(NSError *error) {
        //
    }];
//    [NetWork get:[NSString stringWithFormat:@"http://%@%@",app.host_ip,getCharge] parameters:dic success:^(id responseObject) {
//        if (![responseObject[@"ret"] boolValue]) {
//            [weakSelf payWith:responseObject[@"charge"]];
//        }
//    } fail:^(NSError *error) {
//        //
//    }];
//    [manager GET:[NSString stringWithFormat:@"http://%@%@",app.host_ip,getCharge] parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@",responseObject);
//        if (![responseObject[@"ret"] boolValue]) {
//            [weakSelf payWith:responseObject[@"charge"]];
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        //
//    }];
}

- (void)payWith:(NSObject *)charge
{
    NSLog(@"%@",charge);
    //TopupController *__weak weakSelf = self;
    if (payway == PayWayAlipay) {
        [Pingpp createPayment:charge viewController:_controller appURLScheme:Alipay_AppID withCompletion:^(NSString *result, PingppError *error) {
            JGProgressHUD *hud = [[JGProgressHUD alloc]initWithStyle:JGProgressHUDStyleDark];
            if ([result isEqualToString:@"success"]) {
                // 支付成功
                hud.indicatorView = [[JGProgressHUDSuccessIndicatorView alloc]init];
                hud.textLabel.text = @"支付成功";
                [hud showInView:self.view];
                [hud dismissAfterDelay:1.0 animated:YES];
            } else {
                // 支付失败或取消
                hud.indicatorView = [[JGProgressHUDErrorIndicatorView alloc]init];
                hud.textLabel.text = @"支付失败";
                [hud showInView:self.view];
                [hud dismissAfterDelay:1.0 animated:YES];
                NSLog(@"Error: code=%lu msg=%@", error.code, [error getMsg]);
            }
        }];
    } else {
        [Pingpp createPayment:charge viewController:_controller appURLScheme:Wechat_AppID withCompletion:^(NSString *result, PingppError *error) {
            JGProgressHUD *hud = [[JGProgressHUD alloc]initWithStyle:JGProgressHUDStyleDark];
            if ([result isEqualToString:@"success"]) {
                // 支付成功
                hud.indicatorView = [[JGProgressHUDSuccessIndicatorView alloc]init];
                hud.textLabel.text = @"支付成功";
                [hud showInView:self.view];
                [hud dismissAfterDelay:1.0 animated:YES];
            } else {
                // 支付失败或取消
                hud.indicatorView = [[JGProgressHUDErrorIndicatorView alloc]init];
                hud.textLabel.text = @"支付失败";
                [hud showInView:self.view];
                [hud dismissAfterDelay:1.0 animated:YES];
                NSLog(@"Error: code=%lu msg=%@", error.code, [error getMsg]);
            }
        }];
    }
//    if (payway == PayWayAlipay) {
//        JGProgressHUD *hud = [[JGProgressHUD alloc]initWithStyle:JGProgressHUDStyleDark];
//        [Pingpp createPayment:charge viewController:self appURLScheme:Alipay_AppID withCompletion:^(NSString *result, PingppError *error) {
//            
//            if ([result isEqualToString:@"success"]) {
//                // 支付成功
//                hud.indicatorView = [[JGProgressHUDSuccessIndicatorView alloc]init];
//                hud.textLabel.text = @"支付成功";
//                [hud showInView:self.navigationController.view];
//                [hud dismissAfterDelay:1.0 animated:YES];
//                [ws.navigationController popToRootViewControllerAnimated:YES];
//            } else {
//                // 支付失败或取消
//                hud.indicatorView = [[JGProgressHUDErrorIndicatorView alloc]init];
//                hud.textLabel.text = @"支付失败";
//                [hud showInView:ws.view];
//                [hud dismissAfterDelay:1.0 animated:YES];
//                NSLog(@"Error: code=%lu msg=%@", error.code, [error getMsg]);
//            }
//        }];
//    } else {
//        [Pingpp createPayment:charge viewController:self appURLScheme:Wechat_AppID withCompletion:^(NSString *result, PingppError *error) {
//            JGProgressHUD *hud = [[JGProgressHUD alloc]initWithStyle:JGProgressHUDStyleDark];
//            if ([result isEqualToString:@"success"]) {
//                // 支付成功
//                hud.indicatorView = [[JGProgressHUDSuccessIndicatorView alloc]init];
//                hud.textLabel.text = @"支付成功";
//                [hud showInView:self.view];
//                [hud dismissAfterDelay:1.0 animated:YES];
//            } else {
//                // 支付失败或取消
//                hud.indicatorView = [[JGProgressHUDErrorIndicatorView alloc]init];
//                hud.textLabel.text = @"支付失败";
//                [hud showInView:self.view];
//                [hud dismissAfterDelay:1.0 animated:YES];
//                NSLog(@"Error: code=%lu msg=%@", error.code, [error getMsg]);
//            }
//        }];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
