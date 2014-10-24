//
//  DetailLikeRequest.m
//  MyShow
//
//  Created by wang dong on 14-8-21.
//  Copyright (c) 2014年 maxingchuan. All rights reserved.
//

#import "DetailLikeRequest.h"

@implementation DetailLikeRequest

- (NSString*)getRequestUrl
{
    return [REQUEST_DOMAIN stringByAppendingString:@"detail/like"];
}

- (ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodPost;
}

- (void)processResult
{
    [super processResult];
    NSString *result = [[self.handleredResult objectForKey:@"resp"] objectForKey:@"result"];
    [self.handleredResult setObject:result forKey:@"respResult"];
}

@end
