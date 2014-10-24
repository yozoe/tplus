//
//  MyDistributeTagClickRequest.m
//  MyShow
//
//  Created by max on 14-8-13.
//  Copyright (c) 2014年 maxingchuan. All rights reserved.
//

#import "MyDistributeTagClickRequest.h"
#import "ItemModel.h"


@implementation MyDistributeTagClickRequest

- (NSString*)getRequestUrl
{
    return [REQUEST_DOMAIN stringByAppendingString:@"user/mymessage/list"];
}

- (void)processResult
{
    [super processResult];
    
    NSDictionary *resultDic = [self.handleredResult objectForKey:@"resp"];
    NSMutableArray *itemsArray = [resultDic objectForKey:@"items"];
    
    NSMutableArray *itemModelArray = [NSMutableArray array];
    
    for (NSDictionary *dic in itemsArray) {
        ItemModel *itemModel = [[ItemModel alloc] initWithDataDic:dic];
        [itemModel configKeyPath:@"publish" fromSource:[dic objectForKey:@"publish"]];
        [itemModel configKeyPath:@"dynamic" fromSource:[dic objectForKey:@"dynamic"]];
        [itemModel configKeyPath:@"user" fromSource:[dic objectForKey:@"user"]];
        [itemModel configKeyPath:@"tagsArray" fromSource:[dic objectForKey:@"tag"]];
        [itemModel configKeyPath:@"linksArray" fromSource:[dic objectForKey:@"links"]];
        [itemModel configKeyPath:@"coverKeyArray" fromSource:[dic objectForKey:@"coverKey"]];
        [itemModelArray addObject:itemModel];
    }
    
    [self.handleredResult setObject:itemModelArray forKey:@"models"];
}

@end
