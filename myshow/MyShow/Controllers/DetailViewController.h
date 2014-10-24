//
//  PublishDetailViewController.h
//  MyShow
//
//  Created by wang dong on 8/6/14.
//  Copyright (c) 2014 maxingchuan. All rights reserved.
//

#import "BaseViewController.h"
#import "MWPhotoBrowser.h"
#import "DrawerViewController.h"
#import "ItemModel.h"
#import "CommentInputView.h"

@interface DetailViewController : MWPhotoBrowser<DrawerViewControllerDelegate, UMSocialUIDelegate>

@property (retain, nonatomic) UIView *drawerView;
@property (retain, nonatomic) DrawerViewController *drawerViewController;
@property (retain, nonatomic) ItemModel *item;
@property (nonatomic, assign) BOOL showCommentView;
@property (nonatomic, assign) BOOL showTagView;

- (void)updatePhotoIndexViewWithIndex:(NSInteger)index;

@end
