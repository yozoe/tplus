//
//  HomeViewController.m
//  MyShow
//
//  Created by max on 14-7-10.
//  Copyright (c) 2014年 maxingchuan. All rights reserved.
//

#import "HomeViewController.h"
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
#import "SearchViewController.h"
#import "UserPraiseRequest.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UserAtlasListAttentionRequest.h"

@interface HomeViewController ()
{
    NSInteger _selectedIndex;
    ITTPullTableView *_currentTableView;
    NSInteger _currentScrollPage;
    NSMutableDictionary *_sourceDic;
    NSMutableDictionary *_recommentHeightDic;
    NSMutableDictionary *_pageDic;
    NSMutableArray *_photoModelArray;
}

@property (strong, nonatomic, getter = getCurrentKey) NSString *currentKey;

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _selectedIndex = 0;
        _tableViewDataSource = [NSMutableArray array];
        _sourceDic = [NSMutableDictionary dictionary];
        _recommentHeightDic = [NSMutableDictionary dictionary];
        _pageDic = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (iOS7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    [self initViews];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)initViews
{
    [self addNavigationBar];
    [self addTitleSegmentedView];
    [self addMainScrollView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addNavigationBar
{
    self.navigationController.navigationBarHidden = YES;

    _navigationBar = [[MyShowNavigationBar alloc] initWithFrame:self.view.frame
                                                       ColorStr:[NSString stringWithUTF8String:"#BD0007"]];
    _navigationBar.titleLabel.text = @"T语言";

    [_navigationBar.rightButton setImage:[UIImage imageNamed:@"sousuo.png"] forState:UIControlStateNormal];
    _navigationBar.leftButton = nil;
    _navigationBar.delegate = self;
    [self.view addSubview:_navigationBar];
}


- (void)rightButtonClick
{
    SearchViewController * searchVC = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)addMainScrollView
{
    float scrollViewY = _titleSegmentedView.top + _titleSegmentedView.height;
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, scrollViewY, self.view.width, self.view.height - scrollViewY - 49)];
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.bounces = NO;
    _mainScrollView.delegate = self;
    [self.view addSubview:_mainScrollView];

    _titleArray = @[@"推荐", @"最新", @"关注"];

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

        [_pageDic setObject:@1 forKey:[NSString stringWithFormat:@"%d", i]];
    }
    [_mainScrollView setContentSize:CGSizeMake(_titleArray.count * 320, _mainScrollView.height)];

    _titleSegmentedView.sectionTitles = _titleArray;
    _titleSegmentedView.selectedSegmentIndex = 0;

    //    [self requestMainCellWithPageID:pageID andType:pageType andPage:@"1"];
    [self requestMainCellWithType:@"-3" andPage:@"1"];
}

#pragma mark - titleSegmentedView
- (void)addTitleSegmentedView
{
    _titleSegmentedView = [[HMSegmentedControl alloc] initWithSectionTitles:nil];
    _titleSegmentedView.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    _titleSegmentedView.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _titleSegmentedView.scrollEnabled = YES;
    _titleSegmentedView.selectionIndicatorColor = [MyShowTools hexStringToColor:@"#BD0007"];
    _titleSegmentedView.selectedTextColor = [MyShowTools hexStringToColor:@"#BD0007"];
    [_titleSegmentedView setFrame:CGRectMake(0, _navigationBar.frame.size.height + _navigationBar.frame.origin.y, self.view.frame.size.width, NAV_HEIGHT)];
    [_titleSegmentedView addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_titleSegmentedView];
}

#pragma mark - 请求item
- (void)requestMainCellWithType:(NSString *)typeStr andPage:(NSString *)page
{
    NSDictionary *parameter = @{@"page" : page, @"limit" : HOME_PAGE_SIZE, @"type" : typeStr};
    [HomeTagClickRequest requestWithParameters:parameter withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
    } onRequestFinished:^(ITTBaseDataRequest *request) {

        NSArray *itemsArray = [request.handleredResult objectForKey:@"models"];
        BOOL isAdd = page.integerValue > 1 ? YES : NO;
        [self fillTalbeViewSourceFromArray:itemsArray isAdd:isAdd];
        [self endLoadingData];

    } onRequestCanceled:^(ITTBaseDataRequest *request) {
    } onRequestFailed:^(ITTBaseDataRequest *request) {
    }];
}

- (void)requestAttentionCellWithPage:(NSString *)page
{
    NSDictionary *parameter = @{@"page" : page, @"limit" : HOME_PAGE_SIZE};
    [UserAtlasListAttentionRequest requestWithParameters:parameter withIndicatorView:nil onRequestFinished:^(ITTBaseDataRequest *request) {
        NSArray *itemsArray = [request.handleredResult objectForKey:@"models"];
        BOOL isAdd = page.integerValue > 1 ? YES : NO;
        [self fillTalbeViewSourceFromArray:itemsArray isAdd:isAdd];
        [self endLoadingData];
    }];
}

- (void)fillTalbeViewSourceFromArray:(NSArray *)array isAdd:(BOOL)isAdd
{
    NSMutableArray *heightArray = [_recommentHeightDic objectForKey:self.currentKey];
    if (!heightArray) {
        heightArray = [[NSMutableArray alloc] init];
    } else {
        if (!isAdd) {
            [heightArray removeAllObjects];
        }
    }

    for (int i = 0; i < array.count; i++) {
        ItemModel *im = array[i];
        CGSize  size = [im.atlas.content sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(300, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        [heightArray addObject:@((int)size.height + 16)];
    }
    [_recommentHeightDic setObject:heightArray forKey:self.currentKey];

    NSMutableArray *sourceArray = [_sourceDic objectForKey:self.currentKey];
    if (!sourceArray) {
        sourceArray = [[NSMutableArray alloc] initWithArray:array];
    } else {
        if (!isAdd) {
            [sourceArray removeAllObjects];
        }
        [sourceArray addObjectsFromArray:array];
    }
    //    NSMutableArray *tempSourceArray = [[NSMutableArray alloc] initWithArray:array];
    [_sourceDic setObject:sourceArray forKey:self.currentKey];

    [_currentTableView  reloadData];
}

#pragma mark - 切换标签触发的事件
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl
{
    [self changeIndex:segmentedControl.selectedSegmentIndex];
}

- (void)changeIndex:(NSInteger)index
{
    _selectedIndex = index;
    [_titleSegmentedView setSelectedSegmentIndex:index animated:YES];
    [_mainScrollView setContentOffset:CGPointMake(index * 320, 0) animated:YES];
    _currentTableView = (ITTPullTableView *)[_mainScrollView viewWithTag:index + 1000];

    NSArray *sourceArray = [_sourceDic objectForKey:self.currentKey];
    if (!sourceArray) {
        _currentTableView.pullTableIsRefreshing = YES;

        switch (index) {
            case 0:
            {
                [self requestMainCellWithType:@"-3" andPage:@"1"];
            }
                break;
            case 1:
            {
                [self requestMainCellWithType:@"-2" andPage:@"1"];
            }
                break;
            case 2:
            {
                [self requestAttentionCellWithPage:@"1"];
            }
                break;
        }
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
    return [[_sourceDic objectForKey:self.currentKey] count];
}

- (CGFloat)calculateRecommendCellHeightWithItemModel:(ItemModel *)itemModel indexPath:(NSIndexPath *)indexPath
{
    NSArray *heightArray = [_recommentHeightDic objectForKey:self.currentKey];

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
        case 6:
            bodyHeight = 213;
            break;
    }
    return headerHeight + bodyHeight + textHeight + footerHeight;
}

- (CGFloat)calculateItemCellHeightWithItemModel:(ItemModel *)itemModel indexPath:(NSIndexPath *)indexPath
{
    CoverKeyModel *ckm = [itemModel.coverKeyArray lastObject];
    NSArray *sizeArray = [ckm.size componentsSeparatedByString:@"*"];
    NSInteger width = [sizeArray[0] integerValue];
    NSInteger height = [sizeArray[1] integerValue];

    NSArray *heightArray = [_recommentHeightDic objectForKey:self.currentKey];
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
    NSArray *sourceArray = [_sourceDic objectForKey:self.currentKey];
    ItemModel *im = sourceArray[indexPath.row];
    if (_selectedIndex == 0) {
        return  [self calculateRecommendCellHeightWithItemModel:im indexPath:indexPath];
    } else {
        return [self calculateItemCellHeightWithItemModel:im indexPath:indexPath];
    }
}

- (void)requestPublishImgsWithPulishModel:(AtlasModel *)publishModel index:(NSInteger)index onFinished:(void(^)(NSArray *imgsArray))finishedBlock
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

    NSArray *sourceArray = [_sourceDic objectForKey:self.currentKey];
    NSArray *heightArray = [_recommentHeightDic objectForKey:self.currentKey];
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
        if (cell.itemModel.atlas.imageNum > 0 && im.atlas.imgsArray.count == 0) {
            [self requestPublishImgsWithPulishModel:cell.itemModel.atlas index:indexPath.row onFinished:^(NSArray *imgsArray) {
                if (imgsArray) {
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectedIndex == 0) {
        return;
    }

    NSArray *sourceArray = [_sourceDic objectForKey:self.currentKey];

    if (!_photoModelArray) {
        _photoModelArray = [[NSMutableArray alloc] init];
    }

    [_photoModelArray removeAllObjects];

    ItemModel *im = sourceArray[indexPath.row];
    if (!im.publish.imgsArray.count) {

        [self requestPublishImgsWithPulishModel:im.atlas index:indexPath.row onFinished:^(NSArray *imgsArray) {
            for (ImgsModel *imgModel in imgsArray) {
                MWPhoto *mp = [[MWPhoto alloc] initWithURL:[NSURL URLWithString:imgModel.url]];
                [_photoModelArray addObject:mp];
            }
            [self goToDetailViewWith:im imageIndex:0 showView:0];
        }];


    } else {
        for (ImgsModel *imgModel in im.atlas.imgsArray) {
            MWPhoto *mp = [[MWPhoto alloc] initWithURL:[NSURL URLWithString:imgModel.url]];
            [_photoModelArray addObject:mp];
        }
        [self goToDetailViewWith:im imageIndex:0 showView:0];
    }

    _selectedItemIndex = indexPath.row;
}

- (void)handleClickImageViewWithIndexPath:(NSIndexPath *)indexPath imageIndex:(NSInteger)imageIndex showView:(NSInteger)viewType
{
    NSArray *sourceArray = [_sourceDic objectForKey:self.currentKey];
    if (!_photoModelArray) {
        _photoModelArray = [[NSMutableArray alloc] init];
    }
    [_photoModelArray removeAllObjects];

    ItemModel *im = sourceArray[indexPath.row];
    if (!im.atlas.imgsArray.count) {
        [self requestPublishImgsWithPulishModel:im.atlas index:indexPath.row onFinished:^(NSArray *imgsArray) {
            for (ImgsModel *imgModel in imgsArray) {
                MWPhoto *mp = [[MWPhoto alloc] initWithURL:[NSURL URLWithString:imgModel.url]];
                [_photoModelArray addObject:mp];
            }
            [self goToDetailViewWith:im imageIndex:imageIndex showView:viewType];
        }];
    } else {
        for (ImgsModel *imgModel in im.atlas.imgsArray) {
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
    switch (_selectedIndex) {
        case 0:
        {
            [self requestMainCellWithType:@"-3" andPage:@"1"];
        }
            break;
        case 1:
        {
            [self requestMainCellWithType:@"-2" andPage:@"1"];
        }
            break;
        case 2:
        {
            [self requestAttentionCellWithPage:@"1"];
        }
            break;
    }

}

- (void)pullTableViewDidTriggerLoadMore:(ITTPullTableView*)pullTableView
{
    NSInteger page = [[_pageDic objectForKey:self.currentKey] integerValue];
    page++;
    [_pageDic setObject:@(page) forKey:self.currentKey];

    switch (_selectedIndex) {
        case 0:
        {
            [self requestMainCellWithType:@"-3" andPage:[NSString stringWithFormat:@"%d", page]];
        }
            break;
        case 1:
        {
            [self requestMainCellWithType:@"-2" andPage:[NSString stringWithFormat:@"%d", page]];
        }
            break;
        case 2:
        {
            [self requestAttentionCellWithPage:[NSString stringWithFormat:@"%d", page]];
        }
            break;
    }

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

- (NSString *)getCurrentKey
{
    return [NSString stringWithFormat:@"%d", _selectedIndex];
}

@end
