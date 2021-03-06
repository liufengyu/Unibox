//
//  MemberTequanController.m
//  Unibox_iOS
//
//  Created by 刘羽 on 15/12/6.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import "MemberTequanController.h"
#import "Header.h"
#import "MemberTableViewCell.h"
#import "UIImage+Color.h"

@interface MemberTequanController () <UITableViewDataSource, UITableViewDelegate>
{
    //NSArray *_dataArray;
}
@end

@implementation MemberTequanController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //self.edgesForExtendedLayout = UIRectEdgeAll;
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"会员特权";
    
    
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    //[self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor clearColor]]];
    self.view.backgroundColor = kWhite_Main;
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    //[self configLeftBar];
    
//    _dataArray = @[
//                @{@"img":@"mem-putong",@"title":@"普通会员",@"detail":@"免费租DVD 0张 + 免租期0天"},
//                @{@"img":@"mem-yinka",@"title":@"银卡会员",@"detail":@"免费租DVD 1张 + 免租期1天"},
//                @{@"img":@"mem-jinka",@"title":@"金卡会员",@"detail":@"免费租DVD 2张 + 免租期1天"},
//                @{@"img":@"mem-zuanshi",@"title":@"钻石会员",@"detail":@"免费租DVD 3张/蓝光 1张 + 免租期2天"}
//                ];
    
    [self createUI];
}

- (void)createUI{
    //当前等级
    UILabel *levelLb = [MyControl createLabelWithFrame:CGRectMake(10, 64, 200, 35) Font:14.f Text:nil];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"您当前为%@",self.rankTitle] attributes:@{NSForegroundColorAttributeName:RGB(102, 102, 102)}];
    [str addAttributes:@{NSForegroundColorAttributeName:kRed} range:NSMakeRange(4,4)];
    levelLb.attributedText = str;
    
    [self.view addSubview:levelLb];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(levelLb.frame), kScreenWidth - 20, 270)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.borderColor = RGB(194, 194, 194).CGColor;
    bgView.layer.borderWidth = 1.0f;
    [self.view addSubview:bgView];
    
    //tableView
    UITableView *tb = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth - 20, bgView.height) style:UITableViewStylePlain];
    tb.backgroundColor = [UIColor clearColor];
    tb.separatorStyle = UITableViewCellSeparatorStyleNone;
    tb.delegate = self;
    tb.dataSource = self;
    tb.scrollEnabled = NO;
    [tb registerNib:[UINib nibWithNibName:@"MemberTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MTCell"];
    [bgView addSubview:tb];
    
    //注意事项
    UILabel *lb = [MyControl createLabelWithFrame:CGRectMake(30, CGRectGetMaxY(bgView.frame) + 15, bgView.width - 30, 50) Font:10.0f Text:@"免租期是指再会员有效期内，每次免费租碟时间，超过时间未归还碟片则收取租金。亲，记得及时换碟哦^_^"];
    [lb sizeToFit];
    [self.view addSubview:lb];
    
    UIImageView *iv = [MyControl createImageViewFrame:CGRectMake(10, lb.y + (lb.height - 17) / 2, 17.0, 17.0) imageName:@"mem-tishi"];
    [self.view addSubview:iv];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _rankArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 67.5f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MemberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MTCell"];
    [cell configUI:_rankArr[indexPath.row]];
    if (kScreenWidth < 375.0){
        cell.lb1.font = [UIFont systemFontOfSize:11.0f];
        cell.lb2.font = [UIFont systemFontOfSize:11.0f];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
