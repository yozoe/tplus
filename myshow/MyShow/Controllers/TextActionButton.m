//
//  CellActionButton.m
//  MyShow
//
//  Created by wang dong on 8/3/14.
//  Copyright (c) 2014 maxingchuan. All rights reserved.
//

#import "TextActionButton.h"
#import "MyShowTools.h"

@interface TextActionButton()
{
    UILabel *_numberLabel;
}

@end

@implementation TextActionButton

+ (id)createWithTitle:(NSString *)title
{
    TextActionButton *view = [[TextActionButton alloc] initWithFrame:CGRectMake(0, 0, 78, 25)];
    [view crateButtonWithTitle:title];
    return view;
}

- (void)initView
{
    _actionButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _actionButton.width = 78;
    _actionButton.height = 25;
    _actionButton.layer.borderColor = [self borderColor];
    _actionButton.layer.borderWidth = [self borderWidth];
    _actionButton.titleEdgeInsets = UIEdgeInsetsMake(2, -30, 0, 0);
    _actionButton.titleLabel.font = [UIFont systemFontOfSize:11.f];

    _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(42, self.height / 2 - 8, self.width - 42, 15)];
    _numberLabel.textColor = [MyShowTools hexStringToColor:@"#8e8e8e"];
    _numberLabel.font = [UIFont systemFontOfSize:10.f];
    _numberLabel.text = @"1";
    [self addSubview:_numberLabel];

    [_actionButton setTitleColor:[MyShowTools hexStringToColor:@"#626262"] forState:UIControlStateNormal];
    [self addSubview:_actionButton];
}

- (CGColorRef)borderColor
{
    return [UIColor blackColor].CGColor;
}

- (CGFloat)borderWidth
{
    return 1.f;
}

- (void)crateButtonWithTitle:(NSString *)title
{
    [_actionButton setTitle:title forState:UIControlStateNormal];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)setNumberText:(NSString *)number
{
    _numberLabel.text = number;
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)events
{
    [_actionButton addTarget:target action:action forControlEvents:events];
}

@end
