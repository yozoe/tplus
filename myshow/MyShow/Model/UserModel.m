//
//  UserModel.m
//  MyShow
//
//  Created by wang dong on 14-7-24.
//  Copyright (c) 2014年 maxingchuan. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

- (NSDictionary*)attributeMapDictionary
{
	return @{@"ID": @"id"
             ,@"uid": @"uid"
             ,@"username": @"username"
             ,@"nickname" : @"nickname"
             ,@"email" : @"email"
             ,@"phone" : @"phone"
             ,@"sex" : @"sex"
             ,@"headUrl" : @"headUrl"
             ,@"type" : @"type"
             };
}

@end
