//
//  NetWork.h
//  Unibox_iOS
//
//  Created by 刘羽 on 15/12/11.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 请求成功block
 */
typedef void (^requestSuccessBlock)(id responseObj);

/**
 请求失败block
 */
typedef void (^requestFailureBlock) (NSError *error);

@interface NetWork : NSObject
/**
 GET请求
 */
+ (void)getRequest:(NSString *)url params:(NSDictionary*)params success:(requestSuccessBlock)successHandler failure:(requestFailureBlock)failureHandler;


@end
