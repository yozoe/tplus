//
//  AppDelegate.m
//  MyShow
//
//  Created by max on 14-7-8.
//  Copyright (c) 2014年 maxingchuan. All rights reserved.
//

#import "AppDelegate.h"
#import "MyTabBarViewController.h"
#import "MyShowDefine.h"
#import "MMLocationManager.h"

#import "MobClick.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialTencentWeiboHandler.h"
#import "UMSocialRenrenHandler.h"

static AppDelegate *_appDelegate;

@implementation AppDelegate

+ (AppDelegate*)GetAppDelegate
{
    return _appDelegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [application setStatusBarHidden:NO];
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    
    _appDelegate = self;

    _tabBarController = [[MyTabBarViewController alloc] init];
    self.window.rootViewController = _tabBarController;
    
    
    
    //本机信息
    DATA_ENV.platformString = [[UIDevice currentDevice] platformString];
    NSLog(@"platformString:%@",DATA_ENV.platformString);
    
    //定位location
    [[MMLocationManager shareLocation] getAddress:^(NSString *addressString) {
        DATA_ENV.location = addressString;
        NSLog(@"location:%@",DATA_ENV.location);
    }];
    
    //经度&纬度
    [[MMLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
        DATA_ENV.longitude = [NSString stringWithFormat:@"%f",locationCorrrdinate.longitude];
        DATA_ENV.latitude = [NSString stringWithFormat:@"%f",locationCorrrdinate.latitude];
        
        NSLog(@"longitude:%@",DATA_ENV.longitude);
        NSLog(@"latitude:%@",DATA_ENV.latitude);
    }];
    
    //UUID
    DATA_ENV.did = [[UIDevice currentDevice] uuid];
    NSLog(@"did:%@",DATA_ENV.did);
    
    
    //打开调试log的开关
    [UMSocialData openLog:YES];
    
    //设置友盟社会化组件appkey
    [UMSocialData setAppKey:UmengAppkey];
    
    //    //设置微信AppId，设置分享url，默认使用友盟的网址
    //    [UMSocialWechatHandler setWXAppId:@"wxd9a39c7122aa6516" url:@"http://www.umeng.com/social"];
    
    //打开新浪微博的SSO开关
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    //打开腾讯微博SSO开关，设置回调地址
//    [UMSocialTencentWeiboHandler openSSOWithRedirectUrl:@"http://sns.whalecloud.com/tencent2/callback"];
    
    //打开人人网SSO开关
    [UMSocialRenrenHandler openSSO];
    
    //设置分享到QQ空间的应用Id，和分享url 链接
//    [UMSocialQQHandler setQQWithAppId:@"100424468" appKey:@"c7394704798a158208a74ab60104f0ba" url:@"http://www.umeng.com/social"];
    [UMSocialQQHandler setQQWithAppId:@"100424468" appKey:@"c7394704798a158208a74ab60104f0ba" url:@"http://www.umeng.com/social"];
    //设置支持没有客户端情况下使用SSO授权
    [UMSocialQQHandler setSupportWebView:YES];
    
    [MobClick startWithAppkey:UmengAppkey reportPolicy:SEND_INTERVAL channelId:@"App Store"];
    
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory=[paths objectAtIndex:0];
    NSLog(@"NSDocumentDirectory:%@",documentsDirectory);
    
    [self.window makeKeyAndVisible];
    
    return YES;
}



- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [UMSocialSnsService  applicationDidBecomeActive];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
