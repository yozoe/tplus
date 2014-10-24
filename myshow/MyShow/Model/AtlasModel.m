//
//  AtlasModel.m
//  MyShow
//
//  Created by wang dong on 14-10-9.
//  Copyright (c) 2014年 maxingchuan. All rights reserved.
//

#import "AtlasModel.h"

@implementation AtlasModel

- (id)initWithDataDic:(NSDictionary *)data
{
    if (self = [super initWithDataDic:data]) {
        _imgsArray = [NSMutableArray array];
    }
    return self;
}

- (NSDictionary*)attributeMapDictionary
{
	return @{@"ID": @"id"
             ,@"imageNum": @"imageNum"
             ,@"praiseNum": @"praiseNum"
             ,@"commentNum" : @"commentNum"
             ,@"shareNum" : @"shareNum"
             ,@"location" : @"location"
             ,@"content" : @"content"
             };

}

- (void)addImg:(ImgsModel *)imgModel
{
    [_imgsArray addObject:imgModel];
}

- (NSInteger)imgCount
{
    return [_imgsArray count];
}

@end
