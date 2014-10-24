//
//  RXUitils.m
//  RongXin
//
//  Created by melody on 13-12-29.
//  Copyright (c) 2013年 KSY. All rights reserved.
//

#import "RXUitils.h"
#import "MBProgressHUD.h"
#import "ITTSlienceHintView.h"
#import "ITTHintView.h"
#import "ITTDateUtil.h"
#import "UIColor-Expanded.h"

@implementation RXUitils

+ (void)showHUDWithImg:(UIImage *)image WithTitle:(NSString *)title withHiddenDelay:(NSTimeInterval)delay
{
    //    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].delegate.window];
    //    [[UIApplication sharedApplication].delegate.window addSubview:hud];
    //
    //    hud.customView = [[UIImageView alloc] initWithImage:image];
    //
    //    hud.mode = MBProgressHUDModeCustomView;
    //    hud.labelText = title;
    //
    //    [hud showAnimated:YES whileExecutingBlock:^{
    //        sleep(delay);
    //    } completionBlock:^{
    //        [hud removeFromSuperview];
    //    }];
    
    ITTSlienceHintView *hintView = [ITTSlienceHintView loadFromXib];
    hintView.messageLabel.text = title;
    [hintView showInView:[UIApplication sharedApplication].delegate.window disappearDelay:delay];
    [hintView performSelector:@selector(hide) withObject:nil afterDelay:delay];
}

+ (void)showHintMessage:(NSString*)message
{
    CGFloat delay = 1.0;
    ITTSlienceHintView *hintView = [ITTSlienceHintView loadFromXib];
    hintView.messageLabel.text = message;
    [hintView showInView:[UIApplication sharedApplication].delegate.window disappearDelay:delay];
    [hintView performSelector:@selector(hide) withObject:nil afterDelay:delay];
}

+ (void)showHUDWithView:(UIView *)view WithTitle:(NSString *)title withHiddenDelay:(NSTimeInterval)delay
{
    //    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    //    [view addSubview:hud];
    //
    //    hud.mode = MBProgressHUDModeText;
    //    hud.labelText = title;
    //
    //    [hud showAnimated:YES whileExecutingBlock:^{
    //        sleep(delay);
    //    } completionBlock:^{
    //        [hud removeFromSuperview];
    //    }];
    
    ITTSlienceHintView *hintView = [ITTSlienceHintView loadFromXib];
    hintView.messageLabel.text = title;
    [hintView showInView:[UIApplication sharedApplication].delegate.window disappearDelay:delay];
    [hintView performSelector:@selector(hide) withObject:nil afterDelay:delay];
}



+ (void)showAlertMessage:(NSString*)message
{
    //    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"程序调试" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    //    [alertView show];
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [ITTHintView hintWithTitle:@"提示信息" message:message inView:window onCancel:nil onConfirm:nil];
}

+ (void)showDebugMessage:(NSString*)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"调试信息" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

+ (NSString*)timeHintString:(NSString*)dateTimeString
{
    NSString *hint = @"";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *messageDate = [dateFormatter dateFromString:dateTimeString];
    if (!messageDate) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        messageDate = [dateFormatter dateFromString:dateTimeString];
    }
    NSInteger year = [ITTDateUtil getCurrentYear];
    NSInteger month = [ITTDateUtil getCurrentMonth];
    NSInteger today = [ITTDateUtil getCurrentDay];
    
    NSInteger messageYear = [ITTDateUtil getYearWithDate:messageDate];
    NSInteger messageMonth = [ITTDateUtil getMonthWithDate:messageDate];
    NSInteger messageDay = [ITTDateUtil getDayWithDate:messageDate];
    //当前年，当前月
    if (year == messageYear && month == messageMonth) {
        //当天
        if (messageDay == today) {
            [dateFormatter setDateFormat:@"HH:mm"];
            hint = [dateFormatter stringFromDate:messageDate];
        }
        //昨天
        else if(messageDay + 1 == today) {
            hint = @"昨天";
        }
        //昨天以前的
        else {
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            hint = [dateFormatter stringFromDate:messageDate];
        }
    }
    else {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        hint = [dateFormatter stringFromDate:messageDate];
    }
    return hint;
}

+ (void)setImagePickerNavigationBarBackground:(UIImagePickerController*)imagePicker
{
    imagePicker.navigationBar.translucent = FALSE;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        imagePicker.navigationBar.barTintColor = [UIColor blackColor];
        imagePicker.navigationBar.tintColor = [UIColor colorWithHexString:@"0X0079ff"];//[UIColor blueColor];
        imagePicker.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                         [UIColor clearColor], UITextAttributeTextShadowColor,
                                                         [UIColor blackColor],UITextAttributeTextColor,
                                                         [UIFont systemFontOfSize:20],UITextAttributeFont,
                                                         nil];
        imagePicker.navigationBar.barStyle = UIBarStyleBlack;
        [imagePicker.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_new@2x.png"] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [imagePicker setNeedsStatusBarAppearanceUpdate];
    }
    else {
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
        [imagePicker.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_new"] forBarMetrics:UIBarMetricsDefault];
    }
}
@end
