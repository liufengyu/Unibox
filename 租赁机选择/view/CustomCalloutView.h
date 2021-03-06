//
//  CustomCalloutView.h
//  Unibox_iOS
//
//  Created by 刘羽 on 15/11/4.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomCalloutViewDelegate <NSObject>

- (void)calloutBtnClick:(NSString *)kioskId;

@end

@interface CustomCalloutView : UIView

@property (nonatomic, assign) id<CustomCalloutViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (nonatomic, copy) NSString *kioskId;

@end
