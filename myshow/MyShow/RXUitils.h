//
//  RXUitils.h
//  RongXin
//
//  Created by melody on 13-12-29.
//  Copyright (c) 2013年 KSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RXUitils : NSObject

+ (void)showHUDWithImg:(UIImage *)image WithTitle:(NSString *)title withHiddenDelay:(NSTimeInterval)delay;

+ (void)showHUDWithView:(UIView *)view WithTitle:(NSString *)title withHiddenDelay:(NSTimeInterval)delay;


+ (void)showAlertMessage:(NSString*)message;

+ (void)showDebugMessage:(NSString*)message;

+ (void)showHintMessage:(NSString*)message;

+ (NSString*)timeHintString:(NSString*)dateTimeString;

+ (void)setImagePickerNavigationBarBackground:(UIImagePickerController*)imagePicker;

@end
