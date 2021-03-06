//
//  HuodongZeroTableViewCell.m
//  Unibox_iOS
//
//  Created by 刘羽 on 15/11/26.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import "HuodongZeroTableViewCell.h"
#import "API.h"
#import "UIButton+WebCache.h"
#import "ScreenImage.h"

@implementation HuodongZeroTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.bt1.userInteractionEnabled = NO;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configUI:(ActModel *)model{
    //[self.bt1 sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_IP,model.img]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placehold"]];
    [self.bt1 sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_IP,model.img]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placehold"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            [self.bt1 setBackgroundImage:[ScreenImage shotImageContext:image View:self.bt1] forState:UIControlStateNormal];
        }
    }];
    self.titleLb.text = model.title;
    self.desLb.text = model.profile;
}

@end
