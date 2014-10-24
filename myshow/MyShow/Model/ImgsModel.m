//
//  ImgsModel.m
//  MyShow
//
//  Created by wang dong on 7/30/14.
//  Copyright (c) 2014 maxingchuan. All rights reserved.
//

#import "ImgsModel.h"

@implementation ImgsModel

//@property (retain, nonatomic) NSString *cacheKey;
//@property (retain, nonatomic) NSString *createTime;
//@property (retain, nonatomic) NSString *ID;
//@property (retain, nonatomic) NSString *pubID;
//@property (retain, nonatomic) NSString *size;
//@property (retain, nonatomic) NSString *url;

- (NSDictionary*)attributeMapDictionary
{
	return @{@"ID": @"id"
             ,@"url": @"url"
             ,@"suffix": @"suffix"
             ,@"size" : @"size"
             ,@"cacheKey" : @"cacheKey"
             ,@"foreignId" : @"foreignId"
             };
}

@end
