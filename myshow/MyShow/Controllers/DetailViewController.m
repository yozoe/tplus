//
//  PublishDetailViewController.m
//  MyShow
//
//  Created by wang dong on 8/6/14.
//  Copyright (c) 2014 maxingchuan. All rights reserved.
//

#import "DetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "UIView+AnimationOptionsForCurve.h"
#import "UserCommentAddRequest.h"
#import "UMSocial.h"
#import "LinkWebViewController.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "MyShowDefine.h"
#import "PersonalHomePageViewController.h"
#import "SearchTagListViewController.h"
#import "DefaultTagModel.h"
#import "MyTabBarViewController.h"

@interface DetailViewController ()
{
    BOOL _isMiddle;
    UIView *_navigationView;
    CommentInputView *_inputView;
    UITapGestureRecognizer *_fullViewTagGesture;
    UILabel *_photoIndexLabel;
    UIView *_photoIndexView;
    BOOL _keyboardIsShow;
    BOOL _handelKeyboadyEvent;
    UILabel *_descLabel;
}

@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyBoardWillShowEvent:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyBoardWillHideEvent:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];

    [self initNavigationBar];

    _drawerViewController = [[DrawerViewController alloc] initWithItem:_item];
    _drawerViewController.view.top = self.view.bottom - 40;
    _drawerViewController.delegate = self;
    self.drawerView = _drawerViewController.view;

    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handDrawerControllerViewPanGesture:)];

    [_drawerViewController.drawerHeaderView addGestureRecognizer:panGesture];
    [_drawerView addObserver:self forKeyPath:@"frame" options: NSKeyValueObservingOptionNew context:nil];

    _inputView = [[CommentInputView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    _inputView.top = self.view.height;
    _inputView.backgroundColor = [UIColor whiteColor];

    _photoIndexView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 46, 46)];
    _photoIndexView.right = self.view.right;
    _photoIndexView.centerY = self.view.centerY + 50;
    UIImage *image = [UIImage imageNamed:@"zhangshu"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:_photoIndexView.bounds];
    imageView.image = image;
    [_photoIndexView addSubview:imageView];
    [self.view addSubview:_photoIndexView];

    _photoIndexLabel = [[UILabel alloc] init];
    _photoIndexLabel.top = 15;

    _photoIndexLabel.font = [UIFont systemFontOfSize:12.f];
    _photoIndexLabel.textColor = [UIColor whiteColor];
    _photoIndexLabel.textAlignment = NSTextAlignmentCenter;
    [_photoIndexView addSubview:_photoIndexLabel];

    __block ItemModel *item = _item;
    __block DrawerViewController *dvc = _drawerViewController;
    __block UIView *superView = self.view.superview;
    __block DetailViewController *detailVC = self;
    _inputView.commentSendCompleteBlock = ^(NSString *txt) {

        if (!DATA_ENV.isHasUserInfo) {
            [detailVC jumpToLoginView];
        } else {
            [UserCommentAddRequest requestWithParameters:@{@"atlasId" : item.atlas.ID, @"content" : txt} withIndicatorView:superView withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {

            } onRequestFinished:^(ITTBaseDataRequest *request) {
                item.atlas.commentNum = [NSString stringWithFormat:@"%d", item.atlas.commentNum.integerValue + 1];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESH_NOTIFICATION" object:nil];
                [dvc reloadCommentData];
            } onRequestCanceled:^(ITTBaseDataRequest *request) {

            } onRequestFailed:^(ITTBaseDataRequest *request) {
                
            }];
        }

    };
    
    _fullViewTagGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleFullViewTagGestureEvent:)];

    if (_item.publish.publistext.length) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.textColor = [UIColor whiteColor];
        _descLabel.font = [UIFont systemFontOfSize:12.f];
        _descLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _descLabel.numberOfLines = 0;
        _descLabel.text = _item.publish.publistext;

        CGSize  size = [_item.publish.publistext sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(310, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        _descLabel.width = size.width;
        _descLabel.height = size.height;
        _descLabel.left = 5;
        _descLabel.bottom = self.view.bottom - 42;
        [self.view addSubview:_descLabel];
    }

    [self.view addSubview:_drawerViewController.view];
    [self.view addSubview:_inputView];

    if (_showTagView) {
        [_drawerViewController showTagView];
    }

    if (_showCommentView) {
        [_drawerViewController showCommentView];
    }

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    MyTabBarViewController * tabbar = [AppDelegate GetAppDelegate].tabBarController;
    [tabbar hiddenTabbar:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNavigationBar
{
    UIView *navigationView = [[UIView alloc] init];
    navigationView.height = 44;
    navigationView.width = 320;
    navigationView.backgroundColor = [UIColor blackColor];

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, 32, 32)];
    [button addTarget:self action:@selector(handleLeftButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    button.top = 14;
    [button setImage:[UIImage imageNamed:@"fanhui_baise"] forState:UIControlStateNormal];
    [navigationView addSubview:button];

    UIImageView *portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    portraitImageView.backgroundColor = [UIColor grayColor];
    [portraitImageView setImageWithURL:[NSURL URLWithString:_item.user.headUrl]];
    portraitImageView.right = self.view.width - 14;
    portraitImageView.centerY = button.centerY;
    portraitImageView.layer.masksToBounds = YES;
    portraitImageView.layer.cornerRadius = 15.f;
    
    UIImage *locationImage = [UIImage imageNamed:@"didian"];
    UIImageView *locationImageView = [[UIImageView alloc] initWithImage:locationImage];

    UILabel *locationLabel = [[UILabel alloc] init];
    locationLabel.text = _item.atlas.location;
    locationLabel.font = [UIFont systemFontOfSize:12.f];
    [locationLabel sizeToFit];
    locationLabel.right = portraitImageView.left - 8;
    locationLabel.top = portraitImageView.top;
    locationLabel.textColor = [UIColor whiteColor];

    locationImageView.right = locationLabel.left - 2;
    locationImageView.centerY = locationLabel.centerY;

    UILabel *dateLabel = [[UILabel alloc] init];
    dateLabel.textColor = [UIColor whiteColor];
    dateLabel.font = [UIFont systemFontOfSize:11.f];
    dateLabel.text = [NSDate timeStringWithInterval:[_item.atlas.createDate doubleValue] / 1000];
    [dateLabel sizeToFit];
    dateLabel.right = portraitImageView.left - 8;
    dateLabel.bottom = portraitImageView.bottom;

    [navigationView addSubview:dateLabel];
    [navigationView addSubview:locationLabel];
    [navigationView addSubview:locationImageView];
    [navigationView addSubview:portraitImageView];
    [self.view addSubview:navigationView];

    _navigationView = navigationView;
}

#pragma mark - 拖动手势事件
- (void)handDrawerControllerViewPanGesture:(UIPanGestureRecognizer *)gesture
{
    CGPoint offset = [gesture translationInView:self.view];
    CGRect targetFrame = _drawerView.frame;
    if ([gesture state] == UIGestureRecognizerStateBegan) {
        if (_keyboardIsShow) {
            [_inputView.inputTextField resignFirstResponder];
        } else if ([self.drawerViewController isComment]) {
            [_inputView show];
        }
    }
    if (
        ([gesture state] == UIGestureRecognizerStateChanged) ) {

        targetFrame.origin.y = targetFrame.origin.y + offset.y;

        CGFloat limitTop = [self drawerViewLimitTop];
        CGFloat limitBottom = [self drawerViewLimitBottom];

        if (targetFrame.origin.y < limitTop) {
            _drawerView.top = limitTop;
        } else if (targetFrame.origin.y > limitBottom) {
            _drawerView.top = limitBottom;
        } else {
            _drawerView.frame = targetFrame;
        }

        [gesture setTranslation:CGPointZero inView:self.view];
    } else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
        if (targetFrame.origin.y < (self.view.bottom - 50)) {
            if (!_isMiddle) {
                if (targetFrame.origin.y < 50) {
                    [self drawerControlleMoveToTopShowInputView:YES];
                } else {
                    [self drawerControllerMoveToMiddle];
                }
            } else if (targetFrame.origin.y < self.view.centerY - 50) {
                [self drawerControlleMoveToTopShowInputView:YES];
            } else if (targetFrame.origin.y < self.view.centerY) {
                [self drawerControllerMoveToMiddle];
            } else {
                [self drawerControlleMoveToBottom];
            }
        } else {
            [self drawerControlleMoveToBottom];
        }
    }
}

- (void)drawerControlleMoveToTopShowInputView:(BOOL)show
{
    if ([self.drawerViewController isComment] && show) {
        [_inputView show];
    }
    [UIView animateWithDuration:0.3 animations:^{
        _drawerView.top = 0;
    } completion:^(BOOL finished) {
        _isMiddle = NO;
        self.drawerViewController.isExpand = YES;
    }];
}

- (void)drawerControllerMoveToMiddle
{
    if ([self.drawerViewController isComment]) {
        [_inputView show];
    }
    [UIView animateWithDuration:0.3 animations:^{
        _drawerView.top = self.view.centerY;
    } completion:^(BOOL finished) {
        _isMiddle = YES;
        self.drawerViewController.isExpand = YES;
    }];
}

- (void)drawerControlleMoveToBottom
{
    if ([self.drawerViewController isComment]) {
        [_inputView.inputTextField resignFirstResponder];
        [_inputView hide];
    }
    [UIView animateWithDuration:0.3 animations:^{
        _drawerView.top = self.view.bottom - 40;
    } completion:^(BOOL finished) {
        _isMiddle = NO;
        self.drawerViewController.isExpand = NO;
    }];
}

- (CGFloat)drawerViewLimitTop
{
    return 0;
}

- (CGFloat)drawerViewLimitBottom
{
    return 528;
}

- (void)handleLeftButtonEvent
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.3];
    [animation setType: kCATransitionFade];

    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [self.navigationController.view.layer addAnimation:animation forKey:nil];
    [self.navigationController popViewControllerAnimated:NO];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"frame"]) {
        CGRect newRect = [[change objectForKey:@"new"] CGRectValue];
        CGFloat newY = newRect.origin.y;
        self.pagingScrollView.top = (newY - 528) / 10;
        _navigationView.top = (newY - 528) / 10;
        [self.drawerViewController fixCommentTableViewHeight:528 - newY];
    }
}

- (void)drawerMovePosition:(DrawerMovePosition)position
{
    switch (position) {
        case DrawerMoveToBottom:
        {
            [self drawerControlleMoveToBottom];
        }
            break;
        case DrawerMovoToMiddle:
        {
            [self drawerControllerMoveToMiddle];
        }
            break;
        case DrawerMoveToTop:
            break;
    }
}


- (void)showInputView
{
    [_inputView show];
}

- (void)hideInputView
{
    [_inputView hide];
}

- (void)clearInputView
{
    [_inputView clear];
}

- (void)handleKeyBoardWillShowEvent:(NSNotification *)notification
{
    if ([self.drawerViewController isComment]) {
        _keyboardIsShow = YES;
        CGRect keyboardBounds;
        [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
        UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
        double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
        CGRect containerFrame = _inputView.frame;
        containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);

        [UIView animateWithDuration:duration
                              delay:0.0f
                            options:[UIView animationOptionsForCurve:curve]
                         animations:^{
                             _inputView.frame = containerFrame;
                         }
                         completion:^(BOOL finished) {
                         }];

        [self.view addGestureRecognizer:_fullViewTagGesture];
        [self drawerControlleMoveToTopShowInputView:NO];
    }
}

- (void)handleKeyBoardWillHideEvent:(NSNotification *)notification
{
    if ([self.drawerViewController isComment]) {
        _keyboardIsShow = NO;
        UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
        double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        CGRect keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
        CGRect containerFrame = _inputView.frame;
        containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;

        [UIView animateWithDuration:duration
                              delay:0.0f
                            options:[UIView animationOptionsForCurve:curve]
                         animations:^{
                             _inputView.frame = containerFrame;
                         }
                         completion:^(BOOL finished) {

                         }];
        [self.view removeGestureRecognizer:_fullViewTagGesture];
    }
}

- (void)handleFullViewTagGestureEvent:(UITapGestureRecognizer *)tap
{
    [_inputView.inputTextField resignFirstResponder];
}

- (void)updatePhotoIndexViewWithIndex:(NSInteger)index
{
    _photoIndexLabel.text = [NSString stringWithFormat:@"%d / %d", index + 1, _item.atlas.imageNum.intValue];
    [_photoIndexLabel sizeToFit];
    _photoIndexLabel.right = _photoIndexView.width - 3;
}

- (void)shareWithType:(NSString *)type
{
    CoverKeyModel *coverKeyModel = [_item.atlas.imgsArray objectAtIndex:0];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://share.591ku.com/t?imageId=%@", coverKeyModel.ID]];


    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:coverKeyModel.url]]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [UMSocialWechatHandler setWXAppId:@"wxd9a39c7122aa6516" url:[url absoluteString]];
        [UMSocialQQHandler setQQWithAppId:@"100424468" appKey:@"c7394704798a158208a74ab60104f0ba" url:[url absoluteString]];

        [[UMSocialControllerService defaultControllerService] setShareText:_item.atlas.content shareImage:image socialUIDelegate:self];
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:type];
        snsPlatform.snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);

    });

}

- (void)showWebViewWithLink:(LinksModel *)link
{
    LinkWebViewController *vc = [LinkWebViewController new];
    vc.link = link;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 下面一个是点评论头像进个人页的， 一个是点标签的
- (void)pushPersonalHomePageWithUserModel:(UserModel *)userModel
{
    PersonalHomePageViewController *ph = [PersonalHomePageViewController new];
    ph.isFromHomePage = YES;
    ph.user = userModel;
    
    
    UINavigationController * navi = [[UINavigationController alloc] initWithRootViewController:ph];
    //    homeNav.navigationBarHidden = YES;
    [navi.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBg.png"] forBarMetrics:UIBarMetricsDefault];
    
    [navi.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                [UIColor whiteColor], UITextAttributeTextColor,
                                                [UIColor whiteColor], UITextAttributeTextShadowColor,
                                                nil]];
    [self presentViewController:navi animated:YES completion:nil];
//    [self.navigationController pushViewController:ph animated:YES];
}

- (void)pushTagPageWithTagModel:(TagModel *)tagModel
{
    SearchTagListViewController * tagListVC = [[SearchTagListViewController alloc] init];
    DefaultTagModel * model = [[DefaultTagModel alloc] init];
    model.ID = tagModel.ID;
    model.name = tagModel.name;
    tagListVC.tagModel = model;
//    [self.navigationController pushViewController:tagListVC animated:YES];
    
    
    UINavigationController * navi = [[UINavigationController alloc] initWithRootViewController:tagListVC];
    //    homeNav.navigationBarHidden = YES;
    [navi.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBg.png"] forBarMetrics:UIBarMetricsDefault];
    
    [navi.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                   [UIColor whiteColor], UITextAttributeTextColor,
                                                   [UIColor whiteColor], UITextAttributeTextShadowColor,
                                                   nil]];

    [self presentViewController:navi animated:YES completion:nil];
}

- (void)didLoginOrRegisterSuccess
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DISTRIBUTE_SUCCESS object:nil];
}

@end
