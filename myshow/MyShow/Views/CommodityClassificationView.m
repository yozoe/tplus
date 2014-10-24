//
//  CommodityClassification.m
//  MyShow
//
//  Created by unakayou on 14-4-17.
//  Copyright (c) 2014年 unakayou. All rights reserved.
//
//  商品分类
#import "CommodityClassificationView.h"

@implementation CommodityClassificationView
@synthesize titleLabel;
@synthesize backgroundImageView;

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        backgroundImageView = [[UIImageView alloc] init];
        [self addSubview:backgroundImageView];

        titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor whiteColor];
        titleLabel.alpha = 0.5;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    float titleLabelWidth  = self.frame.size.width;
    float titleLabelHeight = self.frame.size.height / 3;
    self.titleLabel.frame = CGRectMake(0, self.frame.size.height - titleLabelHeight, titleLabelWidth, titleLabelHeight);
    
    self.backgroundImageView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"点到了标签:%d",(int)self.tag + 1);
}

@end
