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

@end

@implementation LogingViewController

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
    
    NSArray * titleArray = [NSArray arrayWithObjects:@"新浪微博", @"QQ", @"人人", nil];
    NSArray * colorArray = [NSArray arrayWithObjects:@"#f82a28", @"#2ab2f8", @"#3484fd",nil];
    for (int i = 0; i < 3; i++)
    {
        LoginButton * button = [LoginButton buttonWithType:UIButtonTypeCustom
                                                     title:[titleArray objectAtIndex:i]
                                                 headImage:[UIImage imageNamed:[NSString stringWithFormat:@"Share_%d.png",i + 1]]];
        button.tag = i + 33;
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

- (void)addNavigationBar
{
    _navigationBar = [[MyShowNavigationBar alloc] initWithFrame:self.view.frame
                                                       ColorStr:[NSString stringWithUTF8String:"#BD0007"]];
    _navigationBar.titleLabel.text = @"登陆";
    
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"top_navigation_back"] forState:UIControlStateNormal];
    
    _navigationBar.delegate = self;
    [self.view addSubview:_navigationBar];
}


- (void)leftButtonClick
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
    
    NSArray * arrar = [NSArray arrayWithObjects:UMShareToSina, UMShareToTencent, UMShareToRenren, nil];
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:[arrar objectAtIndex:sender.tag - 33]];
    
//    //如果没有Token,先注册,再登陆
//    if (!DATA_ENV.isHasToken)
//    {
        snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,
                                      ^(UMSocialResponseEntity *response)
                                      {
                                          //新浪微博
                                          if ([snsPlatform.platformName isEqualToString:UMShareToSina])
                                          {
                                              //如果是授权到新浪微博，SSO之后如果想获取用户的昵称、头像等需要再次获取一次账户信息
                                              [[UMSocialDataService defaultDataService] requestSocialAccountWithCompletion:^(UMSocialResponseEntity *accountResponse)
                                               {
                                                   NSLog(@"accountResponse.data:%@",accountResponse.data);
                                                   NSDictionary * sinaDic = [[accountResponse.data objectForKey:@"accounts"] objectForKey:@"sina"];
                                                   
                                                   UserModel * model = [[UserModel alloc] init];
                                                   model.uid = [accountResponse.data objectForKey:@"uid"];
                                                   DATA_ENV.userUid = model.uid;
                                                   
                                                   model.nickname = [sinaDic objectForKey:@"username"];
                                                   model.headUrl = [sinaDic objectForKey:@"icon"];
                                                   model.type = @"sina";
                                                   DATA_ENV.type = model.type;
                                                   
                                                   NSDictionary * params = @{@"uid":model.uid,@"nickname":model.nickname,@"headUrl":model.headUrl,@"type":model.type};
                                                   
                                                   
                                                   
//                                                   NSLog(@"查看请求头数据对不对location:%@",DATA_ENV.location);
//                                                   NSLog(@"查看请求头数据对不对did:%@",DATA_ENV.did);
//                                                   NSLog(@"查看请求头数据对不对brand:%@",DATA_ENV.platformString);
//                                                   NSLog(@"查看请求头数据对不对ll:%@*%@",DATA_ENV.longitude, DATA_ENV.latitude);
                                                
                                                   [self startRegisterWithParams:params];
                                               }];
                                          }else{
                                              
                                              NSLog(@"response:%@",response);
                                              //腾讯微博/人人
                                              NSDictionary * dict = [UMSocialAccountManager socialAccountDictionary];
                                              NSLog(@"dict:%@",dict);
                                              UMSocialAccountEntity * entity = [dict valueForKey:snsPlatform.platformName];
                                              NSLog(@"entity:%@",entity);
                                              NSString * type = nil;
                                              if ([entity.platformName isEqualToString:@"tencent"]) {
                                                  type = @"qq";
                                                  DATA_ENV.type = type;
                                              }else{
                                                  type = @"renren";
                                                  DATA_ENV.type = type;
                                              }
                                              if (nil != entity.accessToken)
                                              {
                                                  UserModel * model = [[UserModel alloc] init];
                                                  model.uid = entity.accessToken;
                                                  
                                                  //uid需要放入请求头去注册
                                                  DATA_ENV.userUid = model.uid;
                                                  model.nickname = entity.userName;
                                                  model.headUrl = entity.iconURL;
                                                  
                                                  NSDictionary * params = @{@"uid":model.uid,@"nickname":model.nickname,@"headUrl":model.headUrl,@"type":type};
                                                  
//                                                  NSLog(@"查看请求头数据对不对location:%@",DATA_ENV.location);
//                                                  NSLog(@"查看请求头数据对不对did:%@",DATA_ENV.did);
//                                                  NSLog(@"查看请求头数据对不对brand:%@",DATA_ENV.platformString);
//                                                  NSLog(@"查看请求头数据对不对ll:%@*%@",DATA_ENV.longitude, DATA_ENV.latitude);
                                                  [self startRegisterWithParams:params];
                                              }
                                              else
                                              {
                                                  NSError * error = [NSError errorWithDomain:[NSString stringWithFormat:@"%@认证失败",snsPlatform.platformName]
                                                                                        code:1
                                                                                    userInfo:nil];
                                                  NSLog(@"error:%@",error);
                                              }
                                          }
                                          
                                      });
//    }else{
//        
//        //如果有Token,直接登陆
//        NSDictionary * loginParames = @{@"uid":DATA_ENV.userUid,@"type":DATA_ENV.type};
//        //登陆
//        [self startLoginWithParams:loginParames];
//    }
    
}


#pragma mark - 注册
- (void)startRegisterWithParams:(NSDictionary *)params
{
    [RegisterRequest requestWithParameters:params withIndicatorView:self.view withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
        
    } onRequestFinished:^(ITTBaseDataRequest *request) {
        NSLog(@"注册成功返回数据:%@",request.handleredResult);

        DATA_ENV.token = [[request.handleredResult objectForKey:@"resp"] objectForKey:@"token"];
        
        NSDictionary * loginParames = @{@"uid":DATA_ENV.userUid,@"type":[params objectForKey:@"type"]};
        [self startLoginWithParams:loginParames];
        
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
