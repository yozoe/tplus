//
//  LogingViewController.h
//  MyShow
//
//  Created by max on 14-8-5.
//  Copyright (c) 2014年 maxingchuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyShowNavigationBar.h"
#import "BaseViewController.h"

@interface LogingViewController : BaseViewController

@property (nonatomic, copy) void(^didLoginSuccess)();
@property (nonatomic, copy) void(^didRegisterSuccess)();
//+ (void)loginAction;

@end
