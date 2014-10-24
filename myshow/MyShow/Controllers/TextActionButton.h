//
//  CellActionButton.h
//  MyShow
//
//  Created by wang dong on 8/3/14.
//  Copyright (c) 2014 maxingchuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextActionButton : UIView
{
@protected
    UIButton *_actionButton;
}

+ (id)createWithTitle:(NSString *)title;
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)events;
- (void)setNumberText:(NSString *)number;

@end
