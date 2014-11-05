//
//  SearchTagListViewController.m
//  MyShow
//
//  Created by max on 14-8-27.
//  Copyright (c) 2014年 maxingchuan. All rights reserved.
//

#import "SearchTagListViewController.h"
#import "MyShowNavigationBar.h"
#import "HomeListRequest.h"
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
#import "HomeListRequest.h"
#import "DistributeViewController.h"
#import "CTAssetsPickerController.h"
#import "HomeRecommendCell.h"
#import "ImageListRequest.h"
#import "PersonalHomePageViewController.h"
#import "SearchViewController.h"
#import "UserPraiseRequest.h"
#import "AtlasModel.h"
#import "SearchTagListRequest.h"

#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UserAtlasListAttentionRequest.h"

@interface SearchTagListViewController ()
{
    NSMutableArray * _sourceArray;

    NSMutableArray * _heightArray;
    NSMutableArray *_photoModelArray;
    int _pageIndex;
}
@end

@implementation SearchTagListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _tableViewDataSource = [NSMutableArray array];
        _sourceArray = [NSMutableArray array];
        _heightArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initNavigationBar];
    
    [self addTableView];
}



//- (void)addNavigationBar
//{
//    self.navigationController.navigationBarHidden = YES;
//    
//    _navigationBar = [[MyShowNavigationBar alloc] initWithFrame:self.view.frame
//                                                       ColorStr:[NSString stringWithUTF8String:"#BD0007"]];
//    
//    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"top_navigation_back"] forState:UIControlStateNormal];
//    _navigationBar.rightButton = nil;
//    _navigationBar.delegate = self;
//    [self.view addSubview:_navigationBar];
//}
- (void)initNavigationBar
{
    self.title = _tagModel.name;
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
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}



- (void)addTableView
{
    _tableView = [[ITTPullTableView alloc] initWithFrame:CGRectMake(0,_navigationBar.bottom,self.view.frame.size.width,self.view.height - 64)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    _tableView.tag = 1000;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.pullDelegate = self;
    [self.view addSubview:_tableView];
        
    _pageIndex = 1;

    NSString *pageID = _tagModel.ID;
    [self requestMainCellWithPageID:pageID andPage:@"1"];
}

#pragma mark - 请求item
- (void)requestMainCellWithPageID:(NSString *)pageID andPage:(NSString *)page
{
    NSDictionary *parameter = @{@"page" : page, @"limit" : HOME_PAGE_SIZE, @"labelId" : pageID};
    [SearchTagListRequest requestWithParameters:parameter withIndicatorView:self.view withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
        
    } onRequestFinished:^(ITTBaseDataRequest *request) {
        
        NSArray *itemsArray = [request.handleredResult objectForKey:@"models"];
        BOOL isAdd = page.integerValue > 1 ? YES : NO;
        [self fillTalbeViewSourceFromArray:itemsArray isAdd:isAdd];
        
        [self endLoadingData];
        
    } onRequestCanceled:^(ITTBaseDataRequest *request) {
        
    } onRequestFailed:^(ITTBaseDataRequest *request) {
        
    }];
}

- (void)fillTalbeViewSourceFromArray:(NSArray *)array isAdd:(BOOL)isAdd
{
    if (!_heightArray) {
        _heightArray = [[NSMutableArray alloc] initWithArray:array];
    }else{
        if (!isAdd) {
            [_heightArray removeAllObjects];
        }
    }
    
    
    for (int i = 0; i < array.count; i++) {
        ItemModel *im = array[i];
        CGSize  size = [im.atlas.content sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(300, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        [_heightArray addObject:@((int)size.height + 16)];
    }
    

    if (!_sourceArray) {
        _sourceArray = [[NSMutableArray alloc] initWithArray:array];
    } else {
        if (!isAdd) {
            [_sourceArray removeAllObjects];
        }
        [_sourceArray addObjectsFromArray:array];
    }
    
    [_tableView  reloadData];
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
    return [_sourceArray count];
}

- (CGFloat)calculateRecommendCellHeightWithItemModel:(ItemModel *)itemModel indexPath:(NSIndexPath *)indexPath tagModel:(TagModel *)tagModel
{
    NSInteger textHeight = [_heightArray[indexPath.row] integerValue];
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

- (CGFloat)calculateItemCellHeightWithItemModel:(ItemModel *)itemModel indexPath:(NSIndexPath *)indexPath
{
    CoverKeyModel *ckm = [itemModel.coverKeyArray lastObject];
    NSArray *sizeArray = [ckm.size componentsSeparatedByString:@"*"];
    CGFloat width = [sizeArray[0] floatValue];
    CGFloat height = [sizeArray[1] floatValue];
    
    NSInteger textHeight = [_heightArray[indexPath.row] integerValue];
    
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
    ItemModel *im = _sourceArray[indexPath.row];
    return [self calculateItemCellHeightWithItemModel:im indexPath:indexPath];
}

- (void)requestPublishImgsWithPulishModel:(AtlasModel *)publishModel index:(NSInteger)index onFinished:(void(^)(NSArray *imgsArray))finishedBlock
{
    [ImageListRequest requestWithParameters:@{@"atlasId" : publishModel.ID} withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
        
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
    

    ItemModel *im = _sourceArray[indexPath.row];
    

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
    
    cell.portraitHandleBlock = ^() {
        UserModel *um = im.user;
        PersonalHomePageViewController *pp = [PersonalHomePageViewController new];
        pp.isFromHomePage = YES;
        pp.user = um;
        [self.navigationController pushViewController:pp animated:YES];
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
    cell.incrementHeight = [_heightArray[indexPath.row] integerValue];
    [cell refresh];
    cell.shareButton.tag = indexPath.row;
    [cell.shareButton addTarget:self action:@selector(handleShareButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    return cell;

    
}


- (void)handleShareButtonEvent:(UIButton *)sender
{
    ItemModel *im = _sourceArray[sender.tag];
    CoverKeyModel *coverKeyModel = [im.coverKeyArray objectAtIndex:0];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://share.591ku.com/t?imageId=%@", coverKeyModel.ID]];
    
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:coverKeyModel.url]]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [UMSocialWechatHandler setWXAppId:@"wxd9a39c7122aa6516" url:[url absoluteString]];
        [UMSocialQQHandler setQQWithAppId:@"100424468" appKey:@"c7394704798a158208a74ab60104f0ba" url:[url absoluteString]];
        
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:UMENG_SDKKEY
                                          shareText:im.atlas.content
                                         shareImage:image
                                    shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatTimeline,UMShareToQQ,UMShareToWechatSession,UMShareToQzone,UMShareToRenren,UMShareToDouban,nil]
                                           delegate:nil];
    });
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
    
    if (!_photoModelArray) {
        _photoModelArray = [[NSMutableArray alloc] init];
    }
    
    [_photoModelArray removeAllObjects];
    
    ItemModel *im = _sourceArray[indexPath.row];
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
    if (!_photoModelArray) {
        _photoModelArray = [[NSMutableArray alloc] init];
    }
    [_photoModelArray removeAllObjects];
    
    ItemModel *im = _sourceArray[indexPath.row];
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

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    NSLog(@"%@",response.description);
}

#pragma mark - 上拉和下拉的回调
- (void)pullTableViewDidTriggerRefresh:(ITTPullTableView*)pullTableView
{
    NSString *pageID = _tagModel.ID;
    [self requestMainCellWithPageID:pageID andPage:@"1"];
}

- (void)pullTableViewDidTriggerLoadMore:(ITTPullTableView*)pullTableView
{
    NSInteger page = _pageIndex;
    page++;
    _pageIndex = page;
    NSString *pageID = _tagModel.ID;
    [self requestMainCellWithPageID:pageID andPage:[NSString stringWithFormat:@"%d", _pageIndex]];
}

- (void)endLoadingData
{
    if (_tableView.pullTableIsLoadingMore) {
        _tableView.pullTableIsLoadingMore = NO;
    }
    if (_tableView.pullTableIsRefreshing) {
        _tableView.pullTableIsRefreshing = NO;
    }
}


- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    ItemModel *im = _sourceArray[_selectedItemIndex];
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
