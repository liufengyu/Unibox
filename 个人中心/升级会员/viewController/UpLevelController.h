//
//  UpLevelController.h
//  Unibox_iOS
//
//  Created by 刘羽 on 15/12/6.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import "BasicViewController.h"

@interface UpLevelController : BasicViewController
@property (nonatomic, strong) NSArray *rankArr;
@property (nonatomic, strong) NSString *rank;
//是否展示会员码支付
@property (nonatomic, assign) BOOL showCard;
@end
