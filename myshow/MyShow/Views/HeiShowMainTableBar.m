//
//  HeiShowMainTableBar.m
//  MyShow
//
//  Created by unakayou on 14-5-18.
//  Copyright (c) 2014年 unakayou. All rights reserved.
//

#import "HeiShowMainTableBar.h"
#import "MyShowDefine.h"

@implementation HeiShowMainTableBar
@synthesize detailsButton;
@synthesize mySpaceButton;
@synthesize photoButton;
@synthesize currentSelect;
@synthesize lastSelected;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.clipsToBounds = NO;
        
        detailsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.detailsButton setTag:99];
        [self.detailsButton setImage:[UIImage imageNamed:@"faxian.png"] forState:UIControlStateNormal];
        [self.detailsButton setImage:[UIImage imageNamed:@"faxian_select.png"] forState:UIControlStateHighlighted];
        [self.detailsButton setImage:[UIImage imageNamed:@"faxian_select.png"] forState:UIControlStateSelected];
        [self.detailsButton addTarget:self action:@selector(tablebarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.detailsButton setSelected:YES];
        [self addSubview:self.detailsButton];
        
        mySpaceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.mySpaceButton setTag:self.detailsButton.tag + 2];
        [self.mySpaceButton setImage:[UIImage imageNamed:@"geren.png"] forState:UIControlStateNormal];
        [self.mySpaceButton setImage:[UIImage imageNamed:@"geren_select.png"] forState:UIControlStateSelected];
        [self.mySpaceButton setImage:[UIImage imageNamed:@"geren_select.png"] forState:UIControlStateHighlighted];
        [self.mySpaceButton addTarget:self action:@selector(tablebarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.mySpaceButton];
        
        photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.photoButton setTag:self.detailsButton.tag + 1];
        [self.photoButton setImage:[UIImage imageNamed:@"fabu.png"] forState:UIControlStateNormal];
        [self.photoButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.photoButton addTarget:self action:@selector(tablebarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.photoButton];
        
        self.currentSelect = 0;
        self.lastSelected  = 0;
    }
    return self;
}

- (void)tablebarButtonClick:(UIButton *)sender
{
    self.lastSelected  = self.currentSelect;
    self.currentSelect = sender.tag - 99;
    if ([self.delegate respondsToSelector:@selector(tablebarDidSelectedAtIndex:)])
        [self.delegate tablebarDidSelectedAtIndex:self.currentSelect];
    [self updateUI];
}

- (void)updateUI
{
    if (self.currentSelect == 1) return;
    for (id obj in self.subviews)
    {
        if ([obj isKindOfClass:[UIButton class]])
        {
            UIButton * button = (UIButton *)obj;
            if (button.tag == self.currentSelect + 99)
                [button setSelected:YES];
            else
                [button setSelected:NO];
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    float length = self.frame.size.height - SPACE;
    
    self.photoButton.frame = CGRectMake((self.frame.size.width - self.frame.size.height) / 2, - SPACE, self.frame.size.height, self.frame.size.height);
    
    self.detailsButton.frame = CGRectMake(((self.frame.size.width - self.photoButton.frame.size.width) / 2 - length) / 2,
                                          (self.frame.size.height - length) / 2,
                                          length, length);
    
    self.mySpaceButton.frame = CGRectMake(self.frame.size.width - (self.frame.size.width - self.photoButton.frame.size.width) / 4 - length / 2,
                                          (self.frame.size.height - length) / 2,
                                          length, length);
}

@end
