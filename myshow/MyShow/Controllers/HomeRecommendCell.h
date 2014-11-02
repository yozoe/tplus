//
//  HomeRecommendCell.h
//  MyShow
//
//  Created by wang dong on 7/30/14.
//  Copyright (c) 2014 maxingchuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemHeader.h"
#import "TextActionButton.h"
#import "ImageActionButton.h"
#import "UserModel.h"

#define HOME_CELL_FOOT_HEIGHT 40

typedef void (^CommentHandlerBlock)();
typedef void (^TagHanlderBlock)();
typedef void (^FavourHanlderBlock)();
typedef void (^PortraitHandlerBlock)();
typedef void (^ImageViewClickHanlderBlock)(NSInteger);

@interface HomeRecommendCell : UITableViewCell <UIGestureRecognizerDelegate>
{
@protected
    UIView *_imagesView;
    UIImageView *_portraitImageView;
    UIView *_headerView;
    UIView *_bodyView;
    UIView *_footerView;
    UILabel *_publichLabel;
    UILabel *_timeLabel;
    UILabel *_usernameLabel;
    TextActionButton *_commentButton;
    TextActionButton *_tagButton;
    ImageActionButton *_favourButton;
}

@property (strong, nonatomic) ItemModel *itemModel;
@property (assign, nonatomic) NSInteger incrementHeight;

@property (copy, nonatomic) CommentHandlerBlock commentBlock;
@property (copy, nonatomic) TagHanlderBlock tagBlock;
@property (copy, nonatomic) FavourHanlderBlock favourBlock;
@property (copy, nonatomic) ImageViewClickHanlderBlock imageViewClickHandlerBlock;
@property (copy, nonatomic) PortraitHandlerBlock portraitHandleBlock;
@property (assign, nonatomic) BOOL fixImageHeight;
@property (assign, nonatomic) BOOL isSquare;
@property (strong, nonatomic) UIButton *shareButton;

- (void)refresh;
- (void)isLike:(BOOL)isLike;
- (void)updateLike;

@end
