//
//  TrailerViewController.m
//  Unibox_iOS
//
//  Created by 刘羽 on 15/11/26.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import "TrailerViewController.h"
#import "Header.h"
#import "TrailerTableViewCell.h"
#import "TrailerDetailController.h"
#import "API.h"
#import "MJRefresh.h"
#import "PrevueModel.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "AFNetworking.h"
#import "ZixunDetailViewController.h"
#import "ScreenImage.h"

@interface TrailerViewController ()
{
    //广告数据
    PrevueModel *_adModel;
    //预告片数据
    NSMutableArray *_dataArr;
    //活动列表页码
    int _page;
    
    MJRefreshNormalHeader *_header;
    MJRefreshBackNormalFooter *_footer;
}
@end

@implementation TrailerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    _dataArr = [NSMutableArray array];
    //self.view.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
    self.tableView = [[UITableView alloc]initWithFrame:self.tableView.frame style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"TrailerTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TCell"];
    
    //加载广告数据
    [self loadAdData];
    //加载预告片数据
    [self loadData];
    //[self configTb];
}

#pragma mark 加载广告位数据
- (void)loadAdData{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    TrailerViewController *__weak weakSelf = self;
    [manager GET:[NSString stringWithFormat:@"http://%@%@",app.host_ip,getHotPrevue] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (![responseObject[@"ret"]boolValue]) {
            _adModel = [[PrevueModel alloc]init];
            NSLog(@"%@",responseObject);
            [_adModel setValuesForKeysWithDictionary:responseObject[@"prevue"]];
            //加载广告数据
            [weakSelf configTb];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
    }];
}

#pragma mark 加载预告片数据
- (void)loadData{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    TrailerViewController *__weak weakSelf = self;
    NSDictionary *dic = @{
                          @"page":[NSString stringWithFormat:@"%d",_page]
                          };
    [manager GET:[NSString stringWithFormat:@"http://%@%@",app.host_ip,getPrevueList] parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (![responseObject[@"ret"] boolValue]) {
            for (NSDictionary *d in responseObject[@"list"]) {
                PrevueModel *model = [[PrevueModel alloc]init];
                [model setValuesForKeysWithDictionary:d];
                [_dataArr addObject:model];
            }
            [weakSelf.tableView reloadData];
            [_header endRefreshing];
            [_footer endRefreshing];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
    }];
}

- (void)configTb{
    //self.tableView.contentInset = UIEdgeInsetsMake(120 , 0, 0, 0);
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 195)];
    //UIButton *adBtn = [MyControl createButtonWithFrame:CGRectMake(0, 10 , kScreenWidth, 110 ) target:self SEL:@selector(adBtnClick) title:nil];
    //UIImageView *adImg = [MyControl createImageViewFrame:CGRectMake(0, 10, kScreenWidth, 110) imageName:nil];
    //[adImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_IP, _adModel.img]] placeholderImage:[UIImage imageNamed:@"placehold"]];
    //NSLog(@"%@",[NSString stringWithFormat:@"%@%@",Image_IP, _adModel.img]);
    
    UIButton *adBtn = [MyControl createButtonWithFrame:CGRectMake(0, 10, kScreenWidth, 185) target:self SEL:@selector(adBtnClick) title:nil];
    adBtn.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    //[adBtn setImage:imageNamed(@"btn-bofang1") forState:UIControlStateNormal];
    [adBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_IP, _adModel.img]] forState:UIControlStateNormal placeholderImage:imageNamed(@"placehold") completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [adBtn setBackgroundImage:[ScreenImage shotImageContext:image View:adBtn] forState:UIControlStateNormal];
    }];
    
    //[adImg addSubview:adBtn];
    [headView addSubview:adBtn];
    self.tableView.tableHeaderView = headView;
    
    TrailerViewController *__weak weakSelf = self;
    _header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        [_dataArr removeAllObjects];
        [weakSelf loadData];
    }];
    _footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _page++;
        [weakSelf loadData];
    }];
    _header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = _header;
    self.tableView.mj_footer = _footer;
}


#pragma mark 广告按钮点击事件
- (void)adBtnClick{
    //NSLog(@"fasdfas");
    ZixunDetailViewController *vc = [[ZixunDetailViewController alloc]init];
    vc.url = [NSString stringWithFormat:@"%@?id=%@",Prevue_IP,_adModel.prevueId];
    vc.zixunId = _adModel.prevueId;
    vc.type = NO;
    //NSLog(@"%@",_adModel.prevueId);
    [self.delegate configLeftBar];
    //
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120.0 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TrailerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCell" forIndexPath:indexPath];
    [cell configUI:_dataArr[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    PrevueModel *model = _dataArr[indexPath.row];

    ZixunDetailViewController *vc = [[ZixunDetailViewController alloc]init];
    vc.url = [NSString stringWithFormat:@"%@?id=%@",Prevue_IP,model.prevueId];
    vc.zixunId = model.prevueId;
    vc.type = NO;
    //NSLog(@"%@",model.prevueId);
    [self.delegate configLeftBar];
    //
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
