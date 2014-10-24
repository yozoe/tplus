//
//  CommodityClassificationScrollView.m
//  MyShow
//
//  Created by unakayou on 14-4-18.
//  Copyright (c) 2014年 unakayou. All rights reserved.
//

#import "CommodityClassificationScrollView.h"
#import "MyShowDefine.h"
#import "CommodityClassificationView.h"

@implementation CommodityClassificationScrollView
@synthesize scrollView;
@synthesize scrollViewArray;

- (id)initWithFrame:(CGRect)frame contentArray:(NSArray *)contentArray
{
    if (self = [super initWithFrame:frame])
    {
        scrollView = ({
            UIScrollView * scroll = [[UIScrollView alloc] init];
            scroll.backgroundColor = [UIColor clearColor];
            scroll.pagingEnabled = YES;
            scroll.bounces = NO;
            scroll.clipsToBounds = NO;
            scroll.directionalLockEnabled = YES;
            scroll.showsVerticalScrollIndicator=NO;
            scroll.showsHorizontalScrollIndicator=NO;
            scroll;
        });
        
        self.scrollViewArray = contentArray;
        
        [self addSubview:scrollView];
        
        for (int i = 0; i < [self.scrollViewArray count]; i++)
            [self addCommodityClassificationViewWithArray:self.scrollViewArray inScrollView:self.scrollView atIndex:i];
    }
    return self;
}

//分类选择单个小视图
- (void)addCommodityClassificationViewWithArray:(NSArray *)array inScrollView:(UIView *)fatherView atIndex:(int)index
{
    CommodityClassificationView * view = [[CommodityClassificationView alloc] init];
    view.tag = index;
    view.layer.borderWidth = 1.0;
    view.titleLabel.text = [array objectAtIndex:index];
    [fatherView addSubview:view];
}

- (void)layoutSubviews
{
    self.scrollView.frame = CGRectMake(SPACE / 2,
                                       0,
                                       self.frame.size.height - SPACE / 2,
                                       self.frame.size.height);
    
    float offsetX = (ICON_LENGTH * 2 + SPACE / 2) * [self.scrollViewArray count] - self.frame.size.width + self.scrollView.frame.size.width + SPACE / 2;
    self.scrollView.contentSize = CGSizeMake(offsetX,
                                             self.frame.size.height);
    [self layoutScrollViewSubViews:self.scrollView];
}

- (void)layoutScrollViewSubViews:(UIScrollView *)tmpScrollView
{
    for (CommodityClassificationScrollView * view in tmpScrollView.subviews)
    {
        float index = [tmpScrollView.subviews indexOfObject:view];
        float startX = index * (ICON_LENGTH * 2 + SPACE / 2);
        float startY = (tmpScrollView.frame.size.height - ICON_LENGTH * 2) / 2;
        view.frame = CGRectMake(startX, startY, ICON_LENGTH * 2, ICON_LENGTH * 2);
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView * view = [super hitTest:point withEvent:event];
    if ([view isEqual:self])
    {
        for (UIView * subview in self.scrollView.subviews)
        {
            CGPoint offset = CGPointMake(point.x - self.scrollView.frame.origin.x + self.scrollView.contentOffset.x - subview.frame.origin.x,
                                         point.y - self.scrollView.frame.origin.y + self.scrollView.contentOffset.y - subview.frame.origin.y);
            
            if ((view = [subview hitTest:offset withEvent:event]))
                return view;
        }
        return self.scrollView;
    }
    return view;
}

@end
