//
//  DetailCommentRequest.m
//  MyShow
//
//  Created by wang dong on 8/9/14.
//  Copyright (c) 2014 maxingchuan. All rights reserved.
//

#import "DetailCommentRequest.h"

@implementation DetailCommentRequest

- (NSString *)getRequestUrl
{
    return [REQUEST_DOMAIN stringByAppendingString:@"/atlas/comment/list"];
}

- (void)processResult
{
    [super processResult];
    NSLog(@"%@", self.handleredResult);
    NSArray *array = [[self.handleredResult objectForKey:@"resp"] objectForKey:@"comments"];
    NSMutableArray *commentArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in array) {
        CommentModel *cm = [[CommentModel alloc] initWithDataDic:dic];
        [commentArray addObject:cm];
    }
    [self.handleredResult setObject:commentArray forKey:@"models"];
}

@end
