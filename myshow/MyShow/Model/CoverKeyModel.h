//
//  CoverKeyModel.h
//  MyShow
//
//  Created by wang dong on 14-7-24.
//  Copyright (c) 2014年 maxingchuan. All rights reserved.
//

#import "ITTBaseModelObject.h"

@interface CoverKeyModel : ITTBaseModelObject

@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *cacheKey;
@property (strong, nonatomic) NSString *size;
@property (strong, nonatomic) NSString *pubId;
@property (strong, nonatomic) NSString *createTime;

@end
