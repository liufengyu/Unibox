//
//  CouponTableViewCell.m
//  Unibox_iOS
//
//  Created by 刘羽 on 16/1/22.
//  Copyright © 2016年 刘羽. All rights reserved.
//

#import "CouponTableViewCell.h"
#import "Header.h"

@implementation CouponTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.statusLb.clipsToBounds = YES;
    self.statusLb.layer.cornerRadius = 35.0/2;
    self.descLb.clipsToBounds = YES;
    self.descLb.layer.cornerRadius = 10.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configUI:(CouponModel *)model{
    /*
     @property (weak, nonatomic) IBOutlet UILabel *descLb;
     @property (weak, nonatomic) IBOutlet UILabel *statusLb;
     @property (weak, nonatomic) IBOutlet UILabel *typeLb;
     @property (weak, nonatomic) IBOutlet UILabel *expireTimeLb;
     @property (weak, nonatomic) IBOutlet UILabel *moneyLb;
     */
    if ([model.type isEqualToString:@"rentalCoupon"]) {
        [self.bt setBackgroundImage:imageNamed(@"") forState:UIControlStateNormal];
        self.statusLb.textColor = kBlue;
        self.descLb.textColor = kBlue;
        if ([model.disk intValue] == 1) {
            self.moneyLb.text = @"DVD";
        } else if ([model.disk intValue] == 2) {
            self.moneyLb.text = @"蓝光";
        } else {
            self.moneyLb.font = [UIFont fontWithName:@"HYLingXinJ" size:14.0];
            self.moneyLb.text = @"DVD\n蓝光";
        }
    } else {
        if ([model.money intValue] == 10) {
            [self.bt setBackgroundImage:imageNamed(@"quan10") forState:UIControlStateNormal];
            self.statusLb.textColor = kGreen;
            self.descLb.textColor = kGreen;
        } else if ([model.money intValue] == 20){
            [self.bt setBackgroundImage:imageNamed(@"quan20") forState:UIControlStateNormal];
            self.statusLb.textColor = kOrange;
            self.descLb.textColor = kOrange;
        } else if ([model.money intValue] == 30) {
            [self.bt setBackgroundImage:imageNamed(@"quan30") forState:UIControlStateNormal];
            self.statusLb.textColor = kRed;
            self.descLb.textColor = kRed;
        }
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%@",model.money]];
        [str addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HYLingXinJ" size:10]} range:NSMakeRange(0, 1)];
        self.moneyLb.attributedText = str;
    }
    self.typeLb.text = model.title;
    self.expireTimeLb.text = model.expireTime;
    self.descLb.text = model.desc;
    if ([model.status intValue] == 0) {
        self.statusLb.text = @"未使用";
    } else if ([model.status intValue] == 1) {
        self.statusLb.text = @"已使用";
    } else {
        self.statusLb.text = @"已过期";
    }
    
}

@end
