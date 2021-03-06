//
//  KioskModel.h
//  Unibox_iOS
//
//  Created by 刘羽 on 15/12/8.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import "BasicModel.h"

@interface KioskModel : BasicModel
//地址
ProStr(address);
//是否是选中租赁机
ProNum(cur);
//租赁机id
ProStr(kioskId);
//租赁机图片
ProStr(kioskImg);
//租赁机名
ProStr(kioskName);
//lat
ProStr(latitude);
//lon
ProStr(longitude);
//距离当前位置距离
@property (nonatomic, assign) float distance;
- (NSComparisonResult)compareKiosk:(KioskModel *)model;
@end
