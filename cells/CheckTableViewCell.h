//
//  CheckTableViewCell.h
//  Unibox_iOS
//
//  Created by 刘羽 on 15/11/28.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BillDetailModel.h"

@interface CheckTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *weekLb;
@property (weak, nonatomic) IBOutlet UILabel *dateLb;
@property (weak, nonatomic) IBOutlet UILabel *detailLb;
@property (weak, nonatomic) IBOutlet UILabel *moneyLb;

- (void)configUI:(BillDetailModel *)model;

@end
