//
//  UIUtil.m
//  
//
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UIUtil.h"
#import "CONSTS.h"
#import "UIDevice+ITTAdditions.h"

@implementation UIUtil

+ (void)adjustPositionToPixel:(UIView*)view
{
	view.center = CGPointMake(round(view.center.x), round(view.center.y));
}

+ (void)adjustPositionToPixelByOrigin:(UIView*)view
{
	view.left = round(view.left);
	view.top = round(view.top);
}

+ (NSString*) imageName:(NSString*) name
{
	if (![[UIDevice currentDevice] hasRetinaDisplay]) {
		name = [name stringByAppendingString:@".png"];
	}
	return name;
}

+ (void)setRoundCornerForView:(UIView*)view withRadius:(CGFloat)radius
{
    view.layer.cornerRadius = radius;
    [view setNeedsDisplay];
}

+ (void)setBorderForView:(UIView*)view withWidth:(CGFloat)width withColor:(UIColor*)color
{
    view.layer.borderWidth = width;
    view.layer.borderColor = color.CGColor;
    [view setNeedsDisplay];
}

+ (void)setNavigationBarBackground:(UINavigationController*)navgationController
{
    navgationController.navigationBar.translucent = FALSE;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        navgationController.navigationBar.barTintColor = [UIColor clearColor];
        navgationController.navigationBar.tintColor = [UIColor whiteColor];
        navgationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                         [UIColor clearColor], UITextAttributeTextShadowColor,
                                                         [UIColor whiteColor], UITextAttributeTextColor,
                                                         [UIFont systemFontOfSize:20],UITextAttributeFont,
                                                         nil];
        navgationController.navigationBar.barStyle = UIBarStyleBlack;
        [navgationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tabbar_bg"] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [navgationController setNeedsStatusBarAppearanceUpdate];
    }
    else {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
        [navgationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tabbar_bg"] forBarMetrics:UIBarMetricsDefault];
    }
}
@end
