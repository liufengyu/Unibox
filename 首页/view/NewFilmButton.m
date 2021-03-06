//
//  NewFilmButton.m
//  Unibox_iOS
//
//  Created by 刘羽 on 15/11/28.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import "NewFilmButton.h"

@implementation NewFilmButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        self.titleLabel.numberOfLines = 1;
        self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //self.imageView.contentMode = UIViewContentModeCenter;
        //self.titleLabel.textColor = [UIColor blackColor];
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 30);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(10, self.frame.size.height - 30, self.frame.size.width - 20, 30);
}


@end
