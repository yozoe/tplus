
//  DrawerViewController.h
//  MyShow
//
//  Created by wang dong on 8/6/14.
//  Copyright (c) 2014 maxingchuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailTagView.h"
#import "ItemModel.h"
#import "BaseViewController.h"
#import "DetailCommentView.h"
#import "CommentCell.h"

typedef enum : NSUInteger {
    DrawerMoveToTop,
    DrawerMovoToMiddle,
    DrawerMoveToBottom,
} DrawerMovePosition;

@protocol DrawerViewControllerDelegate <NSObject>

- (void)drawerMovePosition:(DrawerMovePosition)position;
- (void)showInputView;
- (void)hideInputView;
- (void)clearInputView;
- (void)shareWithType:(NSString *)type;
- (void)showWebViewWithLink:(LinksModel *)link;

@end

@interface DrawerViewController : BaseViewController <DetailTagViewDataSource, DetailTagViewDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, ITTPullTableViewDelegate>

- (id)initWithItem:(ItemModel *)item;

@property (nonatomic, retain) ItemModel *item;
@property (nonatomic, assign) id<DrawerViewControllerDelegate> delegate;
@property (nonatomic, assign) BOOL isExpand;
@property (nonatomic, retain) UIView *drawerHeaderView;

- (BOOL)isComment;
- (void)fixCommentTableViewHeight:(CGFloat)height;
- (void)reloadCommentData;
- (void)showCommentView;
- (void)showTagView;

@end
