//
//  MovieController.m
//  Unibox_iOS
//
//  Created by 刘羽 on 15/10/29.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import "MovieController.h"
#import "Header.h"
#import "UIImage+Color.h"
#import "UIImage+Tint.h"
#import "MovieCollectionViewCell.h"
#import "MovieTableViewCell.h"
#import "AppDelegate.h"
#import "API.h"
#import "MovieModel.h"
#import "MovieDetailController.h"
#import "NohightButton.h"
//#import "MapController.h"
#import "MovieConfigModel.h"
#import "MJRefresh.h"
#import "AppDelegate.h"
#import "LoginController.h"
#import "ShopCartController.h"
#import "FavViewController.h"
#import "NetWork.h"
#import "MD5Helper.h"

@interface MovieController ()<UITextFieldDelegate,
                              UICollectionViewDataSource,
                              UICollectionViewDelegateFlowLayout,
                              UITableViewDataSource,
                              UITableViewDelegate,
                              MovieTableViewCellDelegate>
{
    //搜索编辑框
    UITextField *_searchTF;
    //页码
    int _page;
    //接收数据key;
    NSString *_key;
    //影片collectionView
    UICollectionView *_collection;
    //分类tableView
    UITableView *_tb;
    //collectionView数据源
    NSMutableArray *_dataArr;
    //tableView数据源
    NSMutableArray *_tableDataArr;
    //tableViewheadView中选中的按钮
    UIButton *_selectHeadBtn;
    UIButton *_pickBtn;
    /*
     * 参数：
     ** orderType        排序方式（最热，最新等，暂时不传）
     ** genre            影片类型（动作，爱情等）
     ** nation           地区（美国，中国大陆等）
     ** releaseYear      发行年份（如:2013）
     */
    //排序方式
    NSString *_orderType;
    //影片类型
    NSString *_genre;
    //年份
    NSString *_movieYear;
    //碟片类型
    NSString *_titleType;
    
    //下拉刷新
    MJRefreshNormalHeader *_refreshHead;
    //上拉加载
    MJRefreshBackNormalFooter *_refreshFoot;
    //记录刷新状态
    BOOL isRefresh;
}
@end

@implementation MovieController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:kRed] forBarMetrics:UIBarMetricsDefault];
    //[self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor clearColor]]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //AppDelegate *app = [UIApplication sharedApplication].delegate;
    //[app.leftController setPanEnabled:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIView *naviBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64.0)];
    naviBar.backgroundColor = kRed;
    [self.view addSubview:naviBar];
    
    self.view.backgroundColor = kWhite_Slide;
    
    
    [User addObserver:self forKeyPath:kMemberId options:NSKeyValueObservingOptionNew context:nil];
    _page = 1;
    _key = @"";
    //排序方式
    _orderType   = @"";
    //影片类型
    _genre       = @"";
    //年份
    _movieYear = @"";
    //碟片类型
    _titleType = @"";
    //刷新状态
    isRefresh = YES;
    //初始化数据源
    _dataArr      = [NSMutableArray array];
    _tableDataArr = [NSMutableArray array];
    
    //_tableDataArr = [NSArray arrayWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"category" withExtension:@"plist"]];
    [self loadTbData];
    [self configLeftBarWhite];
    //添加其他按钮
    //[self addOtherButton];
    //添加导航条上的搜索栏
    [self addNavBtn];
    //创建UI
    [self createUI];
    //[self loadData];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    [self loadData];
}

#pragma mark 添加导航条上按钮与titleView
- (void)addNavBtn{
    //城市选择按钮
//    UIButton *cityPickBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, 60, 44) target:self SEL:@selector(cityPickBtnClick) title:@"武汉"];
//    cityPickBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
//    cityPickBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
//    [cityPickBtn setImage:[imageNamed(@"down_arrow") imageWithTintColor:[UIColor whiteColor]] forState:UIControlStateNormal];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:cityPickBtn];
    self.navigationItem.title = @"电影";
    
    //购物车与收藏按钮
    UIButton *cartButton = [MyControl createButtonWithFrame:CGRectMake(0, 0, 30, 44) target:self SEL:@selector(carButtonClick) title:nil];
    [cartButton setImage:imageNamed(@"movie-buycar") forState:UIControlStateNormal];
    
    UIButton *scButton = [MyControl createButtonWithFrame:CGRectMake(0, 0, 30, 44) target:self SEL:@selector(scButtonClick) title:nil];
    [scButton setImage:imageNamed(@"movie-sc") forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc]initWithCustomView:scButton],[[UIBarButtonItem alloc]initWithCustomView:cartButton]];
    
}
#pragma mark - 导航栏按钮点击事件
#pragma mark 购物车按钮
- (void)carButtonClick{
    if ([User objectForKey:kMemberId]) {
        [self configLeftBarWhite];
        ShopCartController *vc = [[ShopCartController alloc]init];
        //
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [self configLeftBar];
        LoginController *vc = [[LoginController alloc]init];
        //
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark 收藏按钮
- (void)scButtonClick{
    if ([User objectForKey:kMemberId]) {
        [self configLeftBar];
        FavViewController *vc = [[FavViewController alloc]init];
        //
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [self configLeftBar];
        LoginController *vc = [[LoginController alloc]init];
        //
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
#pragma mark 城市选择按钮
- (void)cityPickBtnClick{
    NSLog(@"城市选择");
}

#pragma mark - 创建UI
- (void)createUI
{
    
    //创建UICollectionView
    [self createCollectionView];
    //创建选择模块UI
    [self createSelection];
    //加载数据
    [_refreshHead beginRefreshing];
    //[self loadData];
}

#pragma mark - 加载数据
- (void)loadData
{
    //AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    /*
     *参数
     ** orderType        排序方式 （传配置中的key）
     ** movieGenre       影片类型（传配置中的key）
     ** titleType        碟片类型（传配置中的key）
     ** movieYear        年份（传配置中的key）
     ** search           搜索关键字
     ** page             页码，从1开始 用于下拉刷新
     ** key              缓存用key，用于下拉刷新，默认传空或不传，下拉刷新时
     传接口上次返回的key
     */
//    JGProgressHUD *hud = [[JGProgressHUD alloc]initWithStyle:JGProgressHUDStyleDark];
//    //hud.interactionType = JGProgressHUDInteractionTypeBlockTouchesOnHUDView;
//    JGProgressHUDFadeZoomAnimation *an = [JGProgressHUDFadeZoomAnimation animation];
//    hud.animation = an;
//    
//    
//    [hud showInView:self.view];
    
    //NSLog(@"22222-----%@",_movieYear);
    NSDictionary *dic = nil;
    if ([User objectForKey:kMemberId]) {
        
    
        dic = @{
              @"_memberId":[User objectForKey:kMemberId],
              @"_accessToken":[User objectForKey:kAccessToken],
              @"orderType":_orderType,
              @"movieGenre":_genre,
              @"titleType":_titleType,
              @"movieYear":_movieYear,
              @"search":_searchTF.text,
              @"page":[NSString stringWithFormat:@"%d",_page],
              @"key":_key
              };
    } else {
        dic = @{
                @"orderType":_orderType,
                @"movieGenre":_genre,
                @"titleType":_titleType,
                @"movieYear":_movieYear,
                @"search":_searchTF.text,
                @"page":[NSString stringWithFormat:@"%d",_page],
                @"key":_key
                };
    }
    //判断是否刷新
    if (isRefresh) {
        [_dataArr removeAllObjects];
    }
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    
    [NetWork getRequest:[NSString stringWithFormat:@"http://%@%@",app.host_ip,GetMovieList_URL] params:dic success:^(id responseObj) {
        //NSLog(@"loi%@",responseObj[@"ret"]);
        if (![[responseObj objectForKey:@"ret"] intValue]) {
            for (NSDictionary *dic in [responseObj objectForKey:@"list"]) {
                MovieModel *model = [[MovieModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                // if ([model.inventory intValue] > 0){
                //[_dataArr insertObject:model atIndex:0];
                //} else {
                [_dataArr addObject:model];
                //}
            }
            _key = responseObj[@"key"];
            
        }
        //[hud dismissAfterDelay:1.0f animated:YES];
        [_refreshHead endRefreshing];
        [_refreshFoot endRefreshing];
        [_collection reloadData];
        
        
    } failure:^(NSError *error) {
//        hud.indicatorView = [[JGProgressHUDErrorIndicatorView alloc]init];
//        hud.textLabel.text = @"加载失败";
//        hud.layoutChangeAnimationDuration = 0.3;
//        [hud dismissAfterDelay:1.0f animated:YES];
    }];
    
//    [NetWork get:[NSString stringWithFormat:@"http://%@%@",app.host_ip,GetMovieList_URL] parameters:dic success:^(id responseObject) {
//        if (![[responseObject objectForKey:@"ret"] intValue]) {
//            for (NSDictionary *dic in [responseObject objectForKey:@"list"]) {
//                MovieModel *model = [[MovieModel alloc]init];
//                [model setValuesForKeysWithDictionary:dic];
//                // if ([model.inventory intValue] > 0){
//                //[_dataArr insertObject:model atIndex:0];
//                //} else {
//                [_dataArr addObject:model];
//                //}
//            }
//            _key = responseObject[@"key"];
//        }
//        
//        [hud dismissAfterDelay:1.0f animated:YES];
//        [_refreshHead endRefreshing];
//        [_refreshFoot endRefreshing];
//        [_collection reloadData];
//    } fail:^(NSError *error) {
//        //NSLog(@"加载数据失败");
//        hud.indicatorView = [[JGProgressHUDErrorIndicatorView alloc]init];
//        hud.textLabel.text = @"加载失败";
//        hud.layoutChangeAnimationDuration = 0.3;
//        [hud dismissAfterDelay:1.0f animated:YES];
//    }];

}

- (void)loadTbData{
    MovieController *__weak weakSelf = self;
    [_tableDataArr removeAllObjects];
    //AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [NetWork getRequest:[NSString stringWithFormat:@"http://%@%@",app.host_ip,GetMovieSearchConfig] params:nil success:^(id responseObj) {
        NSMutableArray *movieGenreArr = [NSMutableArray array];
        NSMutableArray *movieYearArr  = [NSMutableArray array];
        NSMutableArray *titleTypeArr  = [NSMutableArray array];
        NSMutableArray *orderTypeArr  = [NSMutableArray array];
        for (NSDictionary *d in responseObj[@"config"][@"movieGenre"]) {
            //NSLog(@"%@",d);
            MovieConfigModel *model = [[MovieConfigModel alloc]init];
            [model setValuesForKeysWithDictionary:d];
            [movieGenreArr addObject:model];
        }
        [_tableDataArr addObject:movieGenreArr];
        for (NSDictionary *d in responseObj[@"config"][@"movieYear"]) {
            MovieConfigModel *model = [[MovieConfigModel alloc]init];
            [model setValuesForKeysWithDictionary:d];
            [movieYearArr addObject:model];
        }
        [_tableDataArr addObject:movieYearArr];
        for (NSDictionary *d in responseObj[@"config"][@"titleType"]) {
            MovieConfigModel *model = [[MovieConfigModel alloc]init];
            [model setValuesForKeysWithDictionary:d];
            [titleTypeArr addObject:model];
        }
        [_tableDataArr addObject:titleTypeArr];
        for (NSDictionary *d in responseObj[@"config"][@"orderType"]) {
            MovieConfigModel *model = [[MovieConfigModel alloc]init];
            [model setValuesForKeysWithDictionary:d];
            [orderTypeArr addObject:model];
        }
        [_tableDataArr addObject:orderTypeArr];
        [weakSelf createTB];
    } failure:^(NSError *error) {
        //
    }];
//    [NetWork get:[NSString stringWithFormat:@"http://%@%@",app.host_ip,GetMovieSearchConfig] parameters:nil success:^(id responseObject) {
//        NSMutableArray *movieGenreArr = [NSMutableArray array];
//        NSMutableArray *movieYearArr  = [NSMutableArray array];
//        NSMutableArray *titleTypeArr  = [NSMutableArray array];
//        NSMutableArray *orderTypeArr  = [NSMutableArray array];
//        for (NSDictionary *d in responseObject[@"config"][@"movieGenre"]) {
//            //NSLog(@"%@",d);
//            MovieConfigModel *model = [[MovieConfigModel alloc]init];
//            [model setValuesForKeysWithDictionary:d];
//            [movieGenreArr addObject:model];
//        }
//        [_tableDataArr addObject:movieGenreArr];
//        for (NSDictionary *d in responseObject[@"config"][@"movieYear"]) {
//            MovieConfigModel *model = [[MovieConfigModel alloc]init];
//            [model setValuesForKeysWithDictionary:d];
//            [movieYearArr addObject:model];
//        }
//        [_tableDataArr addObject:movieYearArr];
//        for (NSDictionary *d in responseObject[@"config"][@"titleType"]) {
//            MovieConfigModel *model = [[MovieConfigModel alloc]init];
//            [model setValuesForKeysWithDictionary:d];
//            [titleTypeArr addObject:model];
//        }
//        [_tableDataArr addObject:titleTypeArr];
//        for (NSDictionary *d in responseObject[@"config"][@"orderType"]) {
//            MovieConfigModel *model = [[MovieConfigModel alloc]init];
//            [model setValuesForKeysWithDictionary:d];
//            [orderTypeArr addObject:model];
//        }
//        [_tableDataArr addObject:orderTypeArr];
//        [weakSelf createTB];
//    } fail:^(NSError *error) {
//        //
//    }];
//    [manager GET:[NSString stringWithFormat:@"http://%@%@",app.host_ip,GetMovieSearchConfig] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        //NSLog(@"%@",responseObject);
//        NSMutableArray *movieGenreArr = [NSMutableArray array];
//        NSMutableArray *movieYearArr  = [NSMutableArray array];
//        NSMutableArray *titleTypeArr  = [NSMutableArray array];
//        NSMutableArray *orderTypeArr  = [NSMutableArray array];
//        for (NSDictionary *d in responseObject[@"config"][@"movieGenre"]) {
//            //NSLog(@"%@",d);
//            MovieConfigModel *model = [[MovieConfigModel alloc]init];
//            [model setValuesForKeysWithDictionary:d];
//            [movieGenreArr addObject:model];
//        }
//        [_tableDataArr addObject:movieGenreArr];
//        for (NSDictionary *d in responseObject[@"config"][@"movieYear"]) {
//            MovieConfigModel *model = [[MovieConfigModel alloc]init];
//            [model setValuesForKeysWithDictionary:d];
//            [movieYearArr addObject:model];
//        }
//        [_tableDataArr addObject:movieYearArr];
//        for (NSDictionary *d in responseObject[@"config"][@"titleType"]) {
//            MovieConfigModel *model = [[MovieConfigModel alloc]init];
//            [model setValuesForKeysWithDictionary:d];
//            [titleTypeArr addObject:model];
//        }
//        [_tableDataArr addObject:titleTypeArr];
//        for (NSDictionary *d in responseObject[@"config"][@"orderType"]) {
//            MovieConfigModel *model = [[MovieConfigModel alloc]init];
//            [model setValuesForKeysWithDictionary:d];
//            [orderTypeArr addObject:model];
//        }
//        [_tableDataArr addObject:orderTypeArr];
//        [weakSelf createTB];
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        
//    }];
}

#pragma mark 创建选择模块UI
- (void)createSelection
{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(10, (45 - 30)/2.0 + 64.0, kScreenWidth - 20 - 55, 30)];
    [bgView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:bgView];
    UITextField *textf = [[UITextField alloc]initWithFrame:CGRectMake(20, 0, kScreenWidth - 40 - 55 - 30, 30)];
    _searchTF = textf;
    //textf.backgroundColor = [UIColor whiteColor];
    textf.font = [UIFont systemFontOfSize:13.0f];
    textf.placeholder = @"输入电影标题、拼音、首字母";
    textf.delegate = self;
    textf.autocorrectionType = UITextAutocorrectionTypeNo;
    textf.returnKeyType = UIReturnKeySearch;
    [textf setValue:kRed forKeyPath:@"_placeholderLabel.textColor"];
    [bgView addSubview:textf];
    
    UIButton *searchBtn = [MyControl createButtonWithFrame:CGRectMake(bgView.width - 30, 0, 30, 30) target:self SEL:@selector(searchBtnClick) title:nil];
    [searchBtn setImage:imageNamed(@"movie-sousuo") forState:UIControlStateNormal];
    [bgView addSubview:searchBtn];
    
    UIButton *pickBtn = [MyControl createButtonWithFrame:CGRectMake(CGRectGetMaxX(bgView.frame)  , bgView.y, kScreenWidth- bgView.width - 10, bgView.height) target:self SEL:@selector(allBtnClick:) title:nil];
    _pickBtn = pickBtn;
    //[pickBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //pickBtn.titleLabel.font = [UIFont systemFontOfSize:10.0f];
    [pickBtn setImage:imageNamed(@"icon-fenlei") forState:UIControlStateNormal];
    [pickBtn setImage:[imageNamed(@"icon-fenlei") imageWithTintColor:[UIColor grayColor]] forState:UIControlStateSelected];
    [self.view addSubview:pickBtn];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self loadData];
    return YES;
}

- (void)createTB{
    _tb = [[UITableView alloc]initWithFrame:CGRectMake(0, 45 + 64.0, kScreenWidth, 0) style:UITableViewStylePlain];
    _tb.tableFooterView  = [[UIView alloc]init];
    _tb.delegate = self;
    _tb.dataSource = self;
    //_tb.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    _tb.backgroundColor = [UIColor colorWithPatternImage:imageNamed(@"bg-fenlei")];
    [_tb registerClass:[MovieTableViewCell class] forCellReuseIdentifier:@"movieCell1"];
    //_tb.hidden = YES;
    _tb.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tb.scrollEnabled = NO;
    [self.view addSubview:_tb];
}


#pragma mark - UITableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableDataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f / 640.0 * kScreenHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"movieCell1";
    MovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden forIndexPath:indexPath];
    
    if (!cell) {
        
    
        cell = [[MovieTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        
    }
    if (cell.contentView.subviews.count) {
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    [cell configUI:_tableDataArr[indexPath.row]];
    cell.delegate = self;
    
    return cell;
}

#pragma mark cell的代理
- (void)movieCellButtnClick:(UITableViewCell *)cell withButtonTag:(NSInteger)tag
{
    UIButton *btn = (UIButton *)[cell viewWithTag:tag];
    NSIndexPath *indexPath = [_tb indexPathForCell:cell];
    
    NSInteger num = tag - 6300;
    
    
    if (num) {
        if (indexPath.row == 0) {
            for (MovieConfigModel *model in _tableDataArr[0])
            {
                if ([model.text isEqualToString:btn.currentTitle]) {
                    _genre = model.key;
                }
            }
        } else if (indexPath.row == 1){
            for (MovieConfigModel *model in _tableDataArr[1])
            {
                if ([model.text isEqualToString:btn.currentTitle]) {
                    _movieYear = model.key;
                }
            }
        } else if (indexPath.row == 2){
            for (MovieConfigModel *model in _tableDataArr[2])
            {
                if ([model.text isEqualToString:btn.currentTitle]) {
                    _titleType = model.key;
                }
            }
            //_titleType = btn.currentTitle;
        } else if (indexPath.row == 3){
            for (MovieConfigModel *model in _tableDataArr[3])
            {
                if ([model.text isEqualToString:btn.currentTitle]) {
                    _orderType = model.key;
                }
            }
            //_orderType = btn.currentTitle;
        }
    }else{
        if (indexPath.row == 0) {
            _genre = @"";
        } else if (indexPath.row == 1){
            _movieYear = @"";
        } else if (indexPath.row == 2){
            _titleType = @"";
        } else if (indexPath.row == 3){
            _orderType = @"";
        }
    }
    [self loadData];
    //NSLog(@"-----%@,%@,%@",_genre,_nation,_releaseYear);
}

#pragma mark tableViewheadBtn点击事件
- (void)headBtnClick:(UIButton *)btn
{
    btn.selected = YES;
    _selectHeadBtn.selected = NO;
    _selectHeadBtn = btn;
}

#pragma mark 全部按钮点击事件
- (void)allBtnClick:(UIButton *)btn
{
//    _selectBtn.selected = NO;
//    _selectBtn = nil;
//    _selectView.hidden = YES;
//    _selectView = nil;
    btn.selected = !btn.selected;
    
    if (btn.selected) {
        [UIView animateWithDuration:0.25 animations:^{
            _tb.height = 40.0 / 640.0 * kScreenHeight * _tableDataArr.count;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.25 animations:^{
            _tb.height = 0;
        }];
        //[self loadData];
    }
}


#pragma mark - UITextField代理


#pragma mark 创建collectionView
- (void)createCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumInteritemSpacing = 5.0f;
    flowLayout.minimumLineSpacing = 5.0f;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 45 + 64.0, kScreenWidth, kScreenHeight - 64 - 45 - 49) collectionViewLayout:flowLayout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = [UIColor clearColor];
    _collection = collectionView;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnCollection)];
    tap.cancelsTouchesInView = NO;
    [collectionView addGestureRecognizer:tap];
    
    [collectionView registerNib:[UINib nibWithNibName:@"MovieCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MovieCell"];
    
    [self.view addSubview:collectionView];
    MovieController * __weak weakSelf = self;
    _refreshHead = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        isRefresh = YES;
        _key = @"";
        [weakSelf loadData];
    }];
    _refreshHead.lastUpdatedTimeLabel.hidden = YES;
    
    _refreshFoot = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _page++;
        isRefresh = NO;
        [weakSelf loadData];
    }];
    //_refreshFoot.stateLabel.hidden = YES;
    _collection.mj_header = _refreshHead;
    _collection.mj_footer = _refreshFoot;
}

#pragma mark 点击空白出键盘消失
- (void)tapOnCollection{
    [_searchTF resignFirstResponder];
}

#pragma mark - UICollectionView代理方法
/*
 设置单元格数量
 */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArr.count;
}

/*
 设置水平间隙
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 2.0f;
}

/*
 设置竖直间隙
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 2.0f;
}

/*
 设置item大小
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake((kScreenWidth - 4)/3, 160.0f);
}

/*
 设置UICollectionViewCell
 */
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MovieCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
//    if (_dataArr.count) {
//        [cell configUI:_dataArr[indexPath.row]];
//    }
    
    return cell;
}

/*
 item点击事件
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (_pickBtn.selected) {
        [self allBtnClick:_pickBtn];
        return;
    }
    if (![User objectForKey:kMemberId]) {
        [self configLeftBar];
        LoginController *vc = [[LoginController alloc]init];
        //
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [self configLeftBarWhite];
        MovieDetailController *vc = [[MovieDetailController alloc]init];
        vc.name = [_dataArr[indexPath.row] movieName];
        vc.titleId = [_dataArr[indexPath.row] titleId];
        //
        [self.navigationController pushViewController:vc animated:YES];
    }
    //[self.view.window.rootViewController presentViewController:vc animated:YES completion:nil];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    if(_dataArr.count > 0){
        [(MovieCollectionViewCell *)cell configUI:_dataArr[indexPath.row]];
    }
}




- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (_pickBtn.selected) {
        [self allBtnClick:_pickBtn];
    }
}

- (void)searchBtnClick{
    [_searchTF resignFirstResponder];
    
    [self loadData];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
