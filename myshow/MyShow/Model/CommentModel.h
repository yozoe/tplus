//
//  CommentModel.h
//  MyShow
//
//  Created by wang dong on 8/10/14.
//  Copyright (c) 2014 maxingchuan. All rights reserved.
//

#import "ITTBaseModelObject.h"

@interface CommentModel : ITTBaseModelObject

//brand = Xiaomi;
//cacheKey = "http://qzapp.qlogo.cn/qzapp/100424468/2EBB954E9C365A6ACD60A94761C8C264/100";
//createTime = 1406976176000;
//headUrl = "http://qzapp.qlogo.cn/qzapp/100424468/2EBB954E9C365A6ACD60A94761C8C264/100";
//id = 1179;
//latitude = "<null>";
//location = "\U5317\U4eac\U5e02\U671d\U9633\U533a";
//longitude = "<null>";
//nickname = 812200157;
//txt = "\U7f8e\U91d1";
//userId = 2EBB954E9C365A6ACD60A94761C8C264;

@property (retain, nonatomic) NSString *ID;
@property (retain, nonatomic) NSString *content;
@property (retain, nonatomic) NSString *userID;
@property (retain, nonatomic) NSString *headUrl;
@property (retain, nonatomic) NSString *nickname;
@property (retain, nonatomic) NSString *supprot;
@property (retain, nonatomic) NSString *createDate;

@end
