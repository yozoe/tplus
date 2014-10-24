//
//  LinkWebViewController.h
//  MyShow
//
//  Created by wang dong on 14-9-7.
//  Copyright (c) 2014年 maxingchuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyShowNavigationBar.h"
#import "LinksModel.h"

@interface LinkWebViewController : UIViewController <NavigationBarDelegate>

@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) LinksModel *link;

@end
