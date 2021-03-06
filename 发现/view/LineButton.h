//
//  LineButton.h
//  Unibox_iOS
//
//  Created by 刘羽 on 15/12/24.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LineButton : UIButton
@property (nonatomic, strong) UIView *line;
+(instancetype)createButtonWithFrame:(CGRect)frame target:(id)target SEL:(SEL)method title:(NSString*)title;

@end
