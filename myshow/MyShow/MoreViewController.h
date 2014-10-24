//
//  MoreViewController.h
//  MyShow
//
//  Created by max on 14-8-5.
//  Copyright (c) 2014年 maxingchuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyShowNavigationBar.h"
#import "BaseViewController.h"
#import "ITTMaskActivityView.h"

#define DEFAULT_LOADING_MESSAGE  @"检查更新中..."

@interface MoreViewController : BaseViewController <NavigationBarDelegate>
{
    MyShowNavigationBar * _navigationBar;
    ITTMaskActivityView *_maskActivityView;
}

@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;
@property (nonatomic, copy) NSString * loadingMessage;
@property (nonatomic, copy) NSString * itunesUrl;

@property (nonatomic, copy) void(^didLogoutSuccess)();

@end
