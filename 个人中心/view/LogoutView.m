//
//  LoginView.m
//  Unibox_iOS
//
//  Created by 刘羽 on 16/2/18.
//  Copyright © 2016年 刘羽. All rights reserved.
//

#import "LogoutView.h"

@implementation LogoutView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib{
    self.TXButton.clipsToBounds = YES;
    self.TXButton.layer.cornerRadius = 25.0f;
}

@end
