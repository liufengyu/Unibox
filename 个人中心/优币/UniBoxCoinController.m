//
//  UniBoxCoinController.m
//  Unibox_iOS
//
//  Created by 刘羽 on 16/1/22.
//  Copyright © 2016年 刘羽. All rights reserved.
//

#import "UniBoxCoinController.h"
#import "Masonry.h"
#import "Header.h"
#import "API.h"
#import "CoinTableViewCell.h"
#import "NetWork.h"
#import "AppDelegate.h"
#import "CoinModel.h"
#import "CoinUsehelpController.h"

@interface UniBoxCoinController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tb;
    NSMutableArray *_dataArr;
    NSString *_point;
}
@end

@implementation UniBoxCoinController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"优币";
    _dataArr = [NSMutableArray new];
    
    self.view.backgroundColor = kLightgray;
    UIView *naviBar = [UIView new];
    naviBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:naviBar];
    UniBoxCoinController *__weak ws = self;
    [naviBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.right.left.equalTo(ws.view);
        make.height.equalTo(@64);
    }];
    
    //加载数据
    [self loadData];
}

#pragma mark 加载数据
- (void)loadData{
    JGProgressHUD *hud = [[JGProgressHUD alloc]initWithStyle:JGProgressHUDStyleDark];
    [hud showInView:self.view];
    
    NSDictionary *dic = @{
                          @"_memberId":[User objectForKey:kMemberId],
                          @"_accessToken":[User objectForKey:kAccessToken]
                          };
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [NetWork getRequest:[NSString stringWithFormat:@"http://%@%@",app.host_ip,getPointList] params:dic success:^(id responseObj) {
        if (![responseObj[@"ret"]boolValue]) {
            [hud dismiss];
            _point = responseObj[@"point"];
            //NSLog(@"%@",responseObj);
            for (NSDictionary *d in responseObj[@"list"]) {
                CoinModel *model = [[CoinModel alloc]init];
                [model setValuesForKeysWithDictionary:d];
                if (![model.amount containsString:@"-"]) {
                    model.amount = [NSString stringWithFormat:@"+%@",model.amount];
                }
                [_dataArr addObject:model];
            }
            //加载完成后创建UI
            [self setup];
        } else {
            [hud dismiss];
            JGProgressHUD *hud1 = [[JGProgressHUD alloc]initWithStyle:JGProgressHUDStyleDark];
            hud1.indicatorView = nil;
            hud1.textLabel.text = @"服务器维护中";
            [hud1 showInView:self.view];
            [hud1 dismissAfterDelay:2.0 animated:YES];
        }
    } failure:^(NSError *error) {
        [hud dismiss];
        JGProgressHUD *hud1 = [[JGProgressHUD alloc]initWithStyle:JGProgressHUDStyleDark];
        hud1.indicatorView = nil;
        hud1.textLabel.text = @"服务器维护中";
        [hud1 showInView:self.view];
        [hud1 dismissAfterDelay:2.0 animated:YES];
    }];
    
    
    
}

#pragma mark 创建UI
- (void)setup{
    UITableView *tb = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    [self.view addSubview:tb];
    tb.backgroundColor = [UIColor clearColor];
    _tb = tb;
    UniBoxCoinController *__weak ws = self;
    [tb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.view).offset(65);
        make.right.and.left.and.bottom.equalTo(ws.view);
    }];
    tb.delegate = self;
    tb.dataSource = self;
    tb.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [tb registerNib:[UINib nibWithNibName:@"CoinTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CoinCell"];
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 165.0)];
    headView.backgroundColor = kWhite_Main;
    tb.tableHeaderView = headView;
    
    UIButton *useHelpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [headView addSubview:useHelpButton];
    [useHelpButton setTitle:@"使用帮助" forState:UIControlStateNormal];
    useHelpButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [useHelpButton setTitleColor:kOrange forState:UIControlStateNormal];
    [useHelpButton addTarget:self action:@selector(useHelp) forControlEvents:UIControlEventTouchUpInside];
    
    
    [useHelpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView);
        make.right.equalTo(headView);
        make.height.equalTo(@50);
        make.width.equalTo(@70);
    }];
    
    UILabel *coinNumLabel = [UILabel new];
    coinNumLabel.font = [UIFont systemFontOfSize:28.0];
    coinNumLabel.textColor = kGreen;
    coinNumLabel.text = [NSString stringWithFormat:@"%@个",_point];//@"100个";
    [headView addSubview:coinNumLabel];
    
    [coinNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(headView);
    }];
    
    UILabel *itemizedLabel = [UILabel new];
    itemizedLabel.text = _dataArr.count ? @"收支明细":@"暂无收支明细";//@"收支明细";
    itemizedLabel.font = [UIFont systemFontOfSize:13.0];
    [headView addSubview:itemizedLabel];
    
    [itemizedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView).offset(10);
        make.bottom.equalTo(headView).offset(-10);
    }];
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 60.0)];
    tb.tableFooterView = footView;
    //footView.backgroundColor = [UIColor cl];
    
    UIButton *telButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [footView addSubview:telButton];
    telButton.backgroundColor = kWhite_Main;
    telButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:@"如有疑问,请致电400-880-951"];
    [str addAttributes:@{NSForegroundColorAttributeName:kOrange} range:NSMakeRange(8, str.length - 8)];
    [telButton setAttributedTitle:str forState:UIControlStateNormal];
    [telButton addTarget:self action:@selector(tel) forControlEvents:UIControlEventTouchUpInside];
    [telButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.and.left.equalTo(footView);
        make.top.equalTo(footView).offset(10);
        make.bottom.equalTo(footView);
    }];
}

#pragma mark - UITableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CoinTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CoinCell" forIndexPath:indexPath];
    cell.backgroundColor = kWhite_Main;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [(CoinTableViewCell *)cell configUI:_dataArr[indexPath.row]];
}

#pragma mark 使用帮助
- (void)useHelp{
    //跳转到使用帮助页面
    [self configLeftBar];
    CoinUsehelpController *vc = [[CoinUsehelpController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 拨打电话
- (void)tel{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:@"是否拨打电话" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ac1 = [UIAlertAction actionWithTitle:@"确定"
                                                 style:UIAlertActionStyleDestructive
                                               handler:^(UIAlertAction * _Nonnull action) {
                                                   if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://400880951"]]){
                                                       [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://400880951"]];
                                                   } else {
                                                       UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"当前设备不支持" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                                       [alertView show];
                                                   }
                                                   
                                               }];
    [alert addAction:ac1];
    UIAlertAction *ac2 = [UIAlertAction actionWithTitle:@"取消"
                                                  style:UIAlertActionStyleCancel
                                                handler:nil];
    [alert addAction:ac2];
    
    [self presentViewController:alert animated:YES completion:nil];
    
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
