//
//  MyDownLoadViewController.m
//  MyShow
//
//  Created by max on 14-8-19.
//  Copyright (c) 2014年 maxingchuan. All rights reserved.
//

#import "MyDownLoadViewController.h"

@interface MyDownLoadViewController ()

@end

@implementation MyDownLoadViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addNavigationBar];
}

- (void)addNavigationBar
{
    _navigationBar = [[MyShowNavigationBar alloc] initWithFrame:self.view.frame
                                                       ColorStr:[NSString stringWithUTF8String:"#BD0007"]];
    _navigationBar.titleLabel.text = @"我的下载";
    
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"top_navigation_back"] forState:UIControlStateNormal];
    
    _navigationBar.delegate = self;
    [self.view addSubview:_navigationBar];
}

- (void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
