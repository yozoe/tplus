//
//  ItemModel.m
//  MyShow
//
//  Created by wang dong on 14-7-24.
//  Copyright (c) 2014年 maxingchuan. All rights reserved.
//

#import "ItemModel.h"

@implementation ItemModel

- (id)init
{
    if (self = [super init]) {
        _coverKeyArray = [NSMutableArray array];
        _linksArray = [NSMutableArray array];
        _tagsArray = [NSMutableArray array];
        _labelsArray = [NSMutableArray array];
    }
    return self;
}

- (NSDictionary*)attributeMapDictionary
{
	return @{@"isLike": @"isLike"
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
    if ([keyPath isEqualToString:@"tagsArray"]) {
        return [[TagModel alloc] initWithDataDic:dic];
    }
    if ([keyPath isEqualToString:@"linksArray"]) {
        return [[LinksModel alloc] initWithDataDic:dic];
    }
    if ([keyPath isEqualToString:@"coverKeyArray"]) {
        return [[CoverKeyModel alloc] initWithDataDic:dic];
    }
    if ([keyPath isEqualToString:@"dynamic"]) {
        return [[DynamicModel alloc] initWithDataDic:dic];
    }
    if ([keyPath isEqualToString:@"user"]) {
        return [[UserModel alloc] initWithDataDic:dic];
    }
//    if ([keyPath isEqualToString:@"publish"]) {
//        return [[PublishModel alloc] initWithDataDic:dic];
//    }
    if ([keyPath isEqualToString:@"atlas"]) {
        return [[AtlasModel alloc] initWithDataDic:dic];
    }
    if ([keyPath isEqualToString:@"labelsArray"]) {
        return [[LabelModel alloc] initWithDataDic:dic];
    }
    return nil;
}

- (void)setIsLike:(NSString *)isLike
{
    _isLike = isLike;
    NSInteger favCount = _dynamic.favnum.integerValue;
    if  ([_isLike isEqualToString:@"1"]) {
        favCount++;
    } else {
        favCount--;
    }
    _dynamic.favnum = [NSString stringWithFormat:@"%d", favCount];
}

- (BOOL)isIsLike
{
    return [_isLike isEqualToString:@"1"];
}

@end
