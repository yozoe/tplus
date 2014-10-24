//
//  HomeTagModel.h
//  MyShow
//
//  Created by wang dong on 7/24/14.
//  Copyright (c) 2014 maxingchuan. All rights reserved.
//

#import "ITTBaseModelObject.h"
#define DEFAULT_HOME_TAG @"-1"
#define DEFAULT_DISTRIBUTE_TAG @"1"

@interface TagModel : ITTBaseModelObject

@property (nonatomic, retain) NSString *cacheKey;
@property (nonatomic, retain) NSString *ID;
@property (nonatomic, retain) NSString *imgSize;
@property (nonatomic, retain) NSString *imgUrl;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *ord;
@property (nonatomic, retain) NSString *type;


@end
