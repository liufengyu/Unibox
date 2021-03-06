//
//  MovieDetailTableViewCell.m
//  Unibox_iOS
//
//  Created by 刘羽 on 15/11/27.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import "MovieDetailTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation MovieDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configWithModel:(CommentModel *)model{
    [self.iv1 sd_setImageWithURL:[NSURL URLWithString:model.picture] placeholderImage:[UIImage imageNamed:@"img-man"]];
    self.iv1.clipsToBounds = YES;
    self.iv1.layer.cornerRadius = self.iv1.frame.size.height / 2.0;
    
    int score = [model.score intValue];
    if (score == 1) {
        self.iv2.image = [UIImage imageNamed:@"img-yixing"];
    } else if (score == 2){
        self.iv2.image = [UIImage imageNamed:@"img-liangxing"];
    } else if (score == 3){
        self.iv2.image = [UIImage imageNamed:@"img-sanxing"];
    } else if (score == 4){
        self.iv2.image = [UIImage imageNamed:@"img-sixing"];
    } else {
        self.iv2.image = [UIImage imageNamed:@"img-wuxing"];
    }
    self.timeLb.text = model.createTime;
    self.nameLb.text = model.nickName;
    self.detailLb.text = model.content;
    
}

@end
