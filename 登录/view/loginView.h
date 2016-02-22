//
//  loginView.h
//  Unibox_iOS
//
//  Created by 刘羽 on 15/10/23.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface loginView : UIView
//头像按钮
@property (strong, nonatomic) IBOutlet UIButton *touxiangBtn;
//用户名label
@property (strong, nonatomic) IBOutlet UILabel *userNameLb;
//用户名输入框
@property (strong, nonatomic) IBOutlet UITextField *userNameTF;
//密码输入框
@property (strong, nonatomic) IBOutlet UITextField *psdTF;
//找回密码按钮
@property (strong, nonatomic) IBOutlet UIButton *forgetBtn;
//注册按钮
@property (strong, nonatomic) IBOutlet UIButton *resignBtn;
//登录按钮
@property (strong, nonatomic) IBOutlet UIButton *loginBtn;
//QQ按钮
@property (strong, nonatomic) IBOutlet UIButton *qqBtn;
//微信按钮
@property (strong, nonatomic) IBOutlet UIButton *wechatBtn;
//支付宝按钮
@property (strong, nonatomic) IBOutlet UIButton *alipayBtn;
//新浪微博按钮
@property (strong, nonatomic) IBOutlet UIButton *sinaBtn;
@end
