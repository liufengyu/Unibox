//
//  MainTableViewCellDelegate.h
//  Unibox_iOS
//
//  Created by 刘羽 on 15/12/22.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol MainTableViewCellDelegate <NSObject>
- (void)btnClickAtIndex:(NSInteger)index inSection:(NSInteger)section;
@end
