//
//  MovieDetailController.m
//  Unibox_iOS
//
//  Created by 刘羽 on 15/10/30.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import "MovieDetailController.h"
#import "Header.h"
#import "UIImageView+WebCache.h"
#import "API.h"
#import "MovieDetailModel.h"
//#import <MediaPlayer/MediaPlayer.h>
//#import "KRVideoPlayerController.h"
#import "UIImage+Color.h"
#import "MovieDetailTableViewCell.h"
#import "CommentModel.h"
#import "MJRefresh.h"
#import "AppDelegate.h"
#import "ShopCartController.h"
#import "PayViewController.h"
#import "MapViewController.h"
#import "NetWork.h"

@interface MovieDetailController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIImageView *_movieImg;
    //UITableView
    UITableView *_tb;
    //tableView数据源
    NSMutableArray *_dataArr;
    //评论页码
    int _page;
    
    //tableView的HeadView
    UIView *_headView;
    //headView中的descView
    UIButton *_sperBtn;
    //影片详情view
    UIView *_movieDetailView;
    //影片详情Lb
    UILabel *_movieDetailLb;
    //评论视图
    //UIView *_commentView;
    //影片详情
    MovieDetailModel *_DetailModel;
    //购物车数量
    UILabel *_carNumLb;
    //立即预订按钮
    UIButton *_reserveBtn;
    //加入购物车按钮
    UIButton *_addCarBtn;
    //下拉刷新
    MJRefreshNormalHeader *_head;
    MJRefreshBackNormalFooter *_foot;
    UIView *_tableHead;
    
    //是否收藏
    BOOL isFav;
}
//@property (nonatomic, strong) KRVideoPlayerController *videoController;
@end

@implementation MovieDetailController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    if (_dataArr != nil) {
        [self getCartNum];
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = kWhite_Main;
    //isFav = NO;
    if ([self.name length]) {
        self.title = self.name;
    } else {
        self.title = @"影片详情";
    }
    
    
    UIView *gView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    gView.backgroundColor = kRed;
    [self.view addSubview:gView];
    _dataArr = [NSMutableArray array];
    _page = 1;
   
    //修改返回按钮
    //[self configLeftBarWhite];
    //加载数据
    [self loadData];
    //[self createUI];
    //加载评论数据
    [self loadCommitData];
    
}

#pragma mark 加载评论数据
- (void)loadCommitData{
    //AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *dic = @{
                          @"titleId":_titleId,
                          @"page":[NSString stringWithFormat:@"%d",_page]
                          };
    JGProgressHUD *hud = [[JGProgressHUD alloc]initWithStyle:JGProgressHUDStyleDark];
    [hud showInView:self.navigationController.view];
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    //NSLog(@"%@",[NSString stringWithFormat:@"http://%@%@?titleId=%@&page=1",app.host_ip,GetCommentList,_titleId]);
    //AppDelegate *app = [UIApplication sharedApplication].delegate;
    [NetWork getRequest:[NSString stringWithFormat:@"http://%@%@",app.host_ip,GetCommentList] params:dic success:^(id responseObj) {
        if (![responseObj[@"ret"] intValue]) {
            for (NSDictionary *d in responseObj[@"list"]) {
                CommentModel *model = [[CommentModel alloc]init];
                [model setValuesForKeysWithDictionary:d];
                [_dataArr addObject:model];
            }
            //NSLog(@"%@",_dataArr);
            hud.indicatorView = [[JGProgressHUDSuccessIndicatorView alloc]init];
            //hud.textLabel.text = @"加载完成";
            if (_dataArr.count == 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    //添加尾视图
                    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
                    //label.backgroundColor = kRed;
                    label.text = @"暂无评论";
                    label.font = [UIFont systemFontOfSize:16.0];
                    //label.textColor = kWhite_Main;
                    label.textAlignment = NSTextAlignmentCenter;
                    _tb.tableFooterView = label;
                });
                
            } else {
                [_tb reloadData];
            }
        } else {
            hud.indicatorView = [[JGProgressHUDSuccessIndicatorView alloc]init];
            //hud.textLabel.text = @"请求失败";
        }
        
        hud.position = JGProgressHUDPositionCenter;
        [hud dismissAfterDelay:1.0f animated:YES];
        [_head endRefreshing];
        [_foot endRefreshing];
    } failure:^(NSError *error) {
        [hud dismissAfterDelay:1.0f animated:YES];
    }];
}

//#pragma mark 加载数据
- (void)loadData
{
    //AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //NSLog(@"--------%@",_titleId);
    NSDictionary *dic = @{
                          @"_memberId":[User objectForKey:kMemberId],
                          @"_accessToken":[User objectForKey:kAccessToken],
                          @"titleId":_titleId
                          };
    NSLog(@"%@",_titleId);
    MovieDetailController *__weak weakSelf = self;
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [NetWork getRequest:[NSString stringWithFormat:@"http://%@%@",app.host_ip, GetMovieDetail_URL] params:dic success:^(id responseObj) {
        if (![[responseObj objectForKey:@"ret"] intValue]) {
            _DetailModel = [[MovieDetailModel alloc]init];
            [_DetailModel setValuesForKeysWithDictionary:[responseObj objectForKey:@"info"]];
            //NSLog(@"%@",responseObj);
            isFav = [[_DetailModel fav] boolValue] ? YES:NO;
            [weakSelf createUI];
            [weakSelf createTB];
            
        }
    } failure:^(NSError *error) {
        NSLog(@"失败");
    }];
}

#pragma mark 创建UI
- (void)createUI
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 10 + 64, kScreenWidth, 240)];
    headView.backgroundColor = [UIColor whiteColor];
    _headView = headView;
    //[self.view addSubview:headView];
    //影片图片
    UIImageView *iv = [MyControl createImageViewFrame:CGRectMake(10, 20, 150 / kWidthScale, 200) imageName:@"img-cainixh2"];
    [iv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_IP, _DetailModel.movie_img]] placeholderImage:imageNamed(@"placehold")];
    [headView addSubview:iv];
    
    if ([_DetailModel.blueray intValue]) {
        //是蓝光
        UIImageView *bluerayImageView = [[UIImageView alloc]initWithFrame:CGRectMake(iv.width - 48.0, 0, 48.0, 49.5)];
        bluerayImageView.image = imageNamed(@"img-blu-ray");
        [iv addSubview:bluerayImageView];
    }
    
    UILabel *dyLb = [MyControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(iv.frame) + 10, iv.y + 2, 35, 15 / kWidthScale) Font:12.0 Text:@"导演:"];
    [headView addSubview:dyLb];
    //导演
    UILabel *directorLb = [MyControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(dyLb.frame), dyLb.y, kScreenWidth - CGRectGetMaxX(dyLb.frame) - 10, dyLb.height) Font:13.0 Text:_DetailModel.director];
    [headView addSubview:directorLb];
    
    UILabel *zyLb = [MyControl createLabelWithFrame:CGRectMake(dyLb.x, CGRectGetMaxY(directorLb.frame) + 4, dyLb.width, dyLb.height) Font:12.0 Text:@"主演:"];
    [headView addSubview:zyLb];
    
    //主演
    //UILabel *leadLb = [MyControl createLabelWithFrame:CGRectMake(directorLb.x, zyLb.y, directorLb.width, 30) Font:12.0 Text:_DetailModel.actor];
    UILabel *leadLb = [[UILabel alloc]initWithFrame:CGRectMake(directorLb.x, zyLb.y, directorLb.width, 30)];
    leadLb.font = [UIFont systemFontOfSize:12.0];
    leadLb.text = _DetailModel.actor;
    
    leadLb.numberOfLines = 3;
    //leadLb.lineBreakMode = UILineBreakModeWordWrap|UILineBreakModeTailTruncation;
    [leadLb sizeToFit];
    CGRect frame = leadLb.frame;
    frame.size.height += 3;
    leadLb.frame = frame;
    [headView addSubview:leadLb];
    
    UILabel *lxLb = [MyControl createLabelWithFrame:CGRectMake(dyLb.x, CGRectGetMaxY(leadLb.frame) + 4, dyLb.width, dyLb.height) Font:12.0 Text:@"类型:"];
    if (leadLb.text.length == 0) {
        lxLb.y = CGRectGetMaxY(zyLb.frame) + 4;
    }
    [headView addSubview:lxLb];
    
    //类型
    UILabel *typeLb = [MyControl createLabelWithFrame:CGRectMake(directorLb.x, lxLb.y, directorLb.width, dyLb.height) Font:12.0 Text:_DetailModel.genre];
    [headView addSubview:typeLb];
    
    UILabel *dqLb = [MyControl createLabelWithFrame:CGRectMake(dyLb.x, CGRectGetMaxY(lxLb.frame) + 4, dyLb.width, dyLb.height) Font:12.0 Text:@"地区:"];
    [headView addSubview:dqLb];
    
    //地区
    UILabel *areaLb = [MyControl createLabelWithFrame:CGRectMake(directorLb.x, dqLb.y, directorLb.width, dyLb.height) Font:12.0 Text:_DetailModel.nation];
    [headView addSubview:areaLb];
    
    UILabel *sysjLb = [MyControl createLabelWithFrame:CGRectMake(dyLb.x, CGRectGetMaxY(dqLb.frame) + 4, dyLb.width + 30, dyLb.height) Font:12.0 Text:@"上映时间:"];
    [headView addSubview:sysjLb];
    
    //上映时间
    UILabel *timeLb = [MyControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(sysjLb.frame), sysjLb.y, kScreenWidth - CGRectGetMaxX(sysjLb.frame) - 10, dyLb.height) Font:13.0 Text:_DetailModel.release_time];
    [headView addSubview:timeLb];
    
    UILabel *pcLb = [MyControl createLabelWithFrame:CGRectMake(dyLb.x, CGRectGetMaxY(sysjLb.frame) + 4, dyLb.width, dyLb.height) Font:12.0 Text:@"片长:"];
    [headView addSubview:pcLb];
    
    //片长
    UILabel *timeLongLb = [MyControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(pcLb.frame), pcLb.y, directorLb.width, dyLb.height) Font:12.0 Text:[NSString stringWithFormat:@"%@分钟",_DetailModel.running_time]];
    [headView addSubview:timeLongLb];
    
    UILabel *kcLb = [MyControl createLabelWithFrame:CGRectMake(dyLb.x, CGRectGetMaxY(pcLb.frame) + 4, dyLb.width, dyLb.height) Font:12.0 Text:@"库存:"];
    kcLb.textColor = kRed;
    [headView addSubview:kcLb];
    
    //库存
    UILabel *stockLb = [MyControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(kcLb.frame), kcLb.y, directorLb.width, dyLb.height) Font:13.0 Text:@""];
    if ([_DetailModel.inventory intValue] == -1) {
        stockLb.text = @"未选择租赁机";
    } else {
        stockLb.text = _DetailModel.inventory;
    }
    stockLb.textColor = kRed;
    [headView addSubview:stockLb];
    
    UILabel *yjLb = [MyControl createLabelWithFrame:CGRectMake(dyLb.x, CGRectGetMaxY(kcLb.frame) + 4, dyLb.width, 20) Font:12.0 Text:@"押金:"];
    [yjLb sizeToFit];
    [headView addSubview:yjLb];
    
    //押金
    UILabel *depositLb = [MyControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(yjLb.frame), yjLb.y, 100, 20) Font:12.0 Text:[NSString stringWithFormat:@"￥%@",_DetailModel.deposit]];//￥
    [depositLb sizeToFit];
    depositLb.textColor = kRed;
    [headView addSubview:depositLb];
    
    UILabel *zjLb = [MyControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(depositLb.frame) + 10, yjLb.y, yjLb.width, yjLb.height) Font:12.0 Text:@"租金:"];
    [zjLb sizeToFit];
    [headView addSubview:zjLb];
    
    //租金
    UILabel *rentLb = [MyControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(zjLb.frame), zjLb.y, 100, 20) Font:12.0 Text:[NSString stringWithFormat:@"￥%@/天",_DetailModel.dailyFee]];
    [rentLb sizeToFit];
    rentLb.textColor = kRed;
    [headView addSubview:rentLb];
    
    //影片详情view
    UIView *movieDetailView= [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(headView.frame) + 10, kScreenWidth, 55.0)];
    movieDetailView.backgroundColor = [UIColor whiteColor];
    _movieDetailView = movieDetailView;
    //[self.view addSubview:movieDetailView];
    
    UILabel *ypxqLb = [MyControl createLabelWithFrame:CGRectMake(10, 5, 60, 15) Font:13.0 Text:@"影片详情"];
    [movieDetailView addSubview:ypxqLb];
    
    
    
    //UILabel *movieDetailLb = [MyControl createLabelWithFrame:CGRectMake(10, CGRectGetMaxY(ypxqLb.frame) + 5, kScreenWidth - 20, 20) Font:12.0f Text:_DetailModel.synopsis];
    //NSLog(@"%@",_DetailModel.movie_desc);
    UILabel *movieDetailLb = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(ypxqLb.frame) + 5, kScreenWidth - 20, 20)];
    movieDetailLb.font = [UIFont systemFontOfSize:12.0f];
    movieDetailLb.text = _DetailModel.synopsis;
    
    movieDetailLb.numberOfLines = 5;
    //movieDetailLb.lineBreakMode = UILineBreakModeWordWrap|UILineBreakModeTailTruncation;
    _movieDetailLb = movieDetailLb;
    movieDetailLb.textColor = [UIColor lightGrayColor];
    [movieDetailLb sizeToFit];
    movieDetailView.clipsToBounds = YES;
    [movieDetailView addSubview:movieDetailLb];
    
    //下拉按钮
    UIButton *sprBtn = [MyControl createButtonWithFrame:CGRectMake(0, CGRectGetMaxY(movieDetailView.frame), kScreenWidth, 25.0) target:self SEL:@selector(sprBtnClick:) title:nil];
    _sperBtn = sprBtn;
    sprBtn.backgroundColor = [UIColor whiteColor];
    [sprBtn setBackgroundImage:imageNamed(@"down_arrow1") forState:UIControlStateNormal];
    [sprBtn setBackgroundImage:imageNamed(@"up_arrow1") forState:UIControlStateSelected];
    //[self.view addSubview:sprBtn];
    
    //创建tableView;
    //[self createTB];
    
    
}

- (void)getCartNum{
    //AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *dic = @{
                          @"_memberId":[User objectForKey:kMemberId],
                          @"_accessToken":[User objectForKey:kAccessToken]
                          };
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [NetWork getRequest:[NSString stringWithFormat:@"http://%@%@",app.host_ip,getUserCartCount] params:dic success:^(id responseObj) {
        if (![responseObj[@"ret"] boolValue]) {
            _carNumLb.text = [responseObj[@"count"] stringValue];
        }
    } failure:^(NSError *error) {
        //
    }];
}
//
//- (void)playVideoWithURL:(NSURL *)url
//{
//    if (!self.videoController) {
//        //CGFloat width = [UIScreen mainScreen].bounds.size.width;
//        self.videoController = [[KRVideoPlayerController alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, kScreenWidth * 0.5)];
//        __weak typeof(self)weakSelf = self;
//        [self.videoController setDimissCompleteBlock:^{
//            weakSelf.videoController = nil;
//        }];
//        [self.videoController showInWindow];
//    }
//    self.videoController.contentURL = url;
//}

#pragma mark 创建中部三个按钮
- (void)createBottomView
{
    UIView *shopView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 50.0, kScreenWidth, 50)];
    shopView.backgroundColor = [UIColor whiteColor];
    
    shopView.clipsToBounds = NO;
    shopView.layer.shadowColor = kWhite_Main.CGColor;
    shopView.layer.shadowOffset = CGSizeMake(0, -1);
    shopView.layer.shadowRadius = 1.0f;
    shopView.layer.shadowOpacity = 0.9;
    [self.view addSubview:shopView];
    
    //收藏按钮
    //UIButton *scBtn = [MyControl createButtonWithFrame:CGRectMake(10, (50 - 31.5)/2 + 2, 21.5, 31.5) target:self SEL:@selector(scBtnClick) title:nil];
    UIImageView *scIv = [MyControl createImageViewFrame:CGRectMake(10, (50 - 48) / 2 + 2, 46, 48) imageName:@"shoucang_00000"];
    if (isFav) {
        scIv.image = imageNamed(@"shoucang_00029");
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scBtnClick:)];
    [scIv addGestureRecognizer:tap];
    NSMutableArray *imgArr = [NSMutableArray array];
    for (int i = 0; i < 30; i++) {
        //NSLog(@"%2d",i);
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"shoucang_000%02d",i]];
        [imgArr addObject:image];
        
    }
    scIv.animationImages = imgArr;
    [shopView addSubview:scIv];
    
    
    //[scBtn setBackgroundImage:imageNamed(@"icon-sc") forState:UIControlStateNormal];
    //[shopView addSubview:scBtn];
    
    //购物车按钮
    UIButton *carBtn = [MyControl createButtonWithFrame:CGRectMake(CGRectGetMaxX(scIv.frame) + 30, (50 - 38)/2 + 3, 34, 38) target:self SEL:@selector(carBtnClick) title:nil];
    [carBtn setBackgroundImage:imageNamed(@"icon-buy-car") forState:UIControlStateNormal];
    [shopView addSubview:carBtn];
    
    //加入购物车按钮
    UIButton *addCarBtn = [MyControl createButtonWithFrame:CGRectMake(CGRectGetMaxX(carBtn.frame) + 10, 0, (kScreenWidth - CGRectGetMaxX(carBtn.frame) - 10) / 2, 50) target:self SEL:@selector(addCarBtnClick:) title:@"加入购物车"];
    addCarBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    addCarBtn.backgroundColor = kRed;
    _addCarBtn = addCarBtn;
    [shopView addSubview:addCarBtn];
    
    //购物车数量label
    UILabel *carNumLb = [MyControl createLabelWithFrame:CGRectMake(carBtn.width - 12, 0, 10, 10) Font:10.0f Text:@"0"];
    carNumLb.numberOfLines = 1;
    carNumLb.textAlignment = NSTextAlignmentCenter;
    _carNumLb = carNumLb;
    //carNumLb.backgroundColor = [UIColor greenColor];
    carNumLb.textColor = [UIColor whiteColor];
    [carBtn addSubview:carNumLb];
    
    //立即预订按钮
    UIButton *reserveBtn = [MyControl createButtonWithFrame:CGRectMake(CGRectGetMaxX(addCarBtn.frame), 0, (kScreenWidth - CGRectGetMaxX(carBtn.frame) - 10) / 2, 50) target:self SEL:@selector(reserveBtnClick:) title:@""];
    reserveBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    reserveBtn.backgroundColor = RGB(253, 111, 74);
    if ([_DetailModel.inventory intValue] == -1) {
        [reserveBtn setTitle:@"选择租赁机" forState:UIControlStateNormal];
    } else if ([_DetailModel.inventory intValue] == 0){
        [reserveBtn setTitle:@"立即预订" forState:UIControlStateNormal];
        //reserveBtn.enabled = NO;
        reserveBtn.backgroundColor = kMidgray;
        [addCarBtn setTitle:@"更换租赁机" forState:UIControlStateNormal];
    }
    else {
        [reserveBtn setTitle:@"立即预订" forState:UIControlStateNormal];
//        reserveBtn.enabled = NO;
//        reserveBtn.backgroundColor = kMidgray;
//        [addCarBtn setTitle:@"更换租赁机" forState:UIControlStateNormal];
    }
    _reserveBtn = reserveBtn;
    
    [shopView addSubview:reserveBtn];
    
    
}

#pragma mark 收藏按钮点击事件
- (void)scBtnClick:(UITapGestureRecognizer *)tap{
    
    UIImageView *iv = (UIImageView *)tap.view;
    if (!isFav) {
        iv.image = imageNamed(@"shoucang_00029");
        iv.animationDuration = 3;
        iv.animationRepeatCount = 1;
        [iv startAnimating];
        isFav = YES;
        [self addFav];
    } else {
        iv.image = imageNamed(@"shoucang_00001");
        isFav = NO;
        [self delFav];
    }
    
}

#pragma mark 添加收藏
- (void)addFav{
    //AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *dic = @{
                          @"_memberId":[User objectForKey:kMemberId],
                          @"_accessToken":[User objectForKey:kAccessToken],
                          @"titleId":self.titleId
                          };
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [NetWork getRequest:[NSString stringWithFormat:@"http://%@%@",app.host_ip, AddFav_URL] params:dic success:^(id responseObj) {
        if (![responseObj[@"ret"] boolValue]) {
            JGProgressHUD *hud = [[JGProgressHUD alloc]initWithStyle:JGProgressHUDStyleDark];
            hud.indicatorView = nil;
            hud.textLabel.text = @"收藏成功";
            hud.textLabel.font = [UIFont systemFontOfSize:12.0f];
            hud.position = JGProgressHUDPositionBottomCenter;
            [hud showInView:self.view];
            [hud dismissAfterDelay:2];
            _DetailModel.fav = responseObj[@"favId"];
        } else {
            JGProgressHUD *hud = [[JGProgressHUD alloc]initWithStyle:JGProgressHUDStyleDark];
            hud.indicatorView = nil;
            hud.textLabel.text = @"收藏失败";
            hud.textLabel.font = [UIFont systemFontOfSize:12.0f];
            hud.position = JGProgressHUDPositionBottomCenter;
            [hud showInView:self.view];
            [hud dismissAfterDelay:2];
        }
    } failure:^(NSError *error) {
        JGProgressHUD *hud = [[JGProgressHUD alloc]initWithStyle:JGProgressHUDStyleDark];
        hud.indicatorView = nil;
        hud.textLabel.text = @"请求失败";
        hud.textLabel.font = [UIFont systemFontOfSize:12.0f];
        hud.position = JGProgressHUDPositionBottomCenter;
        [hud showInView:self.view];
        [hud dismissAfterDelay:2];
    }];
}

#pragma mark 删除收藏
- (void)delFav{
    NSLog(@"%@", NSStringFromClass([_DetailModel.fav class]));
    NSDictionary *dic = @{
                          @"_memberId":[User objectForKey:kMemberId],
                          @"_accessToken":[User objectForKey:kAccessToken],
                          @"favId":_DetailModel.fav
                          };
    
   // NSStringFromClass([_DetailModel class])
    MovieDetailController *__weak weakSelf = self;
    // AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [NetWork getRequest:[NSString stringWithFormat:@"http://%@%@",app.host_ip,DelFav_URL] params:dic success:^(id responseObj) {
        NSLog(@"%@",responseObj);
        NSLog(@"%@",_DetailModel.fav);
        if (![responseObj[@"ret"] boolValue]) {
            JGProgressHUD *hud = [[JGProgressHUD alloc]initWithStyle:JGProgressHUDStyleDark];
            hud.indicatorView = nil;
            hud.textLabel.text = @"取消收藏成功";
            hud.textLabel.font = [UIFont systemFontOfSize:12.0f];
            hud.position = JGProgressHUDPositionBottomCenter;
            [hud showInView:weakSelf.view];
            [hud dismissAfterDelay:2];
        }
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"delSelectRow" object:responseObj[@"ret"]];
    } failure:^(NSError *error) {
        //
    }];
}

#pragma mark 购物车按钮点击事件
- (void)carBtnClick{
    //跳转到购物车页面
    ShopCartController *vc = [[ShopCartController alloc]init];
    [self configLeftBarWhite];
    //
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 加入购物车按钮点击事件
- (void)addCarBtnClick:(UIButton *)btn{
    if ([btn.titleLabel.text isEqualToString:@"更换租赁机"]) {
        //跳转到租赁机选择
        [self configLeftBarWhite];
        MapViewController *vc = [[MapViewController alloc]init];
        //
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    
   // AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    /*
     * 参数：
     ** titleId          碟片ID
     ** _memberId        用户ID
     ** _accessToken     用户accessToken
     */
    NSDictionary *dic = @{
                          @"titleId":self.titleId,
                          @"_memberId":[User objectForKey:kMemberId],
                          @"_accessToken":[User objectForKey:kAccessToken]
                          };
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [NetWork getRequest:[NSString stringWithFormat:@"http://%@%@",app.host_ip,AddCart_URL] params:dic success:^(id responseObj) {
        if (![responseObj[@"ret"] boolValue]) {
            JGProgressHUD *hud = [[JGProgressHUD alloc]initWithStyle:JGProgressHUDStyleDark];
            hud.indicatorView = [[JGProgressHUDSuccessIndicatorView alloc]init];
            hud.textLabel.text = @"添加购物车成功";
            hud.textLabel.font = [UIFont systemFontOfSize:10.0f];
            [hud showInView:self.view];
            [hud dismissAfterDelay:1.0f animated:YES];
            _carNumLb.text = [NSString stringWithFormat:@"%d",[_carNumLb.text intValue] + 1];
            [_addCarBtn setTitle:@"已加入购物车" forState:UIControlStateNormal];
        } else {
            JGProgressHUD *hud = [[JGProgressHUD alloc]initWithStyle:JGProgressHUDStyleDark];
            hud.indicatorView = [[JGProgressHUDErrorIndicatorView alloc]init];
            hud.textLabel.text = @"购物车中已存在";
            hud.textLabel.font = [UIFont systemFontOfSize:10.0f];
            [hud showInView:self.view];
            [hud dismissAfterDelay:1.0f animated:YES];
            
        }
    } failure:^(NSError *error) {
        //
    }];
}

#pragma mark 立即预订按钮点击事件
- (void)reserveBtnClick:(UIButton *)btn{
    if ([btn.titleLabel.text isEqualToString:@"立即预订"]){
        if ([_DetailModel.inventory intValue] == 0) {
            JGProgressHUD *hud = [[JGProgressHUD alloc]init];
            hud.textLabel.text = @"请更换租赁机后进行预订";
            hud.textLabel.font = [UIFont systemFontOfSize:14.0];
            [hud showInView:self.view];
            [hud dismissAfterDelay:1.0];
            return;
        }
        
        //预订.
        [self configLeftBar];
        PayViewController *vc = [[PayViewController alloc]init];
        vc.titleId = @[self.titleId];
        //
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        //跳转到租赁机选择
        [self configLeftBarWhite];
        MapViewController *vc = [[MapViewController alloc]init];
        //
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark 创建UITableView
- (void)createTB
{
    _tb = [[UITableView alloc]initWithFrame:CGRectMake(0, 64.0, kScreenWidth, kScreenHeight - 50.0 - 64.0) style:UITableViewStylePlain];
    _tb.backgroundColor = [UIColor clearColor];
    //_tb.contentInset = UIEdgeInsetsMake(CGRectGetMaxY(_sperBtn.frame), 0, 0, 0);
    
    UIView *tableHead = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, CGRectGetMaxY(_sperBtn.frame) - 64.0)];
    tableHead.backgroundColor = [UIColor clearColor];
    _headView.y = 10;
    [tableHead addSubview:_headView];
    _movieDetailView.y = CGRectGetMaxY(_headView.frame) + 10;
    [tableHead addSubview:_movieDetailView];
    _sperBtn.y = CGRectGetMaxY(_movieDetailView.frame);
    [tableHead addSubview:_sperBtn];
    _tableHead = tableHead;
    _tb.tableHeaderView = tableHead;
    
    [_tb registerNib:[UINib nibWithNibName:@"MovieDetailTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MDCell"];
    _tb.delegate = self;
    _tb.dataSource = self;
    _tb.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    [self.view addSubview:_tb];
    
    MovieDetailController *__weak weakSelf = self;
    _head = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        [_dataArr removeAllObjects];
        [weakSelf loadCommitData];
    }];
    _head.lastUpdatedTimeLabel.hidden = YES;
    _foot = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _page++;
        [weakSelf loadCommitData];
    }];
    _tb.mj_header = _head;
    _tb.mj_footer = _foot;
    //_tb.backgroundColor = kRed;
    //创建底部购物车
    [self createBottomView];
    //获取购物车数量
    [self getCartNum];
}

#pragma mark - UITableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MovieDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MDCell" forIndexPath:indexPath];
    [cell configWithModel:_dataArr[indexPath.row]];
    return cell;
}

- (void)sprBtnClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    CGFloat height = _movieDetailLb.height + 25 - 55;
    if (btn.selected) {
        //展开headView
        //[UIView animateWithDuration:0.25 animations:^{
            _movieDetailView.height += height;
            _sperBtn.y += height;
            _tableHead.height += height;
            _tb.tableHeaderView = _tableHead;
        //}];
    }
    else
    {
        //收起headView
        //[UIView animateWithDuration:0.25 animations:^{
            _movieDetailView.height -= height;
            _sperBtn.y -= height;
            _tableHead.height -= height;
            _tb.tableHeaderView = _tableHead;
        //}];
    }
    [_tb reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
