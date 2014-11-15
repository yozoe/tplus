//
//  CONSTS.h
//  Hupan
//
//  Copyright 2010 iTotem Studio. All rights reserved.
//


#define REQUEST_DOMAIN @"http://tplus.api.591ku.com/"     //真实环境服务器

//#define REQUEST_DOMAIN @"http://test.api.591ku.com/"        //测试服务器


#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UICOLOR_ORIGIN [UIColor colorWithRed:0.606 green:0.835 blue:0.600 alpha:1.000]
#define UICOLOR_SELECTED [UIColor colorWithRed:0.957 green:0.045 blue:0.252 alpha:1.000]

//text
#define TEXT_LOAD_MORE_NORMAL_STATE @"向上拉动加载更多..."
#define TEXT_LOAD_MORE_LOADING_STATE @"更多数据加载中..."

#define HOME_PAGE_SIZE @"10"

#define KEY_USER @"KEY_USER"
#define KEY_USERID @"KEY_USERID"
#define KEY_UCODE @"KEY_UCODE"
#define KEY_DID @"KEY_DID"
#define KEY_TOKEN @"KEY_TOKEN"
#define KEY_TYPE @"KEY_TYPE"


#define NOTIFICATION_DISTRIBUTE_SUCCESS @"NOTIFICATION_DISTRIBUTE_SUCCESS"
#define NOTIFICATION_ADDTAG @"NOTIFICATION_ADDTAG"
#define NOTIFICATION_LOGIN_SUCCESS @"NOTIFICATION_LOGIN_SUCCESS"
//other consts
typedef enum{
	kTagWindowIndicatorView = 501,
	kTagWindowIndicator,
} WindowSubViewTag;

typedef enum{
    kTagHintView = 101
} HintViewTag;


