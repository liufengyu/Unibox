//
//  FavModel.h
//  Unibox_iOS
//
//  Created by 刘羽 on 15/10/27.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import "BasicModel.h"

@interface FavModel : BasicModel
//收藏ID
ProStr(favId);
//影片图片
ProStr(movieImg);
//碟片ID
ProStr(titleId);
//电影名
ProStr(movieName);
//是否蓝光 0不是  1是
ProStr(blueray);
//上映时间
ProStr(releaseTime);
//是否选择
@property (nonatomic, assign) BOOL isSelect;
@end
