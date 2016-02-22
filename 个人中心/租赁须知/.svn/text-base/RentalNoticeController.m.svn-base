//
//  RentalNoticeController.m
//  Unibox_iOS
//
//  Created by 刘羽 on 16/1/9.
//  Copyright © 2016年 刘羽. All rights reserved.
//

#import "RentalNoticeController.h"
#import "Masonry.h"
#import "Header.h"

@interface RentalNoticeController ()

@end

@implementation RentalNoticeController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kLightgray;
    RentalNoticeController *__weak weakSelf = self;
    
    UIView *naviBar = [UIView new];
    [self.view addSubview:naviBar];
    [naviBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.and.left.and.top.equalTo(weakSelf.view);
        make.height.equalTo(@64);
    }];
    naviBar.backgroundColor = [UIColor whiteColor];
    
    self.title = @"租赁须知";
    
    UIScrollView *sc = [[UIScrollView alloc]init];
    [self.view addSubview:sc];
    [sc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(naviBar.mas_bottom);
        make.right.and.left.and.bottom.equalTo(weakSelf.view);
    }];
    
    UIView *container = [UIView new];
    container.backgroundColor = [UIColor whiteColor];
    container.layer.borderWidth = 1.0;
    container.layer.borderColor = kMidgray.CGColor;
    [sc addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(sc).insets(UIEdgeInsetsMake(10, 10, 10, 10));
        make.width.equalTo(@(kScreenWidth - 20));
    }];
    
    UILabel *lb = [UILabel new];
    NSString *str = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"zulinxuzhi" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:str];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:5.0];
    [attStr addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, [str length])];
    lb.attributedText = attStr;
    
    lb.font = [UIFont systemFontOfSize:12.0];
    lb.numberOfLines = 0;
    [container addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.and.right.equalTo(container);
        make.left.equalTo(container).offset(10);
        make.right.equalTo(container).offset(-10);
        make.top.equalTo(container).offset(10);
    }];
    
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lb.mas_bottom);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
