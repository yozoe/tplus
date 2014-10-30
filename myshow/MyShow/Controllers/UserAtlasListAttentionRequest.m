//
//  UserAtlasListAttentionRequest.m
//  MyShow
//
//  Created by wang dong on 14/10/29.
//  Copyright (c) 2014年 maxingchuan. All rights reserved.
//

#import "UserAtlasListAttentionRequest.h"
#import "ItemModel.h"

@implementation UserAtlasListAttentionRequest

- (NSString*)getRequestUrl
{
    return [REQUEST_DOMAIN stringByAppendingString:@"user/atlas/list/attention"];
}

- (void)processResult
{
    [super processResult];

    NSLog(@"%@", [self.handleredResult objectForKey:@"msg"]);

    NSDictionary *resultDic = [self.handleredResult objectForKey:@"resp"];
    NSMutableArray *itemsArray = [resultDic objectForKey:@"items"];

    NSMutableArray *itemModelArray = [NSMutableArray array];

    for (NSDictionary *dic in itemsArray) {
        ItemModel *itemModel = [[ItemModel alloc] initWithDataDic:dic];
        //        [itemModel configKeyPath:@"publish" fromSource:[dic objectForKey:@"publish"]];
        [itemModel configKeyPath:@"atlas" fromSource:[dic objectForKey:@"atlas"]];
        [itemModel configKeyPath:@"dynamic" fromSource:[dic objectForKey:@"dynamic"]];
        [itemModel configKeyPath:@"user" fromSource:[dic objectForKey:@"user"]];
        [itemModel configKeyPath:@"tagsArray" fromSource:[dic objectForKey:@"tag"]];
        [itemModel configKeyPath:@"linksArray" fromSource:[dic objectForKey:@"links"]];
        [itemModel configKeyPath:@"coverKeyArray" fromSource:[dic objectForKey:@"coverKey"]];
        [itemModel configKeyPath:@"labelsArray" fromSource:[dic objectForKey:@"labels"]];
        [itemModelArray addObject:itemModel];
    }

    [self.handleredResult setObject:itemModelArray forKey:@"models"];
}

@end
