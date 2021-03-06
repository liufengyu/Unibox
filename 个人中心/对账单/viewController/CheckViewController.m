//
//  CheckViewController.m
//  Unibox_iOS
//
//  Created by 刘羽 on 15/11/28.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import "CheckViewController.h"
#import "Header.h"
#import "CheckSectionView.h"
#import "CheckTableViewCell.h"
#import "CheckDetailViewController.h"
#import "API.h"
#import "AppDelegate.h"
#import "BillModel.h"
#import "NetWork.h"

@interface CheckViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *_dataArr;
    UITableView *_tb;
}
@end

@implementation CheckViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    _dataArr = [NSMutableArray array];
    self.title = @"对账单";
    self.view.backgroundColor = kWhite_Main;
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    
    
    
    //创建UI
    [self createUI];
    
    //加载数据
    [self loadData];
}

#pragma mark 加载数据
- (void)loadData{
    //AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *dic = @{
                          @"_memberId":[User objectForKey:kMemberId],
                          @"_accessToken":[User objectForKey:kAccessToken]
                          };
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    
    [NetWork getRequest:[NSString stringWithFormat:@"http://%@%@",app.host_ip,getBillList] params:dic success:^(id responseObj) {
        if (![responseObj[@"ret"] boolValue]) {
            for (NSDictionary *d in responseObj[@"list"]) {
                BillModel *model = [[BillModel alloc]init];
                [model setValuesForKeysWithDictionary:d];
                [_dataArr addObject:model];
            }
            [_tb reloadData];
        }
    } failure:^(NSError *error) {
        //
    }];
    
}



#pragma mark 创建UI
- (void)createUI{
    UITableView *tb = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    _tb = tb;
    tb.delegate = self;
    tb.dataSource = self;
    [tb registerNib:[UINib nibWithNibName:@"CheckTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CKCell"];
    tb.backgroundColor = [UIColor clearColor];
    tb.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tb];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    BillModel *model = _dataArr[section];
    return [model.list count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CheckTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CKCell" forIndexPath:indexPath];
    BillModel *model = _dataArr[indexPath.section];
    BillDetailModel *detailModel = [model.list objectAtIndex:indexPath.row];
    [cell configUI:detailModel];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CheckSectionView *view = [[[NSBundle mainBundle]loadNibNamed:@"CheckSectionView" owner:self options:nil]lastObject];
    BillModel *model = _dataArr[section];
    view.frame = CGRectMake(0, 0, kScreenWidth, 35.0);
    view.monthLb.text = model.month;
    view.totalLb.text = [NSString stringWithFormat:@"累计消费:￥%.2f",
                         [model.total floatValue]];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //跳转到对账单明细
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CheckDetailViewController *vc = [[CheckDetailViewController alloc]init];
    BillModel *model = _dataArr[indexPath.section];
    BillDetailModel *detailModel = [model.list objectAtIndex:indexPath.row];
    vc.billId = detailModel.billId;
    //修改返回按钮
    [self configLeftBar];
    [self.navigationController pushViewController:vc animated:YES];
    
}


@end
