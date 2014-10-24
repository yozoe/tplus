//
//  UserCommentRequest.m
//  MyShow
//
//  Created by wang dong on 14-8-13.
//  Copyright (c) 2014年 maxingchuan. All rights reserved.
//

#import "UserCommentAddRequest.h"

@implementation UserCommentAddRequest

- (NSString*)getRequestUrl
{
    return [REQUEST_DOMAIN stringByAppendingString:@"user/comment/atlas/add"];
}

- (ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodPost;
}

- (void)processResult
{
    [super processResult];

    NSLog(@"%@", self.handleredResult);

//    NSArray *imgsArray = [[self.handleredResult objectForKey:@"resp"] objectForKey:@"imgs"];
//    NSMutableArray *imgModelArray = [[NSMutableArray alloc] init];
//    for (NSDictionary *dic in imgsArray) {
//        ImgsModel *im = [[ImgsModel alloc] initWithDataDic:dic];
//        [imgModelArray addObject:im];
//    }
//
//    [self.handleredResult setObject:imgModelArray forKey:@"models"];
}


@end
