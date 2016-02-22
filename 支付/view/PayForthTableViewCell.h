//
//  PayForthTableViewCell.h
//  Unibox_iOS
//
//  Created by 刘羽 on 15/12/16.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayForthTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *arrowBtn;
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *verifyTextFiled;
@property (weak, nonatomic) IBOutlet UIImageView *verifyIv;

@end
