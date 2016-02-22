//
//  helpCenterController.m
//  Unibox_iOS
//
//  Created by 刘羽 on 15/10/27.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import "helpCenterController.h"
#import "Header.h"
#import "UIImage+Color.h"
#import "HelpDetailController.h"

@interface helpCenterController () <UITableViewDataSource, UITableViewDelegate>
{
    NSArray *_dataArr;
}
@end

@implementation helpCenterController

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:kWhite_Main] forBarMetrics:UIBarMetricsDefault];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"帮助中心";
    self.view.backgroundColor = [UIColor colorWithHexString:@"ededed"];
    
    //初始化数据源
    _dataArr = @[@[@"租碟流程",@"租碟须知",@"碟片保护方法",@"优博卡"],@[@"货到付款区域",@"配送方式",@"支付方式",@"退换货原则",@"产品质量保证"]];
    
    //创建UITableView
    [self createTB];
}

//创建UITableView
- (void)createTB
{
    UITableView *_tb = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth - 20, kScreenHeight - kStatus_Height - kNav_Height) style:UITableViewStylePlain];
    _tb.backgroundColor = [UIColor clearColor];
    _tb.dataSource = self;
    _tb.delegate = self;
    _tb.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_tb];
    
}

#pragma mark - UITableView代理
/*
 设置行高
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95.0f / 2;
}

/*
 设置段头高
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 15.0f;
    }
    else
    {
        return 0.0f;
    }
}

/*
 设置段数
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArr.count;
}

/*
 设置行数
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_dataArr objectAtIndex:section] count];
}

/*
 UITableViewCell
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    cell.textLabel.text = _dataArr[indexPath.section][indexPath.row];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"343434"];
    UIImageView *iv = [MyControl createImageViewFrame:CGRectMake(kScreenWidth - 20 - 10 - 11.5, (95.0/2 - 20)/2, 11.5, 20) imageName:@"arrow_black"];
    [cell.contentView addSubview:iv];
    return cell;
}

/*
 cell点击事件
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HelpDetailController *vc = [[HelpDetailController alloc]init];
    vc.navTitle = _dataArr[indexPath.section][indexPath.row];
    vc.type = indexPath.section * 4 + indexPath.row;
    [self.navigationController pushViewController:vc animated:YES];
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
