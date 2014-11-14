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

#import "SMTagField.h"
#import "RXUitils.h"


@interface TagsViewController () <UIAlertViewDelegate,ASIHTTPRequestDelegate,DataRequestDelegate,SMTagFieldDelegate>
{
    NSMutableArray * tags;
    ASIFormDataRequest * asiRequest;
}

@property (weak, nonatomic) IBOutlet SMTagField * tagField;
@property (weak, nonatomic) IBOutlet UIButton * addButton;


//@property (weak, nonatomic) IBOutlet AMTagListView *tagListView;
//@property (nonatomic, strong) AMTagView * selectedTagView;

@property (strong, nonatomic) UILabel *placeHolder;
@property (weak, nonatomic) IBOutlet UIImageView *textFieldBg;

- (IBAction)handleAddAction:(id)sender;


@end

@implementation TagsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _selectedArray = [NSMutableArray array];
        _selectedNames = [NSMutableArray array];
        _stateDict = [NSMutableDictionary dictionary];
        tags = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGBACOLOR(244, 244, 242, 1);
    // Do any additional setup after loading the view from its nib.
    [self addNavigationBar];
//    [self initTags];
//    [self requestTitleSegmentedViewTitle];
    
    _tagField.tagDelegate = self;
    _tagField.delegate = self;
    _tagField.tags = [[NSArray alloc] init];
    
    _placeHolder = [[UILabel alloc] initWithFrame:CGRectMake(7, 8, 150, 16)];
    _placeHolder.font = [UIFont boldSystemFontOfSize:13];
    _placeHolder.text = @"打个标签吧...";
    _placeHolder.enabled = NO;
    _placeHolder.backgroundColor = [UIColor clearColor];
    [_tagField addSubview:_placeHolder];
    
    
    
    _textFieldBg.layer.cornerRadius = 8.0f;
    _textFieldBg.clipsToBounds = YES;
    
    _addButton.layer.cornerRadius = 5.0f;
    _addButton.clipsToBounds = YES;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChange:)
                                                 name:@"UITextFieldTextDidChangeNotification"
                                               object:nil];

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)textFieldDidChange:(NSNotification*)aNotification
{
    if(self.tagField.text.length == 0 && self.tagField.tags.count == 0){
        _placeHolder.text = @"打个标签吧...";
    }else{
        _placeHolder.text = @"";
    }

}





#pragma mark - SMTagField delegate
-(void)tagField:(SMTagField *)tagField tagAdded:(NSString *)tag{
    NSLog(@"tagAdded:%@",tag);
    [tags addObject:tag];
}

-(void)tagField:(SMTagField *)tagField tagRemoved:(NSString *)tag{
    [tags removeObject:tag];
    if (tags.count == 0) {
        _placeHolder.text = @"打个标签吧...";
    }
}

//- (void)tagField:(SMTagField *)tagField tagsChanged:(NSArray *)tags
//{
//    _placeHolder.text = @"";
//}


- (void)addNavigationBar
{
    self.navigationController.navigationBarHidden = YES;
    
    _navigationBar = [[MyShowNavigationBar alloc] initWithFrame:self.view.frame
                                                       ColorStr:[NSString stringWithUTF8String:"#BD0007"]];
    _navigationBar.titleLabel.text = @"添加标签";
    
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"top_navigation_back"] forState:UIControlStateNormal];
    [_navigationBar.rightButton setTitle:@"上传" forState:UIControlStateNormal];
    
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
    if (_tagField.tags.count <= 0) {
        [RXUitils showHintMessage:@"请至少输入一个标签"];
    }else{
        if (!DATA_ENV.isHasUserInfo) {
            [self jumpToLoginView];
        }else
            [self startRequest];
    }
}

#pragma mark - 登陆成功回调方法
- (void)didLoginOrRegisterSuccess
{
//    [RXUitils showHintMessage:@"登陆成功，可以上传了"];
    [self startRequest];
}


- (void)startRequest
{
//    if (!_maskActivityView) {
//        _maskActivityView = [ITTMaskActivityView loadFromXib];
//        [_maskActivityView showInView:self.view withHintMessage:@"上传中..."];
//    }
    if (!_hud) {
        _hud = [MBProgressHUD showHUDAddedTo:[AppDelegate GetAppDelegate].window animated:YES];
        _hud.labelText = @"Loading...";
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *zipFile = [documentsPath stringByAppendingPathComponent:@"imgfiles.zip"];

//    真实环境
//    NSURL * url = [NSURL URLWithString:@"http://show.591ku.com/myshow/client/user/atlas/add"];
    
    //测试环境
    NSURL * url = [NSURL URLWithString:@"http://test.api.591ku.com/user/atlas/add"];
    
    
    
    asiRequest = [ASIFormDataRequest requestWithURL:url];
    
    [asiRequest setRequestMethod:@"POST"];
    [asiRequest setDelegate:self];
    asiRequest.defaultResponseEncoding = NSUTF8StringEncoding;

    
    
//    //uid
//    [request addRequestHeader:@"uid" value:DATA_ENV.userUid];
//    //手机信息
//    [request addRequestHeader:@"brand" value:[DATA_ENV.platformString encodeUrl]];
//    //token
//    [request addRequestHeader:@"token" value:DATA_ENV.token];
//    //位置
//    [request addRequestHeader:@"location" value:[DATA_ENV.location encodeUrl]];
//    //经度
//    [request addRequestHeader:@"longtitude" value:DATA_ENV.longitude];
//    //纬度
//    [request addRequestHeader:@"latitude" value:DATA_ENV.latitude];
    

    
    //用户id
    [asiRequest addRequestHeader:@"uid" value:DATA_ENV.userInfo.uid];
    //手机信息
    [asiRequest addRequestHeader:@"brand" value:DATA_ENV.platformString];
    //位置
    [asiRequest addRequestHeader:@"location" value:[DATA_ENV.location encodeUrl]];
    //经度
    [asiRequest addRequestHeader:@"longtitude" value:DATA_ENV.longitude];
    //纬度
    [asiRequest addRequestHeader:@"latitude" value:DATA_ENV.latitude];
    //用户头像
    [asiRequest addRequestHeader:@"headurl" value:DATA_ENV.userInfo.headUrl];
    //用户昵称
    [asiRequest addRequestHeader:@"nickname" value:[DATA_ENV.userInfo.nickname encodeUrl]];
    //UUID    新添加字段
    [asiRequest addRequestHeader:@"did" value:DATA_ENV.did];
    //TOKEN   新添加字段
    [asiRequest addRequestHeader:@"token" value:DATA_ENV.token];
    
    //以下数据测试用
//    if (!DATA_ENV.longitude) {
//        DATA_ENV.longitude = @"37.785834";
//    }
//    
//    if (!DATA_ENV.latitude) {
//        DATA_ENV.latitude = @"122.406417";
//    }
//    
//    if (!DATA_ENV.location) {
//        DATA_ENV.location = @"北京市朝阳区";
//    }
    
    //经纬度   新添加字段
    [asiRequest addRequestHeader:@"ll" value:[NSString stringWithFormat:@"%@*%@", DATA_ENV.longitude, DATA_ENV.latitude]];
    //位置
    [asiRequest addRequestHeader:@"location" value:[DATA_ENV.location encodeUrl]];
    
    
    
    //文字说明
    [asiRequest setPostValue:[_uploadText encodeUrl] forKey:@"content"];
    
    //标签id
    _uploadTags = [tags copy];
    for (NSString * name in _uploadTags) {
        [asiRequest setPostValue:name forKey:@"labelNames"];

    }
    
    //图片压缩包
    [asiRequest addFile:zipFile forKey:@"imageFiles"];
    
    [self performSelector:@selector(uploadAction) withObject:nil afterDelay:1.0f];
    

    
}

- (void)uploadAction
{
    [asiRequest startAsynchronous];

}


#pragma mark - ASIHTTPRequest-requestFinished
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSData *jsonData = [request.responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * resultDic = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    
    NSLog(@"request.responseString:%@",request.responseString);
    
    if ([[resultDic objectForKey:@"code"]  isEqual: @20000]) {
        NSLog(@"发布成功了!");
        
        if (_hud) {
            [MBProgressHUD hideHUDForView:[AppDelegate GetAppDelegate].window animated:YES];
        }
//        if (_maskActivityView) {
//            [_maskActivityView hide];
//            _maskActivityView = nil;
//        }
        
        
        [self showHUDWithImgWithTitle:@"发布成功." withHiddenDelay:1.0f];
        
        [self performSelector:@selector(successAction) withObject:nil afterDelay:1.0f];
    }
    
    
}

- (void)successAction
{
    if (_didDistributeSuccess) {
        //发布图集页面回掉，让其dismiss
        _didDistributeSuccess();
        
        //还需要发个全局通知，如果是在个人页面发布的，发布完了需要刷新我发布的图集；如果是首页图集页面，当发布完了，不需要做什么
//        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DISTRIBUTE_SUCCESS object:nil];
        
        DATA_ENV.isNeedRefresh = YES;
    }
}

#pragma mark - ASIHTTPRequest-requestFailed
- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"response:%@",request.responseString);
    NSLog(@"发布失败了!");
    
//    if (_maskActivityView) {
//        [_maskActivityView hide];
//        _maskActivityView = nil;
//    }
    if (_hud) {
        [MBProgressHUD hideHUDForView:[AppDelegate GetAppDelegate].window animated:YES];
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


/*
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
                    [_selectedNames addObject:m.name];
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
                    [_selectedNames removeObject:m.name];
                }
            }
        }
        _uploadTags = _selectedNames;
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
    NSLog(@"选中tagView合集:%@",_selectedNames);

}

#pragma mark - 请求标签
- (void)requestTitleSegmentedViewTitle
{
    [HomeTagRequest requestWithParameters:nil withIndicatorView:self.view withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
        
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)handleAddAction:(id)sender {
    if (self.tagField.text.length == 0) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ADDTAG object:nil];
}

@end
