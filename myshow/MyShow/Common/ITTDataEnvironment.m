//
//  DataEnvironment.m
//  
//
//  Copyright 2010 itotem. All rights reserved.
//


#import "ITTDataEnvironment.h"
#import "ITTDataCacheManager.h"
#import "ITTNetworkTrafficManager.h"
#import "ITTObjectSingleton.h"
#import "UserModel.h"
#import "UMSocial.h"

@interface ITTDataEnvironment()
- (void)restore;
- (void)registerMemoryWarningNotification;
@end
@implementation ITTDataEnvironment

ITTOBJECT_SINGLETON_BOILERPLATE(ITTDataEnvironment, sharedDataEnvironment)

#pragma mark - lifecycle methods
- (id)init
{
    self = [super init];
	if ( self) {
		[self restore];
        [self registerMemoryWarningNotification];
	}
	return self;
}

#pragma mark -
#pragma mark 本地保存用户信息
- (void)setUserInfo:(UserModel *)userInfo
{
    _userInfo = userInfo;
    [DATA_MANAGER addObject:_userInfo forKey:KEY_USER];
    [DATA_MANAGER doSave];
}

- (void)setUserUid:(NSString *)userUid
{
    _userUid = userUid;
    [DATA_MANAGER addObject:_userUid forKey:KEY_USERID];
    [DATA_MANAGER doSave];
}


- (void)setDid:(NSString *)did
{
    _did = did;
    [DATA_MANAGER addObject:_did forKey:KEY_DID];
    [DATA_MANAGER doSave];
}

- (void)setToken:(NSString *)token
{
    _token = token;
    [DATA_MANAGER addObject:_token forKey:KEY_TOKEN];
    [DATA_MANAGER doSave];
}

-(void)setType:(NSString *)type
{
    _type = type;
    [DATA_MANAGER addObject:_type forKey:KEY_TYPE];
    [DATA_MANAGER doSave];
}

#pragma mark 本地删除用户信息
- (void)clearDiskCache
{
    _userInfo = nil;
    _userUid = nil;
//    _platformString = nil;
    _location = nil;
    _longitude = nil;
    _latitude = nil;
//    _did = nil;
    _token = nil;
    _type = nil;
    
    [DATA_MANAGER clearAllCache];
}


-(void)clearNetworkData
{
    [[ITTDataCacheManager sharedManager] clearAllCache];
}

#pragma mark - public methods

- (void)clearCacheData
{
    //clear cache data if needed
}



#pragma mark - 从本地恢复数据
- (void)restore
{
    _urlRequestHost = REQUEST_DOMAIN;
    _userInfo = [DATA_MANAGER getCachedObjectByKey:KEY_USER];
    _userUid = [DATA_MANAGER getCachedObjectByKey:KEY_USERID];
    _did = [DATA_MANAGER getCachedObjectByKey:KEY_DID];
    _token = [DATA_MANAGER getCachedObjectByKey:KEY_TOKEN];
    _type = [DATA_MANAGER getCachedObjectByKey:KEY_TYPE];
}


- (void)registerMemoryWarningNotification
{
#if TARGET_OS_IPHONE
    // Subscribe to app events
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clearCacheData)
                                                 name:UIApplicationDidReceiveMemoryWarningNotification
                                               object:nil];    
#ifdef __IPHONE_4_0
    UIDevice *device = [UIDevice currentDevice];
    if ([device respondsToSelector:@selector(isMultitaskingSupported)] && device.multitaskingSupported){
        // When in background, clean memory in order to have less chance to be killed
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(clearCacheData)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
    }
#endif
#endif        
}

- (BOOL)isHasUserInfo
{
    return _userInfo != nil ? TRUE : FALSE;
}

- (BOOL)isHasToken
{
    return _token != nil ? TRUE : FALSE;
}


@end