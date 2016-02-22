//
//  FavController.m
//  Unibox_iOS
//
//  Created by 刘羽 on 15/10/27.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import "FavController.h"
#import "Header.h"
#import "UIImage+Color.h"
#import "FavModel.h"
#import "FavTableViewCell.h"
#import "API.h"
#import "UIImageView+WebCache.h"
#import "MovieDetailController.h"
#import "AppDelegate.h"
@interface FavController ()<UITableViewDataSource, UITableViewDelegate>
{
    //数据源
    NSMutableArray *_dataArr;
    //需要删除的数据
    NSMutableArray *_deleArr;
    //tableView;
    UITableView *_tb;
    //编辑状态下弹出的view
    UIView *_bottomView;
    //删除按钮
    UIButton *_deleBtn;
    //记录删除数
    NSInteger numOfDel;
}
@end

@implementation FavController

- (void)viewWillAppear:(BOOL)animated
{
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:kWhite_Main] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的收藏";
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.view.backgroundColor = [UIColor whiteColor];
    //初始化删除数组
    _deleArr = [NSMutableArray array];
    //初始化数据源
    _dataArr = [NSMutableArray array];

    
    //添加导航栏右侧编辑按钮
    //[self addNavRightBar];
    
    //创建UITableView
    _tb = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kStatus_Height - kNav_Height) style:UITableViewStylePlain];
    _tb.delegate = self;
    _tb.dataSource = self;
    _tb.separatorStyle = UITableViewCellSeparatorStyleNone;
    //[_tb registerClass:[FavTableViewCell class] forCellReuseIdentifier:@"FavCell"];
    [_tb registerClass:[FavTableViewCell class] forCellReuseIdentifier:@"FavCell"];
    
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 86.0f)];
    UILabel *label = [MyControl createLabelWithFrame:CGRectMake(0, (86 - 14)/2.0, kScreenWidth, 14.0f) Font:14.0f Text:@"暂无更多..."];
    label.textAlignment = NSTextAlignmentCenter;
    [footView addSubview:label];
    _tb.tableFooterView = footView;
    [self.view addSubview:_tb];
    
    //创建点击编辑弹出的View
    [self createBottomView];
    
    //加载数据
    [self loadData];
}

- (void)loadData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //获取收藏列表
    /*
     * 控制器：Fav
     * 方法：  getUserFav
     * 参数：  ** _memberId        用户ID
     *        * _accessToken     用户accessToken
     * 返回：
     {
     ret : 0:成功； 1：失败
     fav : [
     {
     favId : 收藏唯一ID，
     titleId : 碟片ID
     note : 备注，
     movieName : 影片名
     movieImg : 影片图片
     synopsis : 摘要
     }
*/
    JGProgressHUD *hud = [[JGProgressHUD alloc]initWithStyle:JGProgressHUDStyleDark];
   // hud.progressIndicatorView =
    [hud showInView:self.view];
    [_dataArr removeAllObjects];
    [_deleArr removeAllObjects];
    
    
    NSDictionary *dic = @{
                          @"_memberId":[NSUSER objectForKey:kMemberId],
                          @"_accessToken":[NSUSER objectForKey:kAccessToken]
                          };
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [manager GET:[NSString stringWithFormat:@"http://%@%@",app.host_ip, GetFavList_URL] parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if (![[responseObject objectForKey:@"ret"]intValue]) {
            for (NSDictionary *d in [responseObject objectForKey:@"list"]) {
                FavModel *model = [[FavModel alloc]init];
                [model setValuesForKeysWithDictionary:d];
                [_dataArr addObject:model];
            }
            [_tb reloadData];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请先登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [hud dismiss];
            return;
        }
        [hud dismiss];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark UITableView代理
/*
 行数
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

/*
 行高
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 93.0f;
}

/*
 编辑状态
 */
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleInsert|UITableViewCellEditingStyleDelete;
}

/*
 UITableViewCell
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FavTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FavCell" forIndexPath:indexPath];
    FavModel *model = _dataArr[indexPath.row];
    cell.iv.image = imageNamed(model.movieImg);
    [cell.iv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_IP, model.movieImg]] placeholderImage:imageNamed(@"placeholder")];
    cell.titleLb.text = model.movieName;
    cell.detailLb.text = model.synopsis;
    
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    return cell;
}


/*
 cell点击事件
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.editing) {
        //将删除数据添加到删除数组中
        numOfDel++;
        [_deleBtn setTitle:[NSString stringWithFormat:@"删除 (%ld)",numOfDel] forState:UIControlStateNormal];
        [_deleBtn setBackgroundColor:[UIColor redColor]];
        
        [_deleArr addObject:_dataArr[indexPath.row]];
    }
    else
    {
        //跳转到详情
        MovieDetailController *vc = [[MovieDetailController alloc]init];
        //vc.titleId = [_dataArr[indexPath.row] titleId];
        [self presentViewController:vc animated:YES completion:nil];
    }
}

/*
 cell反选
 */
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.editing) {
        //将反选数据从删除数组中删除
        
        numOfDel--;
        if (numOfDel == 0)
        {
            [_deleBtn setTitle:@"删除" forState:UIControlStateNormal];
            [_deleBtn setBackgroundColor:kGray];
        }
        else{
            [_deleBtn setTitle:[NSString stringWithFormat:@"删除 (%ld)",numOfDel] forState:UIControlStateNormal];
        }
        
        [_deleArr removeObject:_dataArr[indexPath.row]];
        NSLog(@"%ld",_deleArr.count);
    }
}
#pragma mark 添加导航栏右侧编辑按钮
- (void)addNavRightBar
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarClick:)];
}

#pragma mark 导航栏右按钮点击事件
- (void)rightBarClick:(UIBarButtonItem *)item
{
    _tb.editing = !_tb.editing;
    if (_tb.editing) {
        numOfDel = 0;
        [item setTitle:@"取消"];
        [UIView animateWithDuration:0.2f animations:^{
            _bottomView.y = kScreenHeight - kStatus_Height - kNav_Height - 50;
        }];
    }
    else
    {
        [_deleArr removeAllObjects];
        [_deleBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_deleBtn setBackgroundColor:kGray];
        [item setTitle:@"编辑"];
        [UIView animateWithDuration:0.2f animations:^{
            _bottomView.y = kScreenHeight - kStatus_Height - kNav_Height;
        }];
    }
}

#pragma mark 点击编辑按钮弹出的View
- (void)createBottomView
{
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - kStatus_Height - kNav_Height, kScreenWidth, 50)];
    bottomView.backgroundColor = kBlack;
    _bottomView = bottomView;
    [self.view addSubview:bottomView];
    
    //全选按钮
    UIButton *selectAllBtn = [MyControl createButtonWithFrame:CGRectMake(10, 10, (kScreenWidth - 60)/2, 30) target:self SEL:@selector(selectBtnClick) title:@"全选"];
    selectAllBtn.layer.cornerRadius = 5.0f;
    [selectAllBtn setBackgroundColor:kBlue];
    [bottomView addSubview:selectAllBtn];
    
    //删除按钮
    UIButton *deleBtn = [MyControl createButtonWithFrame:CGRectMake(CGRectGetMaxX(selectAllBtn.frame) + 40, selectAllBtn.y, selectAllBtn.width, selectAllBtn.height) target:self SEL:@selector(deleBtnClick) title:@"删除"];
    _deleBtn = deleBtn;
    deleBtn.layer.cornerRadius = 5.0f;
    [deleBtn setBackgroundColor:kGray];
    [bottomView addSubview:deleBtn];
}


#pragma mark 全选按钮点击事件
- (void)selectBtnClick
{
    [_deleArr removeAllObjects];
    [_deleArr addObjectsFromArray:_dataArr];
    for (int i = 0; i < _dataArr.count; i++) {
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i inSection:0];
        [_tb selectRowAtIndexPath:indexpath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    [_deleBtn setTitle:[NSString stringWithFormat:@"删除 (%ld)", _dataArr.count] forState:UIControlStateNormal];
    numOfDel = _dataArr.count;
    [_deleBtn setBackgroundColor:[UIColor redColor]];
}

#pragma mark 删除按钮点击事件
- (void)deleBtnClick
{
    _tb.editing = NO;
    
    
    [self.navigationItem.rightBarButtonItem setTitle:@"编辑"];
    [UIView animateWithDuration:0.2f animations:^{
        _bottomView.y = kScreenHeight - kStatus_Height - kNav_Height;
    } completion:^(BOOL finished) {
        [_deleBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_deleBtn setBackgroundColor:kGray];
    }];

    
    //删除收藏 刷新tableview
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    /*
     *
     * 控制器：Fav
     * 方法：  deleteUserFav
     * 参数：
     ** favId            收藏唯一ID, 多个用逗号隔开
     ** _memberId        用户ID
     ** _accessToken     用户accessToken
     */
    NSMutableArray *favId = [NSMutableArray array];
    for (FavModel *model in _deleArr) {
        [favId addObject:model.favId];
    }
    NSString *delFavId = [favId componentsJoinedByString:@","];
    NSDictionary *dic = @{
                          @"favId":delFavId,
                          @"_memberId":[NSUSER objectForKey:kMemberId],
                          @"_accessToken":[NSUSER objectForKey:kAccessToken]
                          };
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [manager GET:[NSString stringWithFormat:@"http://%@%@",app.host_ip, DelFav_URL] parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (![[responseObject objectForKey:@"ret"]intValue]) {
            [self loadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
