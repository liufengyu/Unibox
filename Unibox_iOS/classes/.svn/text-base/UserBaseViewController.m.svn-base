//
//  UserBaseViewController.m
//  Unibox_iOS
//
//  Created by 刘羽 on 15/10/23.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import "UserBaseViewController.h"
#import "Header.h"

@interface UserBaseViewController ()

@end

@implementation UserBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
//    [self.navigationController.navigationBar setBarTintColor:kWhite_Main];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    //修改导航栏左按钮
    [self configLeftItem];
}

#pragma mark 修改导航栏左按钮
//修改导航栏左按钮
- (void)configLeftItem
{
    UIButton *backBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, 23/2, 39/2) target:self SEL:@selector(backBtnClick) title:nil];
    [backBtn setBackgroundImage:imageNamed(@"login_back") forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
}

#pragma mark 导航栏左按钮点击事件
- (void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
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
