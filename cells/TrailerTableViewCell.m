//
//  TrailerTableViewCell.m
//  Unibox_iOS
//
//  Created by 刘羽 on 15/11/26.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import "TrailerTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "API.h"
#import "ScreenImage.h"

@implementation TrailerTableViewCell

- (void)awakeFromNib {
    // Initialization code
    //self.bofangImg.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configUI:(PrevueModel *)model{
    //[self.iv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_IP,model.img]] placeholderImage:[UIImage imageNamed:@"placehold"]];
    [self.iv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_IP,model.img]] placeholderImage:[UIImage imageNamed:@"placehold"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.iv setImage:[ScreenImage shotImageContext:image View:self.iv]];
    }];
    self.nameLb.text = model.prevueTitle;
}

@end
