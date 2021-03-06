//
//  MovieFavTableViewController.h
//  Unibox_iOS
//
//  Created by 刘羽 on 15/11/30.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FavTableViewControllerDelegate.h"


@interface MovieFavTableViewController : UITableViewController

@property (nonatomic, assign) id<FavTableViewControllerDelegate>delegate;
//选择所有行
- (void)selectAllRow;
//取消选择所有行
- (void)deSelectAllRow;
//删除选中行
- (void)delSelectRow;
@property (nonatomic, assign) NSInteger numOfRows;
@end
