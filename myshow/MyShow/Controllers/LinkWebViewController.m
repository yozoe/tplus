//
//  LinkWebViewController.m
//  MyShow
//
//  Created by wang dong on 14-9-7.
//  Copyright (c) 2014年 maxingchuan. All rights reserved.
//

#import "LinkWebViewController.h"

@interface LinkWebViewController ()
{
    MyShowNavigationBar * _navigationBar;
}

@end

@implementation LinkWebViewController

- (void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

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
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;

    _navigationBar = [[MyShowNavigationBar alloc] initWithFrame:self.view.frame
                                                       ColorStr:[NSString stringWithUTF8String:"#BD0007"]];
    _navigationBar.titleLabel.text = _link.name;

    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"fanhui_baise"] forState:UIControlStateNormal];
    _navigationBar.delegate = self;
    [self.view addSubview:_navigationBar];

    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, 320, self.view.height - 64)];
    [self.view addSubview:_webView];
    NSString* encodedString = [_link.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:encodedString]];
    [_webView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
