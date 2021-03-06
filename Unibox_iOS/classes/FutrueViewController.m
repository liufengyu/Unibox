//
//  FutrueViewController.m
//  Unibox_iOS
//
//  Created by 刘羽 on 16/2/22.
//  Copyright © 2016年 刘羽. All rights reserved.
//

#import "FutrueViewController.h"
#import "Header.h"

@interface FutrueViewController ()

@end

@implementation FutrueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIScrollView *sc = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    sc.contentSize = CGSizeMake(kScreenWidth * 4, kScroll_Height);
    sc.pagingEnabled = YES;
    sc.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:sc];
    for (int i = 0; i < 4; i++) {
        UIImageView *iv = [MyControl createImageViewFrame:CGRectMake(kScreenWidth * i, 0, kScreenWidth, kScreenHeight) imageName:[NSString stringWithFormat:@"%02d",i+1]];
        [sc addSubview:iv];
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
