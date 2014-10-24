//
//  CoverKeyModel.m
//  MyShow
//
//  Created by wang dong on 14-7-24.
//  Copyright (c) 2014年 maxingchuan. All rights reserved.
//

#import "CoverKeyModel.h"

@implementation CoverKeyModel

- (NSDictionary*)attributeMapDictionary
{
	return @{@"ID": @"id"
             ,@"url": @"url"
             ,@"cacheKey": @"cacheKey"
             ,@"size" : @"size"
             ,@"pubId" : @"pubId"
             ,@"createTime" : @"createTime"
             };
}

@end
