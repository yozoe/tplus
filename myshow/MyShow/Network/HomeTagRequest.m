//
//  HomeTagRequest.m
//  MyShow
//
//  Created by wang dong on 7/23/14.
//  Copyright (c) 2014 maxingchuan. All rights reserved.
//

#import "HomeTagRequest.h"
#import "TagModel.h"

@implementation HomeTagRequest

- (NSString*)getRequestUrl
{
    return [REQUEST_DOMAIN stringByAppendingString:@"label/list/all"];
}

- (void)processResult
{
    [super processResult];

    NSMutableArray *homeTagModelArray = [NSMutableArray array];

    for (NSDictionary *dic in [self.handleredResult objectForKey:@"resp"]) {
        [homeTagModelArray addObject:[[TagModel alloc] initWithDataDic:dic]];
    }

    [self.handleredResult setObject:homeTagModelArray forKey:@"models"];
}

- (NSDictionary *)getStaticParams
{
    return nil;
}

@end
