//
//  DetailLikeRequest.m
//  MyShow
//
//  Created by wang dong on 14-8-21.
//  Copyright (c) 2014年 maxingchuan. All rights reserved.
//

#import "UserPraiseRequest.h"

@implementation UserPraiseAddRequest

- (NSString*)getRequestUrl
{
    return [REQUEST_DOMAIN stringByAppendingString:@"praise/add"];
}

- (ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodPost;
}

- (void)processResult
{
    [super processResult];
}

@end

@implementation UserPraiseCancelRequest

- (NSString*)getRequestUrl
{
    return [REQUEST_DOMAIN stringByAppendingString:@"user/praise/cancel"];
}

- (ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodPost;
}

- (void)processResult
{
    [super processResult];
}

@end

