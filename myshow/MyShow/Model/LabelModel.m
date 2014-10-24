//
//  LabelModel.m
//  MyShow
//
//  Created by wang dong on 14-10-9.
//  Copyright (c) 2014年 maxingchuan. All rights reserved.
//

#import "LabelModel.h"

@implementation LabelModel

- (NSDictionary*)attributeMapDictionary
{
	return @{@"ID": @"id"
             ,@"parentId": @"parentId"
             ,@"parentName": @"parentName"
             ,@"name" : @"name"
             ,@"imgUrl" : @"imgUrl"
             ,@"imgSize" : @"imgSize"
             ,@"weight" : @"weight"
             ,@"cacheKey" : @"cacheKey"
             };

}

@end
