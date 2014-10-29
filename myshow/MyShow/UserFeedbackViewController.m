//
//  UserFeedbackViewController.m
//  RongXin
//
//  Created by issuser on 14-2-24.
//  Copyright (c) 2014年 KSY. All rights reserved.
//

#import "UserFeedbackViewController.h"
#import "UIPlaceHolderTextView.h"
#import "FeedbackDataRequeat.h"
#import "iToast.h"
#import "RXUitils.h"

@interface UserFeedbackViewController()
 <UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UIPlaceHolderTextView *feedbackTextView;
@property (strong, nonatomic) IBOutlet UIView *backView;

@end

@implementation UserFeedbackViewController

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
    [self addNavigationBar];
    _feedbackTextView.placeholder = @"请填写你的意见反馈";
    _feedbackTextView.font = [UIFont systemFontOfSize:13];
    _backView.top = 0;
    [_feedbackTextView becomeFirstResponder];
}

- (void)addNavigationBar
{
    _navigationBar = [[MyShowNavigationBar alloc] initWithFrame:self.view.frame
                                                       ColorStr:[NSString stringWithUTF8String:"#BD0007"]];
    _navigationBar.titleLabel.text = @"您的反馈";
    
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"top_navigation_back"] forState:UIControlStateNormal];
    [_navigationBar.rightButton setTitle:@"发送" forState:UIControlStateNormal];
    
    _navigationBar.delegate = self;
    [self.view addSubview:_navigationBar];
}

- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightButtonClick
{
    if (_feedbackTextView.text.length == 0) {
        iToast *toast = nil;
        [toast setDuration:iToastDurationNormal];
        [toast setGravity:iToastGravityCenter];
        toast = [iToast makeText:@"请输入反馈意见"];
        [toast show];
    } else {
        [self sendFeedbackDataRequest];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)sendFeedbackDataRequest
{
    NSDictionary *params = @{@"userid":DATA_ENV.userInfo.uid, @"propose":_feedbackTextView.text};
    [FeedbackDataRequeat requestWithParameters:params withIndicatorView:self.view withCancelSubject:nil onRequestStart:
     ^(ITTBaseDataRequest *request) {
     } onRequestFinished:^(ITTBaseDataRequest *request) {
         if ([request isSuccess]) {
             ITTDINFO(@"%@",request.handleredResult);
             if ([request.handleredResult[@"result_code"] isEqualToString:@"0"]) {
                 [RXUitils showHUDWithImg:[UIImage imageNamed:@"37x-Checkmark"] WithTitle:@"发送成功" withHiddenDelay:0.5];
                 [self.navigationController popViewControllerAnimated:YES];
             }
         }
     } onRequestCanceled:^(ITTBaseDataRequest *request) {
         [RXUitils showHUDWithImg:[UIImage imageNamed:@"37-delete"] WithTitle:@"发送失败" withHiddenDelay:0.5];
     } onRequestFailed:^(ITTBaseDataRequest *request) {
         [RXUitils showHUDWithImg:[UIImage imageNamed:@"37-delete"] WithTitle:@"发送失败" withHiddenDelay:0.5];
     }];
}


@end
