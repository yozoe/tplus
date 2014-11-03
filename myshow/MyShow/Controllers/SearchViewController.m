//
//  SearchViewController.m
//  MyShow
//
//  Created by max on 14-8-27.
//  Copyright (c) 2014年 maxingchuan. All rights reserved.
//

#import "SearchViewController.h"
#import "TagModel.h"
#import "AMTagListView.h"
#import "HomeTagRequest.h"
#import "SearchTagListDefaultRequest.h"
#import "DefaultTagModel.h"
#import "CoverImageModel.h"
#import "ThumbModel.h"
#import "defaultTagCollectionViewCell.h"
#import "SearchTagListViewController.h"
#import "myTableViewCell.h"


@interface SearchViewController ()<UISearchBarDelegate,UISearchDisplayDelegate>
//@property (weak, nonatomic) IBOutlet AMTagListView *tagListView;
//@property (nonatomic, strong) AMTagView * selectedTagView;
{
    UISearchBar                 *_searchBar;
    UISearchDisplayController   *_searchDisplayController;
    int _pageIndex;
}
@property (strong, nonatomic) NSArray                       *searchArray;
@property (strong, nonatomic) NSDictionary                  *searchDict;
@property (strong, nonatomic) NSString                      *searchStr;

@property (strong, nonatomic) NSArray                       *tagsArray;
@property (strong, nonatomic) NSMutableArray                *twoCellArray;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation SearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetFrame)
                                                 name:UIKeyboardWillShowNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [_searchBar resignFirstResponder];
//    [_searchDisplayController.searchBar resignFirstResponder];
//    
//    [_searchBar.inputAccessoryView resignFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [_searchBar resignFirstResponder];
//    [_searchDisplayController.searchBar resignFirstResponder];
//    
//    [_searchBar.inputAccessoryView resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    
//    [self initTags];
//    [self requestTitleSegmentedViewTitle];
//    [self addNavigationBar];
    [self initNavigationBar];
    [self initSearchBar];
    [self initTableView];
//    [self initCollectionView];
    
    [self requestDefaultTagsWithPage:@"1"];
    
}

//- (void)addNavigationBar
//{
//    self.navigationController.navigationBarHidden = YES;
//    
//    _navigationBar = [[MyShowNavigationBar alloc] initWithFrame:self.view.frame
//                                                       ColorStr:[NSString stringWithUTF8String:"#BD0007"]];
//    _navigationBar.titleLabel.text = @"搜索";
//    
//    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"top_navigation_back"] forState:UIControlStateNormal];
//    _navigationBar.rightButton = nil;
//    _navigationBar.delegate = self;
//    [self.view addSubview:_navigationBar];
//}

- (void)initNavigationBar
{
    self.title = @"搜索";
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initSearchBar
{
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    _searchBar.backgroundColor = [UIColor colorWithWhite:0.906 alpha:1.000];
    _searchBar.backgroundImage = [UIImage new];
    _searchBar.placeholder = @"输入标签";
    _searchBar.tintColor = [UIColor whiteColor];
    _searchBar.searchBarStyle = UISearchBarStyleDefault;
    
    _searchBar.delegate = self;
    [self.view addSubview:_searchBar];
    
    _searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    _searchDisplayController.delegate = self;
//    _searchDisplayController.searchResultsDataSource = self;
//    _searchDisplayController.searchResultsDelegate = self;
}


//#pragma mark - UITableView Delegate/DataSource Methods
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 10;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 45;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString * cellIdentifier = @"Cell";
//    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//    }
//    cell.textLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];
//    
//    return cell;
//}


#pragma mark - UISearchDisplayController delegate Methods
- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
        [UIView animateWithDuration:0.25 animations:^{
            
            
            for (UIView *subview in self.view.subviews)
                subview.transform = CGAffineTransformMakeTranslation(0, statusBarFrame.size.height);
        }];
    }
    controller.searchResultsTableView.backgroundColor = RGBCOLOR(246, 246, 246);
    
}

- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller
{
    //    controller.searchBar.backgroundColor=[UIColor redColor];
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [UIView animateWithDuration:0.25 animations:^{
            for (UIView *subview in self.view.subviews)
                subview.transform = CGAffineTransformIdentity;
            
            controller.searchResultsTableView.transform = CGAffineTransformIdentity;
            
            for(UIView * subview in controller.searchResultsTableView.superview.subviews)
            {
                if([subview isKindOfClass:NSClassFromString(@"_UISearchDisplayControllerDimmingView")])
                {
                    subview.transform = CGAffineTransformIdentity;
                }
            }
        }];
    }
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    if ([controller.searchBar.text isEqualToString:@""]) {

    }
}


- (void)resetFrame
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
        
        [UIView animateWithDuration:0.25 animations:^{
            for(UIView * subview in _searchDisplayController.searchResultsTableView.superview.subviews)
                if([subview isKindOfClass:NSClassFromString(@"_UISearchDisplayControllerDimmingView")])
                {
                    subview.transform = CGAffineTransformMakeTranslation(0, statusBarFrame.size.height);
                    
                }
            
            _searchDisplayController.searchResultsTableView.transform = CGAffineTransformMakeTranslation(0, statusBarFrame.size.height);
        }];
    }
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    //去除 No Results 标签
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.001);
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        
        for (UIView *subview in _searchDisplayController.searchResultsTableView.subviews) {
            if ([subview isKindOfClass:[UILabel class]] && [[(UILabel *)subview text] isEqualToString:@"No Results"]) {
                UILabel *label = (UILabel *)subview;
                label.text = @"";
                break;
            }
            if ([subview isKindOfClass:[UILabel class]] && [[(UILabel *)subview text] isEqualToString:@"无结果"]) {
                UILabel *label = (UILabel *)subview;
                label.text = @"";
                break;
            }
        }
    });
    return YES;
}


#pragma mark - UISearchBarDelegate Methods
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    ITTDINFO(@"search text %@", searchText);
    _searchStr = [searchText stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
//    int count = 0;
//    for (NSArray * searchArray in self.searchDict.allValues) {
//        count += searchArray.count;
//    }
//    if (count == 0 && [searchText length]) {
//        [self showSearchResultHintView];
//    }
//    else {
//        [self hideSearchResultHintView];
//    }
}

//- (void)showSearchResultHintView
//{
//    UITableView * searchResulesTableView = _searchDisplayController.searchResultsTableView;
//    [searchResulesTableView addSubview:_hintView];
//    searchResulesTableView.userInteractionEnabled = NO;
//    _hintView.hidden = NO;
//}
//
//- (void)hideSearchResultHintView
//{
//    UITableView * searchResulesTableView = _searchDisplayController.searchResultsTableView;
//    searchResulesTableView.userInteractionEnabled = TRUE;
//    _hintView.hidden = YES;
//}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
//    [self hideSearchResultHintView];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if ([searchBar.text isEqualToString:@""]) {
//        //点击搜索"取消"按钮不消失  --max
//        self.searchArray = nil;
        NSLog(@"searchBar.text:%@",_searchStr);
    }else{
        NSLog(@"searchBar.text:%@",_searchStr);
        

    }
}

/*
#pragma mark - initTags
- (void)initTags
{
    [[AMTagView appearance] setTagLength:10];
	[[AMTagView appearance] setTextPadding:14];
	[[AMTagView appearance] setTextFont:[UIFont fontWithName:@"Futura" size:14]];
    [[AMTagView appearance] setTagColor:UICOLOR_ORIGIN];
    
	[self.tagListView setTapHandler:^(AMTagView *view) {
        
//        view.tagColor = UICOLOR_SELECTED;
        
        
        NSString * name = view.labelText.text;
       
        //获取选中的tag对应的model
        for(TagModel * model in _tagsArray)
        {
            if ([model.name isEqualToString:name]) {
                SearchTagListViewController * listVC = [[SearchTagListViewController alloc] init];
                listVC.model = model;
                [self.navigationController pushViewController:listVC animated:YES];
                
            }
        }

	}];
    
}


#pragma mark - 请求标签
- (void)requestTitleSegmentedViewTitle
{
    [HomeTagRequest requestWithParameters:@{@"type" : DEFAULT_DISTRIBUTE_TAG} withIndicatorView:self.view withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
        
    } onRequestFinished:^(ITTBaseDataRequest *request) {
        _tagsArray = [[request.handleredResult objectForKey:@"models"] copy];
        NSLog(@"%@",_tagsArray);
        
        NSMutableArray * nameArray = [NSMutableArray array];
        for (TagModel *m in _tagsArray) {
            [nameArray addObject:m.name];
            [self.tagListView addTag:m.name];
        }
        
    } onRequestCanceled:^(ITTBaseDataRequest *request) {
        
    } onRequestFailed:^(ITTBaseDataRequest *request) {
        
    }];
}
*/

- (void)initTableView
{
    _tableView = [[ITTPullTableView alloc] initWithFrame:CGRectMake(0,_searchBar.bottom,self.view.frame.size.width,self.view.height - 108)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.pullDelegate = self;
    [self.view addSubview:_tableView];
    
    _pageIndex = 1;
}


#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.twoCellArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"myCell";
    myTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"myTableViewCell" owner:self options:nil] lastObject];
    }
    
    cell.cellArray = [self.twoCellArray objectAtIndex:indexPath.row];
    
    cell.oneBlock = ^() {
        DefaultTagModel * model = [[self.twoCellArray objectAtIndex:indexPath.row] objectAtIndex:0];
        SearchTagListViewController * tagListVC = [[SearchTagListViewController alloc] init];
        tagListVC.tagModel = model;
        [self.navigationController pushViewController:tagListVC animated:YES];
    };
    cell.twoBlock = ^() {
        DefaultTagModel * model = [[self.twoCellArray objectAtIndex:indexPath.row] objectAtIndex:1];
        SearchTagListViewController * tagListVC = [[SearchTagListViewController alloc] init];
        tagListVC.tagModel = model;
        [self.navigationController pushViewController:tagListVC animated:YES];
    };

    return cell;
}



#pragma mark - 上拉和下拉的回调
- (void)pullTableViewDidTriggerRefresh:(ITTPullTableView*)pullTableView
{
    [self requestDefaultTagsWithPage:@"1"];
}

- (void)pullTableViewDidTriggerLoadMore:(ITTPullTableView*)pullTableView
{
    NSInteger page = _pageIndex;
    page++;
    _pageIndex = page;
    [self requestDefaultTagsWithPage:[NSString stringWithFormat:@"%d",_pageIndex]];
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

//- (void)initCollectionView
//{
//    [self.collectionView registerClass:[defaultTagCollectionViewCell class] forCellWithReuseIdentifier:@"defaultTagCollectionViewCell"];
//    [self.collectionView registerNib:[UINib nibWithNibName:@"defaultTagCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"defaultTagCollectionViewCell"];
//    
//    self.collectionView.backgroundColor = [UIColor clearColor];
//}
//
//#pragma mark - UICollectionViewDelegate/Datasource
//-(NSInteger)numberOfSectionsInCollectionView:
//(UICollectionView *)collectionView
//{
//    return 1;
//}
//
//-(NSInteger)collectionView:(UICollectionView *)collectionView
//    numberOfItemsInSection:(NSInteger)section
//{
//    return self.tagsArray.count;
//}
//
//-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
//                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    defaultTagCollectionViewCell * cell = (defaultTagCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"defaultTagCollectionViewCell"
//                                                                                      forIndexPath:indexPath];
//    
//    DefaultTagModel * model = [self.tagsArray objectAtIndex:indexPath.row];
//    cell.model = model;
//    
//    
//    return cell;
//}
//
//
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(0, 0, 0, 0);
//}
//
//
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    DefaultTagModel * model = [self.tagsArray objectAtIndex:indexPath.row];
//    SearchTagListViewController * tagListVC = [[SearchTagListViewController alloc] init];
//    tagListVC.tagModel = model;
//    [self.navigationController pushViewController:tagListVC animated:YES];
//}

- (void)requestDefaultTagsWithPage:(NSString *)page
{
    NSDictionary * parameter = @{@"page" : page, @"limit" : HOME_PAGE_SIZE};
    [SearchTagListDefaultRequest requestWithParameters:parameter withIndicatorView:self.view withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
        
    } onRequestFinished:^(ITTBaseDataRequest *request) {
        NSArray * tagsArray = [[request.handleredResult objectForKey:@"models"] copy];
        NSLog(@"%@",_tagsArray);
        
        BOOL isAdd = page.integerValue > 1 ? YES : NO;
        
        [self fillTalbeViewSourceFromTagsArray:tagsArray isAdd:isAdd];
        [self endLoadingData];
        
    } onRequestCanceled:^(ITTBaseDataRequest *request) {
        
    } onRequestFailed:^(ITTBaseDataRequest *request) {
        
    }];
}

- (void)fillTalbeViewSourceFromTagsArray:(NSArray *)tagsArray isAdd:(BOOL)isAdd
{
    NSMutableArray * mArray = [NSMutableArray array];
    NSMutableArray * array = nil;
    for (int i = 0; i < tagsArray.count; i++) {
        if (i%2 == 0) {
            array = [NSMutableArray arrayWithCapacity:2];
            [mArray addObject:array];
        }
        [array addObject:tagsArray[i]];
    }
    
    if (!_twoCellArray) {
        _twoCellArray = [[NSMutableArray alloc] initWithArray:mArray];
    }else{
        if (!isAdd) {
            [_twoCellArray removeAllObjects];
        }
        [_twoCellArray addObjectsFromArray:mArray];
    }
    
    [_tableView reloadData];

}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
