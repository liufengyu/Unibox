//
//  LineButton.m
//  Unibox_iOS
//
//  Created by 刘羽 on 15/12/24.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import "LineButton.h"
#import "Header.h"

@implementation LineButton

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
        
    }
    return self;
}

+ (instancetype)createButtonWithFrame:(CGRect)frame target:(id)target SEL:(SEL)method title:(NSString *)title{
    
    LineButton *button=[LineButton buttonWithType:UIButtonTypeCustom];
    button.frame=frame;
    [button setTitle:title forState:UIControlStateNormal];
        //[button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    button.line = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height - 2 + 10, frame.size.width, 2)];
    button.line.backgroundColor = kRed;
    [button addSubview:button.line];
    button.line.hidden = YES;
    
        
    [button addTarget:target action:method forControlEvents:UIControlEventTouchUpInside];
    return button;
}

@end
