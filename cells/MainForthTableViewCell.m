//
//  MainForthTableViewCell.m
//  Unibox_iOS
//
//  Created by 刘羽 on 15/11/26.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import "MainForthTableViewCell.h"
#import "Header.h"
#import "API.h"
#import "NewFilmButton.h"
#import "IndexMovieModel.h"
#import "UIButton+WebCache.h"
#import "ScreenImage.h"
#define forthHeight 180.0f 
@interface MainForthTableViewCell ()
{
    NSMutableArray *_btnArr;
}
@end
@implementation MainForthTableViewCell

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
    UIScrollView *sc = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 180.0 )];
    sc.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:sc];
    
    
    CGFloat width = (kScreenWidth - 2)/3;
    CGFloat height = 180.0 ;
    sc.contentSize = CGSizeMake(width * 10 + 18, 180.0f );
    sc.contentOffset = CGPointMake(width / 2, 0);
    sc.showsHorizontalScrollIndicator = NO;
    for (int i = 0; i < 10; i++) {
        NewFilmButton *btn = [NewFilmButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake((width + 2) * i, 0, width, height);
        btn.backgroundColor = [UIColor whiteColor];
        [btn addTarget:self action:@selector(scBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 10100 + i;
        
        [_btnArr addObject:btn];
        
        [sc addSubview:btn];
    }

}

- (void)scBtnClick:(UIButton *)btn{
    NSLog(@"%ld", btn.tag);
    if ([self.delegate respondsToSelector:@selector(btnClickAtIndex:inSection:)]) {
        [self.delegate btnClickAtIndex:btn.tag - 10100 inSection:4];
    }
}

- (void)configUI:(NSArray *)arr{
    for (int i = 0; i < _btnArr.count; i++) {
        IndexMovieModel *model = (IndexMovieModel *)arr[i];
        NewFilmButton *btn = (NewFilmButton *)_btnArr[i];
        //[btn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_IP,model.img]] forState:UIControlStateNormal placeholderImage:imageNamed(@"placehold") options:SDWebImageLowPriority];
        [btn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_IP,model.img]] forState:UIControlStateNormal placeholderImage:imageNamed(@"placehold") completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [btn setImage:[ScreenImage shotImageContext:image View:btn] forState:UIControlStateNormal];
        }];
//        [btn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_IP,model.img]] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            if(image){
//                [btn setImage:[ScreenImage shotImageContext:image View:btn] forState:UIControlStateNormal];
//            }
//        }];
        [btn setTitle:model.movieName forState:UIControlStateNormal];
    }
}

@end
