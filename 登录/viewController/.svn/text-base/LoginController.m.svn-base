//
//  LoginController.m
//  Unibox_iOS
//
//  Created by 刘羽 on 15/10/23.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import "LoginController.h"
#import "Header.h"
#import "RegisterController.h"
#import "ForgetPSDController.h"
#import "CheckUser.h"
#import "API.h"
#import "MD5Helper.h"
#import "UIImage+Color.h"
#import "AppDelegate.h"
#import "AFNetworking.h"

@interface LoginController ()<UITextFieldDelegate, UIAlertViewDelegate>
{
    NSString *_userName;
    NSString *_psd;
    
    //UIView *_clearView;
    UIView *_bgView;
    
    //登录按钮
    UIButton *_loginBtn;
}
@end

@implementation LoginController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    [self.view endEditing:YES];
}

- (void)loadView{
    UIScrollView *sc = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.view = sc;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"登录";
    self.view.backgroundColor = RGB(232, 233, 232);
    
    //键盘升起和降落的通知
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillShow:)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillHide:)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:nil];
    
    //返回按钮
    [self configLeftBar];
    
    //创建UI
    [self createUI];
}

//- (void)keyboardWillShow:(NSNotification *)note{
//    CGRect keyboardBounds;
//    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
//   //NSLog(@"%@",note.userInfo);
//    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
//    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
//    
//    // Need to translate the bounds to account for rotation.
//    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
//    //CGRect textFrame;
//    UITextField *textF = (UITextField *)[self.view viewWithTag:102];
//    if (textF.editing) {
//        CGFloat height = (kScreenHeight - 64 - (_bgView.y + 100 / kWidthScale)) - keyboardBounds.size.height;
//        // animations settings
//        if (height < 0) {
//            [UIView beginAnimations:nil context:NULL];
//            [UIView setAnimationBeginsFromCurrentState:YES];
//            [UIView setAnimationDuration:[duration doubleValue]];
//            [UIView setAnimationCurve:[curve intValue]];
//            [UIView setAnimationDelegate:self];
//            
//            // set views with new info
//            _clearView.y = 64.0 + height;;
//            // commit animations
//            [UIView commitAnimations];
//        } else {
//            [UIView beginAnimations:nil context:NULL];
//            [UIView setAnimationBeginsFromCurrentState:YES];
//            [UIView setAnimationDuration:[duration doubleValue]];
//            [UIView setAnimationCurve:[curve intValue]];
//            [UIView setAnimationDelegate:self];
//            
//            // set views with new info
//            _clearView.y = 64.0;
//            // commit animations
//            [UIView commitAnimations];
//        }
//    }
//}
//
//- (void)keyboardWillHide:(NSNotification *)note{
//    CGRect keyboardBounds;
//    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
//    //NSLog(@"%@",note.userInfo);
//    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
//    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
//    
//    // Need to translate the bounds to account for rotation.
//    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
//    if (_clearView.y != 64) {
//        [UIView beginAnimations:nil context:NULL];
//        [UIView setAnimationBeginsFromCurrentState:YES];
//        [UIView setAnimationDuration:[duration doubleValue]];
//        [UIView setAnimationCurve:[curve intValue]];
//        [UIView setAnimationDelegate:self];
//        
//        // set views with new info
//        _clearView.y = 64;
//        // commit animations
//        [UIView commitAnimations];
//    }
//}

#pragma mark 创建UI
- (void)createUI
{
    //添加点按手势取消textField的响应
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapEvent)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    
    //登录后显示用户头像
    UIImageView *touxiangView = [MyControl createImageViewFrame:CGRectMake((kScreenWidth - 82 / kHeightScale) / 2, 20 + 64.0, 82 / kHeightScale, 82 / kHeightScale) imageName:@"lg-logo"];
    touxiangView.clipsToBounds = YES;
    touxiangView.layer.cornerRadius = 82 / kHeightScale / 2;
    [self.view addSubview:touxiangView];
    
    //用户名
    UILabel *label = [MyControl createLabelWithFrame:CGRectMake(0, 0, 100, 30) Font:14.0f Text:@"优尼博思"];
    label.numberOfLines = 1;
    [label sizeToFit];
    label.x = (kScreenWidth - label.width) / 2;
    label.y = CGRectGetMaxY(touxiangView.frame) + 10;
    [self.view addSubview:label];
    
    //背景视图
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake((kScreenWidth - 300 / kWidthScale) / 2, CGRectGetMaxY(label.frame) + 10, 300 / kWidthScale, 150 / kWidthScale)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.clipsToBounds = NO;
    bgView.layer.shadowColor = [UIColor grayColor].CGColor;
    bgView.layer.shadowOffset = CGSizeMake(1, 1);
    bgView.layer.shadowRadius = 1.0f;
    bgView.layer.shadowOpacity = 0.8;
    _bgView = bgView;
    [self.view addSubview:bgView];
    
    //用户名图片
    UIImageView *userNameIv = [MyControl createImageViewFrame:CGRectMake(5, (50 / kWidthScale - 24) / 2, 26.5, 24) imageName:@"lg-yonghuming"];
    [bgView addSubview:userNameIv];
    //输入用户名下方线
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(userNameIv.frame) + 15, 50 / kWidthScale, bgView.width - CGRectGetMaxX(userNameIv.frame) - 15 - 10, 1)];
    lineView1.backgroundColor = RGB(205, 205, 205);
    [bgView addSubview:lineView1];
    
    //密码图片 21 28
    UIImageView *passwordIv = [MyControl createImageViewFrame:CGRectMake(userNameIv.x, 50 / kWidthScale + (50 / kWidthScale - 28) / 2, 21, 28) imageName:@"lg-mima"];
    [bgView addSubview:passwordIv];
    //输入密码下方线
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(lineView1.x, 100 / kWidthScale, lineView1.width, 1)];
    lineView2.backgroundColor = RGB(205, 205, 205);
    [bgView addSubview:lineView2];
    
    //用户名输入框
    UITextField *userNameTF = [[UITextField alloc]initWithFrame:CGRectMake(lineView1.x, 11, lineView1.width, 50 / kWidthScale - 20)];
    [bgView addSubview:userNameTF];
    userNameTF.placeholder = @"请输入手机号";
    userNameTF.font = [UIFont systemFontOfSize:13.0];
    userNameTF.tag = 101;
    userNameTF.delegate = self;
    userNameTF.keyboardType = UIKeyboardTypeNumberPad;
    [bgView addSubview:userNameTF];
    
    //密码输入框
    UITextField *passwordTF = [[UITextField alloc]initWithFrame:CGRectMake(lineView2.x, lineView1.y + 11, lineView2.width, 50 / kWidthScale - 20)];
    passwordTF.placeholder = @"请输入密码";
    passwordTF.font = [UIFont systemFontOfSize:13.0];
    passwordTF.secureTextEntry = YES;
    passwordTF.tag = 102;
    passwordTF.delegate = self;
    [bgView addSubview:passwordTF];
    
    //忘记密码按钮
    UIButton *forgetBtn = [MyControl createButtonWithFrame:CGRectMake(10, lineView2.y + 1, 100, 30) target:self SEL:@selector(forgetBtnClick) title:@"忘记密码?"];
    forgetBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [forgetBtn sizeToFit];
    forgetBtn.y = (50 / kWidthScale - 1 - forgetBtn.height ) / 2 + lineView2.y;
    [forgetBtn setTitleColor:kRed forState:UIControlStateNormal];
    [bgView addSubview:forgetBtn];
    
    //使用微信帐号登录按钮
    UIButton *wechatBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, 100, 30) target:self SEL:@selector(wechatBtnClick) title:@"使用微信帐号登录"];
    wechatBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [wechatBtn sizeToFit];
    wechatBtn.x = bgView.width -  wechatBtn.width - 10;
    wechatBtn.y = forgetBtn.y;
    [wechatBtn setTitleColor:kRed forState:UIControlStateNormal];
    //[bgView addSubview:wechatBtn];
    
    //登录按钮
    UIButton *loginBtn = [MyControl createButtonWithFrame:CGRectMake(bgView.x, CGRectGetMaxY(bgView.frame) + 25, bgView.width, 45) target:self SEL:@selector(Login) title:@"登录"];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [loginBtn setBackgroundImage:[UIImage imageWithColor:kRed] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageWithColor:[UIColor grayColor]] forState:UIControlStateDisabled];
    _loginBtn = loginBtn;
    _loginBtn.enabled = NO;
    [self.view addSubview:loginBtn];
    
    //注册按钮
    UIButton *registerBtn = [MyControl createButtonWithFrame:CGRectMake(bgView.x, CGRectGetMaxY(loginBtn.frame) + 25, bgView.width, 45) target:self SEL:@selector(resignBtnClick) title:@"注册"];
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [registerBtn setBackgroundColor:RGB(235, 111, 74)];
    [self.view addSubview:registerBtn];
}

- (void)tapEvent{
    UITextField *userName = (UITextField *)[self.view viewWithTag:101];
    UITextField *psd = (UITextField *)[self.view viewWithTag:102];
    if (userName.editing) {
        [userName resignFirstResponder];
    }
    if (psd.editing) {
        [psd resignFirstResponder];
    }
}

#pragma mark - UITextField代理
/*
 turn键响应
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    UITextField *userName = (UITextField *)[self.view viewWithTag:101];
    UITextField *psd = (UITextField *)[self.view viewWithTag:102];
    if (textField.tag == 101) {
        [userName resignFirstResponder];
        [psd becomeFirstResponder];
    }
    else
    {
        [psd resignFirstResponder];
    }
    return YES;
}


/*
 监听编辑框停止编辑
 */
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //UITextField *userName = (UITextField *)[self.view viewWithTag:101];
    //UITextField *psd = (UITextField *)[self.view viewWithTag:102];
    if (textField.tag == 101) {
        //判断手机号是否正确
        _userName = textField.text;
        if(_userName.length == 11){
            //调用检测手机号接口
            [self verifyMobile:_userName];
        } else if (_userName.length != 0){
            //请输入11位手机号
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请输入11位手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
            [self alertMessage:@"请输入11位手机号"];
        }
    }
    
}

- (void)verifyMobile:(NSString *)phone{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *dic = @{@"phone":phone};
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [manager GET:[NSString stringWithFormat:@"http://%@%@",app.host_ip, CheckPhone_URL] parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (![responseObject[@"ret"] boolValue]) {
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"输入的手机号未注册" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
            [self alertMessage:@"输入的手机号未注册"];
        } else {
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"])
    {
        return YES;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    UITextField *userName = (UITextField *)[self.view viewWithTag:101];
    UITextField *psd = (UITextField *)[self.view viewWithTag:102];
    if (textField.tag == 101)
    {
        if ([toBeString length]){
            if ([toBeString length] > 11) {
                textField.text = [toBeString substringToIndex:11];
                [self alertMessage:@"手机号不能超过11位"];
                return NO;
            } else {
                if ([psd.text length]) {
                    _loginBtn.enabled = YES;
                }
            }
        } else {
            _loginBtn.enabled = NO;
        }
    } if (textField.tag == 102) {
        if ([toBeString length]) {
            if ([userName.text length]) {
                _loginBtn.enabled = YES;
            }
        } else {
            _loginBtn.enabled = NO;
        }
    }
    return YES;
}

#pragma mark 注册按钮的点击事件
- (void)resignBtnClick
{
    //跳转到注册页面
    [self.navigationController pushViewController:[[RegisterController alloc]init] animated:YES];
}

//#pragma mark 登录按钮点击事件
//- (void)loginBtnClick
//{
//    //
//    if (_userName != _loginView.userNameTF.text)
//    {
//        _userName = _loginView.userNameTF.text;
//    }
//    if (_psd != _loginView.psdTF.text) {
//        _psd = _loginView.psdTF.text;
//    }
//    if (_userName == nil || _psd == nil)
//    {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"用户名或密码不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//        return;
//    }
//    [self Login];
//}

#pragma mark 忘记密码按钮
- (void)forgetBtnClick
{
    //跳转到找回密码页面
    [self.navigationController pushViewController:[[ForgetPSDController alloc]init] animated:YES];
}


#pragma mark 登录
- (void)Login
{
    UITextField *userName = (UITextField *)[self.view viewWithTag:101];
    UITextField *psd = (UITextField *)[self.view viewWithTag:102];
    if (_userName != userName.text)
    {
        _userName = userName.text;
    }
    if (_psd != psd.text) {
        _psd = psd.text;
    }
    NSLog(@"%@,%@",_userName,_psd);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *dic = @{
                          @"phone":_userName,
                          @"psd":[MD5Helper MD5WithString:_psd]
                          };
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    
    [manager GET:[NSString stringWithFormat:@"http://%@%@",app.host_ip,Login_URL] parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //
        NSString *result = [responseObject objectForKey:@"ret"];
        NSLog(@"%@",responseObject);
        NSInteger type = [result integerValue];
        if (type == 0)
        {
            [User setObject:[responseObject objectForKey:@"accessToken"] forKey:kAccessToken];
            [User setObject:[responseObject objectForKey:@"memberId"] forKey:kMemberId];
            [User setObject:_userName forKey:kUserName];
            [User setObject:_psd forKey:kPassword];
            [User synchronize];
            
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"login" object:nil];
            [self tapEvent];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else if (type == 1)
        {
            [self alertMessage:@"用户名错误"];
        }
        else if (type == 2)
        {
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"密码错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
            [self alertMessage:@"密码错误"];
        } else
        {
            [self alertMessage:@"系统维护中"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@,%@",_userName, _psd);
        NSLog(@"错误");
    }];
    
}

#pragma mark 使用微信帐号登录
- (void)wechatBtnClick{
    NSLog(@"微信帐号登录");
}


- (void)alertMessage:(NSString *)message{
//    JGProgressHUD *hud = [[JGProgressHUD alloc]initWithStyle:JGProgressHUDStyleDark];
//    hud.indicatorView = nil;
//    hud.textLabel.text = message;
//    [hud showInView:self.view];
//    [hud dismissAfterDelay:1.0 animated:YES];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ac = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:ac];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
