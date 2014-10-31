//
//  SearchViewController.h
//  MyShow
//
//  Created by max on 14-8-27.
//  Copyright (c) 2014年 maxingchuan. All rights reserved.
//

#import "BaseViewController.h"
#import "MyShowNavigationBar.h"

@interface SearchViewController : BaseViewController<NavigationBarDelegate>
{
    MyShowNavigationBar * _navigationBar;
}

@property (nonatomic, strong) NSArray * tagsArray;

@end
