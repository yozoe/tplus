//
//  UIPlaceHolderTextView.h
//  RongXin
//
//  Created by melody on 14-1-20.
//  Copyright (c) 2014年 KSY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPlaceHolderTextView : UITextView

@property (nonatomic, retain) NSString *placeholder;

@property (nonatomic, retain) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end
