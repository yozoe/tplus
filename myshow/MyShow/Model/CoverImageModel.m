//
//  CoverImageModel.m
//  MyShow
//
//  Created by max on 14/10/31.
//  Copyright (c) 2014年 maxingchuan. All rights reserved.
//

#import "CoverImageModel.h"
#import "ThumbModel.h"

@implementation CoverImageModel

- (NSDictionary*)attributeMapDictionary
{
    return @{@"ID": @"id",
             @"url":@"url",
             @"cacheKey":@"cacheKey",
             @"size":@"size",
             @"foreignId":@"foreignId",
             @"createDate":@"createDate"
             };
}

- (void)configKeyPath:(NSString *)keyPath fromSource:(id)source
{
    id obj;
    if ([source isKindOfClass:[NSArray class]]) {
        obj = [NSMutableArray array];
        for (NSDictionary *dic in source) {
            id model = [self createModelWithKeyPath:keyPath dic:dic];
            if (model) {
                [obj addObject:model];
            }
        }
    } else if ([source isKindOfClass:[NSDictionary class]]) {
        obj = [self createModelWithKeyPath:keyPath dic:source];
    }
    [self setValue:obj forKey:keyPath];
}

- (id)createModelWithKeyPath:(NSString *)keyPath dic:(NSDictionary *)dic
{
    if ([keyPath isEqualToString:@"thumb"]) {
        return [[ThumbModel alloc] initWithDataDic:dic];
    }
        return nil;
}

@end
