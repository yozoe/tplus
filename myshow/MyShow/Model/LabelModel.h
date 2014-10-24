//
//  LabelModel.h
//  MyShow
//
//  Created by wang dong on 14-10-9.
//  Copyright (c) 2014年 maxingchuan. All rights reserved.
//

#import "ITTBaseModelObject.h"

@interface LabelModel : ITTBaseModelObject

@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSString *parentId;
@property (strong, nonatomic) NSString *parentName;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *cacheKey;
@property (strong, nonatomic) NSString *imgUrl;
@property (strong, nonatomic) NSString *imgSize;
@property (strong, nonatomic) NSString *weight;

@end
