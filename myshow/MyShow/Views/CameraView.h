//
//  CameraView.h
//  MyShow
//
//  Created by unakayou on 14-5-22.
//  Copyright (c) 2014年 unakayou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CameraView;

@protocol CameraViewDelegate <NSObject>

@optional
- (void)openCameraButtonClick:(CameraView *)sender;
- (void)openAlbumButtonClick :(CameraView *)sender;

@end

@interface CameraView : UIView

- (id)initWithImages:(NSArray *)images backgroundImage:(UIImage *)backgroundImage;

@property (nonatomic, retain, readonly) UIImageView * backgroundView;
@property (nonatomic, assign) id <CameraViewDelegate> delegate;

@end
