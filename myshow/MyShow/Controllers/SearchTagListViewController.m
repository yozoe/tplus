//
//  SearchTagListViewController.m
//  MyShow
//
//  Created by max on 14-8-27.
//  Copyright (c) 2014年 maxingchuan. All rights reserved.
//

#import "SearchTagListViewController.h"
#import "MyShowNavigationBar.h"
#import "HomeTagClickRequest.h"
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
#import "AtlasModel.h"

@interface SearchTagListViewController ()
{
    NSMutableArray * _sourceArray;
    NSMutableDictionary *_recommentHeightDic;
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
        _recommentHeightDic = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addNavigationBar];
    [self addTableView];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _navigationBar.titleLabel.text = _model.name;
}


- (void)addNavigationBar
{
    self.navigationController.navigationBarHidden = YES;
    
    _navigationBar = [[MyShowNavigationBar alloc] initWithFrame:self.view.frame
                                                       ColorStr:[NSString stringWithUTF8String:"#F92B51"]];
    
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"top_navigation_back"] forState:UIControlStateNormal];
    _navigationBar.rightButton = nil;
    _navigationBar.delegate = self;
    [self.view addSubview:_navigationBar];
}

- (void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
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

    NSString *pageID = _model.ID;
    NSString *pageType = _model.type;
    [self requestMainCellWithPageID:pageID andType:pageType andPage:@"1"];
}

#pragma mark - 请求item
- (void)requestMainCellWithPageID:(NSString *)cidStr andType:(NSString *)typeStr andPage:(NSString *)page
{
    NSDictionary *parameter = @{@"page" : page, @"limit" : HOME_PAGE_SIZE, @"type" : typeStr, @"cid" : cidStr};
    [HomeTagClickRequest requestWithParameters:parameter withIndicatorView:self.view withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
        
    } onRequestFinished:^(ITTBaseDataRequest *request) {
        
        NSArray *itemsArray = [request.handleredResult objectForKey:@"models"];
        BOOL isAdd = page.integerValue > 1 ? YES : NO;
        [self fillTalbeViewSourceFromArray:itemsArray type:typeStr isAdd:isAdd];
        [self endLoadingData];
        
    } onRequestCanceled:^(ITTBaseDataRequest *request) {
        
    } onRequestFailed:^(ITTBaseDataRequest *request) {
        
    }];
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
    
    for (int i = 0; i < array.count; i++) {
        ItemModel *im = array[i];
        CGSize  size = [im.atlas.content sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(300, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        [heightArray addObject:@((int)size.height + 16)];
    }
    [_recommentHeightDic setObject:heightArray forKey:typeStr];
    

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
    NSArray *heightArray = [_recommentHeightDic objectForKey:tagModel.type];
    
    NSInteger textHeight = [heightArray[indexPath.row] integerValue];
    CGFloat headerHeight = 60.f;
    CGFloat bodyHeight = 0.f;
    CGFloat footerHeight = HOME_CELL_FOOT_HEIGHT;
    int imageCount = itemModel.atlas.imageNum;
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

- (CGFloat)calculateItemCellHeightWithItemModel:(ItemModel *)itemModel indexPath:(NSIndexPath *)indexPath tagModel:(TagModel *)tagModel
{
    CoverKeyModel *ckm = [itemModel.coverKeyArray lastObject];
    NSArray *sizeArray = [ckm.size componentsSeparatedByString:@"*"];
    NSInteger width = [sizeArray[0] integerValue];
    NSInteger height = [sizeArray[1] integerValue];
    
    NSArray *heightArray = [_recommentHeightDic objectForKey:tagModel.type];
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
    ItemModel *im = _sourceArray[indexPath.row];
    return [self calculateItemCellHeightWithItemModel:im indexPath:indexPath tagModel:_model];
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
    
    NSArray *heightArray = [_recommentHeightDic objectForKey:_model.type];
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
    
    __block HomeItemCell *itemCell = cell;
    cell.favourBlock = ^() {
        NSString *action = im.isLike.intValue ? @"false" : @"true";
        [self detailLikeWithPublishID:im.atlas.ID action:action completion:^(BOOL finished, NSString *actionResult) {
            if (finished) {
                im.isLike = actionResult;
                [itemCell refresh];
            }
        }];
    };
    cell.itemModel = im;
    cell.incrementHeight = [heightArray[indexPath.row] integerValue];
    [cell refresh];
    return cell;
    
}

#pragma mark - 请求喜欢和不喜欢
- (void)detailLikeWithPublishID:(NSString *)pid action:(NSString *)action completion:(void (^)(BOOL finished, NSString *actionResult))completion
{
    NSDictionary *parameter = @{@"pubId" : pid, @"action" : action};
    [UserPraiseAddRequest requestWithParameters:parameter withIndicatorView:self.view withCancelSubject:nil onRequestFinished:^(ITTBaseDataRequest *request) {
        if ([[request.handleredResult objectForKey:@"respResult"] integerValue] == 1) {
            completion(YES, @"1");
        } else {
            completion(YES, @"0");
        }
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_photoModelArray) {
        _photoModelArray = [[NSMutableArray alloc] init];
    }
    
    [_photoModelArray removeAllObjects];
    
    ItemModel *im = _sourceArray[indexPath.row];
    if (!im.atlas.imageNum) {
        
        [self requestPublishImgsWithPulishModel:im.atlas index:indexPath.row onFinished:^(NSArray *imgsArray) {
            for (ImgsModel *imgModel in imgsArray) {
                MWPhoto *mp = [[MWPhoto alloc] initWithURL:[NSURL URLWithString:imgModel.url]];
                [_photoModelArray addObject:mp];
            }
            [self goToDetailViewWith:im imageIndex:0 showView:0];
        }];
        
        
    } else {
//        for (ImgsModel *imgModel in im.publish.imgsArray) {
//            MWPhoto *mp = [[MWPhoto alloc] initWithURL:[NSURL URLWithString:imgModel.url]];
//            [_photoModelArray addObject:mp];
//        }
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
//    if (!im.publish.imgsArray.count) {
//        [self requestPublishImgsWithPulishModel:im.publish index:indexPath.row onFinished:^(NSArray *imgsArray) {
//            for (ImgsModel *imgModel in imgsArray) {
//                MWPhoto *mp = [[MWPhoto alloc] initWithURL:[NSURL URLWithString:imgModel.url]];
//                [_photoModelArray addObject:mp];
//            }
//            [self goToDetailViewWith:im imageIndex:imageIndex showView:viewType];
//        }];
//    } else {
//        for (ImgsModel *imgModel in im.publish.imgsArray) {
//            MWPhoto *mp = [[MWPhoto alloc] initWithURL:[NSURL URLWithString:imgModel.url]];
//            [_photoModelArray addObject:mp];
//        }
//        [self goToDetailViewWith:im imageIndex:imageIndex showView:viewType];
//    }
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
    NSString *pageID = _model.ID;
    NSString *pageType = _model.type;
    [self requestMainCellWithPageID:pageID andType:pageType andPage:@"1"];
}

- (void)pullTableViewDidTriggerLoadMore:(ITTPullTableView*)pullTableView
{
    NSInteger page = _pageIndex;
    page++;
    _pageIndex = page;
    NSString *pageID = _model.ID;
    NSString *pageType = _model.type;
    [self requestMainCellWithPageID:pageID andType:pageType andPage:[NSString stringWithFormat:@"%d", page]];
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


//- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
//{
//    ItemModel *im = _sourceArray[_selectedItemIndex];
//    return im.publish.imgsArray.count ? im.publish.imgsArray.count : _photoModelArray.count;
//}

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
