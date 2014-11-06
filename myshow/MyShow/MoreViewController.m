//
//  MoreViewController.m
//  MyShow
//
//  Created by max on 14-8-5.
//  Copyright (c) 2014年 maxingchuan. All rights reserved.
//

#import "MoreViewController.h"
#import "AboutUsViewController.h"
#import "MyDownLoadViewController.h"
#import "MobClick.h"
#import "LogoutRequest.h"
#import "MyShowTools.h"


@interface MoreViewController ()
- (IBAction)buttonClickAction:(id)sender;

- (IBAction)logoutAction:(id)sender;
@end

@implementation MoreViewController

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
    [self initNavigationBar];
    [self.logoutBtn setBackgroundColor:[MyShowTools hexStringToColor:@"#BD0007"]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!DATA_ENV.isHasUserInfo) {
        _logoutBtn.userInteractionEnabled = NO;
    }else{
        _logoutBtn.userInteractionEnabled = YES;
    }
}

- (void)initNavigationBar
{
    self.title = @"更多";
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 24, 24);
    [backButton setImage:[UIImage imageNamed:@"top_navigation_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)backAction:(UIButton *)button
{
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)buttonClickAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag - 3000) {
        case 1:
        {
            //我的下载
            MyDownLoadViewController * downloadVC = [[MyDownLoadViewController alloc] init];
            [self.navigationController pushViewController:downloadVC animated:YES];
            break;
        }
        case 2:
        {
            //检查新版本
            if (!self.loadingMessage) {
                self.loadingMessage = DEFAULT_LOADING_MESSAGE;
            }
            if (!_maskActivityView) {
                _maskActivityView = [ITTMaskActivityView loadFromXib];
                [_maskActivityView showInView:self.view withHintMessage:self.loadingMessage onCancleRequest:^(ITTMaskActivityView *hintView){
                    [self cancerUpdate];
                }];
            }

            [MobClick checkUpdateWithDelegate:self selector:@selector(callBack:)];
            break;
        }
        case 3:
        {
            //去评分
            NSString *urlString = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/app/wan-da-dian-ying/id517644732?mt=8"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            break;
        }
        case 4:
        {
            //关于我们
            AboutUsViewController *aboutVC = [[AboutUsViewController alloc]init];
            [self.navigationController pushViewController:aboutVC animated:YES];
            break;
        }
        default:
            break;
    }

}

#pragma mark - MobClick callBack
- (void)callBack:(NSDictionary *)dictionary
{
    [self cancerUpdate];
    NSString * version = [dictionary objectForKey:@"version"];
    NSString * title = [NSString stringWithFormat:@"已有新版本:v%@",version];
    
    NSString * updateLog = [dictionary objectForKey:@"update_log"];
    NSString * updateLogNew = [NSString stringWithFormat:@"更新内容\r\n%@",updateLog];
    
    //_itunesUrl
    NSString * url = [dictionary objectForKey:@"path"];
    _itunesUrl = [url stringByReplacingOccurrencesOfString:@"http" withString:@"itms-apps"];
    
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:title message:updateLogNew delegate:self cancelButtonTitle:@"暂不更新" otherButtonTitles:@"马上更新", nil];
    [alertView show];
    
}

- (void)cancerUpdate
{
    if (_maskActivityView) {
        [_maskActivityView hide];
        _maskActivityView = nil;
    }
}

- (IBAction)logoutAction:(id)sender {
    
    //退出登陆
    [LogoutRequest requestWithParameters:nil withIndicatorView:self.view withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
        
    } onRequestFinished:^(ITTBaseDataRequest *request) {
        
        NSString *platformType = [UMSocialSnsPlatformManager getSnsPlatformString:UMSocialSnsTypeSina];
        [[UMSocialDataService defaultDataService] requestUnOauthWithType:platformType completion:^(UMSocialResponseEntity *response) {
            NSLog(@"unOauth response is %@",response);

        }];
        
        
        NSLog(@"退出登陆返回数据:%@",request.handleredResult);
        
        [DATA_ENV clearDiskCache];
        
        if (_didLogoutSuccess) {
            _didLogoutSuccess();
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    } onRequestCanceled:^(ITTBaseDataRequest *request) {
        
    } onRequestFailed:^(ITTBaseDataRequest *request) {
        
    }];
    
    
    
    

}
@end
