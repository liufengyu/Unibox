//
//  ZixunZeroTableViewCell.m
//  Unibox_iOS
//
//  Created by 刘羽 on 15/11/26.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import "ZixunZeroTableViewCell.h"
#import "UIButton+WebCache.h"
#import "API.h"
#import "ScreenImage.h"

@implementation ZixunZeroTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.bt1.userInteractionEnabled = NO;
    self.bt2.userInteractionEnabled = NO;
    self.bt3.userInteractionEnabled = NO;
}

- (void)configUI:(NewsModel *)model{
    //[self.bt1 sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_IP,model.imgList[0]]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placehold"]];
    //[self.bt2 sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_IP,model.imgList[1]]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placehold"]];
    //[self.bt3 sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_IP,model.imgList[2]]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placehold"]];
    
    [self.bt1 sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_IP,model.imgList[0]]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placehold"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.bt1 setBackgroundImage:[ScreenImage shotImageContext:image View:self.bt1] forState:UIControlStateNormal];
    }];
    [self.bt2 sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_IP,model.imgList[1]]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placehold"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.bt2 setBackgroundImage:[ScreenImage shotImageContext:image View:self.bt2] forState:UIControlStateNormal];
    }];
    [self.bt3 sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_IP,model.imgList[2]]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placehold"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.bt3 setBackgroundImage:[ScreenImage shotImageContext:image View:self.bt3] forState:UIControlStateNormal];
    }];
    self.lb.text = [NSString stringWithFormat:@"● %@",model.time];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
