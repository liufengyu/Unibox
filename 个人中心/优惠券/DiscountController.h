//
//  DiscountController.h
//  Unibox_iOS
//
//  Created by 刘羽 on 16/1/22.
//  Copyright © 2016年 刘羽. All rights reserved.
//

#import "BasicViewController.h"

@interface DiscountController : BasicViewController
typedef void (^ReturnCouponPrice)(NSString *price, NSString *couponId);   //定义一个block返回值void 参数为优惠价格

//回调函数改变优惠价格
- (void)changeCouponPrice:(ReturnCouponPrice)changePrice;
@property(nonatomic, copy)ReturnCouponPrice returnPriceBlock;
@property (nonatomic, assign) NSString *type;
@end
