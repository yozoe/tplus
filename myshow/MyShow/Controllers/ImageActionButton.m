//
//  ImageActionButton.m
//  MyShow
//
//  Created by wang dong on 8/3/14.
//  Copyright (c) 2014 maxingchuan. All rights reserved.
//

#import "ImageActionButton.h"

@implementation ImageActionButton

+ (id)createWithImage:(UIImage *)image
{
    ImageActionButton *view = [[ImageActionButton alloc] initWithFrame:CGRectMake(0, 0, 60, 25)];
    [view crateButtonWithImage:image];
    return view;
}

- (void)crateButtonWithImage:(UIImage *)image
{
    [_actionButton setImage:image forState:UIControlStateNormal];
    [_actionButton setImageEdgeInsets:UIEdgeInsetsMake(2, -30, 0, 0)];
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
    [_actionButton setImage:image forState:state];
}

- (CGColorRef)borderColor
{
    return nil;
}

- (CGFloat)borderWidth
{
    return 0.f;
}

@end
