//
//  UserModel.h
//  MyShow
//
//  Created by wang dong on 14-7-24.
//  Copyright (c) 2014年 maxingchuan. All rights reserved.
//

#import "ITTBaseModelObject.h"

@interface UserModel : ITTBaseModelObject

@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSString *uid;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *nickname;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *sex;
@property (strong, nonatomic) NSString *headUrl;

@property (strong, nonatomic) NSString *type;       //新增字段

@end
