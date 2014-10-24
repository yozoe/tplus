//
//  HeiShowMainTableBar.h
//  MyShow
//
//  Created by unakayou on 14-5-18.
//  Copyright (c) 2014年 unakayou. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HeiShowmainTableBarDelegate <NSObject>

@optional
- (void)tablebarDidSelectedAtIndex:(int)index;

@end

@interface HeiShowMainTableBar : UIView

@property (nonatomic, retain) UIButton * detailsButton;
@property (nonatomic, retain) UIButton * photoButton;
@property (nonatomic, retain) UIButton * mySpaceButton;

@property (nonatomic, assign) int currentSelect;
@property (nonatomic, assign) int lastSelected;

@property (nonatomic, assign) id <HeiShowmainTableBarDelegate> delegate;
@end
