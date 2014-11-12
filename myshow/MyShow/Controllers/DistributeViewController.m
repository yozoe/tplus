//
//  DistributeViewController.m
//  MyShow
//
//  Created by max on 14-7-22.
//  Copyright (c) 2014年 maxingchuan. All rights reserved.
//

#import "DistributeViewController.h"
#import "MyShowNavigationBar.h"
#import "PhotoViewCell.h"
#import "CameraView.h"
#import "CTAssetsPickerController.h"
#import "TagsViewController.h"
#import "ImageDisplayViewController.h"
#import "AppDelegate.h"
#import "MyTabBarViewController.h"

@interface DistributeViewController ()
{
    NSMutableDictionary * _imagesDict;
}
@property (strong, nonatomic) UILabel *placeHolder;

@end

@implementation DistributeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _imageArray = [[NSMutableArray alloc] init];
        _finalImageArray = [[NSMutableArray alloc] init];
        _imagesDict = [NSMutableDictionary dictionary];
        _isShowCameraView = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGBACOLOR(244, 244, 242, 1);
    // Do any additional setup after loading the view from its nib.
    [self addNavigationBar];
    [self initCollectionView];
    
    _placeHolder = [[UILabel alloc] initWithFrame:CGRectMake(7, 8, 150, 16)];
    _placeHolder.font = [UIFont boldSystemFontOfSize:13];
    _placeHolder.text = @"这一刻的想法...";
    _placeHolder.enabled = NO;
    _placeHolder.backgroundColor = [UIColor clearColor];
    [_textView addSubview:_placeHolder];
    
    
    //初始化cameraView
    NSArray * array = [NSArray arrayWithObjects:[UIImage imageNamed:@"xiangce.png"],[UIImage imageNamed:@"paizhao.png"], nil];
    _cameraView = [[CameraView alloc] initWithImages:array backgroundImage:[UIImage imageNamed:@"fabubeijing"]];
    _cameraView.delegate = self;
    _cameraView.frame = CGRectMake((self.view.frame.size.width - 230) / 2,
                                   SCREEN_HEIGHT_OF_IPHONE5,
                                   230, 87);
    [self.view addSubview:_cameraView];
    
    
    UITapGestureRecognizer * tapSelfView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickSelfView)];
    [self.view addGestureRecognizer:tapSelfView];
    
}


- (void)clickSelfView
{
    if ([self.textView isFirstResponder]) {
        [self.textView resignFirstResponder];
    }
    if (_isShowCameraView) {
        [self removeCameraView];
    }
}


- (void)addNavigationBar
{
    self.navigationController.navigationBarHidden = YES;
    
    _navigationBar = [[MyShowNavigationBar alloc] initWithFrame:self.view.frame
                                                       ColorStr:[NSString stringWithUTF8String:"#BD0007"]];
    _navigationBar.titleLabel.text = @"发布状态";
    
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"top_navigation_back"] forState:UIControlStateNormal];
    [_navigationBar.rightButton setTitle:@"下一步" forState:UIControlStateNormal];
    
    _navigationBar.delegate = self;
    [self.view addSubview:_navigationBar];
}


- (void)initCollectionView
{
    [self.collectionView registerClass:[PhotoViewCell class] forCellWithReuseIdentifier:@"PhotoViewCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"PhotoViewCell" bundle:nil] forCellWithReuseIdentifier:@"PhotoViewCell"];
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView reloadData];
}


- (void)leftButtonClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)rightButtonClick
{
    TagsViewController * tagsVC = [[TagsViewController alloc] init];
    tagsVC.uploadText = _textView.text;
    
    [self storeImages];
    
    tagsVC.uploadImagesDict = _imagesDict;
    
    
    //上传结束,拉起自定义tabbar
    tagsVC.didDistributeSuccess = ^(){
        MyTabBarViewController * tabbar = [AppDelegate GetAppDelegate].tabBarController;
        [tabbar hiddenTabbar:NO];
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    tagsVC.didDistributeFail = ^(){
        MyTabBarViewController * tabbar = [AppDelegate GetAppDelegate].tabBarController;
        [tabbar hiddenTabbar:NO];
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    
    [self.navigationController pushViewController:tagsVC animated:YES];
}

#pragma mark - 存储图片
- (void)storeImages
{
    int index = 0;
    
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString * documentsPath = [paths objectAtIndex:0];
    for (UIImage * image in _imageArray) {
        NSString *filePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"pic_%d.png", index]];
        // 保存文件的名称
        [UIImageJPEGRepresentation(image, 0) writeToFile:filePath atomically:YES];
        
        // 保存文件的名称
        [_imagesDict setObject:filePath forKey:[NSString stringWithFormat:@"pic_%d", index]];
        index ++;
    }
}

-(void)setImageArray:(NSArray *)imageArray
{
    _imageArray = [imageArray mutableCopy];
    [self generateFinalImageArrayWithArray:imageArray];
}

- (void)generateFinalImageArrayWithArray:(NSArray *)array
{
    self.finalImageArray = [[NSArray arrayWithArray:array] mutableCopy];
    [self.finalImageArray addObject:[UIImage imageNamed:@"AlbumAddBtn"]];
    [self.collectionView reloadData];
}


-(void)setImage:(UIImage *)image
{
    [self.imageArray addObject:image];
    [self generateFinalImageArrayWithArray:self.imageArray];
    [self.collectionView reloadData];
}


#pragma mark - UICollectionViewDelegate/Datasource
-(NSInteger)numberOfSectionsInCollectionView:
(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section
{
    return self.finalImageArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoViewCell * cell = (PhotoViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoViewCell"
                                  forIndexPath:indexPath];
    
    UIImage * image = [self.finalImageArray objectAtIndex:indexPath.row];
    [cell.myImageView setImage:image];
    cell.myImageView.tag = indexPath.row;
    


    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapProfileImage:)];
    tap.numberOfTapsRequired = 1;
    cell.myImageView .userInteractionEnabled = YES;
    [cell.myImageView addGestureRecognizer:tap];

    return cell;
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


- (void) tapProfileImage:(UITapGestureRecognizer *)gestureRecognizer{
    UIImageView *tableGridImage = (UIImageView*)gestureRecognizer.view;
    NSInteger index = tableGridImage.tag;
    if ([self.textView isFirstResponder]) {
        [self.textView resignFirstResponder];
    }
    if (index == (self.finalImageArray.count -1) )
    {
        [self showCameraView];
    }else{
        ImageDisplayViewController * displayVC = [[ImageDisplayViewController alloc] init];
        displayVC.images = self.imageArray;
        [self.navigationController pushViewController:displayVC animated:YES];
    }
}


#pragma mark - UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        _placeHolder.text = @"这一刻的想法...";
    }else{
        _placeHolder.text = @"";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (BOOL)showCameraView
{
    _isShowCameraView = YES;
    [UIView animateWithDuration:.2f animations:^{
        _cameraView.bottom = SCREEN_HEIGHT_OF_IPHONE5;
    } completion:nil];
    
    return YES;
}

- (BOOL)removeCameraView
{
    _isShowCameraView = NO;
    [UIView animateWithDuration:.2f animations:^{
        _cameraView.top = SCREEN_HEIGHT_OF_IPHONE5;
    } completion:nil];
    
    return NO;
}

#pragma cameraView delegate
- (void)openCameraButtonClick:(CameraView *)sender
{
    [self openCamera];
}

- (void)openAlbumButtonClick :(CameraView *)sender
{
    [self openAlbum];
}

#pragma mark - 打开相机
- (void)openCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        _picker = [[UIImagePickerController alloc] init];
        _picker.delegate = self;
        _picker.allowsEditing = YES;
        _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        _picker.showsCameraControls = YES;
        [self presentViewController:_picker animated:YES completion:NULL];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        _picker.wantsFullScreenLayout = NO;
    }
}

#pragma mark - 打开相册
- (void)openAlbum
{
    CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
    picker.maximumNumberOfSelection = 10;
    picker.assetsFilter = [ALAssetsFilter allAssets];
    picker.delegate = self;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark - AssetsPicker Delegate

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    NSLog(@"self.imageArray:%@",self.imageArray);
    for (ALAsset * asset in assets) {
        
        
        //获取资源图片的详细资源信息
        ALAssetRepresentation* representation = [asset defaultRepresentation];
        //获取高清图片
        UIImage * hignQualityImage = [UIImage imageWithCGImage:[representation fullResolutionImage]];
        
        hignQualityImage = [UIImage imageWithData:UIImageJPEGRepresentation(hignQualityImage, 0)];
        
        [self.imageArray addObject:hignQualityImage];
    }
    [self generateFinalImageArrayWithArray:self.imageArray];
    [self removeCameraView];
}

- (void)assetsPickerControllerDidCancel:(CTAssetsPickerController *)picker
{
//    if (self.imageArray.count <= 0) {
        [picker dismissViewControllerAnimated:YES completion:nil];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [self removeCameraView];

//    }
}


#pragma mark UIImagePickerController Delegate
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    UIImage * image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    
    image = [UIImage imageWithData:UIImageJPEGRepresentation(image, 0)];
    
    [self.imageArray addObject:image];
    [self generateFinalImageArrayWithArray:self.imageArray];
    [self removeCameraView];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
//    if (self.imageArray.count <= 0) {
        [picker dismissViewControllerAnimated:YES completion:nil];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [self removeCameraView];
//    }
}




@end
