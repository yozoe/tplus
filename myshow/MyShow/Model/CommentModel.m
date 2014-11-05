//
//  CommentModel.m
//  MyShow
//
//  Created by wang dong on 8/10/14.
//  Copyright (c) 2014 maxingchuan. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel

- (NSDictionary *)attributeMapDictionary
{
    return @{
              @"ID" : @"id"
              ,@"content" : @"content"
              ,@"NSString" : @"NSString"
              ,@"headUrl" : @"headUrl"
              ,@"nickname" : @"nickname"
              ,@"supprot" : @"supprot"
              ,@"createDate" : @"createDate"
              ,@"userID" : @"userId"
             };
}

@end
