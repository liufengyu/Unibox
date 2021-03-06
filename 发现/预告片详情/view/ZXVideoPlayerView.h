//
//  ZXVideoPlayerViewController.h
//  demo
//
//  Created by shaw on 15/7/25.
//  Copyright (c) 2015年 shaw. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZXVideoPlayerDelegate <NSObject>

- (void)back;

@end

@interface ZXVideoPlayerView : UIView

@property (nonatomic,copy) NSString *videoUrl;

@property (nonatomic, assign) id<ZXVideoPlayerDelegate>delegate;

@end
