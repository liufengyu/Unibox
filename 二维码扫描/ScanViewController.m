//
//  ScanViewController.m
//  EabChinaManager_Demo
//
//  Created by 刘羽on 15/10/12.
//  Copyright © 2015年 Unibox. All rights reserved.
//

#import "ScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "Header.h"
#import "API.h"
#import "UIImage+Color.h"
#import "AppDelegate.h"
#import "NetWork.h"
#define TopBar_Height 64.0
@interface ScanViewController ()
<AVCaptureMetadataOutputObjectsDelegate, UIAlertViewDelegate>//用于处理采集信息的代理
{
    int _num;
    BOOL _isUP;//判断扫描线向上还是向下运动
}

//设置相机设备捕获属性
@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, strong) AVCaptureDeviceInput *input;
@property (nonatomic, strong) AVCaptureMetadataOutput *output;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *preview;

@property (nonatomic, strong) UIImageView *line;//设置二维码扫描线
@property (nonatomic, strong) NSTimer *timer;//定时器

@end

@implementation ScanViewController


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"二维码扫描";
    UIView *naviBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64.0)];
    naviBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:naviBar];
    //self.view.backgroundColor = [UIColor grayColor];
    
    //UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64.0)];
    //iv.image = [UIImage imageWithColor:[UIColor colorWithWhite:0.0 alpha:0.5]];
    //[self.view addSubview:iv];
    
    
    //
    
    
    //二维码扫描框背景
//    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth - 245)/2, (kScreenHeight - 245) / 2, 245, 245)];
//    imageView.image = [UIImage imageNamed:@"pick_bg"];
//    [self.view addSubview:imageView];
    
    //二维码扫描线
    _line = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - 210)/2, (kScreenHeight - 230) / 2, 210, 2)];
    _line.image = [UIImage imageNamed:@"line"];
    [self.view addSubview:_line];
    
    _num = 0;
    _isUP = NO;
    
    //启动定时器，让扫描线上下浮动
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.02
                                                  target:self
                                                selector:@selector(animation)
                                                userInfo:nil
                                                 repeats:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self beginScan];//开始扫描
}

- (void)animation
{
    if (_isUP == NO)
    {
        _num++;
        int tmpY = _num*2;
        self.line.frame = CGRectMake((kScreenWidth - 230)/2, (kScreenHeight - 230) / 2+tmpY, 230, 2);
        if (tmpY == 230)
        {
            _isUP = YES;
        }
    }
    else
    {
        _num--;
        int tmpY = _num*2;
        self.line.frame = CGRectMake((kScreenWidth - 230)/2, (kScreenHeight - 230) / 2+tmpY, 230, 2);
        if (_num == 0)
        {
            _isUP = NO;
        }
    }
}

//-(void)backAction
//{
//    [self dismissViewControllerAnimated:YES completion:^{
//        [self.timer invalidate];
//    }];
//}

- (void)beginScan
{
    // Device
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    self.output = [[AVCaptureMetadataOutput alloc] init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    self.session = [[AVCaptureSession alloc] init];
    [self.session setSessionPreset:AVCaptureSessionPresetMedium];
    if ([self.session canAddInput:self.input])
    {
        [self.session addInput:self.input];
    }
    
    if ([self.session canAddOutput:self.output])
    {
        [self.session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    self.output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
    
    CGSize winsize = [UIScreen mainScreen].bounds.size;
    self.output.rectOfInterest = CGRectMake(((winsize.height - 300) / 2 - 5) / winsize.height, (winsize.width - 300) / 2 / winsize.width , 300 / winsize.height, 300 / winsize.width);
    
    // Preview
    self.preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    //self.preview.frame =CGRectMake((kScreenWidth - 280)/2.0,(kScreenHeight - 280) / 2,280,280);
    self.preview.frame = CGRectMake(0, 0, winsize.width, winsize.height);
    self.preview.backgroundColor = [UIColor redColor].CGColor;
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    
   // CGRect rect = self.output.rectOfInterest;
    CGRect frame = CGRectZero;
    
    frame.origin.x = (winsize.width - 230) / 2;//winsize.width * rect.origin.y;
    frame.origin.y = (winsize.height - 230) / 2;//winsize.height * rect.origin.x;
    frame.size.width = 230;
    frame.size.height= 230;
    
    UIView* view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor= [UIColor clearColor];
    view.layer.borderWidth = 1;
    view.layer.borderColor = [[UIColor grayColor] CGColor];
    //self.scanFrame = view;
    [self.view addSubview:view];
    
    
    //top
    UIView* shadow = [[UIView alloc] initWithFrame:CGRectMake(0, TopBar_Height, winsize.width, view.frame.origin.y - TopBar_Height)];
    shadow.backgroundColor = [UIColor blackColor];
    shadow.alpha = 0.5;
    [self.view addSubview:shadow];
    
    //bottom
    shadow = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.origin.y + view.frame.size.height, winsize.width, winsize.height - (view.frame.origin.y + view.frame.size.height))];
    shadow.backgroundColor = [UIColor blackColor];
    shadow.alpha = 0.5;
    [self.view addSubview:shadow];
    
    //left
    shadow = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.origin.y, (winsize.width - view.frame.size.width) / 2, view.frame.size.height)];
    shadow.backgroundColor = [UIColor blackColor];
    shadow.alpha = 0.5;
    [self.view addSubview:shadow];
    
    //right
    shadow = [[UIView alloc] initWithFrame:CGRectMake(view.frame.origin.x + view.frame.size.width, view.frame.origin.y, (winsize.width - view.frame.size.width) / 2, view.frame.size.height)];
    shadow.backgroundColor = [UIColor blackColor];
    shadow.alpha = 0.5;
    [self.view addSubview:shadow];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - 260)/2.0, (kScreenHeight - 260) / 2 - 50, 260, 50)];
    lab.backgroundColor = [UIColor clearColor];
    lab.numberOfLines = 2;
    lab.textColor = [UIColor whiteColor];
    lab.font = [UIFont systemFontOfSize:14.0f];
    lab.text = @"将二维码图像置于矩形方框内，离手机摄像头10CM左右，系统会自动识别。";
    
    lab.textAlignment = NSTextAlignmentCenter;
    [lab sizeToFit];
    [self.view addSubview:lab];
    // Start
    [_session startRunning];
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    // Stop
    [_session stopRunning];
    //Get Metadata
    NSString *stringValue = nil;
    if ([metadataObjects count] > 0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    
    
    AudioServicesPlaySystemSound(1015);
    //if ([stringValue rangeOfString:@"http"].length != 0){
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"scan" object:stringValue];
        
       // return;
    //}
    
    //AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    //[self.navigationController popViewControllerAnimated:YES];
//}




@end
