//
//  ZixunThirdTableViewCell.h
//  Unibox_iOS
//
//  Created by 刘羽 on 15/11/26.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsModel.h"
@interface ZixunThirdTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iv;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *detailLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
- (void)configUI:(NewsModel *)model;
@end
