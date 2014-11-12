//
//  MyTabBarViewController.m
//  MyShow
//
//  Created by max on 14-8-5.
//  Copyright (c) 2014年 maxingchuan. All rights reserved.
//

#import "MyTabBarViewController.h"
#import "HomeViewController.h"
#import "PersonalHomePageViewController.h"
#import "MyShowDefine.h"
#import "DistributeViewController.h"
#import "MyShowTools.h"


@interface MyTabBarViewController ()

@end

@implementation MyTabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _isShowCameraView = NO;
        _imageArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self initViewCtrls];
    [self initCustumTabbar];
    [self initCameraView];
}

- (void)initViewCtrls
{
    HomeViewController * homeVC = [[HomeViewController alloc] init];
    UINavigationController * homeNav = [[UINavigationController alloc] initWithRootViewController:homeVC];
//    homeNav.navigationBarHidden = YES;
    [homeNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBg.png"] forBarMetrics:UIBarMetricsDefault];

    [homeNav.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor whiteColor], UITextAttributeTextColor,
                                                                     [UIColor whiteColor], UITextAttributeTextShadowColor,
//                                                                     [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset,
//                                                                     [UIFont fontWithName:@"Arial-Bold" size:0.0], UITextAttributeFont,
                                                                     nil]];
    homeNav.delegate = self;
    
    
    
    
    
    
    PersonalHomePageViewController * personHomePageVC = [[PersonalHomePageViewController alloc] init];
    UINavigationController * homePageNav = [[UINavigationController alloc] initWithRootViewController:personHomePageVC];
//    homePageNav.navigationBarHidden = YES;
    [homePageNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBg.png"] forBarMetrics:UIBarMetricsDefault];
    
    [homePageNav.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                   [UIColor whiteColor], UITextAttributeTextColor,
                                                   [UIColor whiteColor], UITextAttributeTextShadowColor,
                                                   //                                                                     [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset,
                                                   //                                                                     [UIFont fontWithName:@"Arial-Bold" size:0.0], UITextAttributeFont,
                                                   nil]];
    
    homePageNav.delegate = self;
    
    self.viewControllers = @[homeNav,homePageNav];
    
}

- (void)initCustumTabbar
{
    CGRect frame = CGRectMake(0, self.view.frame.size.height - ICON_LENGTH, self.view.frame.size.width, ICON_LENGTH);
    _mainTableBar = [[HeiShowMainTableBar alloc] initWithFrame:frame];
    _mainTableBar.delegate = self;
    
    _mainTableBar.backgroundColor  = [MyShowTools hexStringToColor:@"#BD0007"];
    [self.view addSubview:_mainTableBar];
}

- (void)initCameraView
{
    NSArray * array = [NSArray arrayWithObjects:[UIImage imageNamed:@"xiangce.png"],[UIImage imageNamed:@"paizhao.png"], nil];
    _cameraView = [[CameraView alloc] initWithImages:array backgroundImage:[UIImage imageNamed:@"fabubeijing"]];
    _cameraView.delegate = self;
    if (is4InchScreen()) {

        _cameraView.frame = CGRectMake((320 - 230) / 2,
                                       SCREEN_HEIGHT_OF_IPHONE5,
                                       230, 87);
    } else {
        _cameraView.frame = CGRectMake((320 - 230) / 2,
                                       480,
                                       230, 87);
    }


    [self.view insertSubview:_cameraView belowSubview:_mainTableBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self removeCameraView];
}

#pragma mark - TabbarSelect Action
- (void)tablebarDidSelectedAtIndex:(int)index
{
    switch (index)
    {
        case 0:
            self.selectedIndex = 0;
            break;
        case 1:
        {
            if (_isShowCameraView)
                [self removeCameraView];
            else
                [self showCameraView];
        }
            break;
        case 2:
        {
            self.selectedIndex = 1;
        }
            break;
        default:
            break;
    }
}

- (BOOL)showCameraView
{
    _isShowCameraView = YES;
    [UIView animateWithDuration:.2f animations:^{
        if (is4InchScreen()) {
            _cameraView.bottom = SCREEN_HEIGHT_OF_IPHONE5 - 49;
        } else {
            _cameraView.bottom = 480 - 49;
        }

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
    if (!self.imageArray)
        self.imageArray = [[NSMutableArray alloc] init];
    CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
    picker.maximumNumberOfSelection = 10;
    picker.assetsFilter = [ALAssetsFilter allAssets];
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    picker.wantsFullScreenLayout = NO;
}

#pragma mark - Assets Picker Delegate
- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    [UIView animateWithDuration:.5 animations:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }];
   
    if (self.imageArray.count > 0) {
        [self.imageArray removeAllObjects];
    }

    for (ALAsset * asset in assets) {
        //获取资源图片的详细资源信息
        ALAssetRepresentation* representation = [asset defaultRepresentation];
        //获取高清图片
        UIImage * image = [UIImage imageWithCGImage:[representation fullResolutionImage]];
        [self.imageArray addObject:image];
    }
    
    DistributeViewController * distributeVC = [[DistributeViewController alloc] init];
    UINavigationController * distributeNav = [[UINavigationController alloc] initWithRootViewController:distributeVC];
    distributeNav.delegate = self;
    distributeNav.navigationBarHidden = YES;
    distributeVC.imageArray = self.imageArray;
    [picker dismissViewControllerAnimated:YES completion:^{
        [self presentViewController:distributeNav animated:YES completion:nil];
        [self removeCameraView];
    }];

}

#pragma mark - 系统 Picker Delegate
- (void)assetsPickerControllerDidCancel:(CTAssetsPickerController *)picker
{
    [UIView animateWithDuration:.5 animations:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }];
    [picker dismissViewControllerAnimated:YES completion:^{
        [self removeCameraView];
    }];
    
}


#pragma mark UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [UIView animateWithDuration:.5 animations:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }];

    UIImage * image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    UIImage * newImage = [UIImage imageWithData:UIImageJPEGRepresentation(image, 0)];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        DistributeViewController * distributeVC = [[DistributeViewController alloc] init];
        UINavigationController * disNav = [[UINavigationController alloc] initWithRootViewController:distributeVC];
        disNav.delegate = self;
        disNav.navigationBarHidden = YES;
        distributeVC.image = newImage;
        [self presentViewController:disNav animated:YES completion:nil];
        [self removeCameraView];
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [UIView animateWithDuration:.5 animations:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }];
    [picker dismissViewControllerAnimated:YES completion:^{
        [self removeCameraView];
    }];
    
}


#pragma mark -
#pragma mark UINavigationController Delegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    int count = navigationController.viewControllers.count;
    if (count == 1) {
        [self hiddenTabbar:NO];
    }else{
        [self hiddenTabbar:YES];
        [self removeCameraView];
    }
}

- (void)hiddenTabbar:(BOOL)hidden
{
    [UIView animateWithDuration:.2 animations:^{
        if (hidden) {
            if (is4InchScreen()) {
                _mainTableBar.top = SCREEN_HEIGHT_OF_IPHONE5 + 20;
            } else {
                _mainTableBar.top = 500;
            }

        }else{
            if (is4InchScreen()) {
                _mainTableBar.bottom = SCREEN_HEIGHT_OF_IPHONE5;
            } else {
                _mainTableBar.bottom = 480;
            }

        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
