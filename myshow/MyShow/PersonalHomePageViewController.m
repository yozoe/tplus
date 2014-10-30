//
//  PersonalHomePageViewController.m
//  MyShow
//
//  Created by max on 14-8-4.
//  Copyright (c) 2014年 maxingchuan. All rights reserved.
//

#import "PersonalHomePageViewController.h"
#import "MoreViewController.h"
#import "LogingViewController.h"
#import "LoginRequest.h"
#import "AppDelegate.h"
#import "MyTabBarViewController.h"

#import "MyDistributeTagClickRequest.h"
#import "MyFavorateTagClickRequest.h"

#import "MyShowNavigationBar.h"
#import "MyShowDefine.h"
#import "CommodityClassificationScrollView.h"
#import "HomeItemCell.h"
#import "MyShowSegmentedView.h"
#import "MyShowTools.h"
#import "TagTableViewCell.h"
#import "DetailViewController.h"
#import "HMSegmentedControl.h"
#import "UMSocial.h"
#import "HeiShowMainTableBar.h"
#import "UIImageView+WebCache.h"
#import "HomeTagRequest.h"
#import "TagModel.h"
#import "HomeTagClickRequest.h"
#import "DistributeViewController.h"
#import "CTAssetsPickerController.h"
#import "HomeRecommendCell.h"
#import "DetailImgListRequest.h"
#import "PersonalHomePageViewController.h"
#import "UserPraiseRequest.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"

@interface PersonalHomePageViewController ()
{
    NSInteger _selectedIndex;
    ITTPullTableView *_currentTableView;
    NSInteger _currentScrollPage;
    NSMutableDictionary *_sourceDic;
    NSMutableDictionary *_recommentHeightDic;
    NSMutableArray *_photoModelArray;
    NSMutableDictionary *_pageDic;
}
@property (weak, nonatomic) IBOutlet UIView *HeaderView;
@property (strong, nonatomic, getter = getCurrentKey) NSString *currentKey;


@end

@implementation PersonalHomePageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _selectedIndex = 0;
        _tableViewDataSource = [NSMutableArray array];
        _sourceDic = [NSMutableDictionary dictionary];
        _recommentHeightDic = [NSMutableDictionary dictionary];
        _titleArray = @[@"发布",@"喜欢"];
        _pageDic = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if (!DATA_ENV.isHasUserInfo) {
        _noLoginView.hidden = NO;
        [self.view bringSubviewToFront:_noLoginView];
    }else{
        _noLoginView.hidden = YES;
//        [self reloadData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (iOS7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self addNavigationBar];
    [self initHeadImage];
    if (!DATA_ENV.isHasUserInfo) {
        //如果没有用户信息，就是没登陆，不再加载图集信息，只显示_noLoginView
    }else{
        //如果有用户信息
        //如果有token，才去登陆更新下token
        if (DATA_ENV.isHasToken) {
            [self refreshUserInfo];
        }
        
//        [self addTitleSegmentedView];
//        [self addMainScrollView];
//        [self initTableView];
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(distributeSccessAction:) name:NOTIFICATION_DISTRIBUTE_SUCCESS object:nil];
    
//    UITapGestureRecognizer * tapSelfView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickView:)];
//    [self.view addGestureRecognizer:tapSelfView];
}


//- (void)clickView:(UITapGestureRecognizer *)tap
//{
//    MyTabBarViewController * tabbar = [AppDelegate GetAppDelegate].tabBarController;
//    if (tabbar.isShowCameraView) {
//        [tabbar removeCameraView];
//    }
//}


#pragma mark - NSNotification action
- (void)distributeSccessAction:(NSNotification *)notification
{
    [_currentTableView reloadData];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addNavigationBar
{
    _navigationBar = [[MyShowNavigationBar alloc] initWithFrame:self.view.frame
                                                       ColorStr:[NSString stringWithUTF8String:"#BD0007"]];
    _navigationBar.titleLabel.text = @"我的主页";
    
    [_navigationBar.rightButton setImage:[UIImage imageNamed:@"Session_Multi_More_HL"] forState:UIControlStateNormal];
    
    _navigationBar.delegate = self;
    [self.view addSubview:_navigationBar];
}

- (void)initHeadImage
{
    _headImage.layer.masksToBounds = YES;
    _headImage.layer.cornerRadius = 23.0f;
    
    [_loginButton setBackgroundColor:[MyShowTools hexStringToColor:@"#BD0007"]];
}




#pragma mark - 登陆刷新Token
- (void)refreshUserInfo
{
    //如果有Token,直接登陆,更新下Token
    NSDictionary * loginParames = @{@"uid":DATA_ENV.userUid,@"type":DATA_ENV.type};
    [self startLoginWithParams:loginParames];
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
        
        //自动登陆成功加载页面所有数据
        [self reloadData];
        [self addTitleSegmentedView];
        [self addMainScrollView];
        [self initTableView];
        
    } onRequestCanceled:^(ITTBaseDataRequest *request) {
        
    } onRequestFailed:^(ITTBaseDataRequest *request) {
        
    }];
}


- (void)reloadData
{
    NSLog(@"DATA_ENV.userInfo:%@",DATA_ENV.userInfo);
    NSLog(@"DATA_ENV.token:%@",DATA_ENV.token);
    [self.headImage loadImage:DATA_ENV.userInfo.headUrl placeHolder:[UIImage imageNamed:@"NoHeaderImge"]];
    self.nameLabel.text = DATA_ENV.userInfo.nickname;
}




- (void)rightButtonClick
{
    MoreViewController * moreVC = [[MoreViewController alloc] init];
    moreVC.didLogoutSuccess = ^(){
        [_mainScrollView removeFromSuperview];
    };
    [self.navigationController pushViewController:moreVC animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)messageBtnClickAction:(UIButton *)sender {
}

#pragma mark -
#pragma mark 开启登陆
- (IBAction)jumpToLoginViewAction:(id)sender {
    [self jumpToLoginView];
}

#pragma mark 登陆成功回调
- (void)didLoginOrRegisterSuccess
{
    //手动登陆成功加载页面所有数据
    [self reloadData];
    [self addTitleSegmentedView];
    [self addMainScrollView];
    [self initTableView];
}


#pragma mark - titleSegmentedView
- (void)addTitleSegmentedView
{
    _segmentedView = [[HMSegmentedControl alloc] initWithSectionTitles:_titleArray];
    _segmentedView.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    _segmentedView.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _segmentedView.scrollEnabled = YES;
    _segmentedView.selectionIndicatorColor = [MyShowTools hexStringToColor:@"#BD0007"];
    _segmentedView.selectedTextColor = [MyShowTools hexStringToColor:@"#BD0007"];
    [_segmentedView setFrame:CGRectMake(0, _HeaderView.bottom - 5, self.view.frame.size.width, NAV_HEIGHT)];
    [_segmentedView addTarget:self action:@selector(segmentedCtrlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_segmentedView];
    
}

#pragma mark - mainScrollView
- (void)addMainScrollView
{
    float scrollViewY = _segmentedView.top + _segmentedView.height;
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, scrollViewY, self.view.width, self.view.height - scrollViewY - 49)];
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.bounces = NO;
    _mainScrollView.delegate = self;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_mainScrollView];
    
}

- (void)initTableView
{
    for (int i = 0; i < _titleArray.count; i++) {
        ITTPullTableView *tableView = [[ITTPullTableView alloc] initWithFrame:CGRectMake(i * 320,
                                                                                         0,
                                                                                         self.view.frame.size.width,
                                                                                         _mainScrollView.height)];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (i == 0) {
            _currentTableView = tableView;
        }
        tableView.tag = 1000 + i;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.pullDelegate = self;
        [_mainScrollView addSubview:tableView];
        
        [_pageDic setObject:@1 forKey:_titleArray[i]];
    }
    
    
    [_mainScrollView setContentSize:CGSizeMake(_titleArray.count * 320, _mainScrollView.height)];
    _segmentedView.sectionTitles = _titleArray;
    _segmentedView.selectedSegmentIndex = 0;
    
    NSString *pageType = [self.titleArray objectAtIndex:_selectedIndex];
    
    [self requestMainCellWithType:pageType andPage:@"1"];
}

#pragma mark - 请求item
- (void)requestMainCellWithType:(NSString *)typeStr andPage:(NSString *)page
{
    if ([typeStr isEqualToString:@"发布"]) {
        NSDictionary *parameter = @{@"page" : page, @"limit" : HOME_PAGE_SIZE, @"userId" : DATA_ENV.userInfo.uid};
        NSLog(@"DATA_ENV.userUid:%@",DATA_ENV.userUid);
        NSLog(@"DATA_ENV.userInfo.uid:%@",DATA_ENV.userInfo.uid);
        [MyDistributeTagClickRequest requestWithParameters:parameter withIndicatorView:self.view withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
            
        } onRequestFinished:^(ITTBaseDataRequest *request) {
            
            NSArray *itemsArray = [request.handleredResult objectForKey:@"models"];
            BOOL isAdd = page.integerValue > 1 ? YES : NO;
            [self fillTalbeViewSourceFromArray:itemsArray type:typeStr isAdd:isAdd];
            
            [self endLoadingData];
            
        } onRequestCanceled:^(ITTBaseDataRequest *request) {
            
        } onRequestFailed:^(ITTBaseDataRequest *request) {
            
        }];
    }else{
        NSDictionary *parameter = @{@"page" : page, @"limit" : HOME_PAGE_SIZE, @"userId" : DATA_ENV.userUid};
        [MyFavorateTagClickRequest requestWithParameters:parameter withIndicatorView:self.view withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
            
        } onRequestFinished:^(ITTBaseDataRequest *request) {
            
            NSArray *itemsArray = [request.handleredResult objectForKey:@"models"];
            BOOL isAdd = page.integerValue > 1 ? YES : NO;
            [self fillTalbeViewSourceFromArray:itemsArray type:typeStr isAdd:isAdd];
            [self endLoadingData];
            
        } onRequestCanceled:^(ITTBaseDataRequest *request) {
            
        } onRequestFailed:^(ITTBaseDataRequest *request) {
            
        }];
    }
    
}

- (void)fillTalbeViewSourceFromArray:(NSArray *)array type:typeStr isAdd:(BOOL)isAdd
{
    NSMutableArray *heightArray = [_recommentHeightDic objectForKey:typeStr];
    if (!heightArray) {
        heightArray = [[NSMutableArray alloc] init];
    } else {
        if (!isAdd) {
            [heightArray removeAllObjects];
        }
    }
    //    NSMutableArray *tempHeightArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < array.count; i++) {
        ItemModel *im = array[i];
        CGSize  size = [im.publish.publistext sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(300, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        //        [tempHeightArray addObject:@((int)size.height + 16)];
        [heightArray addObject:@((int)size.height + 16)];
    }
    [_recommentHeightDic setObject:heightArray forKey:typeStr];
    
    NSMutableArray *sourceArray = [_sourceDic objectForKey:typeStr];
    if (!sourceArray) {
        sourceArray = [[NSMutableArray alloc] initWithArray:array];
    } else {
        if (!isAdd) {
            [sourceArray removeAllObjects];
        }
        [sourceArray addObjectsFromArray:array];
    }
    //    NSMutableArray *tempSourceArray = [[NSMutableArray alloc] initWithArray:array];
    [_sourceDic setObject:sourceArray forKey:typeStr];
    [_currentTableView  reloadData];
}



#pragma mark - HeiShowManagerDelegate
- (void)homeTitleFinishedWithArray:(NSArray *)array
{
    self.titleArray = [array copy];
    
    NSMutableArray * sectionArray = [NSMutableArray arrayWithCapacity:0];
    
    for (id obj in self.titleArray)
    {
        if ([obj isKindOfClass:[NSString class]])
        {
            [sectionArray addObject:obj];
        }
    }
    _segmentedView.sectionTitles = sectionArray;
    
    NSString * type = [self.titleArray objectAtIndex:_selectedIndex];
    
    
    [self requestMainCellWithType:type andPage:[_pageDic objectForKey:type]];
}


#pragma mark - 切换标签触发的事件
- (void)segmentedCtrlChangedValue:(HMSegmentedControl *)segmentedControl
{
    [self changeIndex:segmentedControl.selectedSegmentIndex];
}

- (void)changeIndex:(NSInteger)index
{
    _selectedIndex = index;
    [_segmentedView setSelectedSegmentIndex:index animated:YES];
    NSString *pageType = [self.titleArray objectAtIndex:index];
    [_mainScrollView setContentOffset:CGPointMake(index * 320, 0) animated:YES];
    _currentTableView = (ITTPullTableView *)[_mainScrollView viewWithTag:index + 1000];
    
    NSString * type = [_titleArray objectAtIndex:_selectedIndex];
    
    NSArray *sourceArray = [_sourceDic objectForKey:type];
    if (!sourceArray) {
        [self requestMainCellWithType:pageType andPage:@"1"];
    }
}

- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
}


#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString * type = _titleArray[_selectedIndex];
    return [[_sourceDic objectForKey:type] count];
}

- (CGFloat)calculateRecommendCellHeightWithItemModel:(ItemModel *)itemModel indexPath:(NSIndexPath *)indexPath andType:(NSString *)type
{
    NSArray *heightArray = [_recommentHeightDic objectForKey:type];
    
    NSInteger textHeight = [heightArray[indexPath.row] integerValue];
    CGFloat headerHeight = 60.f;
    CGFloat bodyHeight = 0.f;
    CGFloat footerHeight = HOME_CELL_FOOT_HEIGHT;
    int imageCount = itemModel.atlas.imageNum.integerValue;
    if (imageCount > 6){
        imageCount = 6;
    }
    switch (imageCount) {
        case 1:
            bodyHeight = 320;
            break;
        case 2:
            bodyHeight = 160;
            break;
        case 3:
            bodyHeight = 106;
            break;
        case 4:
            bodyHeight = 321;
            break;
        case 5:
            bodyHeight = 213;
        case 6:
            bodyHeight = 213;
            break;
    }
    return headerHeight + bodyHeight + textHeight + footerHeight;
}

- (CGFloat)calculateItemCellHeightWithItemModel:(ItemModel *)itemModel indexPath:(NSIndexPath *)indexPath andType:(NSString *)type
{
    CoverKeyModel *ckm = [itemModel.coverKeyArray lastObject];
    NSArray *sizeArray = [ckm.size componentsSeparatedByString:@"*"];
    CGFloat width = [sizeArray[0] floatValue];
    CGFloat height = [sizeArray[1] floatValue];
    
    NSArray *heightArray = [_recommentHeightDic objectForKey:type];
    NSInteger textHeight = [heightArray[indexPath.row] integerValue];
    
    NSInteger imageHeight;
    
    if (width == height) {
        imageHeight = 320;
    } else {
        imageHeight = 320 * height / width;
    }
    
    return textHeight + 60 + imageHeight + HOME_CELL_FOOT_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * type = [_titleArray objectAtIndex:_selectedIndex];
    NSArray *sourceArray = [_sourceDic objectForKey:type];
    ItemModel *im = sourceArray[indexPath.row];
    if (_selectedIndex == 0) {
        return  [self calculateRecommendCellHeightWithItemModel:im indexPath:indexPath andType:type];
    } else {
        return [self calculateItemCellHeightWithItemModel:im indexPath:indexPath andType:type];
    }
    return 0.f;
}

- (void)requestPublishImgsWithPulishModel:(PublishModel *)publishModel index:(NSInteger)index onFinished:(void(^)(NSArray *imgsArray))finishedBlock
{
    
    [DetailImgListRequest requestWithParameters:@{@"atlasId" : publishModel.ID} withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
        
    } onRequestFinished:^(ITTBaseDataRequest *request) {
        
        NSArray *itemsArray = [request.handleredResult objectForKey:@"models"];
        finishedBlock(itemsArray);
        
    } onRequestCanceled:^(ITTBaseDataRequest *request) {
        
    } onRequestFailed:^(ITTBaseDataRequest *request) {
        
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *itemIdentifier = @"HomeItemCell";
    static NSString *recommendIdentifier = @"HomeRecommendCell";
    
    NSString * type = [_titleArray objectAtIndex:_selectedIndex];
    NSArray *sourceArray = [_sourceDic objectForKey:type];
    NSArray *heightArray = [_recommentHeightDic objectForKey:type];
    ItemModel *im = sourceArray[indexPath.row];
    
    if (_selectedIndex == 0) {
        HomeRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:recommendIdentifier];
        
        if (!cell) {
            cell = [[HomeRecommendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:recommendIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.commentBlock = ^() {
            [self handleClickImageViewWithIndexPath:indexPath imageIndex:0 showView:2];
        };
        
        cell.tagBlock = ^() {
            [self handleClickImageViewWithIndexPath:indexPath imageIndex:0 showView:1];
        };
        
        __block HomeRecommendCell *recommendCell = cell;
        cell.favourBlock = ^() {
            
            if (im.isLike.integerValue) {
                
                [self praiseCancelWithAtlasID:im.atlas.ID completion:^(BOOL finished, NSString *result) {
                    if (finished) {
                        im.isLike = @"0";
                        [recommendCell refresh];
                    }
                }];
                
            } else {
                [self praiseAddWithAtlasID:im.atlas.ID completion:^(BOOL finished, NSString *result) {
                    if (finished) {
                        if ([result isEqualToString:@"selfSuccess"]) {
                            im.isLike = @"1";
                        }
                        im.atlas.praiseNum = [NSString stringWithFormat:@"%d", im.atlas.praiseNum.integerValue + 1];
                        [recommendCell refresh];
                    }
                }];
            }
        };
        
        cell.imageViewClickHandlerBlock = ^(NSInteger tag) {
            [self handleClickImageViewWithIndexPath:indexPath imageIndex:tag showView:0];
        };
        
        cell.itemModel = im;
        
        cell.incrementHeight = [heightArray[indexPath.row] integerValue];
        if (cell.itemModel.atlas.imageNum > 0) {
            [self requestPublishImgsWithPulishModel:cell.itemModel.atlas index:indexPath.row onFinished:^(NSArray *imgsArray) {
                if (imgsArray) {
                    [cell.itemModel.atlas.imgsArray removeAllObjects];
                    [cell.itemModel.atlas.imgsArray addObjectsFromArray:imgsArray];
                    [cell refresh];
                }
            }];
        }
        [cell refresh];
        cell.shareButton.tag = indexPath.row;
        [cell.shareButton addTarget:self action:@selector(handleShareButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    } else {
        HomeItemCell * cell = [tableView dequeueReusableCellWithIdentifier:itemIdentifier];
        if (nil == cell)
        {
            cell = [[HomeItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:itemIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.commentBlock = ^() {
            [self handleClickImageViewWithIndexPath:indexPath imageIndex:0 showView:2];
        };
        
        cell.tagBlock = ^() {
            [self handleClickImageViewWithIndexPath:indexPath imageIndex:0 showView:1];
        };
        
        __block HomeItemCell *itemCell = cell;
        cell.favourBlock = ^() {
            
            if (im.isLike.integerValue) {
                
                [self praiseCancelWithAtlasID:im.atlas.ID completion:^(BOOL finished, NSString *result) {
                    if (finished) {
                        im.isLike = @"0";
                        [itemCell refresh];
                    }
                }];
                
            } else {
                [self praiseAddWithAtlasID:im.atlas.ID completion:^(BOOL finished, NSString *result) {
                    if (finished) {
                        if ([result isEqualToString:@"selfSuccess"]) {
                            im.isLike = @"1";
                        }
                        im.atlas.praiseNum = [NSString stringWithFormat:@"%d", im.atlas.praiseNum.integerValue + 1];
                        [itemCell refresh];
                    }
                }];
            }
        };
        cell.itemModel = im;
        cell.incrementHeight = [heightArray[indexPath.row] integerValue];
        [cell refresh];
        cell.shareButton.tag = indexPath.row;
        [cell.shareButton addTarget:self action:@selector(handleShareButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }

    
    return nil;
    
}


- (void)handleShareButtonEvent:(UIButton *)sender
{
    TagModel *tm = [_titleArray objectAtIndex:_selectedIndex];
    NSArray *sourceArray = [_sourceDic objectForKey:self.currentKey];
    ItemModel *im = sourceArray[sender.tag];
    ImgsModel *imageModel = [im.atlas.imgsArray objectAtIndex:0];
    
    NSURL *url = [NSURL URLWithString:[REQUEST_DOMAIN stringByAppendingString:[NSString stringWithFormat:@"share/view?imageId=%@", imageModel.ID]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSOperationQueue *operationQueue=[[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:operationQueue
                           completionHandler:^(NSURLResponse*urlResponce,NSData*data,NSError*error) {
                               if(!error) {
                                   NSString *responseString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
                                   NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\bhttps?://[a-zA-Z0-9\\-.]+(?::(\\d+))?(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?" options:0 error:&error];
                                   
                                   if (regex != nil) {
                                       NSTextCheckingResult *firstMatch = [regex firstMatchInString:responseString options:0 range:NSMakeRange(0, [responseString length])];
                                       if (firstMatch) {
                                           [UMSocialWechatHandler setWXAppId:@"wxd9a39c7122aa6516" url:responseString];
                                           [UMSocialQQHandler setQQWithAppId:@"100424468" appKey:@"c7394704798a158208a74ab60104f0ba" url:responseString];
                                           dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                               UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageModel.url]]];
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   [UMSocialSnsService presentSnsIconSheetView:self
                                                                                        appKey:UMENG_SDKKEY
                                                                                     shareText:im.publish.publistext
                                                                                    shareImage:image
                                                                               shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatTimeline,UMShareToQQ,UMShareToWechatSession,UMShareToQzone,UMShareToRenren,UMShareToDouban,nil]
                                                                                      delegate:nil];
                                               });
                                           });
                                       }
                                   }
                               }
                           }];
}

- (void)praiseAddWithAtlasID:(NSString *)atlasID completion:(void (^)(BOOL finished, NSString *result))completion
{
    BOOL selfPraise = NO;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:atlasID forKey:@"atlasId"];
    if (DATA_ENV.userInfo) {
        [parameters setObject:DATA_ENV.userInfo.ID forKey:@"userId"];
        selfPraise = YES;
    }
    [UserPraiseAddRequest requestWithParameters:parameters withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
        
    } onRequestFinished:^(ITTBaseDataRequest *request) {
        if ([[request.handleredResult objectForKey:@"code"] integerValue] == 20000) {
            if (selfPraise) {
                completion(YES, @"selfSuccess");
            } else {
                completion(YES, @"customerSuccess");
            }
        }
    } onRequestCanceled:^(ITTBaseDataRequest *request) {
        
    } onRequestFailed:^(ITTBaseDataRequest *request) {
        
    }];
}


- (void)praiseCancelWithAtlasID:(NSString *)atlasID completion:(void (^)(BOOL finished, NSString *result))completion
{
    [UserPraiseCancelRequest requestWithParameters:@{@"atlasId" : atlasID} withIndicatorView:nil withCancelSubject:nil onRequestFinished:^(ITTBaseDataRequest *request) {
        completion(YES, @"");
    }];
}


//#pragma mark - 请求喜欢和不喜欢
//- (void)detailLikeWithPublishID:(NSString *)pid action:(NSString *)action completion:(void (^)(BOOL finished, NSString *actionResult))completion
//{
//    NSDictionary *parameter = @{@"pubId" : pid, @"action" : action};
//    [UserPraiseAddRequest requestWithParameters:parameter withIndicatorView:self.view withCancelSubject:nil onRequestFinished:^(ITTBaseDataRequest *request) {
//        if ([[request.handleredResult objectForKey:@"respResult"] integerValue] == 1) {
//            completion(YES, @"1");
//        } else {
//            completion(YES, @"0");
//        }
//    }];
//}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectedIndex == 0) {
        return;
    }
    NSString * type = [_titleArray objectAtIndex:_selectedIndex];
    NSArray *sourceArray = [_sourceDic objectForKey:type];
    
    if (!_photoModelArray) {
        _photoModelArray = [[NSMutableArray alloc] init];
    }
    
    [_photoModelArray removeAllObjects];
    
    ItemModel *im = sourceArray[indexPath.row];
    if (!im.publish.imgsArray.count) {
        
        [self requestPublishImgsWithPulishModel:im.publish index:indexPath.row onFinished:^(NSArray *imgsArray) {
            for (ImgsModel *imgModel in imgsArray) {
                MWPhoto *mp = [[MWPhoto alloc] initWithURL:[NSURL URLWithString:imgModel.url]];
                [_photoModelArray addObject:mp];
            }
            [self goToDetailViewWith:im imageIndex:0 showView:0];
        }];
        
        
    } else {
        for (ImgsModel *imgModel in im.publish.imgsArray) {
            MWPhoto *mp = [[MWPhoto alloc] initWithURL:[NSURL URLWithString:imgModel.url]];
            [_photoModelArray addObject:mp];
        }
        [self goToDetailViewWith:im imageIndex:0 showView:0];
    }
    
    _selectedItemIndex = indexPath.row;
}



- (void)handleClickImageViewWithIndexPath:(NSIndexPath *)indexPath imageIndex:(NSInteger)imageIndex showView:(NSInteger)viewType
{
    NSString * type = [_titleArray objectAtIndex:_selectedIndex];
    NSArray *sourceArray = [_sourceDic objectForKey:type];
    if (!_photoModelArray) {
        _photoModelArray = [[NSMutableArray alloc] init];
    }
    [_photoModelArray removeAllObjects];
    
    ItemModel *im = sourceArray[indexPath.row];
    if (!im.publish.imgsArray.count) {
        [self requestPublishImgsWithPulishModel:im.publish index:indexPath.row onFinished:^(NSArray *imgsArray) {
            for (ImgsModel *imgModel in imgsArray) {
                MWPhoto *mp = [[MWPhoto alloc] initWithURL:[NSURL URLWithString:imgModel.url]];
                [_photoModelArray addObject:mp];
            }
            [self goToDetailViewWith:im imageIndex:imageIndex showView:viewType];
        }];
    } else {
        for (ImgsModel *imgModel in im.publish.imgsArray) {
            MWPhoto *mp = [[MWPhoto alloc] initWithURL:[NSURL URLWithString:imgModel.url]];
            [_photoModelArray addObject:mp];
        }
        [self goToDetailViewWith:im imageIndex:imageIndex showView:viewType];
    }
    _selectedItemIndex = indexPath.row;
}

- (void)goToDetailViewWith:(ItemModel *)item imageIndex:(NSInteger)imageIndex showView:(NSInteger)viewType
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.3];
    [animation setType: kCATransitionFade];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [self.navigationController.view.layer addAnimation:animation forKey:nil];
    DetailViewController * dvc = [[DetailViewController alloc] initWithDelegate:self];
    switch (viewType) {
        case 0:
            break;
        case 1:
            dvc.showTagView = YES;
            break;
        case 2:
            dvc.showCommentView = YES;
            break;
    }
    dvc.item = item;
    dvc.alwaysShowControls = NO;
    dvc.displayActionButton = NO;
    [dvc setCurrentPhotoIndex:imageIndex];
    [self.navigationController pushViewController:dvc animated:NO];
}



- (NSString *)makeTime:(NSNumber *)seconds
{
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[seconds intValue]];
    NSString * dateStr = [NSString stringWithFormat:@"%@",date];
    NSArray  * strArray = [dateStr componentsSeparatedByString:@" "];
    if (strArray && strArray.count) return [strArray objectAtIndex:0];
    
    return [NSString stringWithFormat:@"%@",seconds];
}

- (void)mainCellSegmentedViewClickAtIndex:(int)index
{
    if (index == 3)
    {
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:UMENG_SDKKEY
                                          shareText:@"T语言 已经在AppStore上线啦!"
                                         shareImage:[UIImage imageNamed:@"152.png"]
                                    shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatTimeline,UMShareToTencent,UMShareToRenren,UMShareToSina,nil]
                                           delegate:nil];
    }
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    NSLog(@"%@",response.description);
}

#pragma mark - 上拉和下拉的回调
- (void)pullTableViewDidTriggerRefresh:(ITTPullTableView*)pullTableView
{
    NSString *pageType = [self.titleArray objectAtIndex:_selectedIndex];
    [self requestMainCellWithType:pageType andPage:@"1"];
    
}

- (void)pullTableViewDidTriggerLoadMore:(ITTPullTableView*)pullTableView
{
    NSString * pageType = [self.titleArray objectAtIndex:_selectedIndex];
    NSInteger page = [[_pageDic objectForKey:pageType] integerValue];
    page++;
    [_pageDic setObject:@(page) forKey:pageType];

    [self requestMainCellWithType:pageType andPage:[NSString stringWithFormat:@"%d", page]];
}

- (void)endLoadingData
{
    if (_currentTableView.pullTableIsLoadingMore) {
        _currentTableView.pullTableIsLoadingMore = NO;
    }
    if (_currentTableView.pullTableIsRefreshing) {
        _currentTableView.pullTableIsRefreshing = NO;
    }
}


#pragma mark - scrollView delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_mainScrollView]) {
        NSInteger result = scrollView.contentOffset.x / 320;
        NSInteger index = 0;
        if (result != 0) {
            index = result;
        }
        _selectedIndex = index;
        [self changeIndex:index];
    }
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    NSArray *sourceArray = [_sourceDic objectForKey:self.currentKey];
    ItemModel *im = sourceArray[_selectedItemIndex];
    return im.atlas.imgsArray.count ? im.atlas.imgsArray.count : _photoModelArray.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    return _photoModelArray[index];
}

- (void)photoBrowser:(DetailViewController *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index
{
    [photoBrowser updatePhotoIndexViewWithIndex:index];
}


@end
