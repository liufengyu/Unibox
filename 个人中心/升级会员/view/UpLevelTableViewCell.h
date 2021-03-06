//
//  UpLevelTableViewCell.h
//  Unibox_iOS
//
//  Created by 刘羽 on 15/12/6.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RankConfModel.h"

@interface UpLevelTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *detailLb;
@property (weak, nonatomic) IBOutlet UILabel *priceLb;

- (void)configUI:(RankConfModel *)model;

@end
