//
//  EditInfoController.m
//  Unibox_iOS
//
//  Created by 刘羽 on 15/10/27.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import "EditInfoController.h"
#import "Header.h"
#import "UIImage+Color.h"
#import "EditTableViewCell.h"
//#import "UIView+TYAutoLayout.h"
#import "TYAlertController.h"
#import "AppDelegate.h"
#import "API.h"
#import "UserInfoModel.h"
#import "UpdateMemberInfo.h"
#import "IntersetModel.h"
#import "UIImageView+WebCache.h"
#import "ModifyPSDController.h"
#import "ModifyNameViewController.h"
#import "ModifyEmailViewController.h"
#import "NetWork.h"
//#import "AFNetworking.h"

@interface EditInfoController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIPickerViewDataSource,UIPickerViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UITableView *_tb;
    //tableview数据源
    NSArray *_dataArr;
    //pickerview数据源
    NSMutableArray *_pickDataArr;
    //pickView所在view
    UIView *_pickView;
    UIPickerView *_pickerView;
    //日期选择控件
    UIDatePicker *_datePicker;
    //MyDatePicker *_datePicker;
    //省市区字典
    NSDictionary *_areaDic;
    //省
    NSArray *_province;
    //市
    NSArray *_city;
    //区
    NSArray *_district;
    //地区选择器
    UIPickerView *_areaPickerView;
    //记录选中省份
    NSString *_selectedProvince;
    //兴趣选择视图
    UIView *_interestView;
    //兴趣数组
    NSMutableArray *_interestArr;
    //保存选中兴趣
    NSMutableArray *_addIntersetArr;
    //alert
    TYAlertController *_alertController;
    //头像视图
    UIImageView *_touxiangView;
    //用户信息
    UserInfoModel *_model;
}
@end

@implementation EditInfoController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"编辑资料";
    //self.edgesForExtendedLayout = UIRectEdgeAll;
    _model = [[UserInfoModel alloc]init];
    self.view.backgroundColor = kWhite_Main;
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    [self configLeftBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modifyNickname:) name:@"modifyNickname" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modifyEamil:) name:@"modifyEamil" object:nil];
    //初始化数据源
    _pickDataArr = [NSMutableArray array];
    _addIntersetArr = [NSMutableArray array];
    //_interestArr = [NSMutableArray arrayWithArray:@[@[@"纪录",@"动作",@"武侠",@"科幻",@"爱情",@"冒险"],@[@"喜剧",@"惊悚",@"恐怖",@"动画",@"犯罪",@"悬疑"],@[@"剧情",@"运动",@"战争",@"奇幻",@"歌舞",@"恶搞"]]];
    _interestArr = [NSMutableArray array];
    _dataArr = @[@[@{@"title":@"昵称:"},@{@"title":@"性别:"},@{@"title":@"绑定手机号:"}],@[@{@"title":@"生日:"},@{@"title":@"地区城市:"},@{@"title":@"兴趣:"}],@[/*@{@"title":@"第三方帐号绑定:",@"detail":@"QQ:123456789"},@{@"title":@"电子邮箱:"},*/@{@"title":@"修改密码"}]];
    
    //创建UITableView
    [self createTB];
    //底部退出登录按钮
    [self createBottomBtn];
    
    //创建UIPickerView
    [self createPickerView];
    
    //创建日期选择器
    [self createDatePicker];
    
    //创建地区选择器
    [self createAreaPicker];
    
    //获取用户信息和兴趣列表
    [self loadData];
    
    //创建兴趣爱好选择视图
    
}

- (void)modifyNickname:(NSNotification *)noti{
    NSLog(@"%@",noti.object);
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    EditTableViewCell *cell = [_tb cellForRowAtIndexPath:indexPath];
    if (![cell.detailLb.text isEqualToString:noti.object]) {
        cell.detailLb.text = noti.object;
        [UpdateMemberInfo updateType:@"nickName" with:noti.object success:^(id responseObject) {
            NSLog(@"%@",responseObject);
        } fail:^(NSError *error) {
            //
        }];
    }
}

- (void)modifyEamil:(NSNotification *)noti{
    NSLog(@"%@",noti.object);
}

#pragma mark - 获取数据
- (void)loadData{
    //获取用户信息
    //AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *dic = @{
                          @"_memberId":[User objectForKey:kMemberId],
                          @"_accessToken":[User objectForKey:kAccessToken]
                          };
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [NetWork getRequest:[NSString stringWithFormat:@"http://%@%@",app.host_ip,getMemberProfile] params:dic success:^(id responseObj) {
        if (![responseObj[@"ret"] boolValue]) {
            NSLog(@"获取成功");
            [_model setValuesForKeysWithDictionary:responseObj[@"info"]];
            //NSLog(@"%@",responseObject[@"info"]);
            
            for (NSDictionary *d in responseObj[@"interestConf"]) {
                IntersetModel *model = [[IntersetModel alloc]init];
                [model setValuesForKeysWithDictionary:d];
                [_interestArr addObject:model];
            }
            [self createInterestView];
            [_touxiangView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_IP,_model.picture]]];
            [_tb reloadData];
        }
    } failure:^(NSError *error) {
        //
    }];
//    [manager GET:[NSString stringWithFormat:@"http://%@%@",app.host_ip,getMemberProfile] parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        //
//        if (![responseObject[@"ret"] boolValue]) {
//            NSLog(@"获取成功");
//            [_model setValuesForKeysWithDictionary:responseObject[@"info"]];
//            //NSLog(@"%@",responseObject[@"info"]);
//            
//            for (NSDictionary *d in responseObject[@"interestConf"]) {
//                IntersetModel *model = [[IntersetModel alloc]init];
//                [model setValuesForKeysWithDictionary:d];
//                [_interestArr addObject:model];
//            }
//            [self createInterestView];
//            [_touxiangView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_IP,_model.picture]]];
//            [_tb reloadData];
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        //
//    }];
}

#pragma mark - 创建TB
- (void)createTB
{
    _tb = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 70.0 - 64.0) style:UITableViewStyleGrouped];
    _tb.delegate = self;
    _tb.dataSource = self;
    _tb.showsVerticalScrollIndicator = NO;
    _tb.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tb];
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 70)];
    headView.backgroundColor = [UIColor clearColor];
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, kScreenWidth, 60)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [headView addSubview:whiteView];
    

    UIImageView *touxiangView = [MyControl createImageViewFrame:CGRectMake(10, 10 + 10, 40, 40) imageName:@"img-man"];
    touxiangView.clipsToBounds = YES;
    touxiangView.layer.cornerRadius = 20.0f;
    _touxiangView = touxiangView;
    //判断本地是否保存有头像文件
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",[NSUSER objectForKey:kMemberId]]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        touxiangView.image = image;
    }
    [headView addSubview:touxiangView];
    
    UILabel *completeLb = [MyControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(touxiangView.frame) + 7.5, (60 - 15) / 2 + 10, 100, 15) Font:12.0f Text:@""];
    completeLb.textColor = RGB(120, 120, 120);
    [headView addSubview:completeLb];
    
//    UIButton *configTXBtn = [MyControl createButtonWithFrame:CGRectMake(kScreenWidth - 80, (60.0 - 16.0) /2 + 10, 80, 16) target:self SEL:@selector(configTouxiang) title:@"更换头像"];
//    configTXBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
//    [configTXBtn setTitleColor:kBlack forState:UIControlStateNormal];
//    
//    [headView addSubview:configTXBtn];
    
    _tb.tableHeaderView = headView;
    //_tb.scrollEnabled = NO;
    _tb.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tb registerNib:[UINib nibWithNibName:@"EditTableViewCell" bundle:nil] forCellReuseIdentifier:@"EditCell"];
}

#pragma mark - UITableView代理
/*段数*/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArr.count;
}

/*行数*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArr[section] count];
}

/*段头高*/
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == _dataArr.count - 1) {
        return 25.0;
    }
    return 1.0;
}

/*行高*/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

/*
 UITableViewCell
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    EditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditCell" forIndexPath:indexPath];
    cell.titleLb.text = [_dataArr[indexPath.section][indexPath.row] objectForKey:@"title"];
    cell.titleLb.textColor = kBlack;
    if (indexPath.section == 2 && indexPath.row == 0) {
        cell.detailLb.text = [_dataArr[indexPath.section][indexPath.row] objectForKey:@"detail"];
    }
    if (indexPath.section == 2 && indexPath.row == 2) {
        cell.detailLb.text = @"";
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.detailLb.text = _model.nickName;
        } else if (indexPath.row == 1){
            if ([_model.sex isEqualToString:@"1"]) {
                cell.detailLb.text = @"男";
            } else if ([_model.sex isEqualToString:@"2"]){
                cell.detailLb.text = @"女";
            } else {
                cell.detailLb.text = @"未填写";
            }
        } else if (indexPath.row == 2){
            cell.detailLb.text = _model.phone;
        }
    } else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            if ([_model.birthDate length]) {
                cell.detailLb.text = _model.birthDate;
            } else {
                cell.detailLb.text = @"未填写";
            }
        } else if (indexPath.row == 1){
            if ([_model.state length] && [_model.city length]) {
                cell.detailLb.text = [NSString stringWithFormat:@"%@/%@",_model.state,_model.city];
            } else {
                cell.detailLb.text = @"未填写";
            }
        } else if (indexPath.row == 2){
            if ([_model.interestStr length]) {
                cell.detailLb.text = _model.interestStr;
            } else {
                cell.detailLb.text = @"未填写";
            }
        }
    } else if (indexPath.section == 2){
//        if (indexPath.row == 1) {
//            if ([_model.email length]) {
//                cell.detailLb.text = _model.email;
//            } else {
//                cell.detailLb.text = @"未填写";
//            }
//        }
    }
    cell.detailLb.textColor = kBlack;
    cell.detailLb.tag = 3000 + indexPath.section * 2 + indexPath.row;
    return cell;
}

/*
 选中cell
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0 && indexPath.row == 1) {
        _pickDataArr = [NSMutableArray arrayWithArray:@[@[@"男",@"女"]]];
        [_pickerView reloadAllComponents];
        //弹出男女选择视图
        [self presentSexPick];
    } else if (indexPath.section == 0 && indexPath.row == 0){
        //跳转到昵称修改
        ModifyNameViewController *vc = [[ModifyNameViewController alloc]init];
        //
        vc.nickName = _model.nickName;
        [self configLeftBar];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.section == 1 && indexPath.row == 1){
        //弹出地区选择视图
        [self presentAreaPick];
    }else if (indexPath.section == 1 && indexPath.row == 0){
        //弹出时间选择视图
        [self presentDatePick];
    } else if (indexPath.section == 1 && indexPath.row == 2){
        //弹出兴趣选择视图
       [self presentIntersetPick];
    } else if (indexPath.section == 2 && indexPath.row == 0){
        //跳转到修改密码
        ModifyPSDController *vc = [[ModifyPSDController alloc]init];
        //
        [self configLeftBar];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.section == 2 && indexPath.row == 1){
//        //跳转到邮箱修改
//        ModifyEmailViewController *vc = [[ModifyEmailViewController alloc]init];
//        //
//        [self configLeftBar];
//        [self.navigationController pushViewController:vc animated:YES];
    }
  
}

#pragma mark 弹出男女选择视图
- (void)presentSexPick{
    _pickView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 120)];
    _pickView.backgroundColor = [UIColor whiteColor];
    //_pickView上的确定按钮
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    sureBtn.frame = CGRectMake(10, 0, 45, 30);
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:kBlue forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sexSureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_pickView addSubview:sureBtn];
    
    //_pickView上的取消按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelBtn.frame = CGRectMake(kScreenWidth - 45 - 10, 0, 45, 30);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:kBlue forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_pickView addSubview:cancelBtn];
    _pickerView.height = 90;
    
   // _pickerView.backgroundColor = [UIColor blackColor];
    [_pickView addSubview:_pickerView];
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:_pickView preferredStyle:TYAlertControllerStyleActionSheet];
    _alertController = alertController;
    alertController.backgoundTapDismissEnable = YES;
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark 弹出地区选择视图
- (void)presentAreaPick{
    _pickView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 200)];
    _pickView.backgroundColor = [UIColor whiteColor];
    //_pickView上的确定按钮
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    sureBtn.frame = CGRectMake(10, 0, 45, 30);
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:kBlue forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(areaSureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_pickView addSubview:sureBtn];
    
    //_pickView上的取消按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelBtn.frame = CGRectMake(kScreenWidth - 45 - 10, 0, 45, 30);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:kBlue forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_pickView addSubview:cancelBtn];
    
    [_pickView addSubview:_areaPickerView];
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:_pickView preferredStyle:TYAlertControllerStyleActionSheet];
    _alertController = alertController;
    alertController.backgoundTapDismissEnable = YES;
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark 弹出日期选择视图
- (void)presentDatePick{
    _pickView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 160)];
    _pickView.backgroundColor = [UIColor whiteColor];
    //_pickView上的确定按钮
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    sureBtn.frame = CGRectMake(10, 0, 45, 30);
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:kBlue forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(dateSureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_pickView addSubview:sureBtn];
    
    //_pickView上的取消按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelBtn.frame = CGRectMake(kScreenWidth - 45 - 10, 0, 45, 30);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:kBlue forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_pickView addSubview:cancelBtn];
    
    [_pickView addSubview:_datePicker];
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:_pickView preferredStyle:TYAlertControllerStyleActionSheet];
    _alertController = alertController;
    alertController.backgoundTapDismissEnable = YES;
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark 弹出兴趣选择视图
- (void)presentIntersetPick{
    _pickView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    _pickView.backgroundColor = [UIColor whiteColor];
    //_pickView上的确定按钮
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    sureBtn.frame = CGRectMake(10, 0, 45, 30);
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:kBlue forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(intersetBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_pickView addSubview:sureBtn];
    
    //_pickView上的取消按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelBtn.frame = CGRectMake(kScreenWidth - 45 - 10, 0, 45, 30);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:kBlue forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_pickView addSubview:cancelBtn];
    
    [_pickView addSubview:_interestView];
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:_pickView preferredStyle:TYAlertControllerStyleActionSheet];
    _alertController = alertController;
    alertController.backgoundTapDismissEnable = YES;
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark 更改头像按钮
- (void)configTouxiang
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"选择"
                                                                        message:@"选择选取图片的位置"
                                                                 preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *ac1 = [UIAlertAction actionWithTitle:@"从相册选取"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action) {
                                                        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
                                                        imagePicker.delegate = self;
                                                        imagePicker.allowsEditing = YES;
                                                        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                                        [self presentViewController:imagePicker animated:YES completion:nil];
                                                    }];
        [alertC addAction:ac1];
        
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            
            UIAlertAction *ac2 = [UIAlertAction
                                  actionWithTitle:@"拍照"
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction * _Nonnull action) {
                                      UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
                                      imagePicker.delegate = self;
                                      imagePicker.allowsEditing = YES;
                                      imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                      [self presentViewController:imagePicker animated:YES completion:nil];
                                  }];
            
            
            
            
            [alertC addAction:ac2];
            
            
        }
        UIAlertAction *ac3 = [UIAlertAction actionWithTitle:@"取消"
                                                      style:UIAlertActionStyleCancel
                                                    handler:nil];
        [alertC addAction:ac3];
        [self presentViewController:alertC animated:YES completion:nil];
        return;
    }
    
    
    //判断是否支持相机 打开相机设置头像保存到本地沙盒
    UIActionSheet *sheet;
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
        sheet.tag = 212;
    }
    else {
        
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
        sheet.tag = 213;
    }
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger sourceType = 0;
    if (actionSheet.tag == 212) {//支持相机
        if (buttonIndex == 0) {
            sourceType = UIImagePickerControllerSourceTypeCamera;
        }else if (buttonIndex == 1){
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }else{
            return;
        }
    }else{//不支持相机
        if (buttonIndex == 0) {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }else{
            return;
        }
    }
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = sourceType;
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}

#pragma mark - imagePicker代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //保存图片到沙盒
    [self saveImage:image];
    [_touxiangView setImage:image];
}

#pragma mark - 保存图片到沙盒
- (void)saveImage:(UIImage *)currentImage
{
    NSData *imageData = UIImagePNGRepresentation(currentImage);
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",[NSUSER objectForKey:kMemberId]]];
    [imageData writeToFile:fullPath atomically:YES];
}


#pragma mark 创建PickerView
- (void)createPickerView
{
    UIPickerView *pView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 30, kScreenWidth, 170)];
    _pickerView = pView;
    [pView setTintColor:kBlue];
    pView.delegate = self;
    pView.dataSource = self;
    
    _pickView.backgroundColor = [UIColor whiteColor];
}

#pragma mark _pickView上取消按钮
- (void)cancBtnClick{
    [_alertController dismissViewControllerAnimated:YES];
    [_addIntersetArr removeAllObjects];
}

#pragma mark 性别选择确定按钮
- (void)sexSureBtnClick{
    [_alertController dismissViewControllerAnimated:YES];
    NSInteger index = [_pickerView selectedRowInComponent:0];
    NSString *sex = nil;
    if (index == 0) {
        sex = @"男";
        _model.sex = @"1";
    } else {
        sex = @"女";
        _model.sex = @"2";
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    EditTableViewCell *cell = [_tb cellForRowAtIndexPath:indexPath];
    cell.detailLb.text = sex;
    //NSString *str = [UpdateMemberInfo updateWithSex:_model.sex];
    //NSLog(@"=========%@",str);
    //更新资料
    //[self updateInfo];
    [UpdateMemberInfo updateType:@"sex" with:_model.sex success:^(id responseObject) {
        NSLog(@"%@",responseObject);
    } fail:^(NSError *error) {
        //
    }];
}

#pragma mark 地区选择确定按钮
- (void)areaSureBtnClick{
    [_alertController dismissViewControllerAnimated:YES];
    NSInteger provinceIndex = [_areaPickerView selectedRowInComponent: 0];
    NSInteger cityIndex = [_areaPickerView selectedRowInComponent: 1];
    NSInteger districtIndex = [_areaPickerView selectedRowInComponent: 2];
    
    NSString *provinceStr = [_province objectAtIndex: provinceIndex];
    NSString *cityStr = [_city objectAtIndex: cityIndex];
    NSString *districtStr = [[[_district objectAtIndex:districtIndex] componentsSeparatedByString:@"\n"] firstObject];
    
    NSLog(@"%@",districtStr);
    
    _model.state = provinceStr;
    _model.city = cityStr;
    //NSString *str1 = [UpdateMemberInfo updateWithCity:cityStr];
    //NSString *str2 = [UpdateMemberInfo updateWithState:provinceStr];
    
    //NSLog(@"========%@%@",str1,str2);
    if ([provinceStr isEqualToString: cityStr]) {
        cityStr = @"";
        //districtStr = @"";
        NSString *showMsg = [NSString stringWithFormat: @"%@/%@%@", provinceStr, cityStr, districtStr];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
        EditTableViewCell *cell = [_tb cellForRowAtIndexPath:indexPath];
        cell.detailLb.text = showMsg;
        [UpdateMemberInfo updateState:provinceStr city:districtStr success:^(id responseObject) {
            NSLog(@"%@",responseObject);
        } fail:^(NSError *error) {
            //
        }];
        
    }
    else if ([cityStr isEqualToString: districtStr]) {
        districtStr = @"";
        NSString *showMsg = [NSString stringWithFormat: @"%@/%@%@", provinceStr, cityStr, districtStr];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
        EditTableViewCell *cell = [_tb cellForRowAtIndexPath:indexPath];
        cell.detailLb.text = showMsg;
        [UpdateMemberInfo updateState:provinceStr  city:cityStr success:^(id responseObject) {
            NSLog(@"%@",responseObject);
        } fail:^(NSError *error) {
            //
        }];
        
    } else {
        NSString *showMsg = [NSString stringWithFormat: @"%@/%@/%@", provinceStr, cityStr, districtStr];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
        EditTableViewCell *cell = [_tb cellForRowAtIndexPath:indexPath];
        cell.detailLb.text = showMsg;
        [UpdateMemberInfo updateState:provinceStr  city:cityStr success:^(id responseObject) {
            NSLog(@"%@",responseObject);
        } fail:^(NSError *error) {
            //
        }];
    }
    
    
}

#pragma mark 日期选择确认按钮
- (void)dateSureBtnClick{
    [_alertController dismissViewControllerAnimated:YES];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [formatter stringFromDate:_datePicker.date];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    EditTableViewCell *cell = [_tb cellForRowAtIndexPath:indexPath];
    _model.birthDate = dateStr;
    cell.detailLb.text = dateStr;
    
    //NSString *str = [UpdateMemberInfo updateWithBirth:dateStr];
    //NSLog(@"=======%@",str);
    [UpdateMemberInfo updateType:@"birth" with:dateStr success:^(id responseObject) {
        NSLog(@"====%@",responseObject);
    } fail:^(NSError *error) {
        //
    }];
}

#pragma mark 兴趣选择确认按钮
- (void)intersetBtnClick{
    [_alertController dismissViewControllerAnimated:YES];
    NSMutableArray *textArr = [NSMutableArray array];
    NSMutableArray *idArr = [NSMutableArray array];
    NSLog(@"%@",_addIntersetArr);
    for (IntersetModel *model in _addIntersetArr) {
        [textArr addObject:model.text];
        [idArr addObject:model.interestId];
    }
    NSString *str = [textArr componentsJoinedByString:@"/"];
    NSString *idStr = [idArr componentsJoinedByString:@","];
    [_addIntersetArr removeAllObjects];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:1];
    EditTableViewCell *cell = [_tb cellForRowAtIndexPath:indexPath];
    cell.detailLb.text = str;
    NSLog(@"idStr");
    [UpdateMemberInfo updateType:@"interest" with:idStr success:^(id responseObject) {
        NSLog(@"%@",responseObject);
    } fail:^(NSError *error) {
        //
    }];
}
#pragma mark 创建底部退出登录按钮
- (void)createBottomBtn
{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 70, kScreenWidth, 70.0)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    UIButton *cancelBtn = [MyControl createButtonWithFrame:CGRectMake(10, 10, kScreenWidth - 20, 50.0) target:self SEL:@selector(cancelBtnClick) title:@"退出登录"];
    [cancelBtn setBackgroundColor:kRed];
    [bgView addSubview:cancelBtn];
    
}

#pragma mark 注销按钮点击事件
- (void)cancelBtnClick
{
    //AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *dic = @{
                          @"_memberId":[User objectForKey:kMemberId],
                          @"_accessToken":[User objectForKey:kAccessToken]
                          };
    AppDelegate *app = [UIApplication sharedApplication].delegate;

    [NetWork getRequest:[NSString stringWithFormat:@"http://%@%@",app.host_ip,logout] params:dic success:^(id responseObj) {
        NSLog(@"%@",responseObj);
        [User removeObjectForKey:kMemberId];
        [User synchronize];
        NSLog(@"退出登录");
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        //
    }];
}


#pragma mark UIPicker代理
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (pickerView == _areaPickerView) {
        return 3;
    }
    return _pickDataArr.count;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == _areaPickerView) {
        if (component == 0) {
            return [_province count];
        }
        else if (component == 1){
            return [_city count];
        }
        else{
            return [_district count];
        }
    }
    return [_pickDataArr[component] count];
}
/*
 pickerView的高
 */
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 25.0f;
}

/*
 每列的宽度
 */
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (pickerView == _areaPickerView) {
        return kScreenWidth / 3.0;
    }
    return kScreenWidth;
}

/*
 pickerView每行的内容
 */
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{
    if (pickerView == _areaPickerView) {
        UILabel *myView = nil;
        
        if (component == 0) {
            myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, kScreenWidth/3, 30)];
            myView.textAlignment = NSTextAlignmentCenter;
            myView.text = [_province objectAtIndex:row];
            myView.font = [UIFont systemFontOfSize:14];
            myView.backgroundColor = [UIColor clearColor];
        }
        else if (component == 1) {
            myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, kScreenWidth/3, 30)];
            myView.textAlignment = NSTextAlignmentCenter;
            myView.text = [_city objectAtIndex:row];
            myView.font = [UIFont systemFontOfSize:14];
            myView.backgroundColor = [UIColor clearColor];
        }
        else {
            myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, kScreenWidth/3, 30)];
            myView.textAlignment = NSTextAlignmentCenter;
            myView.text = [_district objectAtIndex:row];
            myView.font = [UIFont systemFontOfSize:14];
            myView.backgroundColor = [UIColor clearColor];
        }
        
        return myView;
    }
    
    UILabel *label = [MyControl createLabelWithFrame:CGRectMake(0, 0, kScreenWidth, 30) Font:14.0f Text:_pickDataArr[component][row]];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
    
}
/*
 选中某一行的回调
 */
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    UILabel *label = (UILabel *)[pickerView viewForRow:row forComponent:component];
    label.backgroundColor = kBlue;
    if (pickerView == _areaPickerView) {
        if (component == 0) {
            _selectedProvince = [_province objectAtIndex: row];
            NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [_areaDic objectForKey: [NSString stringWithFormat:@"%ld", row]]];
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: _selectedProvince]];
            NSArray *cityArray = [dic allKeys];
            NSArray *sortedArray = [cityArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
                
                if ([obj1 integerValue] > [obj2 integerValue]) {
                    return (NSComparisonResult)NSOrderedDescending;//递减
                }
                
                if ([obj1 integerValue] < [obj2 integerValue]) {
                    return (NSComparisonResult)NSOrderedAscending;//上升
                }
                return (NSComparisonResult)NSOrderedSame;
            }];
            
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (int i=0; i<[sortedArray count]; i++) {
                NSString *index = [sortedArray objectAtIndex:i];
                NSArray *temp = [[dic objectForKey: index] allKeys];
                [array addObject: [temp objectAtIndex:0]];
            }
            
            _city = [[NSArray alloc] initWithArray: array];
            
            NSDictionary *cityDic = [dic objectForKey: [sortedArray objectAtIndex: 0]];
            _district = [[NSArray alloc] initWithArray: [cityDic objectForKey: [_city objectAtIndex: 0]]];
            [_areaPickerView selectRow: 0 inComponent: 1 animated: YES];
            [_areaPickerView selectRow: 0 inComponent: 2 animated: YES];
            [_areaPickerView reloadComponent: 1];
            [_areaPickerView reloadComponent: 2];
        }
        else if (component == 1)
        {
            NSString *provinceIndex = [NSString stringWithFormat: @"%ld", [_province indexOfObject: _selectedProvince]];
            NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [_areaDic objectForKey: provinceIndex]];
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: _selectedProvince]];
            NSArray *dicKeyArray = [dic allKeys];
            NSArray *sortedArray = [dicKeyArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
                
                if ([obj1 integerValue] > [obj2 integerValue]) {
                    return (NSComparisonResult)NSOrderedDescending;
                }
                
                if ([obj1 integerValue] < [obj2 integerValue]) {
                    return (NSComparisonResult)NSOrderedAscending;
                }
                return (NSComparisonResult)NSOrderedSame;
            }];
            
            NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [sortedArray objectAtIndex: row]]];
            NSArray *cityKeyArray = [cityDic allKeys];
            
            _district = [[NSArray alloc] initWithArray: [cityDic objectForKey: [cityKeyArray objectAtIndex:0]]];
            [_areaPickerView selectRow: 0 inComponent: 2 animated: YES];
            [_areaPickerView reloadComponent: 2];
        }
    }
}

/*
 创建日期选择器
 */
- (void)createDatePicker
{
    _datePicker = [[UIDatePicker alloc]init];
    _datePicker.frame = CGRectMake((kScreenWidth - 320)/2, 30, 320, 130);
    //日期模式
    [_datePicker setDatePickerMode:UIDatePickerModeDate];
    //定义最小日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *minDate = [formatter dateFromString:@"1920-01-01"];
    
    NSDate *maxDate = [NSDate date];
    [_datePicker setMinimumDate:minDate];
    [_datePicker setMaximumDate:maxDate];
}
#pragma mark 创建地区选择器
- (void)createAreaPicker
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"area" ofType:@"plist"];
    _areaDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    NSArray *components = [_areaDic allKeys];
    NSArray *sortedArray = [components sortedArrayUsingComparator: ^(id obj1, id obj2) {
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    NSMutableArray *provinceTmp = [[NSMutableArray alloc] init];
    for (int i=0; i<[sortedArray count]; i++) {
        NSString *index = [sortedArray objectAtIndex:i];
        NSArray *tmp = [[_areaDic objectForKey: index] allKeys];
        [provinceTmp addObject: [tmp objectAtIndex:0]];
    }
    
    _province = [[NSArray alloc] initWithArray: provinceTmp];
    
    NSString *index = [sortedArray objectAtIndex:0];
    NSString *selected = [_province objectAtIndex:0];
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [[_areaDic objectForKey:index]objectForKey:selected]];
    
    NSArray *cityArray = [dic allKeys];
    NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [cityArray objectAtIndex:0]]];
    _city = [[NSArray alloc] initWithArray: [cityDic allKeys]];
    
    
    NSString *selectedCity = [_city objectAtIndex: 0];
    _district = [[NSArray alloc] initWithArray: [cityDic objectForKey: selectedCity]];
    
    _areaPickerView = [[UIPickerView alloc] initWithFrame: CGRectMake(0, 30, kScreenWidth, 170)];
    _areaPickerView.dataSource = self;
    _areaPickerView.delegate = self;
    _areaPickerView.showsSelectionIndicator = YES;
    [_areaPickerView selectRow: 0 inComponent: 0 animated: YES];
    
    _selectedProvince = [_province objectAtIndex: 0];
}

- (void)createInterestView{
    _interestView = [[UIView alloc]initWithFrame:CGRectMake(0, 30, kScreenWidth, 170.0)];
    CGFloat width = (kScreenWidth - 50) / 5;
    CGFloat height = (170 - 40 - 20) / 4.0;
    NSArray *oldInterst = nil;
    if (_model.interest.length) {
        oldInterst = [_model.interest componentsSeparatedByString:@","];
    }
    for (NSInteger i = 0; i < 4; i++) {
        for (NSInteger j = 0; j < 5; j++) {

            if (i == 3 && j == 4) {
                break;
            }
            UIButton *btn = [MyControl createButtonWithFrame:CGRectMake((width + 10) * j, 20 + (height + 10) * i, width, height) target:self SEL:@selector(interestBtnClick:) title:[_interestArr[i * 5 + j] text]];
           // NSLog(@"%@",[_interestArr[i * 5 + j] text]);
            btn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageWithColor:kRed] forState:UIControlStateSelected];
            [_interestView addSubview:btn];
            if (oldInterst) {//用户已有的兴趣需要选中并加入addintersetArr;
                if ([oldInterst indexOfObject:[[_interestArr[i * 5 + j] interestId] stringValue]] != NSNotFound) {
                    btn.selected = YES;
                    [_addIntersetArr addObject:_interestArr[i * 5 + j]];
                }
            }
            
            btn.tag = 12000 + i * 40 + j;
        }
    }
}

- (void)interestBtnClick:(UIButton *)btn{
    
    //判断已选择个数是否超过五个
    if (!btn.selected) {
        if (_addIntersetArr.count == 5) {
            //超过提示
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"选择数量不能超过5个" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
            return;
        }
    }
    //未超过继续
    NSInteger col = (btn.tag - 12000) / 40;
    NSInteger row = (btn.tag - 12000) % 40;
    btn.selected = !btn.selected;
    if (btn.selected) {//按钮选中 将选择数据加入数组保存
        [_addIntersetArr addObject:_interestArr[col * 5 + row]];
       // NSLog(@"%@",[_interestArr[col * 5 + row] text]);
    } else {//按钮未选中 将选择数据从数据中删除
        [_addIntersetArr removeObject:_interestArr[col * 5 + row]];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}







@end
