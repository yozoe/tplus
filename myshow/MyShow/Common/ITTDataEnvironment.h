//
//  DataEnvironment.h
//
//  Copyright 2010 itotem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"                   
#import "UMSocial.h"

@interface ITTDataEnvironment : NSObject <UMSocialUIDelegate> {
    NSString *_urlRequestHost;
}


@property (nonatomic, strong) NSString * urlRequestHost;
@property (nonatomic, strong) UserModel * userInfo;     //用户信息
@property (nonatomic, strong) NSString * userUid;       //用户id
@property (nonatomic, strong) NSString * platformString;//手机平台信息
@property (nonatomic, strong) NSString * location;      //位置信息
@property (nonatomic, strong) NSString * longitude;   //经度
@property (nonatomic, strong) NSString * latitude;    //纬度

//新加字段UUID
@property (nonatomic, strong) NSString * did;           //UUID
@property (nonatomic, strong) NSString * token;         //TOKEN
@property (nonatomic, strong) NSString * type;          //TYPE

@property (nonatomic, assign) BOOL isHasUserInfo;
@property (nonatomic, assign) BOOL isHasToken;



+ (ITTDataEnvironment *)sharedDataEnvironment;

- (void)clearDiskCache;
- (void)clearNetworkData;
- (void)clearCacheData;

@end
