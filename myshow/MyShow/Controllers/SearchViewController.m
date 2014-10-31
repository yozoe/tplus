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
#import "SearchTagListViewController.h"


@interface SearchViewController ()
@property (weak, nonatomic) IBOutlet AMTagListView *tagListView;
@property (nonatomic, strong) AMTagView * selectedTagView;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addNavigationBar];
    
    [self initTags];
    [self requestTitleSegmentedViewTitle];
}

- (void)addNavigationBar
{
    self.navigationController.navigationBarHidden = YES;
    
    _navigationBar = [[MyShowNavigationBar alloc] initWithFrame:self.view.frame
                                                       ColorStr:[NSString stringWithUTF8String:"#BD0007"]];
    _navigationBar.titleLabel.text = @"搜索";
    
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"top_navigation_back"] forState:UIControlStateNormal];
    _navigationBar.rightButton = nil;
    _navigationBar.delegate = self;
    [self.view addSubview:_navigationBar];
}

- (void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

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






- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
