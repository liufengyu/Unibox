//
//  ShopCartEditCell.h
//  Unibox_iOS
//
//  Created by 刘羽 on 15/12/28.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShopCartEditCell;
@protocol ShopCartEditCellDelegate <NSObject>
- (void)selectButtonClick:(ShopCartEditCell *)cell selected:(BOOL)selected;
- (void)deleteCell:(ShopCartEditCell *)cell;
@end

@interface ShopCartEditCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *selBtn;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (nonatomic, assign) id<ShopCartEditCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *desLb;
@property (weak, nonatomic) IBOutlet UIImageView *iv;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *categoryLb;
@property (weak, nonatomic) IBOutlet UILabel *stockLb;

@end
