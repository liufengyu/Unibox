//
//  CheckTableViewCell.m
//  Unibox_iOS
//
//  Created by 刘羽 on 15/11/28.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import "CheckTableViewCell.h"
#import "Header.h"

@implementation CheckTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configUI:(BillDetailModel *)model{
    /*
     @property (weak, nonatomic) IBOutlet UILabel *weekLb;
     @property (weak, nonatomic) IBOutlet UILabel *dateLb;
     @property (weak, nonatomic) IBOutlet UILabel *detailLb;
     @property (weak, nonatomic) IBOutlet UILabel *moneyLb;
     */
    self.weekLb.text = [model.time objectForKey:@"week"];
    self.dateLb.text = [model.time objectForKey:@"date"];
    self.detailLb.text = model.desc;
//    if (model.desc){
//        self.detailLb.text = [NSString stringWithFormat:@"%@-%@",model.type, model.desc];
//    } else {
//        self.detailLb.text = [NSString stringWithFormat:@"%@",model.type];
//    }
    
    if ([model.amount containsString:@"-"]) {
        self.moneyLb.text = [NSString stringWithFormat:@"%@",model.amount];
        self.moneyLb.textColor = kRed;
    } else {
        
        self.moneyLb.text = [NSString stringWithFormat:@"+%@",model.amount];
        self.moneyLb.textColor = kGreen;
    }
}

@end
