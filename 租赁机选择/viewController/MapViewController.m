//
//  MapViewController.m
//  Unibox_iOS
//
//  Created by 刘羽 on 15/11/5.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import "MapViewController.h"
#import "Header.h"
#import "API.h"
#import "UIImage+Color.h"
#import "UIImageView+WebCache.h"
#import "CustomCalloutView.h"
#import "MyAnnotion.h"
#import "KioskModel.h"
#import "MapTableViewCell.h"
#import "NohightButton.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>
#define kLatitudeDelta 0.01
#define kLongitudeDelta 0.01
#import "AppDelegate.h"
#import "NetWork.h"
#import "AFNetworking.h"

@interface MapViewController () <BMKMapViewDelegate,BMKLocationServiceDelegate,BMKPoiSearchDelegate, UITableViewDataSource, UITableViewDelegate, CustomCalloutViewDelegate>
{
    BMKMapView *_mapView;
    BMKLocationService *_locService;
    BMKUserLocation *_userLocation;
    //poi搜索
    BMKPoiSearch *_poiSearch;
    CLGeocoder *_geocoder;
    float lat;
    float lon;
    //每次进入获取一次当前地理位置
    BOOL flag;
    //每次进入选中tableview中已选择的租赁机
    BOOL selectTb;
    //搜索视图
    UIView *_searchView;
    //搜索视图上的textField
    UITextField *_keyText;
    //搜索按钮
    UIButton *_searchBtn;
    //租赁机数组
    NSMutableArray *_kioskArr;
    UITableView *_tb;
    NohightButton *_selectedBtn;
    
    //标注数组
    NSMutableArray *_annArr;
    
    BOOL annFlag;
}
@end

@implementation MapViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    _mapView.delegate = self;
    _locService.delegate = self;
    _poiSearch.delegate = self;
    
}

- (void)dealloc{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
    _poiSearch.delegate = nil;
    _locService.delegate = nil;
}

//- (void)viewWillDisappear:(BOOL)animated
//{
//    
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    flag = YES;
    selectTb = YES;
    self.view.backgroundColor = kRed;
    
    
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    
    //self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我的租赁机";
    _selectedBtn = nil;
    _kioskArr = [NSMutableArray array];
    _annArr = [NSMutableArray array];
    annFlag = YES;
    //[self configLeftBarWhite];
    
    BMKMapView *mapView = [[BMKMapView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:mapView];
   // BMKPoiSearch *poisearch = [[BMKPoiSearch alloc]init];
   // _poiSearch = poisearch;
    
    //_mapView = [[BMKMapView alloc]init];
    _mapView = mapView;
    self.view = _mapView;
    //[self.view addSubview:mapView];
    [_mapView showsUserLocation];
    
    
    _mapView.userTrackingMode = BMKUserTrackingModeNone;
    BMKLocationViewDisplayParam *displayParam = [[BMKLocationViewDisplayParam alloc]init];
    displayParam.isRotateAngleValid = true;//跟随态旋转角度是否生效
    displayParam.isAccuracyCircleShow = false;//精度圈是否显示
    //displayParam.locationViewImgName= @"icon";//定位图标名称
    displayParam.locationViewOffsetX = 0;//定位偏移量(经度)
    displayParam.locationViewOffsetY = 0;//定位偏移量（纬度）
    [_mapView updateLocationViewWithParam:displayParam];
    
    //定位功能
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    //启动LocationService
    [_locService startUserLocationService];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64.0)];
    bgView.backgroundColor = kRed;
    [self.view addSubview:bgView];
    //创建搜索栏
    //[self createSearchTextField];
    //创建搜索栏
    //[self createSearch];
    //创建tabview
    [self createTB];
    //请求数据获取租赁机列表
    [self loadData];
}

#pragma mark 创建搜索栏
//- (void)createSearch{
//    
//}

#pragma mark 创建UITableView
- (void)createTB{
    
    UIView *shadowView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 151, kScreenWidth, 1)];
    [self.view addSubview:shadowView];
    shadowView.clipsToBounds = NO;
    shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
    shadowView.layer.shadowOffset = CGSizeMake(0, -2);
    shadowView.layer.shadowOpacity = 0.2;
    shadowView.layer.shadowRadius = 2.0;
    
    UITableView *tb = [[UITableView alloc]initWithFrame:CGRectMake(0, kScreenHeight- 150, kScreenWidth, 150) style:UITableViewStylePlain];
    tb.delegate = self;
    tb.dataSource = self;
    
//    tb.layer.masksToBounds = NO;
//    tb.layer.shadowColor = [UIColor blackColor].CGColor;
//    tb.layer.shadowOffset = CGSizeMake(0, -2);
//    tb.layer.shadowOpacity = 0.2;
//    tb.layer.shadowRadius = 2.0;
    
    _tb = tb;
    tb.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tb registerNib:[UINib nibWithNibName:@"MapTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MapCell"];
    [self.view addSubview:tb];
}

#pragma mark - UITableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _kioskArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MapTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MapCell" forIndexPath:indexPath];
    KioskModel *model = _kioskArr[indexPath.row];
    cell.kioskName.text = model.kioskName;
    cell.kioskAddress.text = model.address;
    cell.distanceLb.text = [self calDistance:model.distance];
    [cell.img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_IP,model.kioskImg]] placeholderImage:imageNamed(@"placehold")];
    //cell.selectBtn.selected = [model.cur intValue] ? YES:NO;
    
    if ([model.cur intValue]) {
        if (selectTb) {
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
        selectTb = NO;
    }
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark 计算距离
- (NSString *)calDistance:(float)distance{
    int meter = (int)distance;
    if (meter / 1000) {
        return [NSString stringWithFormat:@"%.1fkm",distance / 1000];
    } else {
        return [NSString stringWithFormat:@"%dm",meter];
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   // [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //[self pickRent:indexPath.row];
    KioskModel *model = _kioskArr[indexPath.row];
    for (MyAnnotion *ann in _annArr) {
        if ([ann.kioskId isEqualToString:model.kioskId]) {
            [_mapView selectAnnotation:ann animated:YES];
            [_mapView setCenterCoordinate:ann.coordinate animated:YES];
            [_mapView setRegion:BMKCoordinateRegionMake(ann.coordinate, BMKCoordinateSpanMake(kLatitudeDelta, kLongitudeDelta)) animated:YES];
        }
    }
}

- (void)pickRent:(NSInteger)row{
    //选择租赁机
    NSDictionary *dic = @{
                          @"_memberId":[User objectForKey:kMemberId],
                          @"_accessToken":[User objectForKey:kAccessToken],
                          @"kioskId":[_kioskArr[row] kioskId]
                          };
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [manager GET:[NSString stringWithFormat:@"http://%@%@",app.host_ip,SelectKiosk] parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject[@"ret"]);
        if (![responseObject[@"ret"] boolValue]) {
            [self loadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    KioskModel *model = _kioskArr[row];
    for (MyAnnotion *ann in _annArr) {
        if ([ann.kioskId isEqualToString:model.kioskId]) {
            [_mapView selectAnnotation:ann animated:YES];
            [_mapView setCenterCoordinate:ann.coordinate animated:YES];
            [_mapView setRegion:BMKCoordinateRegionMake(ann.coordinate, BMKCoordinateSpanMake(kLatitudeDelta, kLongitudeDelta)) animated:YES];
        }
    }
    //[self selectKiosk:[_kioskArr[row] kioskId]];
}

- (void)selectKiosk:(NSString *)kioskId{
   // MapViewController *__weak weakSelf = self;
    NSDictionary *dic = @{
                          @"_memberId":[User objectForKey:kMemberId],
                          @"_accessToken":[User objectForKey:kAccessToken],
                          @"kioskId":kioskId
                          };
    //AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [NetWork getRequest:[NSString stringWithFormat:@"http://%@%@",app.host_ip,SelectKiosk] params:dic success:^(id responseObj) {
        if (![responseObj[@"ret"] boolValue]) {
            JGProgressHUD *hud = [[JGProgressHUD alloc]initWithStyle:JGProgressHUDStyleDark];
            hud.indicatorView = [[JGProgressHUDSuccessIndicatorView alloc]init];
            hud.textLabel.text = @"选择租赁机成功";
            [hud showInView:self.view];
            [hud dismissAfterDelay:1.0 animated:YES];
        } else {
            JGProgressHUD *hud = [[JGProgressHUD alloc]initWithStyle:JGProgressHUDStyleDark];
            hud.indicatorView = [[JGProgressHUDErrorIndicatorView alloc]init];
            hud.textLabel.text = @"选择租赁机失败";
            [hud showInView:self.view];
            [hud dismissAfterDelay:1.0 animated:YES];
        }
    } failure:^(NSError *error) {
        JGProgressHUD *hud = [[JGProgressHUD alloc]initWithStyle:JGProgressHUDStyleDark];
        hud.indicatorView = [[JGProgressHUDErrorIndicatorView alloc]init];
        hud.textLabel.text = @"选择租赁机失败";
        [hud showInView:self.view];
        [hud dismissAfterDelay:1.0 animated:YES];
    }];
}

#pragma mark 请求数据获取租赁机列表
- (void)loadData{
    //AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *dic = @{
                          @"_memberId":[User objectForKey:kMemberId],
                          @"_accessToken":[User objectForKey:kAccessToken]
                          };
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    JGProgressHUD *hud = [[JGProgressHUD alloc]initWithStyle:JGProgressHUDStyleDark];
    [hud showInView:self.view];
    [_kioskArr removeAllObjects];
    MapViewController *__weak weakSelf = self;
    [NetWork getRequest:[NSString stringWithFormat:@"http://%@%@",app.host_ip,GetKioskList] params:dic success:^(id responseObj) {
        BMKMapPoint point1 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(lat,lon));
        if (![responseObj[@"ret"] boolValue]) {
            NSLog(@"%@",responseObj);
            for (NSDictionary *d in responseObj[@"list"]) {
                KioskModel *model = [[KioskModel alloc]init];
                [model setValuesForKeysWithDictionary:d];
                BMKMapPoint point2 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake([model.latitude floatValue],[model.longitude floatValue]));
                CLLocationDistance distance = BMKMetersBetweenMapPoints(point1,point2);
                model.distance = distance;
                [_kioskArr addObject:model];
        }
        if (_annArr.count) {
            
        } else {
            [weakSelf createAnnotions];
        }
            //annFlag = NO;
            if (annFlag == NO) {
                //JGProgressHUD *hud = [[JGProgressHUD alloc]initWithStyle:JGProgressHUDStyleDark];
                hud.indicatorView = [[JGProgressHUDSuccessIndicatorView alloc]init];
                hud.textLabel.text = @"选择租赁机成功";
                hud.textLabel.font = [UIFont systemFontOfSize:14.0];
                hud.position = JGProgressHUDPositionCenter;
                //[hud showInView:self.view];
                [hud dismissAfterDelay:1.0f animated:YES];
            }
            [hud dismissAfterDelay:1.0f animated:YES];
        
            //按照距离当前位置距离排序
            [_kioskArr sortUsingSelector:@selector(compareKiosk:)];
            [_tb reloadData];
        }
        annFlag = NO;
    } failure:^(NSError *error) {
        //
    }];
    
}

//- (void)createSearchTextField
//{
//    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(0, -80, kScreenWidth, 80)];
//    searchView.backgroundColor = kWhite_Main;
//    _searchView = searchView;
//    [_mapView addSubview:searchView];
//    
//    UILabel *label = [MyControl createLabelWithFrame:CGRectMake(20, 30, 120, 40) Font:17.0f Text:@"在附近搜索"];
//    label.textColor = kBlack_type;
//    [searchView addSubview:label];
//    
//    UITextField *keyText = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), label.y, 120, 40)];
//    _keyText = keyText;
//    //keyText.delegate = self;
//    [keyText addTarget:self action:@selector(keyTextChange:) forControlEvents:UIControlEventEditingChanged];
//    keyText.borderStyle = UITextBorderStyleRoundedRect;
//    keyText.placeholder = @"输入关键字";
//    keyText.returnKeyType = UIReturnKeySearch;
//    [searchView addSubview:keyText];
//    
//    UIButton *btn = [MyControl createButtonWithFrame:CGRectMake(CGRectGetMaxX(keyText.frame)+5, label.y, 60, 40) target:self SEL:@selector(searchBtnClick) title:@"搜索"];
//    _searchBtn = btn;
//    btn.layer.cornerRadius = 10.0f;
//    [btn setTitleColor:kBlack_type forState:UIControlStateNormal];
//    [btn setTitleColor:kLightgray forState:UIControlStateDisabled];
//    btn.tag = 8500;
//    btn.enabled = NO;
//    [searchView addSubview:btn];
//    //[self.view addSubview:searchView];
//    
//}

//- (void)keyTextChange:(UITextField *)textField
//{
//    //NSLog(@"12312321");
//    if ([textField.text length] == 0) {
//        if (_searchBtn.enabled) {
//            _searchBtn.enabled = NO;
//        }
//    }else{
//        if (!_searchBtn.enabled) {
//            _searchBtn.enabled = YES;
//        }
//    }
//}


//#pragma mark 搜索按钮点击
//- (void)searchBtnClick
//{
//    //
//    //curPage = 0;
//    //BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc]init];
//    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
//    option.pageIndex = 0;
//    option.pageCapacity = 10;
//    //citySearchOption.city= _cityText.text;
//    option.location = [(BMKPointAnnotation *)_selectAnnotation.annotation coordinate];
//    NSLog(@"%f, %f",option.location.latitude, option.location.longitude);
//    option.keyword = _keyText.text;
//    BOOL ret = [_poiSearch poiSearchNearBy:option];
//    if(ret)
//    {
//        _searchBtn.enabled = true;
//        NSLog(@"周边检索发送成功");
//    }
//    else
//    {
//        _searchBtn.enabled = false;
//        NSLog(@"周边检索发送失败");
//    }
//    [UIView animateWithDuration:0.25 animations:^{
//        _searchView.y = -80;
//        [_keyText resignFirstResponder];
//    }];
//    
//
//}

//实现PoiSearchDeleage处理回调结果
//- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)result errorCode:(BMKSearchErrorCode)error
//{
//    // 清楚屏幕中所有的annotation
//    //NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
//    //[_mapView removeAnnotations:array];
//    for (id ann in _mapView.annotations) {
//        if (![ann isKindOfClass:[MyAnnotion class]]) {
//            [_mapView removeAnnotation:ann];
//        }
//    }
//    
//    if (error == BMK_SEARCH_NO_ERROR) {
//        NSMutableArray *annotations = [NSMutableArray array];
//        for (int i = 0; i < result.poiInfoList.count; i++) {
//            BMKPoiInfo* poi = [result.poiInfoList objectAtIndex:i];
//            BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
////          poiinfo中的uid  可以通过uid 经过 BMKPoiDetailSearchOption 进行详情的搜索
//            item.coordinate = poi.pt;
//            item.title = poi.name;
//            [annotations addObject:item];
//        }
//        [_mapView addAnnotations:annotations];
//        //[_mapView showAnnotations:annotations animated:YES];
//    } else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
//        NSLog(@"起始点有歧义");
//    } else {
//        // 各种情况的判断。。。
//    }
//}



//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
    //普通态 展示定位信息
    _mapView.showsUserLocation = YES;
    
   [_mapView updateLocationData:userLocation];
    if (flag) {
        
        [_mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
        flag = NO;
        
        //====位置的反编码
        _geocoder = [[CLGeocoder alloc]init];
        [_geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            for (CLPlacemark *place in placemarks) {
                NSLog(@"name %@",place.name); //位置
                NSLog(@"thoroughfare %@",place.thoroughfare); // 街道
                NSLog(@"subthoroughfare %@", place.subThoroughfare); // 子街道
                NSLog(@"locality %@",  place.locality);   //区
                NSLog(@"subLocality %@", place.subLocality); //子区
                NSLog(@"country %@", place.country); //国家
                
            }
        }];
//        [_mapView setRegion:BMKCoordinateRegionMake(userLocation.location.coordinate, BMKCoordinateSpanMake(kLatitudeDelta, kLongitudeDelta)) animated:YES];
        lat = userLocation.location.coordinate.latitude;
        lon = userLocation.location.coordinate.longitude;
        //flag = NO;
        //[self createAnnotions];
    }
    
    //[_locService stopUserLocationService];
}

- (void)createAnnotions
{
    //NSLog(@"12312312");
    for (int i = 0; i < _kioskArr.count; i++)
    {
        //BMKPointAnnotation * ann = [[BMKPointAnnotation alloc]init];
        KioskModel *model = _kioskArr[i];
        MyAnnotion *ann = [[MyAnnotion alloc]init];
        ann.coordinate = CLLocationCoordinate2DMake([model.latitude floatValue], [model.longitude floatValue]);
        ann.title = model.kioskName;
        ann.subtitle = model.address;
        ann.img = model.kioskImg;
        ann.kioskId = model.kioskId;
        [_annArr addObject:ann];
        [_mapView addAnnotation:ann];
        if ([model.cur boolValue]){
            [_mapView selectAnnotation:ann animated:YES];
            [_mapView setCenterCoordinate:ann.coordinate animated:YES];
            [_mapView setRegion:BMKCoordinateRegionMake(ann.coordinate, BMKCoordinateSpanMake(kLatitudeDelta, kLongitudeDelta)) animated:YES];
        }
        //NSLog(@"12312");
    }
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    CustomCalloutView *calloutView = [[[NSBundle mainBundle]loadNibNamed:@"CustomCalloutView" owner:self options:nil]lastObject];
    calloutView.delegate = self;
    calloutView.frame = CGRectMake(0, 0, 230, 130);
    if ([annotation isKindOfClass:[MyAnnotion class]]) {
        BMKPinAnnotationView *newAnnotation = [[BMKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotation.pinColor = BMKPinAnnotationColorPurple;
        newAnnotation.animatesDrop = NO;
        
        newAnnotation.paopaoView = [[BMKActionPaopaoView alloc]initWithCustomView:calloutView];
        
        calloutView.address.text = [NSString stringWithFormat:@"%@(%@)",[(MyAnnotion *)annotation subtitle],[(MyAnnotion *)annotation title]];
        [calloutView.img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_IP,[(MyAnnotion *)annotation img]]] placeholderImage:imageNamed(@"placehold")];
        calloutView.kioskId = [(MyAnnotion *)annotation kioskId];
        //newAnnotation.annotation = annotation;
        newAnnotation.image = imageNamed(@"icon-zulinji");
        return newAnnotation;
    }else{
        BMKPinAnnotationView *annotation1 = [[BMKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"pinAnnoatiton"];
        annotation1.pinColor = BMKPinAnnotationColorPurple;
        annotation1.animatesDrop = YES;
        return annotation1;
    }
    return nil;
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    NSLog(@"点击ann");
    if ([view.annotation isKindOfClass:[MyAnnotion class]]) {
//        MyAnnotion *ann = (MyAnnotion *)view.annotation;
//        NSLog(@"%@",ann.title);
//        NSLog(@"%@",ann.subtitle);
//        NSLog(@"%f,%f",ann.coordinate.latitude,ann.coordinate.longitude);
        
//        static BOOL chooseRent = NO;
//        if (chooseRent) {//选择租赁机
//            //
//            //[self selectKiosk:ann.kioskId];
//            [_mapView setCenterCoordinate:ann.coordinate animated:YES];
//            [_mapView setRegion:BMKCoordinateRegionMake(ann.coordinate, BMKCoordinateSpanMake(kLatitudeDelta, kLongitudeDelta)) animated:YES];
//        }
//        chooseRent = YES;
        
    }
    
//    //记录选中的标注
//    _selectAnnotation = view;
}


- (void)calloutBtnClick:(NSString *)kioskId{
    NSLog(@"选择租赁机%@",kioskId);
    for (int i = 0; i < _kioskArr.count; i++) {
        KioskModel *model = _kioskArr[i];
        if ([model.kioskId isEqualToString:kioskId]) {
            [_tb selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
            break;
        }
    }
    [self selectKiosk:kioskId];
}

- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view
{
    NSLog(@"点击弹出气泡");
    //改变标注图片
    //view.image = [UIImage imageNamed:@"08.png"];
    if ([view.annotation isKindOfClass:[MyAnnotion class]]) {
        MyAnnotion *ann = (MyAnnotion *)view.annotation;
        NSLog(@"%@",ann.title);
        NSLog(@"%@",ann.subtitle);
        NSLog(@"%f,%f",ann.coordinate.latitude,ann.coordinate.longitude);
        //[self selectKiosk:ann.kioskId];
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
