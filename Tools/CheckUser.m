//
//  CheckUserName.m
//  Unibox_iOS
//
//  Created by 刘羽 on 15/10/26.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import "CheckUser.h"

@implementation CheckUser
//判断手机号是否正确
+ (BOOL)validateMobile:(NSString *)mobileNum
{
      /**
              * 手机号码
              * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
              * 联通：130,131,132,152,155,156,185,186
              * 电信：133,1349,153,180,189
              */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9]|7[6-8])\\d{8}$";
     /**
              10         * 中国移动：China Mobile
              11         * 134[0-9],135,136,137,138,139,150,151,157,158,159,182,187,188,147,
              12         */
    NSString * CM = @"^1(34[0-9]|(3[5-9]|5[0127-9]|8[2378]|47|7[6-8])\\d)\\d{7}$";
    /**
              15         * 中国联通：China Unicom
              16         * 130,131,132,152,155,156,185,186
              17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56]|45|7[6-8])\\d{8}$";
    /**
              20         * 中国电信：China Telecom
              21         * 133,1349,153,180,189
              22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349|7[6-8])\\d{7}$";
    /**
          25         * 大陆地区固话及小灵通
          26         * 区号：010,020,021,022,023,024,025,027,028,029
          27         * 号码：七位或八位
          28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";

    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
//判断输入的邮箱格式是否正确
+(BOOL)checkEmail:(NSString*)email
{
    NSString *Regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *Test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [Test evaluateWithObject:email];
}
//判断输入的qq格式是否正确
+(BOOL)checkQQ:(NSString*)qq
{
    NSString *Regex = @"^[1-9](\\d){4,9}$";
    NSPredicate *Test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [Test evaluateWithObject:qq];
}
//判断输入的身份证号格式是否正确
+(BOOL)checkIdCard:(NSString*)ID
{
    NSString *Regex = @"(^\\d{15}$)|(^\\d{17}([0-9]|X)$)";
    NSPredicate *Test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [Test evaluateWithObject:ID];
}


@end
