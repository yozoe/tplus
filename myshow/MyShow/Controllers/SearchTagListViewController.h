//
//  SearchTagListViewController.h
//  MyShow
//
//  Created by max on 14-8-27.
//  Copyright (c) 2014年 maxingchuan. All rights reserved.
//

#import "BaseViewController.h"
#import "TagModel.h"
#import "MyShowNavigationBar.h"
#import "ITTPullTableView.h"
#import "MWPhotoBrowser.h"

@interface SearchTagListViewController : BaseViewController <NavigationBarDelegate,UITableViewDelegate, UITableViewDataSource, ITTPullTableViewDelegate, UIScrollViewDelegate, MWPhotoBrowserDelegate>
{
    MyShowNavigationBar * _navigationBar;
    ITTPullTableView *_tableView;
    
    NSMutableArray * _tableViewDataSource;
    NSInteger _selectedItemIndex;
}
@property (nonatomic, strong)TagModel * model;
@end
