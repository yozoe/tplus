//
//  CommentInputView.m
//  MyShow
//
//  Created by wang dong on 14-8-11.
//  Copyright (c) 2014年 maxingchuan. All rights reserved.
//

#import "CommentInputView.h"

@implementation CommentInputView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    _inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 6, 240, 30)];
    _inputTextField.borderStyle = UITextBorderStyleLine;
    _inputTextField.delegate = self;
    _inputTextField.placeholder = @"请输入评论";
    [self addSubview:_inputTextField];

    _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
    _sendButton.width = 50;
    _sendButton.height = 30;
    _sendButton.left = _inputTextField.right + 10;
    _sendButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
    _sendButton.backgroundColor = [UIColor grayColor];
    [_sendButton addTarget:self action:@selector(handleSendButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    _sendButton.centerY = _inputTextField.centerY;

    [self addSubview:_sendButton];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, 320, 0);
    CGContextStrokePath(context);
}

- (void)show
{
    [UIView animateWithDuration:0.3 animations:^{
        self.bottom = [[UIScreen mainScreen] bounds].size.height;
    }];
}

- (void)hide
{
    [UIView animateWithDuration:0.3 animations:^{
        self.top = [[UIScreen mainScreen] bounds].size.height;
    }];
}

- (void)clear
{
    _inputTextField.text = @"";
}

- (void)handleSendButtonEvent
{
    NSString *txt = _inputTextField.text;
    txt = [txt stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (txt.length > 0) {
        if (_commentSendCompleteBlock) {
            _commentSendCompleteBlock(txt);
        }
    }
}

@end
