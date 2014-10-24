//
//  DetailCommentView.m
//  MyShow
//
//  Created by wang dong on 8/9/14.
//  Copyright (c) 2014 maxingchuan. All rights reserved.
//

#import "DetailCommentView.h"

@implementation DetailCommentView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    _mainTableView = [[ITTPullTableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
//    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_mainTableView];
}

@end
