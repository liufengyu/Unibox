//
//  UpLevelTableViewCell.m
//  Unibox_iOS
//
//  Created by 刘羽 on 15/12/6.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import "UpLevelTableViewCell.h"

@implementation UpLevelTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.selectBtn setImage:[UIImage imageNamed:@"cart-us"] forState:UIControlStateNormal];
    [self.selectBtn setImage:[UIImage imageNamed:@"cart-s"] forState:UIControlStateSelected];
    self.selectBtn.userInteractionEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configUI:(RankConfModel *)model{
//    NSLog(@"%@",model.rankTitle);
//    NSLog(@"%@",model.freeDvd);
//    NSLog(@"%@",model.freeBlueray);
//    NSLog(@"%@",model.freeDayDvd);
//    NSLog(@"%@",model.price);
    self.titleLb.text  = model.rankTitle;
    
    self.priceLb.text  = [NSString stringWithFormat:@"%.2f元/年",[model.price floatValue]];
    //self.lb1.text = model.rankTitle;
    if ([model.freeDayDvd intValue] == 0) {
        self.detailLb.text = [NSString stringWithFormat:@"免费租DVD %@张",model.freeDvd];
    } else {
        if ([model.freeBlueray intValue] == 0) {
            self.detailLb.text = [NSString stringWithFormat:@"免费租DVD %@张 + 免租期%@天",model.freeDvd,model.freeDayDvd];
        } else {
            self.detailLb.text = [NSString stringWithFormat:@"免费租DVD %@张/蓝光 %@张 + 免租期%@天",model.freeDayDvd,model.freeBlueray, model.freeDayDvd];
        }
    }
}

@end
