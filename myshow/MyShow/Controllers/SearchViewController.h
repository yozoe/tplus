//
//  SearchViewController.h
//  MyShow
//
//  Created by max on 14-8-27.
//  Copyright (c) 2014年 maxingchuan. All rights reserved.
//

#import "BaseViewController.h"
#import "MyShowNavigationBar.h"
#import "ITTPullTableView.h"

@interface SearchViewController : BaseViewController<NavigationBarDelegate,UITableViewDelegate, UITableViewDataSource, ITTPullTableViewDelegate>
{
    MyShowNavigationBar * _navigationBar;
    ITTPullTableView *_tableView;
}


@end
