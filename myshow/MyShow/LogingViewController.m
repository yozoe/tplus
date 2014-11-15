//
//  LogingViewController.m
//  MyShow
//
//  Created by max on 14-8-5.
//  Copyright (c) 2014年 maxingchuan. All rights reserved.
//

#import "LogingViewController.h"
#import "UMSocial.h"
#import "MyShowDefine.h"
#import "MyShowTools.h"
#import "UserModel.h"
#import "RegisterRequest.h"
#import "LoginRequest.h"
#import "PersonalHomePageViewController.h"
#import "RXUitils.h"

@interface LoginButton : UIButton

+ (id)buttonWithType:(UIButtonType)buttonType title:(NSString *)titleStr headImage:(UIImage *)headImage;
@property (nonatomic, retain) UIImageView * iconImageView;
@property (nonatomic, retain) UILabel * nameLabel;
@end

@implementation LoginButton
@synthesize iconImageView;
@synthesize nameLabel;

+ (id)buttonWithType:(UIButtonType)buttonType title:(NSString *)titleStr headImage:(UIImage *)headImage
{
    LoginButton * button = nil;
    if ((button = [super buttonWithType:buttonType]))
    {
        button.layer.cornerRadius = CORNER_RADIUS;
        button.iconImageView = [[UIImageView alloc] initWithImage:headImage];
        button.nameLabel = [[UILabel alloc] init];
        button.nameLabel.text = titleStr;
        button.nameLabel.textColor = [UIColor whiteColor];
        button.nameLabel.backgroundColor = [UIColor clearColor];
        
        [button addSubview:button.iconImageView];
        [button addSubview:button.nameLabel];
    }
    return button;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.nameLabel.frame = CGRectMake((self.frame.size.width - self.frame.size.height) / 2,
                                      0,
                                      self.frame.size.height * 2,
                                      self.frame.size.height);
    
    self.iconImageView.frame = CGRectMake(self.nameLabel.frame.origin.x - SPACE - self.frame.size.height / 2,
                                          self.frame.size.height / 2 - self.frame.size.height / 4,
                                          self.frame.size.height / 2,
                                          self.frame.size.height / 2);
    
}



@end


@interface LogingViewController ()
{
    NSArray * _uMShareArray;
}

@end

@implementation LogingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _uMShareArray = [NSArray arrayWithObjects:UMShareToSina, UMShareToQQ, UMShareToRenren, nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNavigationBar];

    NSArray * titleArray = [NSArray arrayWithObjects:@"新浪微博", @"QQ", @"人人", nil];
    NSArray * colorArray = [NSArray arrayWithObjects:@"#f82a28", @"#2ab2f8", @"#3484fd",nil];
    for (int i = 0; i < 3; i++)
    {
        LoginButton * button = [LoginButton buttonWithType:UIButtonTypeCustom
                                                     title:[titleArray objectAtIndex:i]
                                                 headImage:[UIImage imageNamed:[NSString stringWithFormat:@"Share_%d.png",i + 1]]];
        button.tag = i + 100;
        [button setFrame:CGRectMake(SPACE,
                                    self.view.frame.size.height / 3 + SPACE + (ICON_LENGTH + SPACE) * i,
                                    self.view.frame.size.width - SPACE * 2,
                                    ICON_LENGTH)];
        [button setBackgroundColor:[MyShowTools hexStringToColor:[colorArray objectAtIndex:i]]];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.view addSubview:button];
    }

}


- (void)initNavigationBar
{
    self.title = @"登陆";
    //初始化返回按钮
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
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 第三方注册/登陆
- (void)buttonClick:(UIButton *)sender
{
    [UMSocialControllerService defaultControllerService].socialUIDelegate = self;
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:[_uMShareArray objectAtIndex:sender.tag - 100]];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //获取所有平台账号数据
        NSDictionary *snsAccountDic = [UMSocialAccountManager socialAccountDictionary];
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            //新浪微博
            if ([snsPlatform.platformName isEqualToString:UMShareToSina])
            {
                
                //如果是授权到新浪微博，SSO之后如果想获取用户的昵称、头像等需要再次获取一次账户信息
                [[UMSocialDataService defaultDataService] requestSocialAccountWithCompletion:^(UMSocialResponseEntity *accountResponse)
                 {
                     NSLog(@"accountResponse.data:%@",accountResponse.data);
                     NSDictionary * sinaDic = [[accountResponse.data objectForKey:@"accounts"] objectForKey:@"sina"];
                     
                     UserModel * model = [[UserModel alloc] init];
                     model.uid = [sinaDic objectForKey:@"usid"];
                     DATA_ENV.userUid = model.uid;
                     
                     model.nickname = [sinaDic objectForKey:@"username"];
                     model.headUrl = [sinaDic objectForKey:@"icon"];
                     model.type = @"sina";
                     DATA_ENV.type = model.type;
                     
                     NSDictionary * params = @{@"uid":model.uid,@"nickname":model.nickname,@"headUrl":model.headUrl,@"type":model.type};
                     
                     
                     [self startRegisterWithParams:params];
                     
                 }];
                
                
            }
            //QQ
            else if([snsPlatform.platformName isEqualToString:UMShareToQQ]){
                
                UMSocialAccountEntity *qqAccount = [snsAccountDic valueForKey:UMShareToQQ];
                
                UserModel * model = [[UserModel alloc] init];
                model.uid = qqAccount.usid;
                //uid需要放入请求头去注册
                DATA_ENV.userUid = model.uid;
                
                model.nickname = qqAccount.userName;
                model.headUrl = qqAccount.iconURL;
                model.type = qqAccount.platformName;
                DATA_ENV.type = model.type;
                
                NSDictionary * params = @{@"uid":model.uid,@"nickname":model.nickname,@"headUrl":model.headUrl,@"type":model.type};
                
                [self startRegisterWithParams:params];
                
                
            }
            //人人
            else{
                UMSocialAccountEntity *renrenAccount = [snsAccountDic valueForKey:UMShareToRenren];
                
                UserModel * model = [[UserModel alloc] init];
                model.uid = renrenAccount.usid;
                //uid需要放入请求头去注册
                DATA_ENV.userUid = model.uid;
                
                model.nickname = renrenAccount.userName;
                model.headUrl = renrenAccount.iconURL;
                model.type = renrenAccount.platformName;
                DATA_ENV.type = model.type;
                
                NSDictionary * params = @{@"uid":model.uid,@"nickname":model.nickname,@"headUrl":model.headUrl,@"type":model.type};
                
                [self startRegisterWithParams:params];
            }
        
        }else{
            NSError * error = [NSError errorWithDomain:[NSString stringWithFormat:@"%@认证失败",snsPlatform.platformName]
                                                  code:1
                                              userInfo:nil];
            NSLog(@"error:%@",error);

        }
    });
}


#pragma mark - 注册
- (void)startRegisterWithParams:(NSDictionary *)params
{
    [RegisterRequest requestWithParameters:params withIndicatorView:self.view withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
        
    } onRequestFinished:^(ITTBaseDataRequest *request) {
        NSLog(@"注册成功返回数据:%@",request.handleredResult);
        
        NSNumber * statusCode = [request.handleredResult objectForKey:@"code"];
        
        if (statusCode.longValue == 20000) {
            DATA_ENV.token = [[request.handleredResult objectForKey:@"resp"] objectForKey:@"token"];
            
            NSDictionary * loginParames = @{@"uid":DATA_ENV.userUid,@"type":[params objectForKey:@"type"]};
            [self startLoginWithParams:loginParames];
        }else{
            [RXUitils showHintMessage:@"登陆失败，请重试一次"];
        }

        
        
    } onRequestCanceled:^(ITTBaseDataRequest *request) {
        
    } onRequestFailed:^(ITTBaseDataRequest *request) {
    }];

}

#pragma mark - 登陆
- (void)startLoginWithParams:(NSDictionary *)params
{
    //登陆
    [LoginRequest requestWithParameters:params withIndicatorView:self.view withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
        
    } onRequestFinished:^(ITTBaseDataRequest *request) {
        
        NSLog(@"登陆成功返回数据:%@",request.handleredResult);
        UserModel * loginedUserModel = [[UserModel alloc] initWithDataDic:[[request.handleredResult objectForKey:@"resp"] objectForKey:@"user"]];
        
        [DATA_ENV setUserInfo:loginedUserModel];
        NSLog(@"userinfo:%@",DATA_ENV.userInfo);
        
        DATA_ENV.token = [[request.handleredResult objectForKey:@"resp"] objectForKey:@"token"];
        NSLog(@"token:%@",DATA_ENV.token);
        
        
        if (_didLoginSuccess) {
            _didLoginSuccess();
        }
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } onRequestCanceled:^(ITTBaseDataRequest *request) {
        
    } onRequestFailed:^(ITTBaseDataRequest *request) {
        
    }];
}

- (void)dealloc
{
    _didLoginSuccess = nil;
    _didRegisterSuccess = nil;
}

@end
