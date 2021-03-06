//
//  ModifyPSDView.h
//  Unibox_iOS
//
//  Created by 刘羽 on 15/12/21.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ModifyPSDViewDelegate <NSObject>

- (void)config;

@end

@interface ModifyPSDView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *logoIv;
@property (weak, nonatomic) IBOutlet UITextField *oldPSDTextField;
@property (weak, nonatomic) IBOutlet UITextField *modifyPSDTextField;
@property (weak, nonatomic) IBOutlet UITextField *surePSDTextField;
@property (weak, nonatomic) IBOutlet UIButton *configPSDButton;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (nonatomic, assign) id<ModifyPSDViewDelegate> delegate;
@end
