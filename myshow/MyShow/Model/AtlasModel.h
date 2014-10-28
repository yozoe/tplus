//
//  AtlasModel.h
//  MyShow
//
//  Created by wang dong on 14-10-9.
//  Copyright (c) 2014年 maxingchuan. All rights reserved.
//

#import "ITTBaseModelObject.h"
#import "ImgsModel.h"

@interface AtlasModel : ITTBaseModelObject

@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSString *imageNum;
@property (strong, nonatomic) NSString *praiseNum;
@property (strong, nonatomic) NSString *commentNum;
@property (strong, nonatomic) NSString *shareNum;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSMutableArray *imgsArray;
@property (strong, nonatomic) NSString *createDate;

- (void)addImg:(ImgsModel *)imgModel;
- (NSInteger)imgCount;

@end
