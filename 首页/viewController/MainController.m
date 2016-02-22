//
//  MainController.m
//  Unibox_iOS
//
//  Created by 刘羽 on 15/10/21.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import "MainController.h"
#import "Header.h"
#import "API.h"
#import "MovieDetailController.h"
#import "UIImage+Color.h"
#import "UIButton+WebCache.h"
//#import "MapController.h"
#import "MapViewController.h"
#import "ScanViewController.h"
#import "LoginController.h"
#import "ZixunDetailViewController.h"

#import "AppDelegate.h"

#import "MainZeroTableViewCell.h"
#import "MainFirstTableViewCell.h"
#import "MainSecondTableViewCell.h"
#import "MainThirdTableViewCell.h"
#import "MainForthTableViewCell.h"

#import "HotNewsModel.h"
#import "IndexMovieModel.h"
#import "PrevueModel.h"
#import "AdListModel.h"
#import "SDWebImagePrefetcher.h"
#import "AFNetworking.h"
#import "NetWork.h"
#import "ScreenImage.h"


#import <CoreLocation/CoreLocation.h>

@interface MainController ()<UIScrollViewDelegate, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, MainTableViewCellDelegate>
{
    //UIView *_bgView;
    NSMutableArray *_scArr;
    UIScrollView *_sc;
    UIPageControl *_page;
    //UICollectionView *_collectionView;
    UITableView *_tb;
    float lat;
    float lon;
    
    //数据源
    NSMutableArray *_dataArr;
    
    //广告视图计时器
    NSTimer *_timer;
}
@property (nonatomic, strong) CLLocationManager *locationmanager;
@property (nonatomic, strong) CLGeocoder *geocoder;
@end

@implementation MainController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIView *naviBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64.0)];
    naviBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:naviBar];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    _scArr = [NSMutableArray arrayWithCapacity:0];

    
    
    _dataArr = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scan:) name:@"scan" object:nil];
    
    //创建UI
    [self createUI];
    
    
    //加载数据
    [self loadData];
    //定位
    //[self location];
    
    
}

#pragma mark 加载数据
- (void)loadData{
    JGProgressHUD *hud = [[JGProgressHUD alloc]initWithStyle:JGProgressHUDStyleDark];
    [hud showInView:self.view];
    MainController *__weak weakSelf = self;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [manager GET:[NSString stringWithFormat:@"http://%@%@",app.host_ip,indexList] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (![responseObject[@"ret"] boolValue]){
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *d in responseObject[@"hotNewsList"]) {
                HotNewsModel *model = [[HotNewsModel alloc]init];
                [model setValuesForKeysWithDictionary:d];
                [arr addObject:model];
            }
            [_dataArr addObject:arr];
            NSMutableArray *arr1 = [NSMutableArray array];
            for (NSDictionary *d in responseObject[@"newList"]) {
                IndexMovieModel *model = [[IndexMovieModel alloc]init];
                [model setValuesForKeysWithDictionary:d];
                [arr1 addObject:model];
            }
            //[weakSelf cacheImages:arr1];
            [_dataArr addObject:arr1];
            NSMutableArray *arr2 = [NSMutableArray array];
            for (NSDictionary *d in responseObject[@"hotList"]) {
                IndexMovieModel *model = [[IndexMovieModel alloc]init];
                [model setValuesForKeysWithDictionary:d];
                [arr2 addObject:model];
            }
            //[weakSelf cacheImages:arr2];
            [_dataArr addObject:arr2];
            PrevueModel *pModel = [[PrevueModel alloc]init];
            [pModel setValuesForKeysWithDictionary:responseObject[@"prevue"]];
            [_dataArr addObject:pModel];
            
            for (NSDictionary *d in responseObject[@"adList"]) {
                AdListModel *model = [[AdListModel alloc]init];
                [model setValuesForKeysWithDictionary:d];
                [_scArr addObject:model];
            }
            
            //广告滚动视图
            [weakSelf createScrollView];
            [weakSelf loadGuessLike];
            //[_tb reloadData];
        }
        [hud dismissAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
    }];
}

#pragma mark 加载猜你喜欢数据
- (void)loadGuessLike{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    //MainController *__weak weakSelf = self;
    [manager GET:[NSString stringWithFormat:@"http://%@%@", app.host_ip,getLike] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"%@",responseObject);
        NSMutableArray *arr = [NSMutableArray array];
        if (![responseObject[@"ret"] boolValue]) {
            for (NSDictionary *d in responseObject[@"list"]) {
                IndexMovieModel *model = [[IndexMovieModel alloc]init];
                [model setValuesForKeysWithDictionary:d];
                [arr addObject:model];
            }
            //提前缓存图片
            //[weakSelf cacheImages:arr];
            [_dataArr addObject:arr];
            UIImageView *iv = (UIImageView *)[self.view viewWithTag:9998];
            if (iv.isAnimating) {
                [iv stopAnimating];
            }
            
            [_tb reloadData];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       // NSLog(@"fsdafa");
    }];
}

#pragma mark 提前缓存图片
//- (void)cacheImages:(NSArray *)arr{
//    NSMutableArray *imgArr = [NSMutableArray array];
//    for (IndexMovieModel *model in arr) {
//        [imgArr addObject:[NSString stringWithFormat:@"%@%@",Image_IP,model.img]];
//    }
//    [[SDWebImagePrefetcher sharedImagePrefetcher] prefetchURLs:imgArr];
//}

- (void)scan:(NSNotification *)noti
{
   // NSLog(@"%@",noti.object);
    //[self configLeftBar];
//    if ([noti.object containsString:@"http"]) {
//        NSLog(@"%@",noti.object);
//        ScanResultController *vc = [[ScanResultController alloc]init];
//        vc.type = 200;
//        vc.url = noti.object;
//        [self.navigationController pushViewController:vc animated:YES];
//        return;
//    }
    JGProgressHUD *hud = [[JGProgressHUD alloc]initWithStyle:JGProgressHUDStyleDark];
    hud.indicatorView = nil;
    hud.textLabel.text = @"正在处理扫描结果";
    [hud showInView:self.view];
        NSDictionary *dic = @{
                              @"_memberId":[User objectForKey:kMemberId],
                              @"_accessToken":[User objectForKey:kAccessToken],
                              @"text":noti.object
                              };
        AppDelegate *app = [UIApplication sharedApplication].delegate;
        [NetWork getRequest:[NSString stringWithFormat:@"http://%@%@",app.host_ip,QrCode] params:dic success:^(id responseObj) {
            [hud dismissAfterDelay:1 animated:YES];
            //if ([responseObj[@"ret"] boolValue]) {
            //ScanResultController *vc = [[ScanResultController alloc]init];
            //vc.type = [responseObj[@"ret"] intValue];
            //[self.navigationController pushViewController:vc animated:YES];
            //}
            if ([responseObj[@"ret"] intValue] == 0) {
                if ([responseObj[@"type"] isEqualToString:@"weixin"]) {
                    hud.textLabel.text = @"请使用微信进行扫描";
                } else {
                    hud.textLabel.text = @"扫描成功";
                }
            } else{
                hud.textLabel.text = @"扫描失败";
            }
            [hud dismissAfterDelay:2.0 animated:YES];
            
        } failure:^(NSError *error) {
            hud.textLabel.text = @"服务器未响应，请稍后再试";
            [hud dismissAfterDelay:2.0 animated:YES];
        }];
}
    

    
    
    
    
//    NSLog(@"%@",noti.object);
//    [self configLeftBar];
//    ScanResultController *vc = [[ScanResultController alloc]init];
//    if ([noti.object isKindOfClass:[NSString class]]) {
//        vc.type = 200;
//        vc.url = noti.object;
//    } else {
//        vc.type = [noti.object intValue];
//        
//    }
//    //
//    [self.navigationController pushViewController:vc animated:YES];

//#pragma mark 定位
//- (void)location
//{
//    NSLog(@"定位");
//    _locationmanager = [[CLLocationManager alloc]init];
//    
//    //设置精度
//    //    kCLLocationAccuracyBest
//    //    kCLLocationAccuracyNearestTenMeters
//    //    kCLLocationAccuracyHundredMeters
//    //    kCLLocationAccuracyKilometer
//    //    kCLLocationAccuracyThreeKilometers
//    //设置定位的精度
//    [_locationmanager setDesiredAccuracy:kCLLocationAccuracyBest];
//    //实现协议
//    _locationmanager.delegate = self;
//    //开始定位
//    //[_locationmanager requestAlwaysAuthorization];
//    [_locationmanager startUpdatingLocation];
//}

//- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
//{
//    NSLog(@"123456");
//    for (CLLocation *location in locations) {
//        NSLog(@"%@",location);
//        CLLocationCoordinate2D coordinate = location.coordinate;
//        NSLog(@"精度:%f,纬度:%f",coordinate.latitude,coordinate.longitude);
//        lat = coordinate.latitude;
//        lon = coordinate.longitude;
//    }
//    
//    //====位置的反编码
//    _geocoder = [[CLGeocoder alloc]init];
//    [_geocoder reverseGeocodeLocation:[locations lastObject] completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
//        for (CLPlacemark *place in placemarks) {
//            NSLog(@"name %@",place.name); //位置
//            NSLog(@"thoroughfare %@",place.thoroughfare); // 街道
//            NSLog(@"subthoroughfare %@", place.subThoroughfare); // 子街道
//            NSLog(@"locality %@",  place.locality);   //区
//            NSLog(@"subLocality %@", place.subLocality); //子区
//            NSLog(@"country %@", place.country); //国家
//            
//        }
//    }];
//    [_locationmanager stopUpdatingLocation];
//    
//}
//
//- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
//{
//    switch (status) {
//        case kCLAuthorizationStatusNotDetermined:
//        if ([_locationmanager respondsToSelector:@selector(requestAlwaysAuthorization)])
//        {
//            [_locationmanager requestWhenInUseAuthorization];
//        }
//        break;
//        default:
//        break;
//    }
//}

#pragma mark 创建UI
- (void)createUI
{
    [self addNavBtn];
    //添加搜索栏
    //[self createSearchBar];
    
    
    //创建CollectionView
    [self createTableView];
    
    
    
}

#pragma mark 添加导航栏上的按钮
- (void)addNavBtn{
    //左侧图标
    UIImageView *iv = [MyControl createImageViewFrame:CGRectMake(0, 0, 103/2.0, 25) imageName:@"companyicon"];
    iv.userInteractionEnabled = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:iv];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeIP)];
    //tap.numberOfTapsRequired = 2;
    [iv addGestureRecognizer:tap];
    //城市选择
//    UIButton *cityPickBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, 60, 25) target:self SEL:@selector(cityPickBtnClick) title:@"武汉"];
//    
//    [cityPickBtn setTitleColor:RGB(101, 101, 101) forState:UIControlStateNormal];
//    cityPickBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
//    cityPickBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
//    
//    [cityPickBtn setImage:imageNamed(@"down_arrow") forState:UIControlStateNormal];
    //二维码扫描
    UIButton *scanBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, 20, 20) target:self SEL:@selector(scanBtnClick) title:nil];
    [scanBtn setImage:imageNamed(@"scanbtn") forState:UIControlStateNormal];
    
    //self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc]initWithCustomView:scanBtn],[[UIBarButtonItem alloc]initWithCustomView:cityPickBtn]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:scanBtn];
}

#pragma mark 城市选择按钮点击
- (void)cityPickBtnClick{
}

#pragma mark 二维码扫描按钮点击
- (void)scanBtnClick{
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIAlertView *_alt = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您的设备不支持二维码扫描" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [_alt show];
        return;
    }
    if ([User objectForKey:kMemberId]) {
        //跳转到二维码扫描页面
        [self configLeftBar];
        ScanViewController *scan = [[ScanViewController alloc]init];
        scan.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:scan animated:YES];

    } else {
        [self configLeftBar];
        LoginController *vc = [[LoginController alloc]init];
        //
        [self.navigationController pushViewController:vc animated:YES];
    }
}

/*
 创建头部滚动试图
 */
- (void)createScrollView
{
    if (_scArr.count == 1) {
        AdListModel *model = _scArr[0];
        UIButton *btn = [MyControl createButtonWithFrame:CGRectMake(0, -kScroll_Height, kScreenWidth, kScroll_Height) target:self SEL:@selector(adBtnClick:) title:nil];
        //[btn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_IP,model.img]] forState:UIControlStateNormal];
        [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_IP,model.img]] forState:UIControlStateNormal placeholderImage:imageNamed(@"placehold") completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [btn setImage:[ScreenImage shotImageContext:image View:btn] forState:UIControlStateNormal];
        }];
        
        [btn addTarget:self action:@selector(adBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 6666;
        [_tb addSubview:btn];
        return;
    }
    
    UIScrollView *sc = [[UIScrollView alloc]initWithFrame:CGRectMake(0, -kScroll_Height, kScreenWidth, kScroll_Height)];
    sc.showsHorizontalScrollIndicator = NO;
    [sc setContentOffset:CGPointMake(kScreenWidth, 0)];
    [sc setContentSize:CGSizeMake(kScreenWidth * (_scArr.count + 2), kScroll_Height)];
    //sc.backgroundColor = [UIColor redColor];
    sc.pagingEnabled = YES;
    
    for (int i = 0; i < _scArr.count; i++) {
        AdListModel *model = _scArr[i];
        UIButton *adBtn = [MyControl createButtonWithFrame:CGRectMake(kScreenWidth * (i + 1), 0, kScreenWidth, kScroll_Height) target:self SEL:@selector(adBtnClick:) title:nil];
        [adBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_IP,model.img]] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [adBtn setBackgroundImage:[ScreenImage shotImageContext:image View:adBtn] forState:UIControlStateNormal];
        }];
        adBtn.tag = 6666 + i;
        //NSLog(@"%f",adBtn.height);
        [sc addSubview:adBtn];
    }
    AdListModel *model0 = _scArr[0];
    UIButton *adBtn0 = [MyControl createButtonWithFrame:CGRectMake(kScreenWidth * (_scArr.count + 1), 0, kScreenWidth, kScroll_Height) target:self SEL:@selector(adBtnClick:) title:nil];
    [adBtn0 sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_IP,model0.img]] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [adBtn0 setBackgroundImage:[ScreenImage shotImageContext:image View:adBtn0] forState:UIControlStateNormal];
    }];
    adBtn0.tag = 6666;
    //NSLog(@"%f",adBtn.height);
    [sc addSubview:adBtn0];
    
    AdListModel *model1 = _scArr[_scArr.count - 1];
    UIButton *adBtn1 = [MyControl createButtonWithFrame:CGRectMake(0, 0, kScreenWidth, kScroll_Height) target:self SEL:@selector(adBtnClick:) title:nil];
    [adBtn1 sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_IP,model1.img]] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [adBtn1 setBackgroundImage:[ScreenImage shotImageContext:image View:adBtn1] forState:UIControlStateNormal];
    }];
    adBtn1.tag = 6666 + _scArr.count - 1;
    //NSLog(@"%f",adBtn.height);
    [sc addSubview:adBtn1];
    
    sc.delegate = self;
    sc.bounces = NO;
    _sc = sc;
    [_tb addSubview:sc];
    
    UIPageControl *page = [[UIPageControl alloc]initWithFrame:CGRectMake(kScreenWidth - 100, -30 , 100, 30 )];
    page.numberOfPages = _scArr.count;
    //page.currentPageIndicatorTintColor = [UIColor redColor];
    
    page.currentPageIndicatorTintColor = [UIColor colorWithPatternImage:imageNamed(@"index-page-s")];
    //page.pageIndicatorTintColor = [UIColor lightGrayColor];
    page.pageIndicatorTintColor = [UIColor colorWithPatternImage:imageNamed(@"index-page-us")];
    [page addTarget:self action:@selector(pageChange) forControlEvents:UIControlEventValueChanged];
    _page = page;
    [_tb addSubview:page];
    [self timer];
}



//进入后台
//- (void)applicationWillResignActive
//{
//    NSLog(@"进入后台注销_timer");
    //[_timer invalidate];
    //_timer = nil;
    //将buttonde image置空 体验并不好..
//    for (int i = 6666; i < _scArr.count + 6666; i++) {
//        UIButton *btn = (UIButton *)[self.view viewWithTag:i];
//        [btn setBackgroundImage:nil forState:UIControlStateNormal];
//    }
//}

//成为活跃状态
//- (void)applicationDidBecomeActive
//{
//    NSLog(@"重新活跃,创建_timer");
//    for (int i = 6666; i < _scArr.count + 6666; i++) {
//        UIButton *btn = (UIButton *)[self.view viewWithTag:i];
//        [btn setBackgroundImage:imageNamed(_scArr[i - 6666]) forState:UIControlStateNormal];
//    }
    //_timer = [NSTimer scheduledTimerWithTimeInterval:4.0f target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
    //[_timer fire];
//}

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
    NSInteger pageCount = _page.currentPage;
    if (pageCount == _scArr.count - 1) {
        [_sc setContentOffset:CGPointMake(0, 0)];
        pageCount = 0;
        [_sc setContentOffset:CGPointMake(_sc.width, 0) animated:YES];
    } else {
        pageCount++;
        [_sc setContentOffset:CGPointMake(_sc.width * (pageCount + 1), 0) animated:YES];
    }
    //_page.currentPage = pageCount;
}

#pragma mark - pageControl页码监听
- (void)pageChange
{
    NSInteger page = _page.currentPage;
    [_sc setContentOffset:CGPointMake(kScreenWidth * (page + 1), 0) animated:YES];
}

#pragma mark - UIScrollView代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _sc){
        NSInteger page = (_sc.contentOffset.x + _sc.width * 0.5) / _sc.width;
        if (_sc.contentOffset.x > _sc.width * (_scArr.count + 0.5)) {
            page = 1;
        } else if (_sc.contentOffset.x < _sc.width * 0.5) {
            page = _scArr.count;
        }
        _page.currentPage = page - 1;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == _sc) {
        NSInteger page = (scrollView.contentOffset.x + 0.5 * _sc.width) / kScreenWidth;
        if (page == 0) {
            [scrollView setContentOffset:CGPointMake(kScreenWidth * _scArr.count, 0)];
            //_page.currentPage = 4;
        }
        else if (page == _scArr.count + 1)
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

#pragma mark 广告按钮点击事件
- (void)adBtnClick:(UIButton *)btn{
    //tag 6666
    NSLog(@"%ld",btn.tag-6666);
    AdListModel *model = _scArr[btn.tag - 6666];
    if ([model.type intValue] == 1) {
        if (![User objectForKey:kMemberId]) {
            LoginController *vc = [[LoginController alloc]init];
            [self configLeftBar];
            //
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
        
        MovieDetailController *vc = [[MovieDetailController alloc]init];
        vc.titleId = model.titleId;
        vc.name = @"影片详情";
        [self configLeftBarWhite];
        //
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        ZixunDetailViewController *vc = [[ZixunDetailViewController alloc]init];
        vc.url = model.url;
        [self configLeftBar];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}

#pragma mark 创建CollectionView
- (void)createTableView
{
    UITableView *tb = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 49 - 64) style:UITableViewStyleGrouped];
    tb.backgroundColor = kWhite_Slide;
    tb.contentInset = UIEdgeInsetsMake(kScroll_Height, 0, 0, 0);
    tb.delegate = self;
    tb.dataSource = self;
    
    [tb registerClass:[MainZeroTableViewCell class] forCellReuseIdentifier:@"ZeroCell"];
    [tb registerClass:[MainFirstTableViewCell class] forCellReuseIdentifier:@"FirstCell"];
    [tb registerClass:[MainSecondTableViewCell class] forCellReuseIdentifier:@"SecondCell"];
    [tb registerClass:[MainThirdTableViewCell class] forCellReuseIdentifier:@"ThirdCell"];
    [tb registerClass:[MainForthTableViewCell class] forCellReuseIdentifier:@"ForthCell"];
    _tb = tb;
    
    [self.view addSubview:tb];
    
}

#pragma mark - UITableView代理方法
//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
//段数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArr.count;
}

//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 144.0 ;
    } else if (indexPath.section == 1){
        return 322.0f ;
    } else if (indexPath.section == 2){
        return 436.0f ;
    } else if (indexPath.section == 3){
        return 175.0f ;
    } else{
        return 180.0f ;
    }
   // return 50.0;
}

//tableViewCell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        MainZeroTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZeroCell" forIndexPath:indexPath];
        cell.delegate = self;
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //[cell configUI:_dataArr[indexPath.section]];
        return cell;
    }else if (indexPath.section == 1){
        MainFirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FirstCell" forIndexPath:indexPath];
        cell.delegate = self;
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //[cell configUI:_dataArr[indexPath.section]];
        return cell;

    }else if (indexPath.section == 2){
        MainSecondTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SecondCell" forIndexPath:indexPath];
        cell.delegate = self;
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //[cell configUI:_dataArr[indexPath.section]];
        return cell;

    }else if (indexPath.section == 3){
        MainThirdTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ThirdCell" forIndexPath:indexPath];
        cell.delegate = self;
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //[cell configUI:_dataArr[indexPath.section]];
        return cell;
    }else {
        MainForthTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ForthCell" forIndexPath:indexPath];
        cell.delegate = self;
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //[cell configUI:_dataArr[indexPath.section]];
        return cell;
    }
    
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        //MainZeroTableViewCell *disCell = (MainZeroTableViewCell *)cell;
        [(MainZeroTableViewCell *)cell configUI:_dataArr[indexPath.section]];
    } else if (indexPath.section == 1) {
        //MainFirstTableViewCell *disCell = (MainFirstTableViewCell *)cell;
        [(MainFirstTableViewCell *)cell configUI:_dataArr[indexPath.section]];
    } else if (indexPath.section == 2) {
        //MainSecondTableViewCell *disCell = (MainSecondTableViewCell *)cell;
        [(MainSecondTableViewCell *)cell configUI:_dataArr[indexPath.section]];
    } else if (indexPath.section == 3) {
        //MainThirdTableViewCell *disCell = (MainThirdTableViewCell *)cell;
        [(MainThirdTableViewCell *)cell configUI:_dataArr[indexPath.section]];
    } else if (indexPath.section == 4) {
        //MainForthTableViewCell *disCell = (MainForthTableViewCell *)cell;
        [(MainForthTableViewCell *)cell configUI:_dataArr[indexPath.section]];
    }
}

//段头视图高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50 ;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIButton *sectionBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, kScreenWidth, 50.0 ) target:self SEL:@selector(sectionBtnClick:) title:nil];
    sectionBtn.backgroundColor = [UIColor whiteColor];
    sectionBtn.tag = 16000 + section;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100.0, 50 )];
    label.font = [UIFont systemFontOfSize:16.0f];
    label.textColor = kBlack;
    if (section == 0) {
        label.text = @"今日热点";
    } else if (section == 1){
        label.text = @"最新上架";
    } else if (section == 2){
        label.text = @"精品推荐";
    } else if (section == 3){
        label.text = @"即将上映";
    } else if (section == 4){
        label.text = @"猜你喜欢";
    }
    
    [sectionBtn addSubview:label];
    
    
    
    
    if (section == 4) {
        UIImageView *iv = [MyControl createImageViewFrame:CGRectMake(sectionBtn.width - 50, (50  - 32) /2, 50, 32) imageName:@"index-shuaxin"];
        iv.contentMode = UIViewContentModeCenter;
        //iv.frame = CGRectMake(sectionBtn.width - 25, (50 - 32) / 2, 19, 16.5);
        //iv.image = imageNamed(@"index-shuaxin");
        NSMutableArray *imgArr = [NSMutableArray array];
        for (int i = 0; i < 26; i++) {
            [imgArr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"shuaxin_000%02d.png",i]]];
        }
        iv.animationImages = imgArr;
        iv.animationDuration = 2.0;
        iv.animationRepeatCount = 0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shuaxin:)];
        
        iv.tag = 9998;
        [iv addGestureRecognizer:tap];
        [sectionBtn addSubview:iv];
    }
    
    return sectionBtn;
}

#pragma mark cell的代理
- (void)btnClickAtIndex:(NSInteger)index inSection:(NSInteger)section{
    //NSLog(@"%@", [[[_dataArr objectAtIndex:section] objectAtIndex:index] titleId]);
    if (section == 1 || section == 2 || section == 4) {
        if (![User objectForKey:kMemberId]) {
            LoginController *vc = [[LoginController alloc]init];
            [self configLeftBar];
            //
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
        MovieDetailController *vc = [[MovieDetailController alloc]init];
        vc.titleId = [[[_dataArr objectAtIndex:section] objectAtIndex:index] titleId];
        vc.name = [[[_dataArr objectAtIndex:section] objectAtIndex:index] movieName];
        [self configLeftBarWhite];
        //
        [self.navigationController pushViewController:vc animated:YES];
    } else if (section == 0) {
        ZixunDetailViewController *vc = [[ZixunDetailViewController alloc]init];
        HotNewsModel *model = _dataArr[section][index];
        [self configLeftBar];
        vc.type = YES;
        vc.zixunId = model.newsId;
        vc.url = [NSString stringWithFormat:@"%@?id=%@",Zixun_IP, model.newsId];
        NSLog(@"%@",vc.url);
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        ZixunDetailViewController *vc = [[ZixunDetailViewController alloc]init];
        PrevueModel *model = _dataArr[section];
        [self configLeftBar];
        vc.type = NO;
        vc.zixunId = model.prevueId;
        
        vc.url = [NSString stringWithFormat:@"%@?id=%@",Prevue_IP,model.prevueId];
        NSLog(@"%@",vc.url);
        ////
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark 刷新图片动画
- (void)shuaxin:(UITapGestureRecognizer *)tap{
    UIImageView *iv = (UIImageView *)[tap view];
    if (iv.isAnimating) {
        return;
    }
    
    [_dataArr removeLastObject];
    
    [iv startAnimating];
    [self loadGuessLike];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    MovieDetailController *m = [[MovieDetailController alloc]init];
//    m.titleId= @"1";
//    m.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:m animated:YES];
}

//段头按钮点击事件
- (void)sectionBtnClick:(UIButton *)btn{
    //tag 16000
    NSLog(@"%ld",btn.tag - 16000);
}

- (void)changeIP{
    static int i = 0;
    if (i == 4) {
        AppDelegate *app = [UIApplication sharedApplication].delegate;
        NSString *str = nil;
        if ([app.host_ip containsString:@"test"]) {
            str = @"测试";
        }else if ([app.host_ip containsString:@"dev"]) {
            str = @"dev";
        } else {
            str = @"正式";
        }
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示"
                                                                                 message:[NSString stringWithFormat:@"当前为%@环境",str]
                                                                          preferredStyle:UIAlertControllerStyleActionSheet];;
        UIAlertAction *ac1 = [UIAlertAction actionWithTitle:@"测试"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action) {
                                                        app.host_ip = @"www.test.unibox.com.cn/App";
                                                        i = 0;
                                                    }];
        UIAlertAction *ac2 = [UIAlertAction actionWithTitle:@"dev"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action) {
                                                        app.host_ip = @"www.dev.unibox.com.cn/App";
                                                        i = 0;
                                                    }];
        UIAlertAction *ac3 = [UIAlertAction actionWithTitle:@"正式"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action) {
                                                        app.host_ip = @"www.unibox.com.cn/App";
                                                        i = 0;
                                                    }];
        [alertController addAction:ac1];
        [alertController addAction:ac2];
        [alertController addAction:ac3];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        i++;
    }

}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        AppDelegate *app = [UIApplication sharedApplication].delegate;
        UITextField *textf = [alertView textFieldAtIndex:0];
        app.host_ip = textf.text;
        [User removeObjectForKey:kMemberId];
        NSLog(@"%@",app.host_ip);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
