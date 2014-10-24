//
//  ImgsModel.h
//  MyShow
//
//  Created by wang dong on 7/30/14.
//  Copyright (c) 2014 maxingchuan. All rights reserved.
//

#import "ITTBaseModelObject.h"

@interface ImgsModel : ITTBaseModelObject

@property (retain, nonatomic) NSString *ID;
@property (retain, nonatomic) NSString *url;
@property (retain, nonatomic) NSString *suffix;
@property (retain, nonatomic) NSString *size;
@property (retain, nonatomic) NSString *cacheKey;
@property (retain, nonatomic) NSString *foreignId;

@end
