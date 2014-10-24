//
//  PoppingBaseView.m
//
//  Created by Yan Guanyu on 5/29/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "ITTSlienceHintView.h"

#define APPWINDOW   [[UIApplication sharedApplication].delegate window]

#define DEFAULT_MARGIN_TOP  30

@interface ITTSlienceHintView()

@property (strong, nonatomic) UIControl *bgControl;

- (void)hide;

- (UIView*)keyboardView;
- (UIView*)viewForView:(UIView *)view;

//Animation
- (CAKeyframeAnimation*)scaleAnimation:(BOOL)show;

@end

@implementation ITTSlienceHintView


- (void)awakeFromNib
{
    [super awakeFromNib];
    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = TRUE;
    _bgControl = [[UIControl alloc] initWithFrame:[APPWINDOW bounds]];
    _bgControl.backgroundColor = [UIColor blackColor];
    _bgControl.alpha = 0.5;
//    [_bgControl addTarget:self action:@selector(onCancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)showInView:(UIView *)supView;
{
    UIView *superView = [self viewForView:supView];
    [superView addSubview:_bgControl];
    [superView addSubview:self];
    CGPoint origin = CGPointMake((CGRectGetWidth(superView.bounds) - CGRectGetWidth(self.bounds))/2, (CGRectGetHeight(superView.bounds) - CGRectGetHeight(self.bounds))/2 - DEFAULT_MARGIN_TOP);
    CGRect frame = self.bounds;
    frame.origin.x = origin.x;
    frame.origin.y = origin.y;
    self.frame = frame;    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.alpha = 1.0;
                         [self.layer addAnimation:[self scaleAnimation:YES] forKey:@"ITTALERTVIEWWILLAPPEAR"];
                     }
                     completion:^(BOOL finished){
                         if (finished) {
                         }
                     }];
}

- (void)showInView:(UIView *)supView disappearDelay:(NSTimeInterval)delay
{
    _bgControl.alpha = 0.0;
    UIView *superView = [self viewForView:supView];
    [superView addSubview:_bgControl];
    [superView addSubview:self];
    CGPoint origin = CGPointMake((CGRectGetWidth(superView.bounds) - CGRectGetWidth(self.bounds))/2, (CGRectGetHeight(superView.bounds) - CGRectGetHeight(self.bounds))/2 - DEFAULT_MARGIN_TOP);
    CGRect frame = self.bounds;
    frame.origin.x = origin.x;
    frame.origin.y = origin.y;
    self.frame = frame;
    __block typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.alpha = 1.0;
                         _bgControl.alpha = 0.3;
                         [self.layer addAnimation:[self scaleAnimation:YES] forKey:@"ITTALERTVIEWWILLAPPEAR"];
                     }
                     completion:^(BOOL finished){
                         if (finished) {
                             [weakSelf performSelector:@selector(hide) withObject:nil afterDelay:delay];
                         }
                     }];
}

- (void)hide
{
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.alpha = 0.0;
                         _bgControl.alpha = 0.0;
//                         [self.layer addAnimation:[self scaleAnimation:NO] forKey:@"ITTALERTVIEWWILLDISAPPEAR"];
                     }
                     completion:^(BOOL finished){
                         if (finished) {
                             [_bgControl removeFromSuperview];
                             [self removeFromSuperview];
                         }
                     }];
}

#pragma mark - Animation
- (CAKeyframeAnimation*)scaleAnimation:(BOOL)show
{
    CAKeyframeAnimation *scaleAnimation = nil;
    scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.delegate = self;
    scaleAnimation.fillMode = kCAFillModeForwards;
    
    NSMutableArray *values = [NSMutableArray array];
    if (show){
        scaleAnimation.duration = 0.5;
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.85, 0.85, 0.85)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05, 1.05)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95, 0.95, 0.95)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    }else{
        scaleAnimation.duration = 0.3;
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 0.8)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.6, 0.6, 0.6)]];
    }
    scaleAnimation.values = values;
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    scaleAnimation.removedOnCompletion = TRUE;
    return scaleAnimation;
}

#pragma mark - public methods
- (IBAction)onCancelBtnClicked:(id)sender
{
    if (_onCancelBlock) {
        _onCancelBlock();
    }
    [self hide];
}

- (IBAction)onConfirmBtnClicked:(id)sender
{
    if (_onConfirmBlock) {
        _onConfirmBlock();
    }
    [self hide];
}


+ (void)hintWithMessage:(NSString *)message
                  inView:(UIView *)view
{
    [[self class] hintWithTitle:nil message:message inView:view];
}

+ (void)hintWithConfirmTitle:(NSString *)confirmTitle
                  cancelTitle:(NSString *)cancelTitle
                      message:(NSString *)message
                       inView:(UIView *)view
{
    ITTSlienceHintView *alertView = [[self class] loadFromXib];
    alertView.messageLabel.text = message;
    if (confirmTitle) {
        [alertView.confirmButton setTitle:confirmTitle forState:UIControlStateNormal];
        [alertView.confirmButton setTitle:confirmTitle forState:UIControlStateHighlighted];
    }
    if (cancelTitle) {
        [alertView.cancelButton setTitle:cancelTitle forState:UIControlStateNormal];
        [alertView.cancelButton setTitle:cancelTitle forState:UIControlStateHighlighted];
    }
    [alertView showInView:view];
}

+ (void)hintWithTitle:(NSString *)title
               message:(NSString *)message
                inView:(UIView *)view
{
    ITTSlienceHintView *alertView = [[self class] loadFromXib];
    alertView.titleLabel.text = title;
    alertView.messageLabel.text = message;
    [alertView showInView:view];
}

- (UIView*)keyboardView
{
	NSArray *windows = [[UIApplication sharedApplication] windows];
	for (UIWindow *window in [windows reverseObjectEnumerator])
	{
		for (UIView *view in [window subviews])
		{
            // UIPeripheralHostView is used from iOS 4.0, UIKeyboard was used in previous versions:
			if (!strcmp(object_getClassName(view), "UIPeripheralHostView") || !strcmp(object_getClassName(view), "UIKeyboard"))
			{
				return view;
			}
		}
	}
	return nil;
}

- (UIView*)viewForView:(UIView *)view
{
    UIView *keyboardView = [self keyboardView];
    if (keyboardView) {
        view = keyboardView.superview;
    }
    return view;
}
@end