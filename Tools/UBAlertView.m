//
//  UBAlertView.m
//  Unibox_iOS
//
//  Created by 刘羽 on 15/10/26.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import "UBAlertView.h"
#import "Header.h"

@implementation UBAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        UIView *alerView = [[UIView alloc]initWithFrame:CGRectMake(55, (kScreenHeight - 150)/2, kScreenWidth - 110, 150)];
        alerView.layer.cornerRadius = 5.0f;
        alerView.backgroundColor = [UIColor whiteColor];
        [self addSubview:alerView];
        
        UIImageView *imageView = [MyControl createImageViewFrame:CGRectMake((alerView.width - 50)/2, 35, 50, 50) imageName:@"resignsuccess"];
        [alerView addSubview:imageView];
        
        UILabel *label = [MyControl createLabelWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame) + 30, alerView.width, 18) Font:14.0f Text:title];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        [alerView addSubview:label];
    }
    return self;
}

@end
