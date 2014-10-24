//
//  ItemModel.h
//  MyShow
//
//  Created by wang dong on 14-7-24.
//  Copyright (c) 2014年 maxingchuan. All rights reserved.
//

#import "ITTBaseModelObject.h"
#import "ItemHeader.h"
#import "AtlasModel.h"
#import "LabelModel.h"

@interface ItemModel : ITTBaseModelObject

@property (strong, nonatomic, getter = isLike) NSString *isLike;
@property (strong, nonatomic) NSMutableArray *tagsArray;
@property (strong, nonatomic) NSMutableArray *linksArray;
@property (strong, nonatomic) NSMutableArray *coverKeyArray;
@property (strong, nonatomic) NSMutableArray *labelsArray;
@property (strong, nonatomic) DynamicModel *dynamic;
@property (strong, nonatomic) UserModel *user;
@property (strong, nonatomic) PublishModel *publish;
@property (strong, nonatomic) AtlasModel *atlas;

- (void)configKeyPath:(NSString *)keyPath fromSource:(id)source;

@end
