//
//  CouponTableViewCell.h
//  Unibox_iOS
//
//  Created by 刘羽 on 16/1/22.
//  Copyright © 2016年 刘羽. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponModel.h"

@interface CouponTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *descLb;
@property (weak, nonatomic) IBOutlet UILabel *statusLb;
@property (weak, nonatomic) IBOutlet UILabel *typeLb;
@property (weak, nonatomic) IBOutlet UILabel *expireTimeLb;
@property (weak, nonatomic) IBOutlet UILabel *moneyLb;
@property (weak, nonatomic) IBOutlet UIButton *bt;

- (void)configUI:(CouponModel *)model;

@end
