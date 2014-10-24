//
//  TagsViewController.m
//  MyShow
//
//  Created by max on 14-7-25.
//  Copyright (c) 2014年 maxingchuan. All rights reserved.
//

#import "TagsViewController.h"
#import "HomeTagRequest.h"
#import "TagModel.h"
#import "AMTagListView.h"
#import "DistributeUploadRequest.h"
#import "ZipArchive.h"

#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "UIDevice+ITTAdditions.h"
#import "AppDelegate.h"
#import "MyTabBarViewController.h"



@interface TagsViewController () <UIAlertViewDelegate,ASIHTTPRequestDelegate,DataRequestDelegate>

@property (weak, nonatomic) IBOutlet AMTagListView *tagListView;
@property (nonatomic, strong) AMTagView * selectedTagView;

@end

@implementation TagsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _selectedArray = [NSMutableArray array];
        _selectedID = [NSMutableArray array];
        _stateDict = [NSMutableDictionary dictionary];
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
                                                       ColorStr:[NSString stringWithUTF8String:"#F92B51"]];
    _navigationBar.titleLabel.text = @"添加标签";
    
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"top_navigation_back"] forState:UIControlStateNormal];
    [_navigationBar.rightButton setTitle:@"发布" forState:UIControlStateNormal];
    
    _navigationBar.delegate = self;
    [self.view addSubview:_navigationBar];
}


#pragma mark - 拿到上级页面传递过来的文字跟图片信息,加上本页面tag值进行上传
- (void)setUploadText:(NSString *)uploadText
{
    _uploadText = uploadText;
    NSLog(@"uploadText:%@",uploadText);
}

- (void)setUploadImagesDict:(NSDictionary *)uploadImagesDict
{
    _uploadImagesDict = uploadImagesDict;
    [self zipImages];
}

- (void)zipImages
{
    // 1. 获取Documents目录，新的zip文件要写入到这个目录里。
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    // 3. 获取zip文件的全路径名。
    NSString *zipFile = [documentsPath stringByAppendingPathComponent:@"imgfiles.zip"];
    
    // 4. 创建一个ZipArchive实例，并创建一个内存中的zip文件。需要注意的是，只有当你调用了CloseZipFile2方法之后，zip文件才会从内存中写入到磁盘中去。
    ZipArchive *za = [[ZipArchive alloc] init];
    [za CreateZipFile2:zipFile];
    
    for(int i = 0; i < _uploadImagesDict.count; i++)
    {
        NSString * filePath = [_uploadImagesDict objectForKey:[NSString stringWithFormat:@"pic_%d",i]];
        
        // 6. 把要压缩的文件加入到zip对象中去，加入的文件数量没有限制，也可以加入文件夹到zip对象中去。
        NSString * picName = [NSString stringWithFormat:@"newPic_%d.png",i];
        [za addFileToZip:filePath newname:picName];
    }
    
    // 7. 把zip从内存中写入到磁盘中去。
    BOOL success = [za CloseZipFile2];
    NSLog(@"Zipped file with result %d",success);
}


- (void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightButtonClick
{
    if (!DATA_ENV.isHasUserInfo) {
        [self jumpToLoginView];
    }else{
        [self startRequest];
    }
}

#pragma mark - 登陆成功回调方法
- (void)didLoginOrRegisterSuccess
{
    [self startRequest];
}


- (void)startRequest
{
    if (!_maskActivityView) {
        _maskActivityView = [ITTMaskActivityView loadFromXib];
        [_maskActivityView showInView:self.view withHintMessage:@"上传中..."];
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *zipFile = [documentsPath stringByAppendingPathComponent:@"imgfiles.zip"];

//    真实环境
    NSURL * url = [NSURL URLWithString:@"http://show.591ku.com/myshow/client/user/atlas/add"];
    
    //测试环境
//    NSURL * url = [NSURL URLWithString:@"http://show.591ku.com:8080/myshow/client/user/publish"];
    
    
    
    ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:url];
    
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    
    
    //uid
    [request addRequestHeader:@"uid" value:DATA_ENV.userUid];
    //手机信息
    [request addRequestHeader:@"brand" value:[DATA_ENV.platformString encodeUrl]];
    //token
    [request addRequestHeader:@"token" value:DATA_ENV.token];
    //位置
    [request addRequestHeader:@"location" value:[DATA_ENV.location encodeUrl]];
    //经度
    [request addRequestHeader:@"longtitude" value:DATA_ENV.longitude];
    //纬度
    [request addRequestHeader:@"latitude" value:DATA_ENV.latitude];
    

    
    
    //文字说明
    [request setPostValue:[_uploadText encodeUrl] forKey:@"content"];
    
    //标签id
    for (NSString * stringID in _uploadTags) {
        [request setPostValue:stringID forKey:@"labelNames"];

    }
    
    //图片压缩包
    [request addFile:zipFile forKey:@"imageFiles"];
    
    
    [request startAsynchronous];
    

    
}


#pragma mark - ASIHTTPRequest-requestFinished
- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    NSLog(@"request.response-----------------:%@",request.responseString);
    NSLog(@"发布成功了!");
    NSLog(@"request.responseStatusCode-----------------:%d",request.responseStatusCode);
    
    
    if (_maskActivityView) {
        [_maskActivityView hide];
        _maskActivityView = nil;
    }
    
    [self showHUDWithImgWithTitle:@"发布成功." withHiddenDelay:1.0f];
    [self performSelector:@selector(successAction) withObject:nil afterDelay:1.0f];
    
}

- (void)successAction
{
    if (_didDistributeSuccess) {
        _didDistributeSuccess();
    }
}

#pragma mark - ASIHTTPRequest-requestFailed
- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"response:%@",request.responseString);
    NSLog(@"发布失败了!");
    
    if (_maskActivityView) {
        [_maskActivityView hide];
        _maskActivityView = nil;
    }
    
    [self showHUDWithImgWithTitle:@"发布失败." withHiddenDelay:1.0f];
    [self performSelector:@selector(failAction) withObject:nil afterDelay:1.0f];
    
    
}

- (void)failAction
{
    if (_didDistributeFail) {
        _didDistributeFail();
    }
}

#pragma mark - initTags
- (void)initTags
{
    [[AMTagView appearance] setTagLength:10];
	[[AMTagView appearance] setTextPadding:14];
	[[AMTagView appearance] setTextFont:[UIFont fontWithName:@"Futura" size:14]];
    [[AMTagView appearance] setTagColor:UICOLOR_ORIGIN];
    
	[self.tagListView setTapHandler:^(AMTagView *view) {

        NSString * name = view.labelText.text;
        int state = [[_stateDict objectForKey:name] intValue];
        //初始状态,没有选中
        if (!state) {
            //设置选中状态
            [_stateDict setObject:@1 forKey:name];
            
            //将选中的tag对应的model放入数据源
            for(TagModel *m in _tagsArray)
            {
                if ([m.name isEqualToString:name]) {
                    [_selectedArray addObject:m];
                    [_selectedID addObject:m.ID];
                }
            }
        }else{
            //移除选中状态
            [_stateDict setObject:@0 forKey:name];
            
            //移除数据源
            for(TagModel *m in _selectedArray)
            {
                if ([m.name isEqualToString:name]) {
                    [_selectedArray removeObject:m];
                    [_selectedID removeObject:m.ID];
                }
            }
        }
        _uploadTags = _selectedID;
        [self refreshTagsState];
	}];
    
}

- (void)refreshTagsState
{
    for (AMTagView * tagView in _tagListView.subviews) {
        NSString * name = tagView.labelText.text;
        int state = [[_stateDict objectForKey:name] intValue];
        if (!state) {
            tagView.tagColor = UICOLOR_ORIGIN;
        }else{
            tagView.tagColor = UICOLOR_SELECTED;
        }
    }
    NSLog(@"选中状态:%@",_stateDict);
    NSLog(@"选中tagView合集:%@",_selectedID);

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
