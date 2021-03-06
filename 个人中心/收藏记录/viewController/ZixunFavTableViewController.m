//
//  ZixunFavTableViewController.m
//  Unibox_iOS
//
//  Created by 刘羽 on 15/11/30.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import "ZixunFavTableViewController.h"
#import "ZixunFavTableViewCell.h"
#import "Header.h"
#import "AppDelegate.h"
#import "API.h"
#import "NewsFavModel.h"
#import "AFNetworking.h"
#import "ZixunDetailViewController.h"

@interface ZixunFavTableViewController ()
{
    NSMutableArray *_dataArr;
    NSMutableArray *_selectArr;
}
@end

@implementation ZixunFavTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _dataArr = [NSMutableArray array];
    _selectArr = [NSMutableArray array];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ZixunFavTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZFCell"];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //加载数据
    [self loadData];
}

#pragma mark 加载数据
- (void)loadData{
    //加载完数据后修改footerView
    //加载完成刷新
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    JGProgressHUD *hud = [[JGProgressHUD alloc]initWithStyle:JGProgressHUDStyleDark];
    //hud.position = JGProgressHUDPositionTopCenter;
    [hud showInView:self.navigationController.view];
    
    ZixunFavTableViewController *__weak weakSelf = self;
    NSDictionary *dic = @{
                          @"_memberId":[User objectForKey:kMemberId],
                          @"_accessToken":[User objectForKey:kAccessToken]
                          };
    [manager GET:[NSString stringWithFormat:@"http://%@%@",app.host_ip,getNewsList] parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (![responseObject[@"ret"] boolValue]) {
            for (NSDictionary *d in responseObject[@"list"]) {
                NewsFavModel *model = [[NewsFavModel alloc]init];
                [model setValuesForKeysWithDictionary:d];
                model.isSelect = NO;
                [_dataArr addObject:model];
            }
            weakSelf.numOfRows = _dataArr.count;
            //加载完数据后修改footerView
            [weakSelf createTableviewFooter];
            
        }
        [hud dismissAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
        [hud dismissAnimated:YES];
    }];


}
#pragma mark 创建tableview的footerView
- (void)createTableviewFooter{
    
    UILabel *label = [MyControl createLabelWithFrame:CGRectMake(0, 0, 300, 100) Font:14.0f Text:[NSString stringWithFormat:@"共收藏%ld部影片",_dataArr.count]];
    if (_dataArr.count == 0) {
        label.text = @"暂无收藏影片";
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
    ZixunFavTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZFCell" forIndexPath:indexPath];
    [cell.selBtn addTarget:self action:@selector(selBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.selBtn.tag = indexPath.row + 13500;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configUI:_dataArr[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsFavModel *model = _dataArr[indexPath.row];
    //model.newsId;
    NSString *url = [NSString stringWithFormat:@"%@?id=%@",Zixun_IP,model.newsId];
    ZixunDetailViewController *vc = [[ZixunDetailViewController alloc]init];
    vc.type = YES;
    vc.url = url;
    vc.zixunId = model.newsId;
    vc.desText = model.profile;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)selBtnClick:(UIButton *)btn{
    [_dataArr[btn.tag - 13500] setIsSelect:![_dataArr[btn.tag - 13500] isSelect]];
    [_selectArr addObject:_dataArr[btn.tag - 13500]];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:btn.tag - 13500 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    
    [self.delegate selectBtnClick:[_dataArr[btn.tag - 13500] isSelect]];
}

- (void)selectAllRow{
    for (NewsFavModel *model in _dataArr) {
        model.isSelect = YES;
    }
    _selectArr = [NSMutableArray arrayWithArray:_dataArr];
    [self.tableView reloadData];
}

- (void)deSelectAllRow{
    for (NewsFavModel *model in _dataArr) {
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
    for (NewsFavModel *model in _selectArr) {
        [arr addObject:model.favId];
    }
    
    NSDictionary *dic = @{
                          @"_memberId":[User objectForKey:kMemberId],
                          @"_accessToken":[User objectForKey:kAccessToken],
                          @"favId":[arr componentsJoinedByString:@","]
                          };
    ZixunFavTableViewController *__weak weakSelf = self;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [manager GET:[NSString stringWithFormat:@"http://%@%@",app.host_ip,deleteNewsFav] parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //
        if (![responseObject[@"ret"] boolValue]) {
            [_dataArr removeObjectsInArray:_selectArr];
            [_selectArr removeAllObjects];
            
            [weakSelf createTableviewFooter];
            [weakSelf.tableView reloadData];
            weakSelf.numOfRows = _dataArr.count;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"delSelectRow" object:responseObject[@"ret"]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
    }];
}



@end
