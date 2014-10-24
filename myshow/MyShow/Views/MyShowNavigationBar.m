//
//  MyShowNavigationBar.m
//  MyShow
//
//  Created by unakayou on 14-4-17.
//  Copyright (c) 2014年 unakayou. All rights reserved.
//

#import "MyShowNavigationBar.h"
#import "MyShowTools.h"
#import "MyShowDefine.h"

@implementation MyShowNavigationBar
@synthesize titleLabel;
@synthesize leftButton;
@synthesize rightButton;

- (id)initWithFrame:(CGRect)frame ColorStr:(NSString *)colorStr
{
    CGRect tmpFrame = frame;
    if (iOS7)
        tmpFrame = CGRectMake(0, 0, frame.size.width, NAV_HEIGHT + STATUS_BAR_HEIGHT);
    else
        tmpFrame = CGRectMake(0, 0, frame.size.width, NAV_HEIGHT);
    
    if (self = [super initWithFrame:tmpFrame])
    {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth; //自动旋转
        if (iOS7)
        {
            self.translucent = NO;
            self.tintColor     = [UIColor whiteColor];
            self.barTintColor  = [MyShowTools hexStringToColor:colorStr];
//            [self setBackgroundImage:[UIImage imageNamed:@"top_navigation_background"] forBarMetrics:UIBarMetricsDefault];
        }
        else
        {
            self.tintColor  = [MyShowTools hexStringToColor:colorStr];
            UIImageView * navigationBarBackgroundImageView = [[UIImageView alloc] initWithImage:[MyShowTools createImageWithColor:[MyShowTools hexStringToColor:colorStr]]];
            navigationBarBackgroundImageView.frame = self.bounds;
            navigationBarBackgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            [self insertSubview:navigationBarBackgroundImageView atIndex:1];
            //加入到backGroundView上面。
        }

        UINavigationItem * navItem = [[UINavigationItem alloc] init];
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tmpFrame.size.height * 2, tmpFrame.size.height)];
        IOS6_7_DELTA(titleLabel, 0, 20, 0, -20);
        [self.titleLabel setTextColor:[UIColor whiteColor]];
        [self.titleLabel setBackgroundColor:[UIColor clearColor]];
        [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self.titleLabel setFont:[UIFont boldSystemFontOfSize:TITLE_FONT_SIZE]];
        [navItem setTitleView:self.titleLabel];
        [self pushNavigationItem:navItem animated:YES];

        

        leftButton = [UIButton buttonWithType:UIButtonTypeCustom]; //关闭按钮
        [leftButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
        [self addSubview:leftButton];
        [leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        rightButton = [UIButton buttonWithType:UIButtonTypeCustom]; //关闭按钮
        [rightButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
        [self addSubview:rightButton];
        [rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)layoutSubviews
{
    CGRect frame = self.frame;
    float buttonWidth = frame.size.height;
  
    leftButton.frame = CGRectMake(0, 0, buttonWidth, frame.size.height);
    leftButton.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    IOS6_7_DELTA(leftButton, 0, 20, 0, -20);
    
    rightButton.frame = CGRectMake(frame.size.width - buttonWidth, 0, buttonWidth, frame.size.height);
    rightButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    IOS6_7_DELTA(rightButton, 0, 20, 0, -20);
}

- (void)setLeftButton:(UIButton *)newLeftButton
{
    if (leftButton == newLeftButton) return;
    if (leftButton == nil) return;
    if (newLeftButton == nil) [leftButton removeFromSuperview]; leftButton = nil;
    leftButton = newLeftButton;
}

-(void)setRightButton:(UIButton *)newRightButton
{
    if (rightButton == newRightButton) return;
    if (rightButton == nil) return;
    if (newRightButton == nil) [rightButton removeFromSuperview]; rightButton = nil;
    rightButton = newRightButton;
}


- (void)leftButtonClick:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(leftButtonClick)])
        [self.delegate leftButtonClick];
}

- (void)rightButtonClick:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(rightButtonClick)])
        [self.delegate rightButtonClick];
}

@end
