//
//  AboutmeController.m
//  Unibox_iOS
//
//  Created by 刘羽 on 15/10/26.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import "AboutmeController.h"
#import "UIImage+Color.h"
#import "UIImage+Tint.h"
#import "Header.h"
//#import "helpCenterController.h"
//#import "FavController.h"
#import "EditInfoController.h"
#import "AppDelegate.h"
//#import "CartController.h"
//#import "TopupController.h"
//#import "ScanViewController.h"
#import "CheckViewController.h"
#import "FavViewController.h"
#import "ShopCartController.h"
#import "LoginController.h"
#import "MemberTequanController.h"
#import "UpLevelController.h"
//#import "TixianViewController.h"
#import "SettingViewController.h"
#import "MapViewController.h"
#import "RentalListController.h"
#import "RentalNoticeController.h"
#import "UIImage+Extension.h"
#import "API.h"
#import "AccountModel.h"
#import "RankConfModel.h"
#import "UIButton+WebCache.h"
#import "TopupAndTixianController.h"
#import "NetWork.h"
#import "UniBoxCoinController.h"
#import "DiscountController.h"
#import "LogoutView.h"
#import "LoginView.h"
#import <BlocksKit+UIKit.h>
@interface AboutmeController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate,UITableViewDataSource, UITableViewDelegate>
{
    //已登录状态视图
    LoginView *_loginView;
    //未登录状态视图
    LogoutView *_logoutView;
    
    //uitableView 数据源
    NSArray *_dataArr;
    //登录状态
    BOOL loginStatus;
    //用户信息model
    AccountModel *_account;
    //等级信息
    NSMutableArray *_rankConf;
}
@end

@implementation AboutmeController

/*
 更改导航栏背景图片,标题及标题的颜色
 */
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    static BOOL flag1 = NO;
    if (flag1) {
        if ([User objectForKey:kMemberId]) {
            if (_loginView == nil) {
                [_logoutView removeFromSuperview];
                _logoutView = nil;
                [self createLoginView];
            }
            [self loadUserInfo];
            //[self updateUserInfo];
        } else {
            [self logOut];
        }
    }
    flag1 = YES;
    
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    _rankConf = [NSMutableArray array];
    
    if ([User objectForKey:kMemberId]) {
        loginStatus = YES;
    } else {
        loginStatus = NO;
        
    }
    
    //添加背景图片
//    self.view.backgroundColor = kWhite_Main;
//    UIImageView *bgImage = [MyControl createImageViewFrame:CGRectMake(0, 0, kScreenWidth, 190.0 ) imageName:@"img-bg"];
//    [self.view addSubview:bgImage];
//    
    //创建UI
    [self createUI];
    //加载数据
    if (loginStatus) {
        [self loadUserInfo];
    }
    
}

- (void)loadUserInfo{
    //static BOOL flag = NO;
    [_rankConf removeAllObjects];
    JGProgressHUD *hud = [[JGProgressHUD alloc]initWithStyle:JGProgressHUDStyleDark];
    [hud showInView:self.view];
    //AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //manager.requestSerializer.timeoutInterval = 10;
    NSDictionary *dic = @{
                          @"_memberId":[User objectForKey:kMemberId],
                          @"_accessToken":[User objectForKey:kAccessToken]
                          };
    AppDelegate *app = [UIApplication sharedApplication].delegate;

    [NetWork getRequest:[NSString stringWithFormat:@"http://%@%@",app.host_ip,getAccountInfo] params:dic success:^(id responseObj) {
        
        if (![responseObj[@"ret"] boolValue]) {
            _account = [[AccountModel alloc]init];
            [_account setValuesForKeysWithDictionary:responseObj[@"info"]];
            for (NSDictionary *d in responseObj[@"rankConf"]) {
                RankConfModel *model = [[RankConfModel alloc]init];
                [model setValuesForKeysWithDictionary:d];
                [_rankConf addObject:model];
            }
            [self updateUserInfo];
        }
        [hud dismissAnimated:YES];
    } failure:^(NSError *error) {
        [hud dismissAnimated:YES];
    }];
}

//- (void)loadRankInfo{
//    //AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [_rankConf removeAllObjects];
//    NSDictionary *dic = @{
//                          @"_memberId":[User objectForKey:kMemberId],
//                          @"_accessToken":[User objectForKey:kAccessToken]
//                          };
//    AppDelegate *app = [UIApplication sharedApplication].delegate;
//    [NetWork getRequest:[NSString stringWithFormat:@"http://%@%@",app.host_ip,getAccountInfo] params:dic success:^(id responseObj) {
//        if (![responseObj[@"ret"] boolValue]) {
//            for (NSDictionary *d in responseObj[@"rankConf"]) {
//                RankConfModel *model = [[RankConfModel alloc]init];
//                [model setValuesForKeysWithDictionary:d];
//                [_rankConf addObject:model];
//            }
//            //NSLog(@"%@",responseObj);
//            
//        }
//    } failure:^(NSError *error) {
//        //
//    }];
//}

#pragma mark 更新用户信息
- (void)updateUserInfo{
    RankConfModel *model = [_rankConf objectAtIndex:[_account.rank intValue] - 1];
    [_loginView configUI:_account and:model];
    
    
    
//    [_loginView.TXButton bk_addEventHandler:^(id sender) {
//        //
//    } forControlEvents:UIControlEventTouchUpInside];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//- (void)rental{
//    RentalListController *vc = [[RentalListController alloc]init];
//    //
//    [self.navigationController pushViewController:vc animated:YES];
//}

- (void)logOut{
    if (_loginView != nil) {
        [_loginView removeFromSuperview];
        _loginView = nil;
    }
    [self createLogoutView];
}

#pragma mark 创建UI
- (void)createUI
{
    //头部试图
    [self createTop];
    
}

#pragma mark 创建头部视图
- (void)createTop
{
    if (loginStatus) {
        //已登录
        [self createLoginView];
    } else {
        //未登录
        [self createLogoutView];
    }
    
    [self createTB];
}

#pragma mark 创建登录状态下的视图
- (void)createLoginView{
    LoginView *loginView = [[[NSBundle mainBundle] loadNibNamed:@"LoginView" owner:self options:nil]lastObject];
    _loginView = loginView;
    [loginView.TXButton bk_addEventHandler:^(id sender) {
        //跳转到个人资料编辑页面
        [self configLeftBar];
        EditInfoController *vc = [[EditInfoController alloc]init];
        //
        [self.navigationController pushViewController:vc animated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    
    [_loginView.LevelupButton bk_addEventHandler:^(id sender) {
        [self configLeftBar];
        UpLevelController *vc = [[UpLevelController alloc]init];
        //
        vc.rankArr = _rankConf;
        vc.rank = _account.rank;
        vc.showCard = [_account.showCard boolValue];
        [self.navigationController pushViewController:vc animated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    loginView.frame = CGRectMake(0, 0, kScreenWidth, 190);
    [self.view addSubview:loginView];
}

#pragma mark 创建未登录状态下的视图
- (void)createLogoutView{
    LogoutView *logoutView = [[[NSBundle mainBundle] loadNibNamed:@"LogoutView" owner:self options:nil]lastObject];
    _logoutView = logoutView;
    logoutView.frame = CGRectMake(0, 0, kScreenWidth, 190);
    [logoutView.TXButton bk_addEventHandler:^(id sender) {
        if ([User objectForKey:kMemberId]) {
            //跳转到个人资料编辑页面
            [self configLeftBar];
            EditInfoController *vc = [[EditInfoController alloc]init];
            //
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [self configLeftBar];
            LoginController *vc = [[LoginController alloc]init];
            //
            [self.navigationController pushViewController:vc animated:YES];
        }
    } forControlEvents:UIControlEventTouchUpInside];
    [logoutView.LoginButton bk_addEventHandler:^(id sender) {
        if ([User objectForKey:kMemberId]) {
            //跳转到个人资料编辑页面
            [self configLeftBar];
            EditInfoController *vc = [[EditInfoController alloc]init];
            //
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [self configLeftBar];
            LoginController *vc = [[LoginController alloc]init];
            //
            [self.navigationController pushViewController:vc animated:YES];
        }
    } forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logoutView];
}

#pragma mark 创建UITableView
- (void)createTB{
    NSMutableArray *arr = [NSMutableArray arrayWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"aboutme" withExtension:@"plist"]];
    _dataArr = arr;
    
    UITableView *tb = [[UITableView alloc]initWithFrame:CGRectMake(0, 190.0 , kScreenWidth, kScreenHeight - 190.0  - 49.0) style:UITableViewStyleGrouped];
    tb.backgroundColor = RGB(232, 233, 232);
    tb.delegate = self;
    tb.dataSource = self;
    [self.view addSubview:tb];
    
    //uitableview头视图
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 95.0)];
    headView.backgroundColor = RGB(232, 233, 232);
    CGFloat width = (kScreenWidth - 3) / 4;
    CGFloat height = 95.0 - 20;
    NSArray *imgArr = @[@"me-buy-car",@"icon-yhq",@"me-sc",@"icon-jifen"];
    for (int i = 0; i < 4; i++) {
        UIButton *btn = [MyControl createButtonWithFrame:CGRectMake((width + 1) * i, 10, width, height) target:self SEL:@selector(forBtnClick:) title:nil];
        btn.tag = 10060 + i;
        btn.backgroundColor = [UIColor whiteColor];
        //UIImageView *iv = [[UIImageView alloc]initWithImage:imageNamed(imgArr[i])];
        [btn setImage:imageNamed(imgArr[i]) forState:UIControlStateNormal];
        [headView addSubview:btn];
    }
    tb.tableHeaderView = headView;
}

- (void)forBtnClick:(UIButton *)btn{
    //tag 10060
    if (![User objectForKey:kMemberId]) {
        LoginController *vc = [[LoginController alloc]init];
        [self configLeftBar];
        //
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (btn.tag == 10060) {
        //购物车
        [self configLeftBarWhite];
        
        ShopCartController *vc = [[ShopCartController alloc]init];
        //
        [self.navigationController pushViewController:vc animated:YES];
    } else if (btn.tag == 10061){
        //优惠券t
        [self configLeftBar];
        DiscountController *vc = [[DiscountController alloc]init];
        vc.type = @"normal";
        [self.navigationController pushViewController:vc animated:YES];
        //[self alertTitle:@"提示信息" message:@"暂未开放,敬请期待"];
    } else if (btn.tag == 10062){
        //收藏
        [self configLeftBar];
        FavViewController *vc = [[FavViewController alloc]init];
        //
        [self.navigationController pushViewController:vc animated:YES];
    } else{
        //积分
        [self configLeftBar];
        UniBoxCoinController *vc = [[UniBoxCoinController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        //[self alertTitle:@"提示信息" message:@"暂未开放,敬请期待"];
    }
}

//- (void)configBackItemWhite{
//    UIBarButtonItem* back = [[UIBarButtonItem alloc] init];
//    back.title = @"";
//    [back setBackButtonBackgroundImage:[imageNamed(@"btn-fanhui") resizableImageWithCapInsets:UIEdgeInsetsMake(10, 40, 20, 0)]  forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//    self.navigationItem.backBarButtonItem = back;
//}
//
//- (void)configBackItem{
//    UIBarButtonItem* back = [[UIBarButtonItem alloc] init];
//    back.title = @"";
//    
//    [back setBackButtonBackgroundImage:[[imageNamed(@"btn-fanhui") imageWithTintColor:[UIColor blackColor]] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 40, 20, 0)]  forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//    self.navigationItem.backBarButtonItem = back;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArr[section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0 ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 1.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *iden = @"AMCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, cell.contentView.height - 1, kScreenHeight, 1)];
        [cell.contentView addSubview:lineView];
    }
    cell.imageView.image = imageNamed(_dataArr[indexPath.section][indexPath.row][@"img"]);
    cell.textLabel.text = _dataArr[indexPath.section][indexPath.row][@"title"];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.accessoryView = [[UIImageView alloc]initWithImage:imageNamed(@"btn-more")];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (![User objectForKey:kMemberId]) {
            [self configLeftBar];
            LoginController *vc = [[LoginController alloc]init];
            //
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
        if (indexPath.row == 0) {
            //我的租赁机
            [self configLeftBarWhite];
            MapViewController *vc = [[MapViewController alloc]init];
            //
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 1){
            //我的订单
            [self configLeftBar];
            RentalListController *vc = [[RentalListController alloc]init];
            //
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 2){
            //对账单
            [self configLeftBar];
            CheckViewController *vc = [[CheckViewController alloc]init];
            //
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 3){
            //充值
            [self configLeftBarWhite];
            TopupAndTixianController *vc = [[TopupAndTixianController alloc]init];
            vc.isTopup = YES;
            //TopupController *vc = [[TopupController alloc]init];
            //
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            //取现
            [self configLeftBarWhite];
            TopupAndTixianController *vc = [[TopupAndTixianController alloc]init];
            vc.isTopup = NO;
            //
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else{
        if (indexPath.row == 0) {
            if (![User objectForKey:kMemberId]) {
                [self configLeftBar];
                LoginController *vc = [[LoginController alloc]init];
                //
                [self.navigationController pushViewController:vc animated:YES];
                return;
            }
            //会员特权
            [self configLeftBar];
            MemberTequanController *vc = [[MemberTequanController alloc]init];
            vc.rankArr = _rankConf;
//            vc.rankTitle = _memLb.text;
            vc.rankTitle = _loginView.rankLb.text;
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 1) {
            //租赁须知
            [self configLeftBar];
            RentalNoticeController *vc = [[RentalNoticeController alloc]init];
            //vc.type = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            //设置
            [self configLeftBar];
            SettingViewController *vc = [[SettingViewController alloc]init];
            //
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}


#pragma mark 中间三个按钮点击事件
- (void)threeBtnClick:(UIButton *)btn{
    //tag 10050
    if (btn.tag == 10050) {
        //账户余额
    } else if (btn.tag == 10051){
        //可用余额
    } else {
        //冻结押金
    }
}



- (void)pushViewController:(UIViewController *)vc
{
    //
    [self.navigationController pushViewController:vc animated:YES];
}

//#pragma mark 退出按钮点击事件
//- (void)quitBtnClick
//{
//    [NSUSER removeObjectForKey:kMemberId];
//    [NSUSER removeObjectForKey:kAccessToken];
//    //清除本地保存的用户信息
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"退出成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [alert show];
//}
//
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    [self.navigationController popToRootViewControllerAnimated:YES];
//}

//#pragma mark 头像按钮点击事件
//- (void)touxiangBtnClick
//{
//    //NSLog(@"%@",[User objectForKey:kMemberId]);
//    if ([User objectForKey:kMemberId]) {
//        //跳转到个人资料编辑页面
//        [self configLeftBar];
//        EditInfoController *vc = [[EditInfoController alloc]init];
//        //
//        [self.navigationController pushViewController:vc animated:YES];
//    } else {
//        [self configLeftBar];
//        LoginController *vc = [[LoginController alloc]init];
//        //
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//    
//
//}

#pragma mark 未登录登录
- (void)tapOnLb{
    LoginController *vc = [[LoginController alloc]init];
    //
    [self configLeftBar];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 摄像头按钮点击事件
- (void)cameraBtnClick
{
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"选择"
                                                                        message:@"选择选取图片的位置"
                                                                 preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *ac1 = [UIAlertAction actionWithTitle:@"从相册选取"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action) {
                                                        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
                                                        imagePicker.delegate = self;
                                                        imagePicker.allowsEditing = YES;
                                                        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                                        [self presentViewController:imagePicker animated:YES completion:nil];
                                                    }];
        [alertC addAction:ac1];
        
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        
               UIAlertAction *ac2 = [UIAlertAction
                                     actionWithTitle:@"拍照"
                                               style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction * _Nonnull action) {
                                                        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
                                                        imagePicker.delegate = self;
                                                        imagePicker.allowsEditing = YES;
                                                        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                                        [self presentViewController:imagePicker animated:YES completion:nil];
                                                    }];
        
        
        
        
        [alertC addAction:ac2];
        
        
        }
        UIAlertAction *ac3 = [UIAlertAction actionWithTitle:@"取消"
                                                      style:UIAlertActionStyleCancel
                                                    handler:nil];
        [alertC addAction:ac3];
        [self presentViewController:alertC animated:YES completion:nil];
        return;
    }
    
    
    //判断是否支持相机 打开相机设置头像保存到本地沙盒
    UIActionSheet *sheet;
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
        sheet.tag = 212;
    }
    else {
        
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
        sheet.tag = 213;
    }
    [sheet showInView:self.view];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger sourceType = 0;
    if (actionSheet.tag == 212) {//支持相机
        if (buttonIndex == 0) {
            sourceType = UIImagePickerControllerSourceTypeCamera;
        }else if (buttonIndex == 1){
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }else{
            return;
        }
    }else{//不支持相机
        if (buttonIndex == 0) {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }else{
            return;
        }
    }
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = sourceType;
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}

#pragma mark - imagePicker代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //保存图片到沙盒
    [self saveImage:image];
//    [_touxiangBtn setBackgroundImage:image forState:UIControlStateNormal];
}

#pragma mark - 保存图片到沙盒
- (void)saveImage:(UIImage *)currentImage
{
    NSData *imageData = UIImagePNGRepresentation(currentImage);
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",[NSUSER objectForKey:kMemberId]]];
    [imageData writeToFile:fullPath atomically:YES];
}

#pragma mark 升级按钮点击
- (void)upLevelBtnClick{
    [self configLeftBar];
    UpLevelController *vc = [[UpLevelController alloc]init];
    //
    vc.rankArr = _rankConf;
    vc.rank = _account.rank;
    vc.showCard = [_account.showCard boolValue];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark alert
- (void)alertTitle:(NSString *)title message:(NSString *)message{
    
    JGProgressHUD *hud = [[JGProgressHUD alloc]initWithStyle:JGProgressHUDStyleDark];
    hud.indicatorView = nil;
    hud.textLabel.text = message;
    [hud showInView:self.view];
    [hud dismissAfterDelay:1.0 animated:YES];
    return;
    
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *ac = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
//        [alertController addAction:ac];
//        [self presentViewController:alertController animated:YES completion:nil];
//    } else {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
