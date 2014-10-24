//
//  PublishModel.m
//  MyShow
//
//  Created by wang dong on 14-7-24.
//  Copyright (c) 2014年 maxingchuan. All rights reserved.
//

#import "PublishModel.h"

@implementation PublishModel

//- (id)init
//{
//    if (self = [super init]) {
//        _imgsArray = [[NSMutableArray alloc] init];
//    }
//    return self;
//}
- (id)initWithDataDic:(NSDictionary *)data
{
    if (self = [super initWithDataDic:data]) {
        _imgsArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addImg:(ImgsModel *)imgModel
{
    [_imgsArray addObject:imgModel];
}

- (NSInteger)imgCount
{
    return [_imgsArray count];
}

- (NSDictionary*)attributeMapDictionary
{
	return @{@"ID": @"id"
             ,@"did": @"did"
             ,@"publistext": @"publistxt"
             ,@"brand" : @"brand"
             ,@"userid" : @"userid"
             ,@"location" : @"location"
             ,@"createTime" : @"createTime"
             ,@"status" : @"status"
             ,@"labnum" : @"labnum"
             ,@"imagenum" : @"imagenum"
             ,@"longitude" : @"longitude"
             ,@"latitude" : @"latitude"
             ,@"shareUrl" : @"shareUrl"
             };
}

@end
