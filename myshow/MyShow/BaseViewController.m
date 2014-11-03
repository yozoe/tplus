//
//  BaseViewController.m
//  MyShow
//
//  Created by max on 14-8-5.
//  Copyright (c) 2014年 maxingchuan. All rights reserved.
//

#import "BaseViewController.h"
#import "LogingViewController.h"
#import "MBProgressHUD.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    if (IS_IOS_7) {
//        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//    }
    UISwipeGestureRecognizer * swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backToPreviewAction:)];
    [self.view addGestureRecognizer:swipe];
}

- (void)backToPreviewAction:(UISwipeGestureRecognizer *)swipe
{
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)didLoginOrRegisterSuccess
{
}

- (void)jumpToLoginView
{
    LogingViewController *loginVC = [[LogingViewController alloc] initWithNibName:@"LogingViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    nav.navigationBarHidden = YES;
    __weak typeof(self) weakSelf = self;
    loginVC.didLoginSuccess = ^(){
        [weakSelf didLoginOrRegisterSuccess];
    };
    loginVC.didRegisterSuccess = ^(){
        [weakSelf didLoginOrRegisterSuccess];
    };
    [self presentViewController:nav animated:TRUE completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UIView* view in self.view.subviews) {
        if ([view isKindOfClass:[UITextField class]])
			[view resignFirstResponder];
    }
}

- (AppDelegate *)appDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

-(void)showHUDWithImgWithTitle:(NSString *)title withHiddenDelay:(NSTimeInterval)delay
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithWindow:self.appDelegate.window];
    [self.appDelegate.window addSubview:hud];
    
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark"]] ;
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = title;
    
    [hud showAnimated:YES whileExecutingBlock:^{
        sleep(delay);
    } completionBlock:^{
        [hud removeFromSuperview];
    }];
}

@end
