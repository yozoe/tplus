//
//  DefaultTagModel.h
//  MyShow
//
//  Created by max on 14/10/31.
//  Copyright (c) 2014年 maxingchuan. All rights reserved.
//

#import "ITTBaseModelObject.h"
#import "CoverImageModel.h"

@interface DefaultTagModel : ITTBaseModelObject


@property (strong, nonatomic) NSString * ID;
@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSString * weight;
@property (strong, nonatomic) CoverImageModel *coverImage;
@property (strong, nonatomic) NSMutableArray * atlasImagesArray;

- (void)configKeyPath:(NSString *)keyPath fromSource:(id)source;

@end
