//
//  CheckUserName.h
//  Unibox_iOS
//
//  Created by 刘羽 on 15/10/26.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckUser : NSObject
//判断手机号是否正确
+ (BOOL)validateMobile:(NSString *)mobileNum;
//判断输入的邮箱格式是否正确
+(BOOL)checkEmail:(NSString*)email;
//判断输入的qq格式是否正确
+(BOOL)checkQQ:(NSString*)qq;
//判断输入的身份证号格式是否正确
+(BOOL)checkIdCard:(NSString*)ID;

@end
