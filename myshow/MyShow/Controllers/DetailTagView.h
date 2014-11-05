//
//  DetailTagView.h
//  MyShow
//
//  Created by wang dong on 8/7/14.
//  Copyright (c) 2014 maxingchuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagModel.h"
#import "LinksModel.h"
@class LinkLabel;

@protocol DetailTagViewDataSource <NSObject>

@required
- (TagModel *)tagItemAtIndex:(NSInteger)index;
- (NSInteger)numberOfTags;
- (LinksModel *)linkItemAtIndex:(NSInteger)index;
- (NSInteger)numberOfLinks;

@end

@protocol DetailTagViewDelegate <NSObject>

@optional
- (void)didClickLink:(NSInteger)index;
- (void)clickedTagAtIndex:(NSInteger)index;

@end

@interface DetailTagView : UIScrollView

@property (assign, nonatomic) id<DetailTagViewDataSource> tagDataSource;
@property (assign, nonatomic) id<DetailTagViewDelegate> tagDelegate;

- (void)configData;

@end

@interface LinkLabel : UILabel

@end

@interface TagLabel : UILabel

@end