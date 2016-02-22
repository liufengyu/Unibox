//
//  CartController.m
//  Unibox_iOS
//
//  Created by 刘羽 on 15/11/2.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import "CartController.h"
#import "Header.h"
#import "API.h"
#import "UIImage+Color.h"

@interface CartController () <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
{
    //tableview
    UITableView *_tb;
    //tableview数据源
    NSMutableArray *_dataArr;
    //记录选中的订单状态按钮
    UIButton *_selectBtn;
}
@end

@implementation CartController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:kWhite_Main] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"订单列表";
    self.view.backgroundColor = kWhite_Main;
    //初始化数据源
    _dataArr = [NSMutableArray array];
    //创建订单状态按钮
    [self createStatusBtn];
    //加载数据
    //[self loadData];
    //创建tableView
    [self createTB];
}


#pragma mark 加载数据
- (void)loadData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    /*
     * 参数：
     ** _memberId        用户ID
     ** _accessToken     用户accessToken
     */
    
    NSDictionary *dic = @{
                          @"_memberId":[NSUSER objectForKey:kMemberId],
                          @"_accessToken":[NSUSER objectForKey:kAccessToken]
                          };
    [manager GET:[NSString stringWithFormat:@"http://%@%@",Host_IP, GetUserCart_URL] parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if (![[responseObject objectForKey:@"ret"]intValue]) {
            for (NSDictionary *d in [responseObject objectForKey:@"list"]) {
                
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


#pragma mark 创建订单状态按钮
- (void)createStatusBtn
{
    UIView *view         = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40.0)];
    view.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    CGFloat width        = 70.0f;
    CGFloat height       = 40.0f;
    CGFloat gapWidth     = (kScreenWidth - width * 3 - 20)/2;
    NSArray *titleArr    = @[@"全部",@"已付款",@"待付款"];
    for (int i = 0; i < 3; i++) {
        UIButton *btn = [MyControl createButtonWithFrame:CGRectMake(10 + (width + gapWidth) * i, 0, width, height) target:self SEL:@selector(statusBtnClick:) title:titleArr[i]];
        [btn setTitleColor:kWhite_Main forState:UIControlStateSelected];
        [btn setTitleColor:kBlack forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        //btn setBackgroundColor:<#(UIColor * _Nullable)#>
        [view addSubview:btn];
        if (i == 0) {
            btn.selected        = YES;
            btn.backgroundColor = kBlue;
            _selectBtn = btn;
        }
    }
    [self.view addSubview:view];

}


#pragma mark 创建tableView
- (void)createTB
{
    _tb = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, kScreenWidth, kScreenHeight - kStatus_Height - kNav_Height) style:UITableViewStylePlain];
    _tb.backgroundColor = [UIColor clearColor];
    _tb.delegate        = self;
    _tb.dataSource      = self;
    [self.view addSubview:_tb];
}

#pragma mark - uitableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"cartCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    return cell;
}

#pragma mark 订单状态按钮点击事件
- (void)statusBtnClick:(UIButton *)btn
{
    btn.selected = YES;
    _selectBtn.selected        = NO;
    _selectBtn.backgroundColor = [UIColor whiteColor];
    _selectBtn                 = btn;
    btn.backgroundColor = kBlue;
    
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
