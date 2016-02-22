//
//  ScreenImage.m
//  S_Demo
//
//  Created by LongHuanHuan on 15/5/29.
//  Copyright (c) 2015年 ___LongHuanHuan___. All rights reserved.
//

#import "ScreenImage.h"

@implementation ScreenImage

+(UIImage *)beginImageContext:(CGRect)rect View:(UIView *)view
{
    
    UIGraphicsBeginImageContext(view.frame.size); //currentView 当前的view
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //从全屏中截取指定的范围
    CGImageRef imageRef = viewImage.CGImage;
    
    CGImageRef imageRefRect =CGImageCreateWithImageInRect(imageRef, rect);
    UIImage *sendImage = [[UIImage alloc] initWithCGImage:imageRefRect];
    return sendImage;
    /******截取图片保存的位置，如果想要保存，请把return向后移动*********/
    NSData*data=UIImagePNGRepresentation(viewImage);
    NSString*path=[NSHomeDirectory() stringByAppendingString:@"/documents/1.png"];
    [data writeToFile:path atomically:YES];
    
    NSLog(@"%@",path);
    
    UIImageWriteToSavedPhotosAlbum(sendImage, nil, nil, nil);
    CGImageRelease(imageRefRect);
    /***************/
    
    
    /*
     UIImage *image = [UIImage imageWithData:data];
     
     CGRect rect =  CGRectMake(0, 0, image.size.width, image.size.width * [movieScale floatValue]);//要裁剪的图片区域，按照原图的像素大小来，超过原图大小的边自动适配
     CGImageRef cgimg = CGImageCreateWithImageInRect([image CGImage], rect);
     textureArr[i] = [imageTexture loadWithImage:[UIImage imageWithCGImage:cgimg]];
     CGImageRelease(cgimg);

     
     */
    
}

@end
