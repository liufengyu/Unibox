//
//  GrayborderButton.m
//  Unibox_iOS
//
//  Created by 刘羽 on 15/11/2.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import "GrayborderButton.h"
#import "Header.h"

@implementation GrayborderButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = kGray.CGColor;
    [self setTitleColor:kBlack forState:UIControlStateNormal];
}

@end
