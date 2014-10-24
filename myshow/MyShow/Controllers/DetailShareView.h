//
//  ShareView.h
//  MyShow
//
//  Created by wang dong on 14-8-18.
//  Copyright (c) 2014年 maxingchuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SelectShareBlock)(NSString *);

@interface DetailShareView : UIView

@property (copy, nonatomic) SelectShareBlock selectShareBlock;

+ (DetailShareView *)createShareViewWithFrame:(CGRect)frame;

@end
