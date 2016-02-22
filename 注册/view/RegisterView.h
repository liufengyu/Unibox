//
//  RegisterView.h
//  Unibox_iOS
//
//  Created by 刘羽 on 15/10/23.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterView : UIView
@property (weak, nonatomic) IBOutlet UIButton *touxiangBtn;
@property (weak, nonatomic) IBOutlet UILabel *userNameLb;
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *psdTF;
@property (weak, nonatomic) IBOutlet UITextField *surePsdTF;

@property (weak, nonatomic) IBOutlet UITextField *verifyTF;
@property (weak, nonatomic) IBOutlet UIButton *verifyBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet UILabel *agreeLb;
@property (weak, nonatomic) IBOutlet UIButton *resignBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *qqBtn;
@property (weak, nonatomic) IBOutlet UIButton *wechatBtn;
@property (weak, nonatomic) IBOutlet UIButton *alipayBtn;
@property (weak, nonatomic) IBOutlet UIButton *sinaBtn;

@end
