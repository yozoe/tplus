//
//  AboutUsViewController.h
//  MyShow
//
//  Created by max on 14-8-5.
//  Copyright (c) 2014年 maxingchuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyShowNavigationBar.h"
#import "BaseViewController.h"


#import "UMSocialControllerService.h"

@interface AboutUsViewController : BaseViewController <NavigationBarDelegate,UMSocialUIDelegate>
{
    MyShowNavigationBar * _navigationBar;
}
@end
