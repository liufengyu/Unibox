//
//  GrayLabel.m
//  Unibox_iOS
//
//  Created by 刘羽 on 15/10/30.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import "GrayLabel.h"
#import "Header.h"

@implementation GrayLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)awakeFromNib
{
    self.textColor = kGray;
}

@end
