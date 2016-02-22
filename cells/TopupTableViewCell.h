//
//  TopupTableViewCell.h
//  Unibox_iOS
//
//  Created by 刘羽 on 15/11/3.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "GrayLabel.h"

@interface TopupTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIImageView *iv;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *detailLb;

@end

