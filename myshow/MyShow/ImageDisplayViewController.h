//
//  ImageDisplayViewController.h
//  MyShow
//
//  Created by max on 14-7-24.
//  Copyright (c) 2014年 maxingchuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyShowNavigationBar.h"
#import "IntroControll.h"
#import "BaseViewController.h"

@interface ImageDisplayViewController : BaseViewController<NavigationBarDelegate>
{
    MyShowNavigationBar * _navigationBar;
}

@property (strong, nonatomic) IBOutlet IntroControll *introView;
@property (strong, nonatomic)NSArray * images;
@end
