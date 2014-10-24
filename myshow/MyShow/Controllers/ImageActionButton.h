//
//  ImageActionButton.h
//  MyShow
//
//  Created by wang dong on 8/3/14.
//  Copyright (c) 2014 maxingchuan. All rights reserved.
//

#import "TextActionButton.h"

@interface ImageActionButton : TextActionButton

+ (id)createWithImage:(UIImage *)image;
- (void)setImage:(UIImage *)image forState:(UIControlState)state;

@end
