//
//  MyShowTools.h
//  MyShow
//
//  Created by unakayou on 14-4-17.
//  Copyright (c) 2014年 unakayou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyShowTools : NSObject

+ (id)shareTool;
+ (UIColor*) hexStringToColor:(NSString *) stringToConvert;
+ (UIImage *)createImageWithColor: (UIColor *) color;
+ (NSString *)getMd5HexString:(NSString *)plainText;
+ (NSString *)deviceID;
@end
