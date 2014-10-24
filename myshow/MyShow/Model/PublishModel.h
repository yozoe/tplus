//
//  PublishModel.h
//  MyShow
//
//  Created by wang dong on 14-7-24.
//  Copyright (c) 2014年 maxingchuan. All rights reserved.
//

#import "ITTBaseModelObject.h"
#import "ImgsModel.h"

@interface PublishModel : ITTBaseModelObject

@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSString *did;
@property (strong, nonatomic) NSString *publistext;
@property (strong, nonatomic) NSString *brand;
@property (strong, nonatomic) NSString *userid;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *createTime;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *labnum;
@property (strong, nonatomic) NSString *imagenum;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *shareUrl;
@property (strong, nonatomic) NSMutableArray *imgsArray;

- (void)addImg:(ImgsModel *)imgModel;
- (NSInteger)imgCount;

@end
