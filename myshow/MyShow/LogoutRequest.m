//
//  LogoutRequest.m
//  MyShow
//
//  Created by Max on 14/10/28.
//  Copyright (c) 2014年 maxingchuan. All rights reserved.
//

#import "LogoutRequest.h"

@implementation LogoutRequest

- (NSString*)getRequestUrl
{
    return [REQUEST_DOMAIN stringByAppendingString:@"user/logout"];
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
