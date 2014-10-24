//
//  AppDelegate.h
//  MyShow
//
//  Created by max on 14-7-8.
//  Copyright (c) 2014年 maxingchuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMSocialControllerService.h"
@class MyTabBarViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MyTabBarViewController * tabBarController;

+ (AppDelegate*)GetAppDelegate;

@end
