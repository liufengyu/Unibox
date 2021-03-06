//
//  MapTableViewCell.m
//  Unibox_iOS
//
//  Created by 刘羽 on 15/12/8.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import "MapTableViewCell.h"

@implementation MapTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.selectBtn setImage:[UIImage imageNamed:@"kiosk-btn-us"] forState:UIControlStateNormal];
    [self.selectBtn setImage:[UIImage imageNamed:@"kiosk-btn-s"] forState:UIControlStateSelected];
    self.selectBtn.userInteractionEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if(selected) {
        self.selectBtn.selected = YES;
    } else {
        self.selectBtn.selected = NO;
    }
}

@end
