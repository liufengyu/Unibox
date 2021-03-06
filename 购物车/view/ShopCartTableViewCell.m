//
//  ShopCartTableViewCell.m
//  Unibox_iOS
//
//  Created by 刘羽 on 15/12/1.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import "ShopCartTableViewCell.h"

@implementation ShopCartTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.selBtn setImage:[UIImage imageNamed:@"cart-us"] forState:UIControlStateNormal];
    
    [self.selBtn setImage:[UIImage imageNamed:@"cart-s"] forState:UIControlStateSelected];
    
    //[self.editBtn setImage:[UIImage imageNamed:@"cart-del"] forState:UIControlStateNormal];
    //[self.editBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //[self.editBtn setTitle:@"有货" forState:UIControlStateNormal];
    //[self.editBtn setTitle:@"" forState:UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
- (IBAction)selectBtnClick:(UIButton *)btn {
    btn.selected = !btn.selected;
    [self.delegate selectButtonClick:self selected:btn.selected];
}
//- (IBAction)editBtnClik:(UIButton *)btn {
//    [self.delegate deleteCell:self];
//}

@end
