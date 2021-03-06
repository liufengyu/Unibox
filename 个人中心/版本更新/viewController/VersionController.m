//
//  VersionController.m
//  Unibox_iOS
//
//  Created by 刘羽 on 15/12/7.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import "VersionController.h"
#import "Header.h"

@interface VersionController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation VersionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"版本更新";
    self.view.backgroundColor = RGB(232, 233, 232);
    //[self configLeftBar];
    //创建UI
    [self createUI];
}

#pragma mark 创建UI
- (void)createUI{
    UIView *naviBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64.0)];
    naviBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:naviBar];
    
    UIImageView *iv = [MyControl createImageViewFrame:CGRectMake((kScreenWidth - 80) / 2, 20 + 44.0, 80.0, 80.0) imageName:@"version-icon"];
    [self.view addSubview:iv];
    
    UILabel *lb1 = [MyControl createLabelWithFrame:CGRectMake(0, 0, 300, 50) Font:18.0 Text:@"UNIBOX   优尼博思"];
    [lb1 sizeToFit];
    lb1.x = (kScreenWidth - lb1.width) / 2;
    lb1.y = CGRectGetMaxY(iv.frame) + 20;
    [self.view addSubview:lb1];
    
    UILabel *lb2 = [MyControl createLabelWithFrame:CGRectMake(0, 0, 300, 50) Font:14.0f Text:@"V1.0 内部测试版"];
    [lb2 sizeToFit];
    lb2.x = (kScreenWidth - lb2.width) / 2;
    lb2.y = CGRectGetMaxY(lb1.frame) + 10;
    [self.view addSubview:lb2];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(lb2.frame) + 20, kScreenWidth - 20, 100)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.borderWidth = 1.0f;
    bgView.layer.borderColor = RGB(193, 193, 193).CGColor;
    bgView.layer.cornerRadius = 3.0f;
    [self.view addSubview:bgView];
    
    UITableView *tb = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, bgView.width, bgView.height) style:UITableViewStylePlain];
    tb.layer.cornerRadius = 3.0f;
    tb.separatorStyle = UITableViewCellSeparatorStyleNone;
    tb.delegate = self;
    tb.dataSource = self;
    tb.scrollEnabled = NO;
    [bgView addSubview:tb];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *iden = @"iden";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    if (indexPath.row == 0) {
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 49.0, kScreenWidth - 20, 1)];
        line.backgroundColor = RGB(237, 237, 237);
        [cell.contentView addSubview:line];
        cell.textLabel.text = @"检测新版本";
    } else {
        cell.textLabel.text = @"版本说明";
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.accessoryView = [[UIImageView alloc]initWithImage:imageNamed(@"btn-more")];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        //检测新版本
        JGProgressHUD *hud = [[JGProgressHUD alloc]initWithStyle:JGProgressHUDStyleDark];
        hud.indicatorView = nil;
        hud.textLabel.text = @"正在检测是否有新版本,请稍候.";
        hud.position = JGProgressHUDPositionBottomCenter;
        [hud showInView:self.view];
        
        [hud dismissAfterDelay:2.0f animated:YES];
        
        
    } else {
        //版本说明
    }
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
