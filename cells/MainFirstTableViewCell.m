//
//  MainFirstTableViewCell.m
//  Unibox_iOS
//
//  Created by 刘羽 on 15/11/26.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import "MainFirstTableViewCell.h"
#import "Header.h"
#import "NewFilmButton.h"
#import "IndexMovieModel.h"
#import "UIButton+WebCache.h"
#import "API.h"
#import "ScreenImage.h"
@interface MainFirstTableViewCell ()
{
    NSMutableArray *_btnArr;
}
@end
@implementation MainFirstTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //
        _btnArr = [NSMutableArray array];
        [self createUI];
    }
    return self;
}

- (void)createUI{
    CGFloat width = (kScreenWidth - 4)/3;
    for (int j = 0; j < 2; j++){
        for (int i = 0; i < 3; i++){
            NewFilmButton *btn = [NewFilmButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake((width + 2) * i, (160.0 + 2 ) * j, width, 160.0f );
            [btn setImage:imageNamed(@"placehold1") forState:UIControlStateNormal];
            btn.backgroundColor = [UIColor whiteColor];
            [btn setTitle:@"星球大战X" forState:UIControlStateNormal];
            btn.tag = 10080 + j * 3 + i;
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:btn];
            
            [_btnArr addObject:btn];
        }
    }
}

- (void)btnClick:(UIButton *)btn{
    NSLog(@"按钮%ld",btn.tag);
    if ([self.delegate respondsToSelector:@selector(btnClickAtIndex:inSection:)]) {
        [self.delegate btnClickAtIndex:btn.tag - 10080 inSection:1];
    }
}

- (void)configUI:(NSArray *)arr{
    for (int i = 0; i < arr.count; i++) {
        IndexMovieModel *model = arr[i];
        NewFilmButton *btn = _btnArr[i];
        //[btn setImage:imageNamed(arr[i]) forState:UIControlStateNormal];
        //[btn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_IP, model.img]] forState:UIControlStateNormal placeholderImage:imageNamed(@"placehold") options:SDWebImageLowPriority];
        
        [btn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_IP, model.img]] forState:UIControlStateNormal placeholderImage:imageNamed(@"placehold") completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [btn setImage:[ScreenImage shotImageContext:image View:btn] forState:UIControlStateNormal];
        }];
        
        [btn setTitle:model.movieName forState:UIControlStateNormal];
    }
}

@end
