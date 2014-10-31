//
//  SearchTagListDefaultRequest.m
//  MyShow
//
//  Created by max on 14/10/31.
//  Copyright (c) 2014年 maxingchuan. All rights reserved.
//

#import "SearchTagListDefaultRequest.h"
#import "DefaultTagModel.h"
#import "CoverImageModel.h"
#import "ThumbModel.h"
#import "CoverImageModel.h"

@implementation SearchTagListDefaultRequest

- (NSString*)getRequestUrl
{
    return [REQUEST_DOMAIN stringByAppendingString:@"label/search/default"];
}

- (void)processResult
{
    [super processResult];
    
    NSLog(@"%@", self.handleredResult);
    
    NSDictionary *resultDic = [self.handleredResult objectForKey:@"resp"];
    NSMutableArray *itemsArray = [resultDic objectForKey:@"labels"];
    
    NSMutableArray *itemModelArray = [NSMutableArray array];
    
    for (NSDictionary *dic in itemsArray) {
        DefaultTagModel *tagModel = [[DefaultTagModel alloc] initWithDataDic:dic];


        tagModel.coverImage = [[CoverImageModel alloc] initWithDataDic:[dic objectForKey:@"coverImage"]];
        tagModel.coverImage.thumb = [[ThumbModel alloc] initWithDataDic:[[dic objectForKey:@"coverImage"] objectForKey:@"thumb"]];

        tagModel.atlasImagesArray = [NSMutableArray array];

        for (NSDictionary *imageDic in [dic objectForKey:@"atlasImages"]) {
            CoverImageModel *img = [[CoverImageModel alloc] initWithDataDic:imageDic];
            img.thumb = [[ThumbModel alloc] initWithDataDic:[imageDic objectForKey:@"thumb"]];
            [tagModel.atlasImagesArray addObject:img];
        }

        [itemModelArray addObject:tagModel];
    }
    
    [self.handleredResult setObject:itemModelArray forKey:@"models"];
}

@end
