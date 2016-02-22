//
//  ScanResultController.m
//  Unibox_iOS
//
//  Created by 刘羽 on 15/12/14.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import "ScanResultController.h"
#import "Header.h"

@interface ScanResultController ()

@end

@implementation ScanResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    label.textAlignment = NSTextAlignmentCenter;
    //label.text = @"取碟成功";
    label.font = [UIFont systemFontOfSize:18.0];
    if (self.type == 0) {
        label.text = @"取碟成功";
        [self.view addSubview:label];
    } else if (self.type == 200){
        UIWebView *web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
        [web loadRequest:request];
        [self.view addSubview:web];
    } else {
        label.text = @"取碟失败";
        [self.view addSubview:label];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
