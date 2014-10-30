//
//  DetailImgListRequest.m
//  MyShow
//
//  Created by wang dong on 7/30/14.
//  Copyright (c) 2014 maxingchuan. All rights reserved.
//

#import "ImageListRequest.h"
#import "ImgsModel.h"

@implementation ImageListRequest

- (NSString*)getRequestUrl
{
    return [REQUEST_DOMAIN stringByAppendingString:@"image/list"];
}

- (void)processResult
{
    [super processResult];

    NSArray *imgsArray = [[self.handleredResult objectForKey:@"resp"] objectForKey:@"images"];
    NSMutableArray *imgModelArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in imgsArray) {
        ImgsModel *im = [[ImgsModel alloc] initWithDataDic:dic];
        [imgModelArray addObject:im];
    }

    [self.handleredResult setObject:imgModelArray forKey:@"models"];
}

@end
