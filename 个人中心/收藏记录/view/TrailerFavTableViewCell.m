//
//  TrailerFavTableViewCell.m
//  Unibox_iOS
//
//  Created by 刘羽 on 15/11/30.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import "TrailerFavTableViewCell.h"
#import "UIButton+WebCache.h"
#import "API.h"
#import "Header.h"

@implementation TrailerFavTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.selBtn.imageView.contentMode = UIViewContentModeCenter;
    self.ivBtn.userInteractionEnabled = NO;
    [self.selBtn setImage:[UIImage imageNamed:@"cart-us"] forState:UIControlStateNormal];
    [self.selBtn setImage:[UIImage imageNamed:@"cart-s"] forState:UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configUI:(PrevueFavModel *)model{
    /*
     @property (weak, nonatomic) IBOutlet UIButton *ivBtn;
     @property (weak, nonatomic) IBOutlet UILabel *nameLb;
     @property (weak, nonatomic) IBOutlet UILabel *dedtailLb;
     ProStr(img);
     ProStr(movieName);
     ProStr(synopsis);
     */
    self.selBtn.selected = model.isSelect;
    [self.ivBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_IP,model.image]] forState:UIControlStateNormal placeholderImage:imageNamed(@"placehold") options:SDWebImageLowPriority];
    self.nameLb.text = model.prevueTitle;
    //self.dedtailLb.text = model.synopsis;
}

@end
