//
//  MainForthTableViewCell.h
//  Unibox_iOS
//
//  Created by 刘羽 on 15/11/26.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTableViewCellDelegate.h"
@interface MainForthTableViewCell : UITableViewCell
- (void)configUI:(NSArray *)arr;
@property (nonatomic, assign) id<MainTableViewCellDelegate> delegate;
@end
