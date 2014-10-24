//
//  ITTAFNBaseDataRequest.m
//  iTotemFramework
//
//  Created by Sword Zhou on 7/18/13.
//  Copyright (c) 2013 iTotemStudio. All rights reserved.
//

#import "ITTAFNBaseDataRequest.h"
#import "ITTNetworkTrafficManager.h"
#import "AFHTTPRequestOperation.h"
#import "ITTAFQueryStringPair.h"
#import "ITTDataRequestManager.h"
#import "AFHTTPClient.h"
#import "ITTFileModel.h"

@interface ITTAFNBaseDataRequest()
{
    AFHTTPRequestOperation  *_requestOperation;
}

@end

@implementation ITTAFNBaseDataRequest


- (NSString *)contentType
{
    NSString *charset = @"utf-8";// (NSString*)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    NSString *contentType = [NSString stringWithFormat:@"application/json; charset=%@", charset];
    return contentType;
}

- (NSMutableURLRequest *)requestWithParams:(NSDictionary *)params url:(NSString *)url
{
    NSStringEncoding stringEncoding = NSUTF8StringEncoding;
	// process params
	NSMutableDictionary *allParams = [NSMutableDictionary dictionaryWithCapacity:10];
	[allParams addEntriesFromDictionary: params];
	NSDictionary *staticParams = [self getStaticParams];
	if (staticParams != nil) {
		[allParams addEntriesFromDictionary:staticParams];
	}
    NSURL *URL = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    // used to monitor network traffic , this is not accurate number.
    long long postBodySize = 0;    
	if (ITTRequestMethodGet == [self getRequestMethod]) {
        NSString *paramString = ITTAFQueryStringFromParametersWithEncoding(allParams, stringEncoding);
        NSUInteger found = [url rangeOfString:@"?"].location;
        url = [url stringByAppendingFormat: NSNotFound == found? @"?%@" : @"&%@", paramString];
        URL = [NSURL URLWithString:url];
        [request setURL:URL];
        [request setHTTPMethod:@"GET"];
        postBodySize += [url lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
        ITTDINFO(@"request url %@", url);
    }
    else {
        switch (self.parmaterEncoding) {
            case ITTURLParameterEncoding: {
                NSData *data = nil;
                AFStreamingMultipartFormData *formData = [[AFStreamingMultipartFormData alloc] initWithURLRequest:request stringEncoding:NSUTF8StringEncoding];
                for (ITTAFQueryStringPair *pair in ITTAFQueryStringPairsFromDictionary(allParams)) {
                    NSString *key = [pair.field description];                        
                    if ([pair.value isKindOfClass:[NSData class]]) {
						[formData appendPartWithFileData:pair.value name:key fileName:key mimeType:@"image/jpg"];
                    }
                    else if ([pair.value isKindOfClass:[UIImage class]]) {
                        data = UIImageJPEGRepresentation(pair.value, 1.0);
                        [formData appendPartWithFileData:data name:key fileName:@"image.jpg" mimeType:@"image/jpg"];
                    }
                    else if ([pair.value isKindOfClass:[ITTFileModel class]]) {
                        ITTFileModel *fileModel = pair.value;
                        [formData appendPartWithFileData:fileModel.data name:key fileName:fileModel.fileName mimeType:fileModel.mimeType];
                    }
                    else {
                        data = [[pair.value description] dataUsingEncoding:NSUTF8StringEncoding];
                        [formData appendPartWithFormData:data name:key];                            
                    }
                }
                request = [formData requestByFinalizingMultipartFormData];                
                break;
            }
            case ITTJSONParameterEncoding: {
                NSError *error = nil;
                NSString *contentType = [self contentType];
                [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wassign-enum"
				NSString *jsonString = [NSJSONSerialization jsonStringFromDictionary:allParams];
				NSData *jsonFormatPostData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
//                NSData *jsonFormatPostData = [NSJSONSerialization dataWithJSONObject:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
                [request setHTTPBody:jsonFormatPostData];
                if (error) {
                    ITTDERROR(@"create request error %@", error);
                }
                postBodySize += [jsonFormatPostData length];
#pragma clang diagnostic pop                
                break;
            }
            case ITTPropertyListParameterEncoding:
                //to do
                break;
            default:
                break;
        }
        [request setHTTPMethod:@"POST"];
        ITTDINFO(@"request url %@", url);        
    }
    [request addValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    
    
    //添加请求头

    //debug看属性值用, 别删
    ITTDataEnvironment *hehe = [ITTDataEnvironment sharedDataEnvironment];

    //用户id
    [request addValue:DATA_ENV.userUid forHTTPHeaderField:@"uid"];
    //手机信息
    [request addValue:[DATA_ENV.platformString encodeUrl] forHTTPHeaderField:@"brand"];
    //位置
    [request addValue:[DATA_ENV.location encodeUrl] forHTTPHeaderField:@"location"];
    //经度
    [request addValue:DATA_ENV.longitude forHTTPHeaderField:@"longtitude"];
    //纬度
    [request addValue:DATA_ENV.latitude forHTTPHeaderField:@"latitude"];
    //用户头像
    [request addValue:DATA_ENV.userInfo.headUrl forHTTPHeaderField:@"headurl"];
    //用户昵称
    [request addValue:[DATA_ENV.userInfo.nickname encodeUrl] forHTTPHeaderField:@"nickname"];
    //UUID    新添加字段
    [request addValue:DATA_ENV.did forHTTPHeaderField:@"did"];
    //TOKEN   新添加字段
    [request addValue:DATA_ENV.token forHTTPHeaderField:@"token"];
    
    //以下数据测试用
    if (!DATA_ENV.longitude) {
        DATA_ENV.longitude = @"37.785834";
    }

    if (!DATA_ENV.latitude) {
        DATA_ENV.latitude = @"122.406417";
    }

    if (!DATA_ENV.location) {
        DATA_ENV.location = @"北京市朝阳区";
    }

    //经纬度   新添加字段
    [request addValue:[NSString stringWithFormat:@"%@*%@", DATA_ENV.longitude, DATA_ENV.latitude] forHTTPHeaderField:@"ll"];
    
    
    if (_filePath && [_filePath length] > 0) {
        //create folder
        _requestOperation.outputStream = [NSOutputStream outputStreamToFileAtPath:_filePath append:NO];
    }
    [[ITTNetworkTrafficManager sharedManager] logTrafficOut:postBodySize];
    return request;
}

+ (void)showNetworkActivityIndicator
{
#if TARGET_OS_IPHONE
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
#endif
}

+ (void)hideNetworkActivityIndicator
{
#if TARGET_OS_IPHONE
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
#endif
}

- (void)networkingOperationDidStart:(NSNotification *)notification
{
    ITTDINFO(@"- (void)networkingOperationDidStart:(NSNotification *)notification");            
    AFURLConnectionOperation *connectionOperation = [notification object];
    if (connectionOperation.request.URL) {
        [[self class] showNetworkActivityIndicator];
        [self showIndicator:TRUE];
    }
}

- (void)networkingOperationDidFinish:(NSNotification *)notification
{
    ITTDINFO(@"- (void)networkingOperationDidFinish:(NSNotification *)notification");
    AFURLConnectionOperation *connectionOperation = [notification object];
    if (connectionOperation.request.URL) {
        [[self class] hideNetworkActivityIndicator];
        [self showIndicator:FALSE];
    }
}

- (void)notifyDelegateDownloadProgress
{
    //using block
    if (_onRequestProgressChangedBlock) {
        _onRequestProgressChangedBlock(self, _currentProgress);
    }
}

- (void)generateRequestWithUrl:(NSString*)url withParameters:(NSDictionary*)params
{
    NSMutableURLRequest *request = [self requestWithParams:params url:url];
    _requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];    
    [self registerRequestNotification];
    __weak typeof(self) weakSelf = self;    
    [_requestOperation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject) {
         
         [weakSelf handleResultString:operation.responseString];
         [weakSelf unregisterRequestNotification];
         [weakSelf doRelease];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [weakSelf notifyDelegateRequestDidErrorWithError:error];
         [weakSelf handleError:error];
         [weakSelf unregisterRequestNotification];
         [weakSelf doRelease];
     }];
    [_requestOperation setDownloadProgressBlock:
        ^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
            weakSelf.currentProgress = 1.0*totalBytesRead/totalBytesExpectedToRead;
            [weakSelf notifyDelegateDownloadProgress];
        }];
}

- (void)doRequestWithParams:(NSDictionary*)params
{
    [self generateRequestWithUrl:self.requestUrl withParameters:params];
    [_requestOperation start];
}

- (void)handleError:(NSError*)error
{
    if (error) {
        NSString *errorMsg = nil;
        if ([NSURLErrorDomain isEqualToString:error.domain]) {
            errorMsg = @"无法连接到网络";
        }
        if (!_useSilentAlert) {
            [self showNetowrkUnavailableAlertView:errorMsg];
        }
    }
}

- (void)registerRequestNotification
{
    //register start and finish notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkingOperationDidStart:) name:AFNetworkingOperationDidStartNotification object:_requestOperation];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkingOperationDidFinish:) name:AFNetworkingOperationDidFinishNotification object:_requestOperation];
}

- (void)unregisterRequestNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AFNetworkingOperationDidStartNotification object:_requestOperation];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AFNetworkingOperationDidFinishNotification object:_requestOperation];
}

- (void)cancelRequest
{
    ITTDINFO(@"%@ request is cancled", [self class]);
    [_requestOperation cancel];
    //to cancel here
    if (_onRequestCanceled) {
        _onRequestCanceled(self);
    }
    [self showIndicator:FALSE];
    [self doRelease];
}
@end
