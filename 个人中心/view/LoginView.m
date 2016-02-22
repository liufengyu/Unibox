//
//  LoginView.m
//  Unibox_iOS
//
//  Created by 刘羽 on 16/2/18.
//  Copyright © 2016年 刘羽. All rights reserved.
//

#import "LoginView.h"
#import "Header.h"
#import "UIButton+WebCache.h"
#import "API.h"

@implementation LoginView

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
    self.LevelupButton.hidden = YES;
}

- (void)configUI:(AccountModel *)model and:(RankConfModel *)rankModel{
    /*
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
     */
    self.nickNameLb.text = model.nickName;
    self.totalMoneyLb.text = [NSString stringWithFormat:@"%.2f", [model.totalMoney floatValue]];
    self.moneyLb.text = model.money;
    self.frozenMoneyLb.text = model.frozenMoney ? model.frozenMoney : @"0.00";
    self.pointLb.text = model.point ? model.point : @"0";
    self.rankLb.text = rankModel.rankTitle;
    
    [self.TXButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Image_IP, model.picture]] forState:UIControlStateNormal placeholderImage:imageNamed(@"logo")];
    
    if ([rankModel.rankTitle isEqualToString:@"钻石会员"]){
        self.LevelupButton.hidden = YES;
    } else {
        self.LevelupButton.hidden = NO;
    }
    
    
    if ([rankModel.rankId intValue] == 1) {
        self.rankImg.image = imageNamed(@"icon-putong");
    } else if ([rankModel.rankId intValue] == 2){
        self.rankImg.image = imageNamed(@"icon-yinka");
    } else if ([rankModel.rankId intValue] == 3){
        self.rankImg.image = imageNamed(@"icon-jinka");
    } else {
        self.rankImg.image = imageNamed(@"icon-zuanshi");
    }
    
    
}

@end
