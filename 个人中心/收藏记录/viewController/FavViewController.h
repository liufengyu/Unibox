//
//  FavViewController.h
//  Unibox_iOS
//
//  Created by 刘羽 on 15/11/30.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import "BasicViewController.h"

@protocol favViewControllerDelegate <NSObject>

- (void)selectAll;

@end

@interface FavViewController : BasicViewController

@property (nonatomic, assign)id <favViewControllerDelegate>delegate;

@end
