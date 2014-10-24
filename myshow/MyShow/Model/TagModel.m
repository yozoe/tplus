//
//  HomeTagModel.m
//  MyShow
//
//  Created by wang dong on 7/24/14.
//  Copyright (c) 2014 maxingchuan. All rights reserved.
//

#import "TagModel.h"

@implementation TagModel

- (NSDictionary*)attributeMapDictionary
{
	return @{@"cacheKey": @"cacheKey"
             ,@"ID": @"id"
             ,@"imgSize": @"imgSize"
             ,@"imgUrl" : @"imgUrl"
             ,@"name" : @"name"
             ,@"ord" : @"ord"
             ,@"type" : @"type"
             };
}

@end
