//
//  FavTableViewCell.m
//  Unibox_iOS
//
//  Created by 刘羽 on 15/10/27.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import "FavTableViewCell.h"
#import "Header.h"

@implementation FavTableViewCell

- (void)awakeFromNib {
    // Initialization code
//    self.detailLb.textColor = kGray;
//    self.titleLb.textColor = kBlack;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 18, 197.0f/2, 144.0/2)];
    self.iv = imageView;
    [self.contentView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 7.5, 18, 200, 13)];
    label.textColor = kBlack;
    self.titleLb = label;
    label.font = [UIFont systemFontOfSize:14.0f];
    [self.contentView addSubview:label];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 7.5, CGRectGetMaxY(label.frame) + 10, 200, 44)];
    label1.numberOfLines = 0;
//    [label1 sizeToFit];
    self.detailLb = label1;
    label1.textColor = kGray;
    label1.font = [UIFont systemFontOfSize:12.0f];
    [self.contentView addSubview:label1];
}

@end
