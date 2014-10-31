//
//  CoverImageModel.h
//  MyShow
//
//  Created by max on 14/10/31.
//  Copyright (c) 2014年 maxingchuan. All rights reserved.
//

#import "ITTBaseModelObject.h"
#import "ThumbModel.h"

@interface CoverImageModel : ITTBaseModelObject

@property (strong, nonatomic) NSString * ID;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *cacheKey;
@property (strong, nonatomic) NSString *size;
@property (strong, nonatomic) NSString *foreignId;
@property (strong, nonatomic) ThumbModel *thumb;

- (void)configKeyPath:(NSString *)keyPath fromSource:(id)source;

@end
