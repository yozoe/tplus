//
//  DistributeViewController.h
//  MyShow
//
//  Created by max on 14-7-22.
//  Copyright (c) 2014年 maxingchuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyShowNavigationBar.h"
#import "CameraView.h"
#import "CTAssetsPickerController.h"
#import "BaseViewController.h"

@interface DistributeViewController : BaseViewController<UITextViewDelegate,NavigationBarDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,CTAssetsPickerControllerDelegate,CameraViewDelegate,UINavigationControllerDelegate>
{
    MyShowNavigationBar * _navigationBar;
    CameraView * _cameraView;
    UIImagePickerController *_picker;
    BOOL _isShowCameraView;
//    UIView * _maskView;
}
@property (strong, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSMutableArray * imageArray;
@property (strong, nonatomic) NSMutableArray * finalImageArray;
@property (strong, nonatomic) UIImage * image;


@end
