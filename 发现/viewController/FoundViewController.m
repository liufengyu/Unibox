//
//  FoundViewController.m
//  Unibox_iOS
//
//  Created by 刘羽 on 15/11/25.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import "FoundViewController.h"
#import "Header.h"
#import "HuodongViewController.h"
#import "ZixunViewController.h"
#import "TrailerViewController.h"
#import "UIImage+Color.h"
#import "LineButton.h"


@interface FoundViewController ()<ZixunDelegate>
{
    
    UITableViewController *_childController;
    LineButton *_selectBtn;
}
@end

@implementation FoundViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:1.0 alpha:0.6]] forBarMetrics:UIBarMetricsDefault];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
//    if (_selectBtn != nil) {
//        [self navBtnClick:_selectBtn];
//    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIView *naviBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64.0)];
    naviBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:naviBar];
    //[self configLeftBar];
    //修改导航栏按钮
    [self addNavBtn];
}

#pragma mark 修改导航栏按钮
- (void)addNavBtn{
    LineButton *huodongBtn = [LineButton createButtonWithFrame:CGRectMake(0, 0, 40, 25) target:self SEL:@selector(navBtnClick:) title:@"活动"];
    huodongBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    huodongBtn.selected = YES;
    huodongBtn.line.hidden = NO;
    huodongBtn.tag = 10020;
    _selectBtn = huodongBtn;
    [huodongBtn setTitleColor:RGB(105, 105, 105) forState:UIControlStateNormal];
    [huodongBtn setTitleColor:kRed forState:UIControlStateSelected];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:huodongBtn];
    
    HuodongViewController *huodong = [[HuodongViewController alloc]init];
    [self addChildViewController:huodong];
    huodong.view.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64 - 49);
    _childController = huodong;
    huodong.delegate = self;
    [self.view addSubview:huodong.tableView];
    
    LineButton *zixunBtn = [LineButton createButtonWithFrame:CGRectMake(0, 0, 40, 25) target:self SEL:@selector(navBtnClick:) title:@"资讯"];
    zixunBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    zixunBtn.tag = 10021;
    [zixunBtn setTitleColor:RGB(105, 105, 105) forState:UIControlStateNormal];
    [zixunBtn setTitleColor:kRed forState:UIControlStateSelected];
    self.navigationItem.titleView = zixunBtn;
    
    LineButton *trailerBtn = [LineButton createButtonWithFrame:CGRectMake(0, 0, 60, 25) target:self SEL:@selector(navBtnClick:) title:@"新片预告"];
    trailerBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    trailerBtn.tag = 10022;
    [trailerBtn setTitleColor:RGB(105, 105, 105) forState:UIControlStateNormal];
    [trailerBtn setTitleColor:kRed forState:UIControlStateSelected];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:trailerBtn];
    //NSLog(@"---%f", self.navigationItem.titleView.width);
}

#pragma mark 活动按钮点击
- (void)navBtnClick:(LineButton *)btn{
    if (btn.selected) {
        return;
    }
    _selectBtn.selected = NO;
    _selectBtn.line.hidden = YES;
    _selectBtn = btn;
    btn.selected = YES;
    btn.line.hidden = NO;
    
    [_childController willMoveToParentViewController:nil];
    [_childController removeFromParentViewController];
    [_childController.tableView removeFromSuperview];
    if (btn.tag == 10020) {
        HuodongViewController *huodong = [[HuodongViewController alloc]init];
        [self addChildViewController:huodong];
        huodong.view.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight - 49-64);
        _childController = huodong;
        huodong.delegate = self;
        [self.view addSubview:huodong.tableView];
    } else if (btn.tag == 10021){
        ZixunViewController *zixun = [[ZixunViewController alloc]init];
        [self addChildViewController:zixun];
        zixun.view.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight - 49-64);
        _childController = zixun;
        zixun.delegate = self;
        [self.view addSubview:zixun.tableView];
    }else{
        TrailerViewController *trailer = [[TrailerViewController alloc]init];
        [self addChildViewController:trailer];
        
        trailer.view.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight - 49-64);
        _childController = trailer;
        trailer.delegate = self;
        [self.view addSubview:trailer.tableView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
