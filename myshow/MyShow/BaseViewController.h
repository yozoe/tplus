//
//  BaseViewController.h
//  MyShow
//
//  Created by max on 14-8-5.
//  Copyright (c) 2014年 maxingchuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface BaseViewController : UIViewController

- (void)didLoginOrRegisterSuccess;
- (void)jumpToLoginView;

- (AppDelegate *)appDelegate;
- (void)showHUDWithImgWithTitle:(NSString *)title withHiddenDelay:(NSTimeInterval)delay;

@end
