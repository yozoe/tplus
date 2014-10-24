//
//  ITTMaskActivityView.m
//  iTotemFramework
//
//  Created by jack 廉洁 on 3/28/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//
//  Modify by Sword on 5/2 2013

#import "ITTMaskActivityView.h"

@interface ITTMaskActivityView()
{
    NSInteger       _selctedIndex;
    NSMutableArray  *_imageVies;
    NSTimer         *_timer;
}
@property (strong, nonatomic) IBOutlet UIImageView *loadingImageView;

@property (strong, nonatomic) IBOutlet UIView *bgMaskView;
@property (strong, nonatomic) IBOutlet UILabel *hintLabel;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *maskViewIndicator;
@property (strong, nonatomic) IBOutlet UIButton *cancleBtn;

@end

@implementation ITTMaskActivityView

- (void)awakeFromNib
{
    [super awakeFromNib];
    _bgMaskView.layer.masksToBounds = YES;
    _bgMaskView.layer.cornerRadius = 5;
    //    [self layoutDots];
    
    // Register for notification that app did enter background
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(stopAnimation)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:[UIApplication sharedApplication]];
    
    // Register for notification that app did enter foreground
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resumeAnimation)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:[UIApplication sharedApplication]];
    
}

- (void)setMessage:(NSString *)message
{
    _message = message;
    self.hintLabel.text = message;
}

- (void)layoutDots
{
    
    _selctedIndex = 0;
    _imageVies = [[NSMutableArray alloc] init];
    CGPoint center = CGPointMake(CGRectGetWidth(self.bounds) / 2, 35);
    CGFloat radius = 15;
    NSInteger numberOfDots = 10;
    CGFloat x;
    CGFloat y;
    CGFloat degree = 0;
    CGFloat offset = 2 * M_PI / numberOfDots;
    for (NSInteger i = 0; i < numberOfDots; i++) {
        x = center.x + radius * cosf(degree);
        y = center.y + radius * sinf(degree);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
        imageView.center = CGPointMake(x, y);
        imageView.image = [UIImage imageNamed:@"dot_small"];
        [self addSubview:imageView];
        [_imageVies addObject:imageView];
        degree += offset;
    }
    [self selectAtIndex:_selctedIndex];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    ITTDINFO(@"- (void)layoutSubviews");
}

#define LOADING_ANIMATION_AWEGAWEG  @"LOADING_ANIMATION_AWEGAWEG"

- (void)startAnimation
{
    CABasicAnimation *spinAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    spinAnimation.fromValue = [NSNumber numberWithFloat:0];
    spinAnimation.toValue = [NSNumber numberWithFloat:(2 * M_PI)];
    spinAnimation.duration = 1.2; // Speed
    spinAnimation.repeatCount = HUGE_VALF; // Repeat forever. Can be a finite number.
    [self.loadingImageView.layer addAnimation:spinAnimation forKey:LOADING_ANIMATION_AWEGAWEG];
}

- (void)stopAnimation
{
    [self.loadingImageView.layer removeAnimationForKey:LOADING_ANIMATION_AWEGAWEG];
    if ([_timer isValid]) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)resumeAnimation
{
    CAAnimation *animation = [self.loadingImageView.layer animationForKey:LOADING_ANIMATION_AWEGAWEG];
    if (animation) {
        [self.loadingImageView.layer addAnimation:animation forKey:LOADING_ANIMATION_AWEGAWEG];
    }
    else {
        [self startAnimation];
    }
}

- (void)tick
{
    NSInteger index = (_selctedIndex + 1) % [_imageVies count];
    [self selectAtIndex:index];
}

- (void)selectAtIndex:(NSInteger)index
{
    //reset previous to small dot
    UIImageView *smallDotImageView = _imageVies[_selctedIndex];
    smallDotImageView.image = [UIImage imageNamed:@"dot_small"];
    CGPoint center = smallDotImageView.center;
    CGRect smallDotFrame = CGRectMake(center.x - (5 / 2), center.y - (5 / 2), 5, 5);
    
    //set current image to big dot
    _selctedIndex = index;
    UIImageView *bigDotImageView = _imageVies[_selctedIndex];
    center = bigDotImageView.center;
    bigDotImageView.image = [UIImage imageNamed:@"dot_big"];
    CGRect bigDotFrame = CGRectMake(center.x - (11 / 2), center.y - (11 / 2), 11, 11);
    
    [UIView animateWithDuration:0.5 animations:^{
        smallDotImageView.frame = smallDotFrame;
        bigDotImageView.frame = bigDotFrame;
    }];
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
    //    UIView *keyboardView = [self keyboardView];
    //    if (keyboardView) {
    //        view = keyboardView.superview;
    //    }
    return view;
}

//  Modify by Sword on 5/2 2013
- (void)showInView:(UIView*)parentView
{
    [self showInView:parentView withHintMessage:nil onCancleRequest:nil];
}

//  Modify by Sword on 5/2 2013
- (void)showInView:(UIView *)view withHintMessage:(NSString *)message
{
    [self showInView:view withHintMessage:message onCancleRequest:nil];
}

//  Modify by Sword on 5/2 2013
- (void)showInView:(UIView *)view withHintMessage:(NSString *)message
   onCancleRequest:(void (^)(ITTMaskActivityView *))onCanceledBlock
{
    if (onCanceledBlock) {
        _onRequestCanceled = [onCanceledBlock copy];
    }
    UIView *superView = [self viewForView:view];
    [superView addSubview:self];
    
    CGPoint origin = CGPointMake((CGRectGetWidth(superView.bounds) - CGRectGetWidth(self.bounds))/2, (CGRectGetHeight(superView.bounds) - CGRectGetHeight(self.bounds))/2);
    CGRect frame = self.bounds;
    frame.origin.x = origin.x;
    frame.origin.y = origin.y;
    self.frame = frame;
    
    _hintLabel.hidden = NO;
    _hintLabel.text = message;
    self.alpha = 0;
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.alpha = 1;
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                         }
                     }];
    [self startAnimation];
}

- (void)hide
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             [[NSNotificationCenter defaultCenter] removeObserver:self];
                             [self stopAnimation];
                             [self removeFromSuperview];
                         }
                     }];
}

//  Modify by Sword on 5/2 2013
- (IBAction)onCancelBtnTouched:(id)sender
{
    if (_onRequestCanceled) {
        _onRequestCanceled(self);
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self stopAnimation];
    _imageVies = nil;
}
@end
