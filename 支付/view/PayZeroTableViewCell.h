//
//  PayZeroTableViewCell.h
//  Unibox_iOS
//
//  Created by 刘羽 on 15/12/8.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NohightButton.h"

@interface PayZeroTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lb;
@property (weak, nonatomic) IBOutlet NohightButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;


@end
