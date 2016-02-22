//
//  ScreenImage.h
//  S_Demo
//
//  Created by LongHuanHuan on 15/5/29.
//  Copyright (c) 2015年 ___LongHuanHuan___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ScreenImage : NSObject

+(UIImage *)beginImageContext:(CGRect)rect View:(UIView *)view;

/*
 第一个参数是 截取图片的范围
 第二个参数是 截取那个视图
 */

@end
