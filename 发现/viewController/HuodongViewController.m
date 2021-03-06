//
//  HuodongViewController.m
//  Unibox_iOS
//
//  Created by 刘羽 on 15/11/26.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import "HuodongViewController.h"
#import "Header.h"
#import "HuodongZeroTableViewCell.h"
#import "HuodongFirstTableViewCell.h"
#import "AppDelegate.h"
#import "API.h"
#import "ActAdmodel.h"
#import "ActModel.h"
#import "UIButton+WebCache.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "ZixunDetailViewController.h"
#import "MovieDetailController.h"
#import "UIImage+Tint.h"
#import "LoginController.h"
#import "ScreenImage.h"

@interface HuodongViewController ()
{
    //广告数据
    NSMutableArray *_adArr;
    //在线活动列表数据
    NSMutableArray *_dataArr;
    //往期活动列表
    NSMutableArray *_oldArr;
    //活动列表页码
    int _page;
    //广告
    UIPageControl *_adPage;
    UIScrollView *_sc;
    
    MJRefreshNormalHeader *_header;
    MJRefreshBackNormalFooter *_footer;
    NSTimer *_timer;
}
@end

@implementation HuodongViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    _adArr = [NSMutableArray array];
    _dataArr = [NSMutableArray array];
    _oldArr = [NSMutableArray array];
    _page = 1;
    self.tableView = [[UITableView alloc]initWithFrame:self.tableView.frame style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[HuodongZeroTableViewCell class] forCellReuseIdentifier:@"hotCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HuodongZeroTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"hotCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HuodongFirstTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"earlyCell"];
    
    
    
    //加载广告数据
    [self loadAdData];
    
    [self loadData];
    [self loadOldData];
}

#pragma mark 加载热门活动数据
- (void)loadData{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    HuodongViewController *__weak weakSelf = self;
    [manager GET:[NSString stringWithFormat:@"http://%@%@",app.host_ip,getOnlineAct] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (![responseObject[@"ret"]boolValue]) {
            for (NSDictionary *dic in responseObject[@"list"]) {
                ActModel *model = [[ActModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArr addObject:model];
            }
            //[weakSelf.tableView reloadData];
            [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
    }];
}

#pragma mark 加载往期活动数据
- (void)loadOldData{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    HuodongViewController *__weak weakSelf = self;
    NSDictionary *d = @{
                        @"page":[NSString stringWithFormat:@"%d",_page]
                        };
    [manager GET:[NSString stringWithFormat:@"http://%@%@",app.host_ip,getOfflineAct] parameters:d success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (![responseObject[@"ret"]boolValue]) {
            for (NSDictionary *dic in responseObject[@"list"]) {
                ActModel *model = [[ActModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [_oldArr addObject:model];
            }
            [_header endRefreshing];
            [_footer endRefreshing];
            [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
    }];
}

#pragma mark 加载广告数据
- (void)loadAdData{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    HuodongViewController *__weak weakSelf = self;
    [manager GET:[NSString stringWithFormat:@"http://%@%@",app.host_ip,getActAdList] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (![responseObject[@"ret"] boolValue]) {
            for (NSDictionary *d in responseObject[@"list"]) {
                ActAdmodel *model = [[ActAdmodel alloc]init];
                [model setValuesForKeysWithDictionary:d];
                [_adArr addObject:model];
            }
            //调整tableView 加入广告图片
            [weakSelf configTb];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
    }];
}

#pragma mark 广告按钮
- (void)configTb{
    //self.tableView.contentInset = UIEdgeInsetsMake(185 , 0, 0, 0);
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 195)];
    if (_adArr.count == 1) {
        ActAdmodel *model = _adArr[0];
        UIButton *adBtn = [MyControl createButtonWithFrame:CGRectMake(0, 10 , kScreenWidth, 175 ) target:self SEL:@selector(adBtnClick:) title:nil];
        [adBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_IP,model.img]] forState:UIControlStateNormal placeholderImage:imageNamed(@"placehold") completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [adBtn setBackgroundImage:[ScreenImage shotImageContext:image View:adBtn] forState:UIControlStateNormal];
        }];
        adBtn.tag = 34000;
        [headView addSubview:adBtn];
    } else{
        UIScrollView *sc = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 10, kScreenWidth, 175)];
        sc.pagingEnabled = YES;
        sc.backgroundColor =kRed;
        sc.contentSize = CGSizeMake(kScreenWidth * (_adArr.count + 2), 175);
        sc.showsHorizontalScrollIndicator = NO;
        sc.contentOffset = CGPointMake(kScreenWidth, 0);
        sc.bounces = NO;
        sc.delegate = self;
        _sc = sc;
        //self.tableView.tableHeaderView = sc;
        //[self.tableView addSubview:sc];
        [headView addSubview:sc];
        for (int i = 0; i < _adArr.count; i++) {
            ActAdmodel *model = _adArr[i];
            UIButton *adBtn = [MyControl createButtonWithFrame:CGRectMake(kScreenWidth * (i+1), 0, kScreenWidth, 175) target:self SEL:@selector(adBtnClick:) title:nil];
            //[adBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_IP,model.img]] forState:UIControlStateNormal placeholderImage:imageNamed(@"placehold2")];
            [adBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_IP,model.img]] forState:UIControlStateNormal placeholderImage:imageNamed(@"placehold") completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [adBtn setBackgroundImage:[ScreenImage shotImageContext:image View:adBtn] forState:UIControlStateNormal];
            }];
            adBtn.tag = 34000 + i;
            [sc addSubview:adBtn];
        }
        ActAdmodel *model0 = _adArr[0];
        UIButton *adBtn0 = [MyControl createButtonWithFrame:CGRectMake(kScreenWidth * (_adArr.count + 1), 0, kScreenWidth, 175) target:self SEL:@selector(adBtnClick:) title:nil];
        //[adBtn0 sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_IP,model0.img]] forState:UIControlStateNormal placeholderImage:imageNamed(@"placehold2")];
        [adBtn0 sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_IP,model0.img]] forState:UIControlStateNormal placeholderImage:imageNamed(@"placehold2") completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [adBtn0 setBackgroundImage:[ScreenImage shotImageContext:image View:adBtn0] forState:UIControlStateNormal];
        }];
        adBtn0.tag = 34000;
        [sc addSubview:adBtn0];
        ActAdmodel *model1 = _adArr[_adArr.count - 1];
        UIButton *adBtn1 = [MyControl createButtonWithFrame:CGRectMake(0, 0, kScreenWidth, 175) target:self SEL:@selector(adBtnClick:) title:nil];
        //[adBtn1 sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_IP,model1.img]] forState:UIControlStateNormal placeholderImage:imageNamed(@"placehold2")];
        [adBtn1 sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_IP,model1.img]] forState:UIControlStateNormal placeholderImage:imageNamed(@"placehold") completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [adBtn1 setBackgroundImage:[ScreenImage shotImageContext:image View:adBtn1] forState:UIControlStateNormal];
        }];
        adBtn1.tag = 34000 + _adArr.count - 1;
        [sc addSubview:adBtn1];
        
        UIPageControl *page = [[UIPageControl alloc]initWithFrame:CGRectMake(kScreenWidth - 100, 155 , 100, 30 )];
        page.numberOfPages = _adArr.count;
        //page.currentPageIndicatorTintColor = [UIColor redColor];
        
        page.currentPageIndicatorTintColor = [UIColor colorWithPatternImage:imageNamed(@"index-page-s")];
        //page.pageIndicatorTintColor = [UIColor lightGrayColor];
        page.pageIndicatorTintColor = [UIColor colorWithPatternImage:imageNamed(@"index-page-us")];
        [page addTarget:self action:@selector(pageChange) forControlEvents:UIControlEventValueChanged];
        _adPage = page;
        [headView addSubview:page];
        //[self.tableView addSubview:page];
        self.tableView.tableHeaderView = headView;
        [self timer];
    }
    
    self.tableView.tableHeaderView = headView;
    //[self.tableView addSubview:adBtn];
    HuodongViewController *__weak weakSelf = self;
    _header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        [_oldArr removeAllObjects];
        [weakSelf loadOldData];
    }];
    _header.lastUpdatedTimeLabel.hidden = YES;
    _footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _page++;
        [weakSelf loadOldData];
    }];
    self.tableView.mj_header = _header;
    self.tableView.mj_footer = _footer;
}

- (void)pageChange
{
    NSInteger page = _adPage.currentPage;
    [_sc setContentOffset:CGPointMake(kScreenWidth * (page + 1), 0) animated:YES];
}

- (NSTimer *)timer{
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
    }
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    return _timer;
}

#pragma mark - 按时间滚动scrollView
- (void)timeChange
{
    NSInteger pageCount = _adPage.currentPage;
    if (pageCount == _adArr.count - 1) {
        [_sc setContentOffset:CGPointMake(0, 0)];
        pageCount = 0;
        //_adPage.currentPage = pageCount;
        [_sc setContentOffset:CGPointMake(_sc.width, 0) animated:YES];
    } else {
        pageCount++;
        //_adPage.currentPage = pageCount;
        [_sc setContentOffset:CGPointMake(_sc.width * (pageCount + 1), 0) animated:YES];
    }
    
}

#pragma mark - UIScrollView代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _sc){
        NSInteger page = (_sc.contentOffset.x + _sc.width * 0.5) / _sc.width;
        if (_sc.contentOffset.x > _sc.width * (_adArr.count + 0.5)) {
            page = 1;
        } else if (_sc.contentOffset.x < _sc.width * 0.5) {
            page = _adArr.count;
        }
        _adPage.currentPage = page - 1;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == _sc) {
        NSInteger page = (scrollView.contentOffset.x + 0.5 * _sc.width) / kScreenWidth;
        if (page == 0) {
            [scrollView setContentOffset:CGPointMake(kScreenWidth * _adArr.count, 0)];
            //_page.currentPage = 4;
        }
        else if (page == _adArr.count + 1)
        {
            [scrollView setContentOffset:CGPointMake(kScreenWidth, 0)];
            //_page.currentPage = 0;
        }
        else
        {
            //_page.currentPage = page - 1;
        }
        [self timer];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (scrollView == _sc){
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark 列数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

#pragma mark 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return _dataArr.count;
    }else{
        return _oldArr.count;
    }
}

#pragma mark 段头高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50.0 ;
}

#pragma mark 行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140.0;
}

#pragma mark 段尾高
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.0f;
}

#pragma mark cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        HuodongZeroTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hotCell" forIndexPath:indexPath];
        [cell configUI:_dataArr[indexPath.row]];
        return cell;
    } else {
        HuodongFirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"earlyCell" forIndexPath:indexPath];
        [cell configUI:_oldArr[indexPath.row]];
        return cell;
    }
}

#pragma mark 段头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    UIButton *sectionBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, kScreenWidth, 40.0 ) target:self SEL:@selector(sectionBtnClick:) title:nil];
    sectionBtn.tag = 10030 + section;
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10, 15, 2, 10)];
    line.backgroundColor = kRed;
    [sectionBtn addSubview:line];
    
    sectionBtn.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [MyControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(line.frame) + 8, 0, 200, 40 ) Font:14.0f Text:section ? @"往期活动":@"热门活动"];
    [sectionBtn addSubview:label];
    
    [header addSubview:sectionBtn];
    return header;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ActModel *model = nil;
    if (indexPath.section == 0) {
        model = _dataArr[indexPath.row];
    } else {
        model = _oldArr[indexPath.row];
    }
    ZixunDetailViewController *vc = [[ZixunDetailViewController alloc]init];
    vc.url = [NSString stringWithFormat:@"%@?id=%@",Huodong_IP,model.actId];
    [self.delegate configLeftBar];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 段头视图
- (void)sectionBtnClick:(UIButton *)btn{
    //tag 10030
}


#pragma mark 广告按钮点击事件
- (void)adBtnClick:(UIButton *)btn{
    //NSLog(@"%ld",btn.tag);
    ActAdmodel *model = _adArr[btn.tag - 34000];
    //ZixunDetailViewController *vc = [[ZixunDetailViewController alloc]init];
    if ([model.type isEqualToString:@"1"]) {
        if (![User objectForKey:kMemberId]) {
            [self.delegate configLeftBar];
            LoginController *vc = [[LoginController alloc]init];
            //
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
        //打开影片
        MovieDetailController *vc = [[MovieDetailController alloc]init];
        vc.titleId = model.titleId;
        //
        [self.delegate configLeftBarWhite];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        //打开url
        //NSLog(@"%@",model.url);
        ZixunDetailViewController *vc = [[ZixunDetailViewController alloc]init];
        vc.url = model.url;
        
        [self.delegate configLeftBar];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
