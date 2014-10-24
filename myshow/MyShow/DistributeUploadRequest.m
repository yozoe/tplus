//
//  DistributeUploadRequest.m
//  MyShow
//
//  Created by max on 14-7-30.
//  Copyright (c) 2014年 maxingchuan. All rights reserved.
//

#import "DistributeUploadRequest.h"

@implementation DistributeUploadRequest

/*接口地址
http://114.215.107.53:8080/myshow/client/user/publish
 */

- (NSString*)getRequestUrl
{
    return [REQUEST_DOMAIN stringByAppendingString:@"user/publish"];
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
