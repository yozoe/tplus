//
//  HomeViewController.h
//  MyShow
//
//  Created by max on 14-7-10.
//  Copyright (c) 2014年 maxingchuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyShowSegmentedView.h"
#import "MyShowNavigationBar.h"
#import "ITTPullTableView.h"
#import "BaseViewController.h"
#import "MWPhotoBrowser.h"

@class HMSegmentedControl;

@interface HomeViewController : BaseViewController<MyShowSegmentedDelegate, NavigationBarDelegate,UITableViewDelegate, UITableViewDataSource, ITTPullTableViewDelegate, UIScrollViewDelegate, MWPhotoBrowserDelegate>
{
    MyShowNavigationBar * _navigationBar;
    HMSegmentedControl  * _titleSegmentedView;
    
    ITTPullTableView *_oneTableView;
    ITTPullTableView *_twoTableView;
    ITTPullTableView *_threeTableView;
    
    UIScrollView *_mainScrollView;
    NSMutableArray * _tableViewDataSource;
    NSInteger _selectedItemIndex;
}

@property (nonatomic, strong) NSArray * titleArray;

@end
