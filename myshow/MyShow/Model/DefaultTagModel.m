//
//  DefaultTagModel.m
//  MyShow
//
//  Created by max on 14/10/31.
//  Copyright (c) 2014年 maxingchuan. All rights reserved.
//

#import "DefaultTagModel.h"
#import "CoverImageModel.h"

@implementation DefaultTagModel
- (id)init
{
    if (self = [super init]) {
        _atlasImagesArray = [NSMutableArray array];
    }
    return self;
}

- (NSDictionary*)attributeMapDictionary
{
    return @{@"ID": @"id",
             @"name":@"name",
             @"weight":@"weight",
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
    if ([keyPath isEqualToString:@"coverImage"]) {
        return [[CoverImageModel alloc] initWithDataDic:dic];
    }
    if ([keyPath isEqualToString:@"atlasImagesArray"]) {
        return [[CoverImageModel alloc] initWithDataDic:dic];
    }
    return nil;
}


@end
