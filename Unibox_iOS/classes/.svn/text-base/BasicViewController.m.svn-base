//
//  BasicViewController.m
//  Unibox_iOS
//
//  Created by 刘羽 on 15/10/21.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import "BasicViewController.h"
//#import "AppDelegate.h"
#import "Header.h"
//#import "FavController.h"
#import "UIImage+Color.h"
#import "UIImage+Tint.h"
#import "MainTabBarController.h"
#import "AppDelegate.h"

@interface BasicViewController ()<UIGestureRecognizerDelegate>

@end

@implementation BasicViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.tabBarController.tabBar.hidden == NO) {
        self.tabBarController.tabBar.hidden = YES;
    }
    
    self.navigationController.navigationBar.translucent = YES;
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    if (self.navigationController.viewControllers.count > 1) {
        [app.tabController removeTab];
    } else {
        [app.tabController addTab];
    }
}

//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    if (self.navigationController.viewControllers.count > 1) {
//        AppDelegate *app = [UIApplication sharedApplication].delegate;
//        [app.tabController createTab];
//    }
//    
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.automaticallyAdjustsScrollViewInsets = NO;
//    self.navigationController.navigationBar.translucent = NO;
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    //[self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor clearColor]]];
}
//#pragma mark 添加导航栏的其他按钮
//- (void)addOtherButton
//{
//    //1.收藏按钮
//    UIButton *favBtn = [MyControl createButtonWithFrame:CGRectMake(kScreenWidth - 10 - 37/2, (kNav_Height - 33/2)/2, 37/2, 33/2) target:self SEL:@selector(favBtnClick) title:nil];
//    [favBtn setBackgroundImage:imageNamed(@"favourite_b") forState:UIControlStateNormal];
//    //[self.navBar addSubview:favBtn];
//    //2.租赁记录按钮
//    UIButton *rentBtn = [MyControl createButtonWithFrame:CGRectMake(favBtn.x - 20 - 20, (kNav_Height - 20)/2, 20, 20) target:self SEL:@selector(rentBtnClick) title:nil];
//    [rentBtn setBackgroundImage:imageNamed(@"navBack") forState:UIControlStateNormal];
//    //[self.navBar addSubview:rentBtn];
//    //3.购物车按钮
//    UIButton *shopBtn = [MyControl createButtonWithFrame:CGRectMake(rentBtn.x - 20 - 43/2, (kNav_Height - 45/2)/2, 43/2, 45/2) target:self SEL:@selector(shopBtnClick) title:nil];
//    [shopBtn setBackgroundImage:imageNamed(@"shop_b") forState:UIControlStateNormal];
//    
//    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:favBtn],[[UIBarButtonItem alloc] initWithCustomView:rentBtn],[[UIBarButtonItem alloc] initWithCustomView:shopBtn]];
//    //[self.navBar addSubview:shopBtn];
//}

//#pragma mark 收藏按钮点击事件
//- (void)favBtnClick
//{
//    //跳转到收藏页面
//    [self.navigationController pushViewController:[[FavController alloc] init] animated:YES];
//}
//
//#pragma mark 租赁按钮点击事件
//- (void)rentBtnClick
//{
//    //跳转到租赁记录页面
//}

//#pragma mark 购物车按钮点击事件
//- (void)shopBtnClick
//{
//    //跳转到购物车页面
//}

- (void)configLeftBarWhite{
    UIBarButtonItem* back = [[UIBarButtonItem alloc] init];
    back.title = @"";
    [back setBackButtonBackgroundImage:[imageNamed(@"btn-fanhui") resizableImageWithCapInsets:UIEdgeInsetsMake(10, 40, 20, 0)]  forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    self.navigationItem.backBarButtonItem = back;
}

#pragma mark 修改返回按钮
- (void)configLeftBar{
    UIBarButtonItem* back = [[UIBarButtonItem alloc] init];
    back.title = @"";
    [back setBackButtonBackgroundImage:[[imageNamed(@"btn-fanhui") imageWithTintColor:[UIColor blackColor]] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 40, 20, 0)]  forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    self.navigationItem.backBarButtonItem = back;
}


//- (void)configBar{
//    // 获取系统自带滑动手势的target对象
//    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
//    // 创建全屏滑动手势，调用系统自带滑动手势的target的action方法
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
//    // 设置手势代理，拦截手势触发
//    pan.delegate = self;
//    // 给导航控制器的view添加全屏滑动手势
//    [self.view addGestureRecognizer:pan];
//    // 禁止使用系统自带的滑动手势
//    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//}

// 什么时候调用：每次触发手势之前都会询问下代理，是否触发。
// 作用：拦截手势触发
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//{
//    // 注意：只有非根控制器才有滑动返回功能，根控制器没有。
//    // 判断导航控制器是否只有一个子控制器，如果只有一个子控制器，肯定是根控制器
//    if (self.childViewControllers.count == 1) {
//        // 表示用户在根控制器界面，就不需要触发滑动手势，
//        return NO;
//    }
//    return YES;
//}

//- (void)backBtnClick{
//    [self.navigationController popViewControllerAnimated:YES];
//}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
