//
//  BillInfoModel.h
//  Unibox_iOS
//
//  Created by 刘羽 on 15/12/30.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import "BasicModel.h"

@interface BillInfoModel : BasicModel
ProStr(billId);
ProStr(amount);
ProStr(desc);
ProStr(channel);
ProStr(createTime);
ProStr(money);
ProStr(frozenMoney);
@end
