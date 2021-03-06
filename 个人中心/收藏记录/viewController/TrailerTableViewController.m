//
//  TrailerTableViewController.m
//  Unibox_iOS
//
//  Created by 刘羽 on 15/11/30.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import "TrailerTableViewController.h"
#import "TrailerFavTableViewCell.h"
#import "Header.h"
#import "API.h"
#import "PrevueFavModel.h"
#import "AppDelegate.h"
#import "NetWork.h"
#import "ZixunDetailViewController.h"

@interface TrailerTableViewController ()
{
    //数据源
    NSMutableArray *_dataArr;
    //记录删除数据
    NSMutableArray *_selectArr;
}
@end

@implementation TrailerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _dataArr = [NSMutableArray array];
    _selectArr = [NSMutableArray array];
    [self.tableView registerNib:[UINib nibWithNibName:@"TrailerFavTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TFCell"];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //加载数据
    [self loadData];

}


- (void)loadData{
    //加载完数据后修改footerView
    
    //AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    JGProgressHUD *hud = [[JGProgressHUD alloc]initWithStyle:JGProgressHUDStyleDark];
    //hud.position = JGProgressHUDPositionTopCenter;
    [hud showInView:self.navigationController.view];
    
    TrailerTableViewController *__weak weakSelf = self;
    NSDictionary *dic = @{
                          @"_memberId":[User objectForKey:kMemberId],
                          @"_accessToken":[User objectForKey:kAccessToken]
                          };
    [NetWork getRequest:[NSString stringWithFormat:@"http://%@%@",app.host_ip,getFavPrevueList] params:dic success:^(id responseObj) {
        if (![responseObj[@"ret"] boolValue]) {
            for (NSDictionary *d in responseObj[@"list"]) {
                PrevueFavModel *model = [[PrevueFavModel alloc]init];
                [model setValuesForKeysWithDictionary:d];
                model.isSelect = NO;
                [_dataArr addObject:model];
            }
            weakSelf.numOfRows = _dataArr.count;
            //加载完数据后修改footerView
            [weakSelf createTableviewFooter];
            
        }
        [hud dismissAnimated:YES];
    } failure:^(NSError *error) {
        [hud dismissAnimated:YES];
    }];
//    [manager GET:[NSString stringWithFormat:@"http://%@%@",app.host_ip,getFavPrevueList] parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        if (![responseObject[@"ret"] boolValue]) {
//            for (NSDictionary *d in responseObject[@"list"]) {
//                PrevueFavModel *model = [[PrevueFavModel alloc]init];
//                [model setValuesForKeysWithDictionary:d];
//                model.isSelect = NO;
//                [_dataArr addObject:model];
//            }
//            weakSelf.numOfRows = _dataArr.count;
//            //加载完数据后修改footerView
//            [weakSelf createTableviewFooter];
//            
//        }
//        [hud dismissAnimated:YES];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        //
//        [hud dismissAnimated:YES];
//    }];
    
    
    
//    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
//    footerView.backgroundColor = [UIColor whiteColor];
//    UILabel *label = [MyControl createLabelWithFrame:CGRectMake(0, 0, 300, 40) Font:14.0f Text:@"共收藏5部预告片"];
//    [label sizeToFit];
//    label.x = (kScreenWidth - label.width) / 2;
//    label.y = (100 - label.height) / 2;
//    label.textColor = RGB(120, 120, 120);
//    [footerView addSubview:label];
//    self.tableView.tableFooterView = footerView;
//    self.numOfRows = 5;
}

#pragma mark 创建tableview的footerView
- (void)createTableviewFooter{
    
    UILabel *label = [MyControl createLabelWithFrame:CGRectMake(0, 0, 300, 100) Font:14.0f Text:[NSString stringWithFormat:@"共收藏%ld部预告片",_dataArr.count]];
    if (_dataArr.count == 0) {
        label.text = @"暂无收藏预告片";
    }
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = RGB(120, 120, 120);
    label.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = label;
    [self.tableView reloadData];
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TrailerFavTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TFCell" forIndexPath:indexPath];
    [cell.selBtn addTarget:self action:@selector(selBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.selBtn.tag = indexPath.row + 13400;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configUI:_dataArr[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PrevueFavModel *model = _dataArr[indexPath.row];
    ZixunDetailViewController *vc = [[ZixunDetailViewController alloc]init];
    vc.type = NO;
    vc.zixunId = model.prevueId;
    vc.url = [NSString stringWithFormat:@"%@?id=%@",Prevue_IP, model.prevueId];
    //vc.desText = [NSString stringWithFormat:@"%@...",[model.synopsis substringToIndex:20]] ;
    //NSLog(@"%@",vc.url);
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)selBtnClick:(UIButton *)btn{
    NSLog(@"321312");
    [_dataArr[btn.tag - 13400] setIsSelect:![_dataArr[btn.tag - 13400] isSelect]];
    [_selectArr addObject:_dataArr[btn.tag - 13400]];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:btn.tag - 13400 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    
    [self.delegate selectBtnClick:[_dataArr[btn.tag - 13400] isSelect]];
}

- (void)selectAllRow{
    for (PrevueFavModel *model in _dataArr) {
        model.isSelect = YES;
    }
    _selectArr = [NSMutableArray arrayWithArray:_dataArr];
    [self.tableView reloadData];
}

- (void)deSelectAllRow{
    for (PrevueFavModel *model in _dataArr) {
        model.isSelect = NO;
    }
    [_selectArr removeAllObjects];
    [self.tableView reloadData];
}

#pragma mark 删除某一行
- (void)delSelectRow{
    /*
     * 控制器：Fav
     * 方法：  deleteUserFav
     * 参数：
     ** favId            收藏唯一ID, 多个用逗号隔开
     ** _memberId        用户ID
     ** _accessToken     用户accessToken
     */
    NSMutableArray *arr = [NSMutableArray array];
    for (PrevueFavModel *model in _selectArr) {
        [arr addObject:model.favId];
    }
    
    NSDictionary *dic = @{
                          @"_memberId":[User objectForKey:kMemberId],
                          @"_accessToken":[User objectForKey:kAccessToken],
                          @"favId":[arr componentsJoinedByString:@","]
                          };
    TrailerTableViewController *__weak weakSelf = self;
    //AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [NetWork getRequest:[NSString stringWithFormat:@"http://%@%@",app.host_ip,deletePrevueFav] params:dic success:^(id responseObj) {
        if (![responseObj[@"ret"] boolValue]) {
            [_dataArr removeObjectsInArray:_selectArr];
            [_selectArr removeAllObjects];
            
            [weakSelf createTableviewFooter];
            [weakSelf.tableView reloadData];
            weakSelf.numOfRows = _dataArr.count;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"delSelectRow" object:responseObj[@"ret"]];
    } failure:^(NSError *error) {
        //
    }];
//    [NetWork get:[NSString stringWithFormat:@"http://%@%@",app.host_ip,deletePrevueFav] parameters:dic success:^(id responseObject) {
//        if (![responseObject[@"ret"] boolValue]) {
//            [_dataArr removeObjectsInArray:_selectArr];
//            [_selectArr removeAllObjects];
//            
//            [weakSelf createTableviewFooter];
//            [weakSelf.tableView reloadData];
//            weakSelf.numOfRows = _dataArr.count;
//        }
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"delSelectRow" object:responseObject[@"ret"]];
//    } fail:^(NSError *error) {
//        //
//    }];
//    [manager GET:[NSString stringWithFormat:@"http://%@%@",app.host_ip,deletePrevueFav] parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        //
//        if (![responseObject[@"ret"] boolValue]) {
//            [_dataArr removeObjectsInArray:_selectArr];
//            [_selectArr removeAllObjects];
//            
//            [weakSelf createTableviewFooter];
//            [weakSelf.tableView reloadData];
//            weakSelf.numOfRows = _dataArr.count;
//        }
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"delSelectRow" object:responseObject[@"ret"]];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        //
//    }];
}


@end
