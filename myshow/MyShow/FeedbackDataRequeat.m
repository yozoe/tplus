//
//  FeedbackDataRequeat.m
//  MyShow
//
//  Created by max on 14-8-19.
//  Copyright (c) 2014年 maxingchuan. All rights reserved.
//

#import "FeedbackDataRequeat.h"

@implementation FeedbackDataRequeat

-(ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodPost;
}

- (void)processResult
{
    [super processResult];
    if ([self isSuccess]) {
    }
}

- (NSString*)getRequestUrl
{
    return [REQUEST_DOMAIN stringByAppendingString:@"register"];
}

@end
