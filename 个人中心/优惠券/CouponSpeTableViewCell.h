//
//  CouponSpeTableViewCell.h
//  Unibox_iOS
//
//  Created by 刘羽 on 16/1/25.
//  Copyright © 2016年 刘羽. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponModel.h"

@interface CouponSpeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *descLb;
@property (weak, nonatomic) IBOutlet UILabel *statusLb;
@property (weak, nonatomic) IBOutlet UILabel *typeLb;
@property (weak, nonatomic) IBOutlet UILabel *expireTimeLb;
@property (weak, nonatomic) IBOutlet UILabel *moneyLb;
@property (weak, nonatomic) IBOutlet UIImageView *bt;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UIImageView *quanimg;

- (void)configUI:(CouponModel *)model;
@end
