//
//  BillDetailModel.h
//  Unibox_iOS
//
//  Created by 刘羽 on 15/12/30.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import "BasicModel.h"

@interface BillDetailModel : BasicModel
ProStr(billId);
@property (nonatomic, strong) NSDictionary *time;
//ProStr(type);
ProStr(desc);
ProStr(amount);
ProStr(money);
ProStr(frozenMone);
@end
