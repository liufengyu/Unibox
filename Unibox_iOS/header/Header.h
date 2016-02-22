//
//  Header.h
//  Unibox_iOS
//
//  Created by 刘羽 on 15/10/22.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#ifndef Header_h
#define Header_h

//颜色工具类
#include "UIColor+tools.h"
//我的工厂类
#include "MyControl.h"
//UIView扩展
#include "UIView+Extension.h"
//AFN
//#include "AFNetworking.h"
//菊花
#include "JGProgressHUD.h"

//屏幕的宽和高
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

//导航栏的高度
#define kNav_Height 44.0f
//状态栏的高度
#define kStatus_Height 20.0f
//搜索栏的高度
#define kSearch_Height 24.0f
//滚动广告试图高度
#define kScroll_Height 175.0
#define kHeightScale 640.0 * kScreenHeight
#define kWidthScale  360.0 * kScreenWidth
//百度appkey
#define BaiDu_Key @"gHTrVfCVA7oSEKd4kFqB9u6u"
//友盟appkey
#define uMeng_Key @"56724db467e58ea8b0004e8f"
//微信appid appscrect
#define Wechat_AppID @"wxee221439a20ae169"
#define Wechat_AppSecret @"fcc041924782adc87f901852debcbb20"
//QQ appid appkey
#define QQ_AppID @"1104951367"
#define QQ_Appkey @"1PKkQdRgSo4pgqqQ"
//支付宝
#define Alipay_AppID @"unibox.2016011301088277"
//@"2088021848477155"
//@"2016011301088277"

//NSUserDefault
//用户 accessToken
#define NSUSER [NSUserDefaults standardUserDefaults]
#define kAccessToken @"accessToken"
#define kMemberId @"memberId"
#define kUserName @"userName"
#define kPassword @"password"

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

#define kRed [UIColor colorWithHexString:@"ff5c5c"]

//白色
//#define kWhite [UIColor colorWithHexString:@"ffffff"]
#define kWhite_Main [UIColor colorWithHexString:@"f5f5f5"]
#define kWhite_Slide [UIColor colorWithHexString:@"eaeaea"]
//蓝色
#define kBlue  [UIColor colorWithHexString:@"007ed5"]
//黑色
#define kBlack [UIColor colorWithHexString:@"343434"]
//黑色字体
#define kBlack_type [UIColor colorWithHexString:@"464646"]
//灰色
//#define kGray  [UIColor colorWithHexString:@"ededed"]
//橘色
#define kOrange [UIColor colorWithHexString:@"ff855c"]
//深灰
#define kDrakgray [UIColor colorWithHexString:@"808080"]
//中灰
#define kMidgray [UIColor colorWithHexString:@"c0c0c0"]
//浅灰
#define kLightgray [UIColor colorWithHexString:@"ededed"]
//绿色
#define kGreen RGB(23, 183, 180)
//优惠券 红
#define kQuanRed [UIColor colorWithHexString:@"e51a5d"]
//优惠券 绿
#define kQuanGreen [UIColor colorWithHexString:@"10c678"]
//优惠券 蓝
#define kQuanBlue [UIColor colorWithHexString:@"1ba0e2"]
//优惠券 黄
#define kQuanYellow [UIColor colorWithHexString:@"ed9a15"]


#define User [NSUserDefaults standardUserDefaults]

//快速读取UIImage
#define imageNamed(str) [UIImage imageNamed:(str)]


#endif /* Header_h */
