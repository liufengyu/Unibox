//
//  RentalDetailModel.h
//  Unibox_iOS
//
//  Created by 刘羽 on 16/1/5.
//  Copyright © 2016年 刘羽. All rights reserved.
//

#import "BasicModel.h"

@interface RentalDetailModel : BasicModel
//状态文字
ProStr(statusText);
//取碟码
ProStr(pickupCode);
//预订时间
ProStr(reserveTime);
//取碟地址
ProStr(pickupAddress);
//图片
ProStr(img);
//影片名
ProStr(movieName);
//是否蓝光
ProStr(blueray);
//押金
ProStr(deposit);
//每日租金
ProStr(fee);
//免租天数 (如果大于0在每日租金后括号里现实)
ProStr(freeDay);
//是否显示取消按钮
ProNum(canCancel);
//是否显示删除按钮
ProNum(canDelete);
//是否显示评论按钮
ProNum(canComment);
//是否支付
ProNum(payStatus);
//支付时间
ProStr(payTime);
//取碟时间
ProStr(rentalTime);
//还碟时间
ProStr(returnTime);
@end
