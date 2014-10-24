//
//  PhotoViewCell.m
//  MyShow
//
//  Created by max on 14-7-28.
//  Copyright (c) 2014年 maxingchuan. All rights reserved.
//

#import "PhotoViewCell.h"

@implementation PhotoViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    self.myImageView.layer.borderWidth = 1.0f;
//    self.myImageView.layer.borderColor = [UIColor colorWithWhite:0.727 alpha:1.000].CGColor;
//    [self.myImageView clipsToBounds];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
