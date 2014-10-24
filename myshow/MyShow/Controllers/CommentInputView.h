//
//  CommentInputView.h
//  MyShow
//
//  Created by wang dong on 14-8-11.
//  Copyright (c) 2014年 maxingchuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CommentSendCompleteBlock)(NSString *);

@interface CommentInputView : UIView <UITextFieldDelegate>

@property (retain, nonatomic) UITextField *inputTextField;
@property (retain, nonatomic) UIButton *sendButton;
@property (copy, nonatomic) CommentSendCompleteBlock commentSendCompleteBlock;

- (void)show;
- (void)hide;
- (void)clear;

@end
