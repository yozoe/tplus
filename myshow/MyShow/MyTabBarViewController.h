//
//  MyTabBarViewController.h
//  MyShow
//
//  Created by max on 14-8-5.
//  Copyright (c) 2014年 maxingchuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeiShowMainTableBar.h"
#import "CameraView.h"
#import "CTAssetsPickerController.h"
//#import "itttab"

@interface MyTabBarViewController : UITabBarController <UINavigationControllerDelegate,HeiShowmainTableBarDelegate,CameraViewDelegate,CTAssetsPickerControllerDelegate,UIImagePickerControllerDelegate>
{
    HeiShowMainTableBar * _mainTableBar;
    CameraView * _cameraView;
    UIImagePickerController *_picker;
    UIView * _maskView;
}

@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, assign) BOOL isShowCameraView;

- (BOOL)showCameraView;
- (BOOL)removeCameraView;
- (void)hiddenTabbar:(BOOL)hidden;

@end
