//
//  ZixunDetailViewController.m
//  Unibox_iOS
//
//  Created by 刘羽 on 15/12/31.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import "ZixunDetailViewController.h"
#import "Header.h"
#import "AFNetworking.h"
#import "API.h"
//#import "NJKWebViewProgressView.h"
//#import "NJKWebViewProgress.h"
#import "TYAlertController.h"
#import "Masonry.h"
#import "ShareButton.h"
#import <TencentOpenAPI/TencentApiInterface.h>
#import "WXApi.h"
#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import <MessageUI/MessageUI.h>
#import "NetWork.h"
#import "AppDelegate.h"
#import "WebViewJavascriptBridge.h"

@interface ZixunDetailViewController ()<UIWebViewDelegate,MFMessageComposeViewControllerDelegate>
{
    //JGProgressHUD *_hud;
    UIWebView *_webView;
//    NJKWebViewProgressView *_progressView;
//    NJKWebViewProgress *_progressProxy;
    TYAlertController *_alertController;
    //WebViewJavascriptBridge *bridge;
}
@property WebViewJavascriptBridge *bridge;
@end

@implementation ZixunDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Remove progress view
    // because UINavigationBar is shared with other ViewControllers
    //[_progressView removeFromSuperview];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.title = @"资讯";
    //右侧分享,收藏按钮
    [self addRightBar];
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *naviBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64.0)];
    naviBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:naviBar];
    
    
    
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64.0, kScreenWidth, kScreenHeight - 64.0)];
    
    webView.backgroundColor = kWhite_Main;
    _webView = webView;
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    //NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.dev.unibox.com.cn/App/Act/Invite"]];
    //NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[[NSBundle mainBundle] URLForResource:@"home" withExtension:@"html"]];
    NSLog(@"%@",urlRequest);
    
    [self.view addSubview:webView];
    [webView loadRequest:urlRequest];
    
    [WebViewJavascriptBridge enableLogging];
    _bridge = [WebViewJavascriptBridge bridgeForWebView:webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"------%@",data);
        responseCallback(@"right back atcha");
    }];
    
    
    [_bridge registerHandler:@"showShare" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"showShare%@",data);
        responseCallback(@{@"result":@"1"});
    }];
    
    [_bridge registerHandler:@"getUserToken" handler:^(id data, WVJBResponseCallback responseCallback) {
        if ([User objectForKey:kMemberId]){
            responseCallback(@{@"memberId":[User objectForKey:kMemberId],@"accessToken":[User objectForKey:kAccessToken]});
        } else {
            responseCallback(@{@"memberId":@"0",@"accessToken":@""});
        }
    }];
    
    [_bridge registerHandler:@"showLogin" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"跳转到登录页");
    }];
    
}

- (void)showShare{
    NSLog(@"asdfasd");
}

#pragma mark 右侧分享,收藏按钮
- (void)addRightBar{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[imageNamed(@"share-button") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(share)];
}

- (void)share{
    UIView *share = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 330)];
    share.backgroundColor = kWhite_Main;
    NSArray *btnArr = @[@"share-wx",@"share-pyq",@"share-qq",@"share-kongjian",@"share-paste",@"share-message"];
    UILabel *label = [UILabel new];
    label.text = @"分享这篇内容";
    label.font = [UIFont systemFontOfSize:14.0];
    label.textColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentCenter;
    [share addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(share);
        make.top.equalTo(share).and.offset(10);
    }];
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = kLightgray;
    [share addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(10);
        make.right.and.left.equalTo(share);
        make.height.equalTo(@1);
    }];
    
    ShareButton *lastBtn = nil;
    
    NSNumber *width = [NSNumber numberWithFloat:kScreenWidth / 4];
    NSNumber *height = [NSNumber numberWithFloat:70.0];
    int count = 0;
    for (int i = 0; i < btnArr.count; i++) {
        ShareButton *btn = [ShareButton buttonWithType:UIButtonTypeCustom];
        //[btn setTitle:[btnArr[i] objectForKey:@"title"] forState:UIControlStateNormal];
        [btn setImage:imageNamed(btnArr[i]) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 43000 + i;
        [share addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(width);
            make.height.equalTo(height);
            if (lastBtn) {
                NSLog(@"%f",CGRectGetMaxX(lastBtn.frame));
                if (count % 4 == 0) {
                    make.left.equalTo(share);
                    make.top.equalTo(lastBtn.mas_bottom);
                } else {
                    make.left.equalTo(lastBtn.mas_right);
                    make.top.equalTo(lastBtn);
                }
            } else {
                make.left.equalTo(share);
                make.top.equalTo(label.mas_bottom).and.offset(15);
            }
        }];
        if (i == 2 || i == 3) {
            if ([TencentApiInterface isTencentAppInstall:kIphoneQQ]) {
                lastBtn = btn;
                count++;
            } else {
                btn.hidden = YES;
            }
        } else if (i== 0 || i == 1){
            if ([WXApi isWXAppSupportApi]) {
                lastBtn = btn;
                count++;
            } else {
                btn.hidden = YES;
            }
        } else {
            lastBtn = btn;
            count++;
        }
        btn.imageView.contentMode = UIViewContentModeCenter;
    }
    if (count <= 4) {
        share.height -= 70;
    }
    
    //收藏按钮
    if (self.zixunId) {
        UIButton *favBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [favBtn setTitle:@"收藏" forState:UIControlStateNormal];
        [favBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [favBtn addTarget:self action:@selector(favBtnClick) forControlEvents:UIControlEventTouchUpInside];
        favBtn.backgroundColor = [UIColor whiteColor];
        [share addSubview:favBtn];
        [favBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastBtn.mas_bottom).and.offset(20);
            make.width.equalTo(@(kScreenWidth));
            make.centerX.equalTo(share);
            make.height.equalTo(@50);
        }];
    }
    
    //取消按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelShare) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.backgroundColor = [UIColor whiteColor];
    [share addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(share).and.offset(-20);
        make.width.equalTo(@(kScreenWidth));
        make.centerX.equalTo(share);
        make.height.equalTo(@50);
    }];
    
    
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:share preferredStyle:TYAlertControllerStyleActionSheet];
    _alertController = alertController;
    //_alertController = alertController;
    alertController.backgoundTapDismissEnable = YES;
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)shareBtnClick:(ShareButton *)btn{
    NSInteger type = btn.tag - 43000;
    [_alertController dismissViewControllerAnimated:NO completion:nil];
    [UMSocialWechatHandler setWXAppId:Wechat_AppID appSecret:Wechat_AppSecret url:@"http://www.unibox.com.cn"];
    [UMSocialQQHandler setQQWithAppId:QQ_AppID appKey:QQ_Appkey url:@"http://www.unibox.com.cn"];
    if (type == 0) {
        //微信
        [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatSession] content:self.url image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response) {
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功");
            }
        }];
    } else if (type == 1) {
        //朋友圈
        [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatTimeline] content:self.url image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response) {
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功");
            }
        }];
    } else if (type == 2) {
        //QQ
        [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToQQ] content:self.url image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response) {
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功");
            }
        }];
    } else if (type == 3) {
        //QQ空间
        [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToQzone] content:self.url image:imageNamed(@"logo") location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response) {
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功");
            }
        }];
    } else if (type == 4) {
        //复制链接
        UIPasteboard *pboard = [UIPasteboard generalPasteboard];
        pboard.string = self.url;
        JGProgressHUD *hud = [[JGProgressHUD alloc]initWithStyle:JGProgressHUDStyleDark];
        hud.indicatorView = [[JGProgressHUDSuccessIndicatorView alloc]init];
        hud.textLabel.text = @"复制成功";
        hud.textLabel.font = [UIFont systemFontOfSize:14.0];
        [hud showInView:self.view];
        [hud dismissAfterDelay:1.0 animated:YES];
    } else if (type == 5) {
        //短信
        if( [MFMessageComposeViewController canSendText] ){
            
            MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc]init];
            
            //controller.recipients = [NSArray arrayWithObject:@"10010"];
            controller.body = [NSString stringWithFormat:@"优尼博思,一种观影体验,%@",self.url];
            controller.messageComposeDelegate = self;
            
            [self presentViewController:controller animated:YES completion:nil];
            
            //[[[[controller viewControllers] lastObject] navigationItem] setTitle:@""];//修改短信界面标题
        }else{
            [self alertWithTitle:@"提示信息" msg:@"设备不支持"];
        }
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    
    [controller dismissViewControllerAnimated:NO completion:nil];//关键的一句   不能为YES
    
    switch ( result ) {
            
        case MessageComposeResultCancelled:
            
            [self alertWithTitle:@"提示信息" msg:@"发送取消"];
            break;
        case MessageComposeResultFailed:// send failed
            [self alertWithTitle:@"提示信息" msg:@"发送成功"];
            break;
        case MessageComposeResultSent:
            [self alertWithTitle:@"提示信息" msg:@"发送失败"];
            break;
        default:
            break;
    }
}

- (void)alertWithTitle:(NSString *)str msg:(NSString *)msg{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:str message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}



- (void)webViewDidStartLoad:(UIWebView *)webView{
    //[_hud showInView:self.view];
    NSLog(@"开始请求");
    NSLog(@"%@",webView.request.URL);
    //[self.navigationController.navigationBar addSubview:_progressView];
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

//-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress{
//    //[_progressView setProgress:progress animated:YES];
//    self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
//    NSLog(@"%@",self.title);
//}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    NSLog(@"结束请求");
    
    if (webView.isLoading) {
        return;
    }
    
    //[NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(call) userInfo:self repeats:NO];
//    [_bridge callHandler:@"getHtmlTitle" data:nil responseCallback:^(id responseData) {
//        self.title = responseData;
//    }];
    
}

- (void)call{
    
}

//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
//    static int i = 1;
//    NSURL *url = [request URL];
//    NSLog(@"%d-----%@",i, [url scheme]);
//    NSLog(@"%d-----%@",i, [url host]);
//    NSLog(@"%d-----%@",i,url);
//    i++;
//    
//    if ([[url scheme] isEqualToString:@"yy"]) {
//        
//        [_bridge registerHandler:@"showShare" handler:^(id data, WVJBResponseCallback responseCallback) {
//            NSLog(@"testObjcCallback called: %@", data);
//            responseCallback(@"Response from testObjcCallback");
//        }];
//
//        id data = @{@"type":@"alert", @"content":@"12343"};
//        
//        [_bridge callHandler:@"getHtmlTitle" data:data responseCallback:^(id response) {
//            NSLog(@"testJavascriptHandler responded: %@", response);
//        }];
//        
//        NSString *str = [webView stringByEvaluatingJavaScriptFromString:@"alert('adff')"];
//        NSLog(@"%@",str);
//    }
//    
//    
//    return  YES;
//}

#pragma mark 添加收藏
- (void)favBtnClick{
    [_alertController dismissViewControllerAnimated:YES completion:nil];
    if (self.type) {//资讯收藏
        [self favZixun];
    } else { //预告片收藏
        [self favPrevue];
    }
}

#pragma mark 收藏资讯
- (void)favZixun{
    NSDictionary *dic = @{
                          @"_accessToken":[User objectForKey:kAccessToken],
                          @"_memberId":[User objectForKey:kMemberId],
                          @"newsId":self.zixunId
                          };
    JGProgressHUD *hud = [[JGProgressHUD alloc] initWithStyle:JGProgressHUDStyleDark];
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [NetWork getRequest:[NSString stringWithFormat:@"http://%@%@",app.host_ip,addNewsFav] params:dic success:^(id responseObj) {
        if (![responseObj[@"ret"]boolValue]) {
            hud.indicatorView = [[JGProgressHUDSuccessIndicatorView alloc]init];
            hud.textLabel.text = @"收藏成功";
            hud.textLabel.font = [UIFont systemFontOfSize:14.0];
            [hud showInView:self.view];
            [hud dismissAfterDelay:1.0 animated:YES];
        } else {
            hud.indicatorView = [[JGProgressHUDErrorIndicatorView alloc]init];
            hud.textLabel.text = @"收藏失败";
            hud.textLabel.font = [UIFont systemFontOfSize:14.0];
            [hud showInView:self.view];
            [hud dismissAfterDelay:1.0 animated:YES];
        }
    } failure:^(NSError *error) {
        NSLog(@"失败");
    }];
}

#pragma mark 收藏预告片
- (void)favPrevue{
    NSDictionary *dic = @{
                          @"_accessToken":[User objectForKey:kAccessToken],
                          @"_memberId":[User objectForKey:kMemberId],
                          @"prevueId":self.zixunId
                          };
    NSLog(@"%@",self.zixunId);
    JGProgressHUD *hud = [[JGProgressHUD alloc] initWithStyle:JGProgressHUDStyleDark];
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [NetWork getRequest:[NSString stringWithFormat:@"http://%@%@",app.host_ip,addPrevueFav] params:dic success:^(id responseObj) {
        NSLog(@"%@",responseObj);
        if (![responseObj[@"ret"]boolValue]) {
            hud.indicatorView = [[JGProgressHUDSuccessIndicatorView alloc]init];
            hud.textLabel.text = @"收藏成功";
            hud.textLabel.font = [UIFont systemFontOfSize:14.0];
            [hud showInView:self.view];
            [hud dismissAfterDelay:1.0 animated:YES];
        } else {
            hud.indicatorView = [[JGProgressHUDErrorIndicatorView alloc]init];
            hud.textLabel.text = @"收藏失败";
            hud.textLabel.font = [UIFont systemFontOfSize:14.0];
            [hud showInView:self.view];
            [hud dismissAfterDelay:1.0 animated:YES];
        }
    } failure:^(NSError *error) {
        //
    }];

}

#pragma mark 取消分享
- (void)cancelShare{
    [_alertController dismissViewControllerAnimated:YES completion:nil];
    
}

@end
