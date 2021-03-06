//
//  CouponSpeTableViewCell.m
//  Unibox_iOS
//
//  Created by 刘羽 on 16/1/25.
//  Copyright © 2016年 刘羽. All rights reserved.
//

#import "CouponSpeTableViewCell.h"
#import "Header.h"

@interface CouponSpeTableViewCell ()
{
    //是否可选
    BOOL status;
    UIView *view;
}
@end

@implementation CouponSpeTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.statusLb.clipsToBounds = YES;
    self.statusLb.layer.cornerRadius = 35.0/2;
    self.descLb.clipsToBounds = YES;
    self.descLb.layer.cornerRadius = 5.0;
    UIView *grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 205.0)];
    view = grayView;
    grayView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    [self.contentView addSubview:grayView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    //[super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    if (selected) {
        view.hidden = NO;
    } else {
        view.hidden = YES;
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
}


- (void)configUI:(CouponModel *)model{
    if ([model.disk intValue] == 1) {
        self.moneyLb.text = @"DVD";
    } else if ([model.disk intValue] == 2) {
        self.moneyLb.text = @"蓝光";
    } else {
        self.moneyLb.font = [UIFont fontWithName:@"HYLingXinJ" size:26.0];
        self.moneyLb.text = @"DVD\n蓝光";
    }
    

    [self.bt setImage:imageNamed(@"quan-gray")];
    self.statusLb.textColor = RGB(191, 191, 191);
    self.descLb.textColor = RGB(191, 191, 191);
    
    
    if (kScreenWidth > 320.0) {
        self.typeLb.font = [UIFont fontWithName:@"HYLingXinJ" size:32.0];
    }
    
    
    self.typeLb.text = [NSString stringWithFormat:@"%@%@",[model.title substringToIndex:[model.title length] - 1],@"券"];
    self.expireTimeLb.text = model.expireTime;
    self.descLb.text = model.desc;
    if ([model.status intValue] == 0) {
        self.statusLb.text = @"未使用";
        [self.bt setImage:imageNamed(@"quandvd")];
        self.statusLb.textColor = kQuanBlue;
        self.descLb.textColor = kQuanBlue;
        status = NO;
    } else if ([model.status intValue] == 1) {
        self.statusLb.text = @"已使用";
        status = YES;
    } else {
        self.statusLb.text = @"已过期";
        status = YES;
    }
}

@end
