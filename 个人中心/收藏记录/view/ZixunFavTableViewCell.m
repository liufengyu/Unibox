//
//  ZixunFavTableViewCell.m
//  Unibox_iOS
//
//  Created by 刘羽 on 15/11/30.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import "ZixunFavTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "Header.h"
#import "API.h"

@implementation ZixunFavTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.selBtn.imageView.contentMode = UIViewContentModeCenter;
    [self.selBtn setImage:[UIImage imageNamed:@"cart-us"] forState:UIControlStateNormal];
    [self.selBtn setImage:[UIImage imageNamed:@"cart-s"] forState:UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configUI:(NewsFavModel *)model{
    /*
     @property (weak, nonatomic) IBOutlet UIImageView *iv;
     @property (weak, nonatomic) IBOutlet UILabel *nameLb;
     @property (weak, nonatomic) IBOutlet UILabel *detailLb;
     ProStr(image);
     ProStr(title);
     ProStr(profile);
     ProStr(addTime);
     */
    self.selBtn.selected = model.isSelect;
    [self.iv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_IP,model.image]] placeholderImage:imageNamed(@"placehold") options:SDWebImageLowPriority];
    self.nameLb.text = model.title;
    self.detailLb.text = model.profile;
    
}

@end
