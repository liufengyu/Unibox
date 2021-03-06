//
//  UpdateMemberInfo.h
//  Unibox_iOS
//
//  Created by 刘羽 on 15/12/11.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpdateMemberInfo : NSObject
//+ (NSString *)updateWithName:(NSString *)name;
//+ (NSString *)updateWithSex:(NSString *)sex;
//+ (NSString *)updateWithBirth:(NSString *)birth;
//+ (NSString *)updateWithState:(NSString *)state;
//+ (NSString *)updateWithCity:(NSString *)city;
//+ (NSString *)updateWithInterset:(NSString *)interest;
+ (void)updateType:(NSString *)type
              with:(NSString *)string
    success:(void(^)(id responseObject))success
       fail:(void (^)(NSError *error))failure;
+ (void)updateState:(NSString *)state
               city:(NSString *)city
           success:(void(^)(id responseObject))success
              fail:(void (^)(NSError *error))failure;
@end
