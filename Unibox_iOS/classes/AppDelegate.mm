//
//  AppDelegate.m
//  Unibox_iOS
//
//  Created by 刘羽 on 15/10/21.
//  Copyright © 2015年 刘羽. All rights reserved.
//
//
//                            _ooOoo_
//                           o8888888o
//                           88" . "88
//                           (| -_- |)
//                            O\ = /O
//                        ____/`---'\____
//                      .   ' \\| |// `.
//                       / \\||| : |||// \
//                     / _||||| -:- |||||- \
//                       | | \\\ - /// | |
//                     | \_| ''\---/'' | |
//                      \ .-\__ `-` ___/-. /
//                   ___`. .' /--.--\ `. . __
//                ."" '< `.___\_<|>_/___.' >'"".
//               | | : `- \`.;`\ _ /`;.`/ - ` : | |
//                 \ \ `-. \_ __\ /__ _/ .-` / /
//         ======`-.____`-.___\_____/___.-`____.-'======
//                            `=---='
//
//         .............................................
//                  佛祖保佑            永无BUG
//          佛曰:
//                  写字楼里写字间，写字间里程序员；
//                  程序人员写程序，又拿程序换酒钱。
//                  酒醒只在网上坐，酒醉还来网下眠；
//                  酒醉酒醒日复日，网上网下年复年。
//                  但愿老死电脑间，不愿鞠躬老板前；
//                  奔驰宝马贵者趣，公交自行程序员。
//                  别人笑我忒疯癫，我笑自己命太贱；
//                  不见满街漂亮妹，哪个归得程序员？

/**
 *
 * ━━━━━━神兽出没━━━━━━
 * 　　　┏┓　　　┏┓
 * 　　┏┛┻━━━┛┻┓
 * 　　┃　　　　　　　┃
 * 　　┃　　　━　　　┃
 * 　　┃　┳┛　┗┳　┃
 * 　　┃　　　　　　　┃
 * 　　┃　　　┻　　　┃
 * 　　┃　　　　　　　┃
 * 　　┗━┓　　　┏━┛Code is far away from bug with the animal protecting
 * 　　　　┃　　　┃    神兽保佑,代码无bug
 * 　　　　┃　　　┃
 * 　　　　┃　　　┗━━━┓
 * 　　　　┃　　　　　　　┣┓
 * 　　　　┃　　　　　　　┏┛
 * 　　　　┗┓┓┏━┳┓┏┛
 * 　　　　　┃┫┫　┃┫┫
 * 　　　　　┗┻┛　┗┻┛
 *
 * ━━━━━━感觉萌萌哒━━━━━━
 */

/**
 * 　　　　　　　　┏┓　　　┏┓
 * 　　　　　　　┏┛┻━━━┛┻┓
 * 　　　　　　　┃　　　　　　　┃
 * 　　　　　　　┃　　　━　　　┃
 * 　　　　　　　┃　＞　　　＜　┃
 * 　　　　　　　┃　　　　　　　┃
 * 　　　　　　　┃...　⌒　...　┃
 * 　　　　　　　┃　　　　　　　┃
 * 　　　　　　　┗━┓　　　┏━┛
 * 　　　　　　　　　┃　　　┃　Code is far away from bug with the animal protecting
 * 　　　　　　　　　┃　　　┃   神兽保佑,代码无bug
 * 　　　　　　　　　┃　　　┃
 * 　　　　　　　　　┃　　　┃
 * 　　　　　　　　　┃　　　┃
 * 　　　　　　　　　┃　　　┃
 * 　　　　　　　　　┃　　　┗━━━┓
 * 　　　　　　　　　┃　　　　　　　┣┓
 * 　　　　　　　　　┃　　　　　　　┏┛
 * 　　　　　　　　　┗┓┓┏━┳┓┏┛
 * 　　　　　　　　　　┃┫┫　┃┫┫
 * 　　　　　　　　　　┗┻┛　┗┻┛
 */

/**
 *　　　　　　　　┏┓　　　┏┓+ +
 *　　　　　　　┏┛┻━━━┛┻┓ + +
 *　　　　　　　┃　　　　　　　┃
 *　　　　　　　┃　　　━　　　┃ ++ + + +
 *　　　　　　 ████━████ ┃+
 *　　　　　　　┃　　　　　　　┃ +
 *　　　　　　　┃　　　┻　　　┃
 *　　　　　　　┃　　　　　　　┃ + +
 *　　　　　　　┗━┓　　　┏━┛
 *　　　　　　　　　┃　　　┃
 *　　　　　　　　　┃　　　┃ + + + +
 *　　　　　　　　　┃　　　┃　　　　Code is far away from bug with the animal protecting
 *　　　　　　　　　┃　　　┃ + 　　　　神兽保佑,代码无bug
 *　　　　　　　　　┃　　　┃
 *　　　　　　　　　┃　　　┃　　+
 *　　　　　　　　　┃　 　　┗━━━┓ + +
 *　　　　　　　　　┃ 　　　　　　　┣┓
 *　　　　　　　　　┃ 　　　　　　　┏┛
 *　　　　　　　　　┗┓┓┏━┳┓┏┛ + + + +
 *　　　　　　　　　　┃┫┫　┃┫┫
 *　　　　　　　　　　┗┻┛　┗┻┛+ + + +
 */

#import "AppDelegate.h"
//#import "LeftController.h"
#import "MainController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "Header.h"
#import "API.h"
#import "MD5Helper.h"

#import "MovieController.h"
#import "AboutmeController.h"
#import "FutrueViewController.h"

#import "FoundViewController.h"
#import "UMSocial.h"
#import "AFNetworking.h"
#import "Pingpp.h"

#import "WXApi.h"
#import <TencentOpenAPI/TencentApiInterface.h>


@interface AppDelegate ()<BMKGeneralDelegate,WXApiDelegate,TencentApiInterfaceDelegate>
{
    BMKMapManager *_mapManager;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //友盟appkey
    [UMSocialData setAppKey:uMeng_Key];
    
    self.host_ip = /*@"www.test.unibox.com.cn/App";*/@"www.test.unibox.com.cn/App";
    
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:BaiDu_Key generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    if ([User objectForKey:kMemberId]) {
        [self login];
    }
    
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    MainController *main = [[MainController alloc]init];
    MovieController *movie = [[MovieController alloc]init];
    AboutmeController *aboutMe = [[AboutmeController alloc]init];
    FoundViewController *found = [[FoundViewController alloc]init];
    
    
    UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:main];
    UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:movie];
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:found];
    UINavigationController *nav4 = [[UINavigationController alloc]initWithRootViewController:aboutMe];
    
    MainTabBarController *tab = [[MainTabBarController alloc]init];
    tab.viewControllers = @[nav1,nav2,nav3,nav4];
    
    self.tabController = tab;
    
    
    //[self.window setRootViewController:leftVC];

    //设置状态栏颜色
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    NSString *key = (NSString *)kCFBundleVersionKey;
    //1. 从Info.plist中取出版本号
    NSString *version = [NSBundle mainBundle].infoDictionary[key];
    //2. 从沙盒中取出上次存储的版本号
    NSString *saveVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if ([version isEqualToString:saveVersion]) {
        //不是第一次使用这个版本
        //显示状态栏
        application.statusBarHidden = NO;
        //直接进入主界面
        [self.window setRootViewController:tab];
    }else{//版本号不一样:第一次使用新版本
        //将新版本号写入沙盒
        [[NSUserDefaults standardUserDefaults] setObject:version forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //显示新版本特性界面
        FutrueViewController *vc = [[FutrueViewController alloc]init];
        [self.window setRootViewController:vc];
    }
    
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)showFutrue{
    UIScrollView *sc = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    sc.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * 4, [UIScreen mainScreen].bounds.size.height);
    sc.backgroundColor = [UIColor redColor];
    sc.pagingEnabled = YES;
    for (int i = 1; i < 5; i++) {
        UIImageView *iv = [MyControl createImageViewFrame:CGRectMake(kScreenWidth * (i - 1), 0, kScreenWidth, kScreenHeight) imageName:@"01.png"];
        iv.backgroundColor = [UIColor redColor];
        [sc addSubview:iv];
    }
    [self.window addSubview:sc];
    
    
}

- (void)login{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *dic = @{
                          @"phone":[User objectForKey:kUserName],
                          @"psd":[MD5Helper MD5WithString:[User objectForKey:kPassword]]
                          };
    
    
    [manager GET:[NSString stringWithFormat:@"http://%@%@",self.host_ip,Login_URL] parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //
        NSString *result = [responseObject objectForKey:@"ret"];
        NSLog(@"%@",responseObject);
        NSInteger type = [result integerValue];
        if (type == 0)
        {
            [User setObject:[responseObject objectForKey:@"accessToken"] forKey:kAccessToken];
            [User setObject:[responseObject objectForKey:@"memberId"] forKey:kMemberId];
            [User synchronize];
            //[User setObject:[] forKey:kUserName];
            //[User setObject:_psd forKey:kPassword];
        } else {
            [User removeObjectForKey:kMemberId];
            [User synchronize];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [BMKMapView willBackGround];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [BMKMapView didForeGround];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{

    return [Pingpp handleOpenURL:url withCompletion:nil];
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [Pingpp handleOpenURL:url withCompletion:nil];
    
}

@end
