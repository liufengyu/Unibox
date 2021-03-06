//
//  TrailerButton.m
//  Unibox_iOS
//
//  Created by 刘羽 on 15/12/11.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import "TrailerButton.h"

@implementation TrailerButton

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
        self.imageView.contentMode = UIViewContentModeCenter;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:12.0];
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake(0, 0, self.frame.size.width, self.frame.size.height / 2);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(0, self.frame.size.height / 2, self.frame.size.width, self.frame.size.height / 2);
}

@end
