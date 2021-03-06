//
//  RentalListController.m
//  Unibox_iOS
//
//  Created by 刘羽 on 15/12/9.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import "RentalListController.h"
#import "Header.h"
#import "RentalTableViewCell.h"
#import "RentalModel.h"
#import "API.h"
#import "AppDelegate.h"
#import "UIImage+Color.h"
#import "MJRefresh.h"
#import "RentalDetailController.h"
#import "NetWork.h"
#import "CommitViewController.h"

@interface RentalListController () <UITableViewDataSource, UITableViewDelegate, RentalTableViewCellDelegate>
{
    UITableView *_tb;
    NSMutableArray *_dataArr;
    NSString *_type;
    int page;
    
    UIButton *_selectedBtn;
    UIView *_line;
    
    MJRefreshNormalHeader *_head;
    MJRefreshBackNormalFooter *_foot;
}
@end

@implementation RentalListController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    //[_head beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = kWhite_Main;
    self.title = @"我的订单";
    _type = @"all";
    page = 1;
    _dataArr = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshList) name:@"refreshList" object:nil];
    
    [self configLeftBar];
    
    [self createUI];
    
    
    [self loadData];
}

#pragma mark 刷新列表
- (void)refreshList{
    [_head beginRefreshing];
}

#pragma mark 加载数据
- (void)loadData{
    //AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *dic = @{
                          @"_memberId":[User objectForKey:kMemberId],
                          @"_accessToken":[User objectForKey:kAccessToken],
                          @"type":_type,
                          @"page":[NSString stringWithFormat:@"%d",page]
                          };
    //JGProgressHUD *hud = [[JGProgressHUD alloc]initWithStyle:JGProgressHUDStyleDark];
    //hud.textLabel.text = @"加载中..";
    //[hud showInView:self.view];
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [NetWork getRequest:[NSString stringWithFormat:@"http://%@%@",app.host_ip,getRentalList] params:dic success:^(id responseObj) {
        if (![responseObj[@"ret"] boolValue]) {
            for (NSDictionary *d in responseObj[@"list"]) {
                RentalModel *model = [[RentalModel alloc]init];
                [model setValuesForKeysWithDictionary:d];
                [_dataArr addObject:model];
            }
            //[hud dismissAnimated:YES];
            [_head endRefreshing];
            [_foot endRefreshing];
            [_tb reloadData];
        }
    } failure:^(NSError *error) {
        //
    }];
//    [NetWork get:[NSString stringWithFormat:@"http://%@%@",app.host_ip,getRentalList] parameters:dic success:^(id responseObject) {
//        if (![responseObject[@"ret"] boolValue]) {
//            for (NSDictionary *d in responseObject[@"list"]) {
//                RentalModel *model = [[RentalModel alloc]init];
//                [model setValuesForKeysWithDictionary:d];
//                [_dataArr addObject:model];
//            }
//            [hud dismissAnimated:YES];
//            [_head endRefreshing];
//            [_foot endRefreshing];
//            [_tb reloadData];
//        }
//    } fail:^(NSError *error) {
//        //
//    }];
//    [manager GET:[NSString stringWithFormat:@"http://%@%@",app.host_ip,getRentalList] parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        //
//        //NSLog(@"%@",responseObject);
//        if (![responseObject[@"ret"] boolValue]) {
//            for (NSDictionary *d in responseObject[@"list"]) {
//                RentalModel *model = [[RentalModel alloc]init];
//                [model setValuesForKeysWithDictionary:d];
//                [_dataArr addObject:model];
//            }
//            [hud dismissAnimated:YES];
//            [_head endRefreshing];
//            [_foot endRefreshing];
//            [_tb reloadData];
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        //
//    }];
}

- (void)createUI{
    UIView *gView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    gView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:gView];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 10 + 64, kScreenWidth, 35)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    CGFloat width = kScreenWidth / 5;
    CGFloat height = 34;
    
    NSArray *titArr = @[@"全部",@"已预订",@"已取碟",@"待评价",@"已取消"];
    for (int i = 0; i < 5; i++) {
        UIButton *btn = [MyControl createButtonWithFrame:CGRectMake(width * i, 0, width, height) target:self SEL:@selector(btnClick:) title:titArr[i]];
        [btn setTitleColor:kRed forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [bgView addSubview:btn];
        btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        btn.tag = 15100 + i;
        if (i == 0){
            btn.selected = YES;
            _selectedBtn = btn;
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(btn.x, btn.y + btn.height, btn.width, 1)];
            line.backgroundColor = kRed;
            _line = line;
            [bgView addSubview:line];
        }
        [bgView addSubview:btn];
    }
    
    UITableView *tb = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(bgView.frame), kScreenWidth, kScreenHeight - CGRectGetMaxY(bgView.frame)) style:UITableViewStyleGrouped];
    _tb = tb;
    tb.backgroundColor = [UIColor clearColor];
    tb.delegate = self;
    tb.dataSource = self;
    [tb registerNib:[UINib nibWithNibName:@"RentalTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"RTCell"];
    
    _head = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        [_dataArr removeAllObjects];
        [self loadData];
    }];
    _head.lastUpdatedTimeLabel.hidden = YES;
    
    _foot = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        page++;
        [self loadData];
    }];
    
    tb.mj_header = _head;
    tb.mj_footer = _foot;
    
    
    [self.view addSubview:tb];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArr.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RentalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RTCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_dataArr.count > 0){
    RentalModel *model = _dataArr[indexPath.section];
    
    cell.delegate = self;
    [cell configUI:model];
    }
    return cell;
}

- (void)commitWith:(RentalTableViewCell *)cell{
    NSIndexPath *index = [_tb indexPathForCell:cell];
    NSLog(@"%ld",index.section);
    CommitViewController *vc = [[CommitViewController alloc]init];
    vc.model = _dataArr[index.section];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RentalDetailController *vc = [[RentalDetailController alloc]init];
    //
    vc.rModel = _dataArr[indexPath.section];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)btnClick:(UIButton *)btn{
    if (_selectedBtn != btn) {
        btn.selected = YES;
        _selectedBtn.selected = NO;
        _selectedBtn = btn;
        [UIView animateWithDuration:0.25 animations:^{
            _line.frame = CGRectMake(btn.x, btn.y + btn.height, btn.width, 1);
        }];
        page = 1;
        if (btn.tag - 15100 == 0) {
            _type = @"all";
        } else if (btn.tag - 15100 == 1) {
            _type = @"reserve";
        } else if (btn.tag - 15100 == 2) {
            _type = @"rental";
        } else if (btn.tag - 15100 == 3) {
            _type = @"complete";
        } else {
            _type = @"cancel";
        }
        [_dataArr removeAllObjects];
        [self loadData];
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
