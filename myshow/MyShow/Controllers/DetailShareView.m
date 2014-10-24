//
//  ShareView.m
//  MyShow
//
//  Created by wang dong on 14-8-18.
//  Copyright (c) 2014年 maxingchuan. All rights reserved.
//

#import "DetailShareView.h"

/**
 新浪微博
 */
extern NSString *const UMShareToSina;

/**
 腾讯微博
 */
extern NSString *const UMShareToTencent;

/**
 人人网
 */
extern NSString *const UMShareToRenren;

/**
 豆瓣
 */
extern NSString *const UMShareToDouban;

/**
 QQ空间
 */
extern NSString *const UMShareToQzone;

/**
 邮箱
 */
extern NSString *const UMShareToEmail;

/**
 短信
 */
extern NSString *const UMShareToSms;

/**
 微信好友
 */
extern NSString *const UMShareToWechatSession;

/**
 微信朋友圈
 */
extern NSString *const UMShareToWechatTimeline;

/**
 微信收藏
 */
extern NSString *const UMShareToWechatFavorite;

/**
 手机QQ
 */
extern NSString *const UMShareToQQ;

/**
 Facebook
 */
extern NSString *const UMShareToFacebook;

/**
 Twitter
 */
extern NSString *const UMShareToTwitter;


/**
 易信好友
 */
extern NSString *const UMShareToYXSession;

/**
 易信朋友圈
 */
extern NSString *const UMShareToYXTimeline;

/**
 来往好友
 */
extern NSString *const UMShareToLWSession;

/**
 来往朋友圈
 */
extern NSString *const UMShareToLWTimeline;

/**
 分享到Instragram
 */
extern NSString *const UMShareToInstagram;

@implementation DetailShareView

+ (DetailShareView *)createShareViewWithFrame:(CGRect)frame
{
    DetailShareView *view = [[DetailShareView alloc] initWithFrame:frame];

    [view createShareButtonWithFrame:CGRectMake(20, 10, 39, 39) title:@"新浪微博" imageName:@"share_sina@2x" index:0];
    [view createShareButtonWithFrame:CGRectMake(100, 10, 39, 39) title:@"朋友圈" imageName:@"share_wechat_timeline@2x" index:1];
    [view createShareButtonWithFrame:CGRectMake(180, 10, 39, 39) title:@"QQ好友" imageName:@"share_qq@2x" index:2];
    [view createShareButtonWithFrame:CGRectMake(260, 10, 39, 39) title:@"微信" imageName:@"share_wechat@2x" index:3];
    [view createShareButtonWithFrame:CGRectMake(20, 80, 39, 39) title:@"QQ空间" imageName:@"share_qzone@2x" index:4];
    [view createShareButtonWithFrame:CGRectMake(100, 80, 39, 39) title:@"人人网" imageName:@"share_renren@2x" index:5];
    [view createShareButtonWithFrame:CGRectMake(180, 80, 39, 39) title:@"豆瓣" imageName:@"share_douban@2x" index:6];

    return view;
}

- (void)createShareButtonWithFrame:(CGRect)frame title:(NSString *)title imageName:(NSString *)imageName index:(NSInteger)index
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    button.frame = frame;
    button.tag = index;
    [self addSubview:button];

    [button addTarget:self action:@selector(handleShareButtonEvent:) forControlEvents:UIControlEventTouchUpInside];

    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.font = [UIFont systemFontOfSize:14.f];
    [label sizeToFit];
    label.centerX = button.centerX;
    label.top = button.bottom + 5;
    [self addSubview:label];
}

- (void)handleShareButtonEvent:(UIButton *)button
{
    NSString *type;
    switch (button.tag) {
        case 0:
        {
            type = UMShareToSina;
        }
            break;
        case 1:
        {
            type = UMShareToWechatTimeline;
        }
            break;
        case 2:
        {
            type = UMShareToQQ;
        }
            break;
        case 3:
        {
            type = UMShareToWechatSession;
        }
            break;
        case 4:
        {
            type = UMShareToQzone;
        }
            break;
        case 5:
        {
            type = UMShareToRenren;
        }
            break;
        case 6:
        {
            type = UMShareToDouban;
        }
            break;
    }
    if (_selectShareBlock) {
        _selectShareBlock(type);
    }
}

@end
