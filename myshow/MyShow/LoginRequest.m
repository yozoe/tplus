//
//  LoginRequest.m
//  MyShow
//
//  Created by max on 14-8-2.
//  Copyright (c) 2014年 maxingchuan. All rights reserved.
//

#import "LoginRequest.h"

@implementation LoginRequest

- (NSString*)getRequestUrl
{
    return [REQUEST_DOMAIN stringByAppendingString:@"third/login"];
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
