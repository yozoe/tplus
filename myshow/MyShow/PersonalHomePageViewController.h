//
//  PersonalHomePageViewController.h
//  MyShow
//
//  Created by max on 14-8-4.
//  Copyright (c) 2014年 maxingchuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyShowSegmentedView.h"
#import "MyShowNavigationBar.h"
#import "ITTPullTableView.h"
#import "ITTImageView.h"
#import "BaseViewController.h"
#import "MWPhotoBrowser.h"

@class HMSegmentedControl;

@interface PersonalHomePageViewController : BaseViewController <MyShowSegmentedDelegate,UITableViewDelegate, UITableViewDataSource, ITTPullTableViewDelegate, UIScrollViewDelegate, MWPhotoBrowserDelegate>
{
    HMSegmentedControl  * _segmentedView;
    
    
//    ITTPullTableView *_oneTableView;
//    ITTPullTableView *_twoTableView;
    
    UIScrollView *_mainScrollView;
    NSInteger _selectedItemIndex;
}

@property (nonatomic, strong) NSArray * titleArray;



@property (weak, nonatomic) IBOutlet ITTImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;
@property (weak, nonatomic) IBOutlet UIView *noLoginView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) UserModel *user;
@property (assign, nonatomic) BOOL isFromHomePage;


- (IBAction)messageBtnClickAction:(UIButton *)sender;
- (IBAction)jumpToLoginViewAction:(id)sender;

@end
