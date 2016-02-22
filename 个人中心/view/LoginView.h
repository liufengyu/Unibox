//
//  LoginView.h
//  Unibox_iOS
//
//  Created by 刘羽 on 16/2/18.
//  Copyright © 2016年 刘羽. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountModel.h"
#import "RankConfModel.h"

@interface LoginView : UIView
//用户名
@property (weak, nonatomic) IBOutlet UILabel *nickNameLb;
//头像按钮
@property (weak, nonatomic) IBOutlet UIButton *TXButton;
//账号余额
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLb;
//可用余额
@property (weak, nonatomic) IBOutlet UILabel *moneyLb;
//冻结押金
@property (weak, nonatomic) IBOutlet UILabel *frozenMoneyLb;
//优币
@property (weak, nonatomic) IBOutlet UILabel *pointLb;
//会员等级
@property (weak, nonatomic) IBOutlet UILabel *rankLb;
//等级图片
@property (weak, nonatomic) IBOutlet UIImageView *rankImg;
@property (weak, nonatomic) IBOutlet UIButton *LevelupButton;

- (void)configUI:(AccountModel *)model and:(RankConfModel *)rankModel;

@end
