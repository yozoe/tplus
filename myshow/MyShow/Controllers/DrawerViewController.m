//
//  DrawerViewController.m
//  MyShow
//
//  Created by wang dong on 8/6/14.
//  Copyright (c) 2014 maxingchuan. All rights reserved.
//

#import "DrawerViewController.h"
#import "DetailCommentRequest.h"
#import "DetailShareView.h"
#import "ImageActionButton.h"
#import "UserPraiseRequest.h"
#import "MoreViewController.h"
#import "PersonalHomePageViewController.h"

#define FIX_BUTTON_TAG(x) (x - 1000)
#define CREATE_BUTTON_TAG(x) (x + 1000)

int static drawerHeaderViewHeight = 40;

@interface DrawerViewController ()
{
    UIView *_flagView;
    UIButton *_selectedButton;
    DetailTagView *_tagView;
    UIScrollView *_contentScrollView;
    DetailCommentView *_commentView;
    NSMutableArray *_commentSourceArray;
    NSMutableArray *_heightArray;
    NSInteger _selectedIndex;
    BOOL _commentFirstRequest;
    BOOL _inputIsShow;
    NSInteger _commentPage;
    UIView *_headerView;
    ImageActionButton *_favourButton;
}

@end

@implementation DrawerViewController

- (id)initWithItem:(ItemModel *)item
{
    if (self = [super init]) {
        self.item = item;
        _commentSourceArray = [[NSMutableArray alloc] init];
        _heightArray = [[NSMutableArray alloc] init];
        _commentPage = 1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    _flagView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, drawerHeaderViewHeight)];
    _flagView.backgroundColor = [UIColor redColor];

    NSArray *buttonTitleArray = @[@"标签", @"评论", @"分享"];

    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, 320, 40);
    headerView.backgroundColor = [UIColor whiteColor];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39, 320, 1)];
    lineView.backgroundColor = RGBCOLOR(243, 243, 243);
    [headerView addSubview:lineView];
    [headerView addSubview:_flagView];

    for (int i = 0; i < 3; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i * 80, 0, 80, 39);
        [button setTitle:buttonTitleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(handleHeaderButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = CREATE_BUTTON_TAG(i);
        if (i == 0) {
            button.selected = YES;
            _selectedButton = button;
        }
        [headerView addSubview:button];
    }

    _headerView = headerView;

    [self.view addSubview:headerView];
    _drawerHeaderView = headerView;

    _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, headerView.height, 320, self.view.height - headerView.height)];
    _contentScrollView.delegate = self;
    _contentScrollView.pagingEnabled = YES;
    _contentScrollView.bounces = NO;

    [_contentScrollView setContentSize:CGSizeMake(320 * 3, self.view.height - headerView.height)];

    [self.view addSubview:_contentScrollView];

    [self initFavourButton];
    [self initDetailTagView];
    [self initDetailCommentView];
    [self initDetailShareView];
}

- (void)initFavourButton
{
    NSString *favourImageName = self.item.isLike.intValue ? @"xihuan_select" : @"xihuan";
    _favourButton = [ImageActionButton createWithImage:[UIImage imageNamed:favourImageName]];
    [_favourButton addTarget:self action:@selector(handleFavourButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _favourButton.right = _headerView.right;
    _favourButton.top = 6;
    [_favourButton setNumberText:self.item.dynamic.favnum];
    [_headerView addSubview:_favourButton];
}

- (void)initDetailCommentView
{
    _commentView = [[DetailCommentView alloc] initWithFrame:CGRectMake(320, 0, 320, _contentScrollView.height - 40)];
    _commentView.mainTableView.delegate = self;
    _commentView.mainTableView.dataSource = self;
    _commentView.mainTableView.pullDelegate = self;
    _commentView.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;;
    [_contentScrollView addSubview:_commentView];
}

- (void)initDetailTagView
{
    _tagView = [[DetailTagView alloc] initWithFrame:CGRectMake(0, 0, 320, _contentScrollView.height)];
    _tagView.tagDataSource = self;
    _tagView.tagDelegate = self;
    [_tagView configData];
    [_contentScrollView addSubview:_tagView];
}

#pragma mark - 初始化分享view
- (void)initDetailShareView
{
    DetailShareView *dsv = [DetailShareView createShareViewWithFrame:CGRectMake(640, 0, 320, _contentScrollView.height)];
    dsv.selectShareBlock = ^(NSString *shareType) {
        if ([_delegate respondsToSelector:@selector(shareWithType:)]) {
            [_delegate shareWithType:shareType];
        }
    };
    [_contentScrollView addSubview:dsv];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleHeaderButtonEvent:(UIButton *)sender
{
    _selectedIndex = FIX_BUTTON_TAG(sender.tag);
    if (_isExpand && sender.selected) {
        if ([_delegate respondsToSelector:@selector(drawerMovePosition:)]) {
            [_delegate drawerMovePosition:DrawerMoveToBottom];
        }
    } else if (!_isExpand) {
        if ([_delegate respondsToSelector:@selector(drawerMovePosition:)]) {
            [_delegate drawerMovePosition:DrawerMovoToMiddle];
        }
    }
    if (_selectedButton) {
        _selectedButton.selected = NO;
    }
    _selectedButton = sender;
    _selectedButton.selected = YES;
    _flagView.left = FIX_BUTTON_TAG(sender.tag) * _flagView.width;
    [_contentScrollView setContentOffset:CGPointMake(320 * FIX_BUTTON_TAG(sender.tag), 0) animated:_isExpand];

    if (_selectedIndex == 1) {
        [self checkCommentDataSource];
        if (!_inputIsShow) {
            [self showInputView];
        }
    } else {
        [self hideInputView];
    }
}

- (TagModel *)tagItemAtIndex:(NSInteger)index
{
    return _item.labelsArray[index];
}

- (NSInteger)numberOfTags
{
    return _item.labelsArray.count;
}

- (LinksModel *)linkItemAtIndex:(NSInteger)index
{
    return _item.linksArray[index];
}

- (NSInteger)numberOfLinks
{
    return _item.linksArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = [_heightArray[indexPath.row] CGSizeValue];
    if (size.height >= 14.316) {
        return 40 + size.height - 14.316;
    }
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _commentSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CommentCell";
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

    if (!cell) {
        cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }


    CommentModel *cm = _commentSourceArray[indexPath.row];
    [cell configModel:cm];

    cell.portraitButtonBlock = ^() {
        if ([_delegate respondsToSelector:@selector(pushPersonalHomePageWithUserModel:)]) {
            UserModel *um = [UserModel new];
            um.ID = cm.userID;
            um.nickname = cm.nickname;
            um.headUrl = cm.headUrl;
            [_delegate pushPersonalHomePageWithUserModel:um];
        }
    };


    return cell;
}

- (void)showInputView
{
    if ([_delegate respondsToSelector:@selector(showInputView)]) {
        _inputIsShow = YES;
        [_delegate showInputView];
    }
}

- (void)hideInputView
{
    if ([_delegate respondsToSelector:@selector(hideInputView)]) {
        _inputIsShow = NO;
        [_delegate hideInputView];
    }
}

- (void)clearInputView
{
    if ([_delegate respondsToSelector:@selector(clearInputView)]) {
        [_delegate clearInputView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_contentScrollView]) {
        _selectedIndex = scrollView.contentOffset.x / 320;
        if (_selectedIndex == 1) {
            [self checkCommentDataSource];
            if (!_inputIsShow) {
                [self showInputView];
            }
        } else {
            [self hideInputView];
        }

        if (_selectedButton) {
            _selectedButton.selected = NO;
        }
        _selectedButton = (UIButton *)[_drawerHeaderView viewWithTag:CREATE_BUTTON_TAG(_selectedIndex)];
        _selectedButton.selected = YES;

        _flagView.left = _flagView.width * _selectedIndex;

        [self checkCommentDataSource];
    }
}

- (void)reloadCommentData
{
    _commentPage = 1;
    NSDictionary *parameter = @{@"page" :[NSString stringWithFormat:@"%d", _commentPage], @"limit" : @"20", @"atlasId" : _item.atlas.ID};
    [self requestCommentDataWithParameter:parameter];
}

#pragma mark - 抓取评论数据
- (void)checkCommentDataSource
{
    if (!_commentFirstRequest) {
        NSDictionary *parameter = @{@"page" : [NSString stringWithFormat:@"%d", _commentPage], @"limit" : @"20", @"atlasId" : _item.atlas.ID};
        [self requestCommentDataWithParameter:parameter];
    }
}

- (void)requestCommentDataWithParameter:(NSDictionary *)parameter
{
    NSInteger page = [[parameter objectForKey:@"page"] integerValue];
    [DetailCommentRequest requestWithParameters:parameter withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {

    } onRequestFinished:^(ITTBaseDataRequest *request) {
        [self clearInputView];
        NSArray *itemsArray = [request.handleredResult objectForKey:@"models"];
        BOOL isAdd = page > 1 ? YES : NO;
        [self fillDataSource:itemsArray isAdd:isAdd];
        if (!_commentFirstRequest) {
            _commentFirstRequest = YES;
        }
        [self endLoadingData];

    } onRequestCanceled:^(ITTBaseDataRequest *request) {

    } onRequestFailed:^(ITTBaseDataRequest *request) {
        [self endLoadingData];
    }];
}

- (void)fillDataSource:(NSArray *)source isAdd:(BOOL)isAdd
{
    if (source.count) {
        if (!isAdd) {
            [_heightArray removeAllObjects];
            [_commentSourceArray removeAllObjects];
        }
        [_commentSourceArray addObjectsFromArray:source];
        for (CommentModel *cm in _commentSourceArray) {
            CGSize size = [cm.content sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(268, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
            [_heightArray addObject:[NSValue valueWithCGSize:size]];
        }

        [_commentView.mainTableView reloadData];
    }
}

- (BOOL)isComment
{
    return _selectedIndex == 1;
}

- (void)fixCommentTableViewHeight:(CGFloat)height
{
    _commentView.mainTableView.height = height - drawerHeaderViewHeight;
    _commentView.mainTableView.top = 0;
}

- (void)pullTableViewDidTriggerRefresh:(ITTPullTableView*)pullTableView
{
    [self reloadCommentData];
}

- (void)pullTableViewDidTriggerLoadMore:(ITTPullTableView*)pullTableView
{
    NSDictionary *parameter = @{@"page" : [NSString stringWithFormat:@"%d", ++_commentPage], @"limit" : @"20", @"atlasId" : _item.atlas.ID};
    [self requestCommentDataWithParameter:parameter];
}

- (void)endLoadingData
{
    if (_commentView.mainTableView.pullTableIsLoadingMore) {
        _commentView.mainTableView.pullTableIsLoadingMore = NO;
    }
    if (_commentView.mainTableView.pullTableIsRefreshing) {
        _commentView.mainTableView.pullTableIsRefreshing = NO;
    }
}

- (void)showCommentView
{
    UIButton *button = (UIButton *)[_headerView viewWithTag:CREATE_BUTTON_TAG(1)];
    [self handleHeaderButtonEvent:button];
}

- (void)showTagView
{
    UIButton *button = (UIButton *)[_headerView viewWithTag:CREATE_BUTTON_TAG(0)];
    [self handleHeaderButtonEvent:button];
}

- (void)handleFavourButtonAction:(UIButton *)sender
{

    if (_item.isLike.integerValue) {

        [self praiseCancelWithAtlasID:_item.atlas.ID completion:^(BOOL finished, NSString *result) {
            if (finished) {
                _item.isLike = @"0";
                [_favourButton setImage:[UIImage imageNamed:@"xihuan"] forState:UIControlStateNormal];
            }
        }];

    } else {
        [self praiseAddWithAtlasID:_item.atlas.ID completion:^(BOOL finished, NSString *result) {
            if (finished) {

                _item.isLike = @"1";
                _item.atlas.praiseNum = [NSString stringWithFormat:@"%d", _item.atlas.praiseNum.integerValue + 1];
                [_favourButton setImage:[UIImage imageNamed:@"xihuan_select"] forState:UIControlStateNormal];
            }
        }];
    }
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

- (void)didClickLink:(NSInteger)index
{
    LinksModel *lm = _item.linksArray[index];
    if ([_delegate respondsToSelector:@selector(showWebViewWithLink:)]) {
        [_delegate showWebViewWithLink:lm];
    }
}

- (void)clickedTagAtIndex:(NSInteger)index
{
    TagModel *tm = _item.labelsArray[index];
    if ([_delegate respondsToSelector:@selector(pushTagPageWithTagModel:)]) {
        [_delegate pushTagPageWithTagModel:tm];
    }
}

@end
