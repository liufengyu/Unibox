//
//  HuodongZeroTableViewCell.h
//  Unibox_iOS
//
//  Created by 刘羽 on 15/11/26.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActModel.h"

@interface HuodongZeroTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *bt1;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *desLb;

- (void)configUI:(ActModel *)model;

@end
