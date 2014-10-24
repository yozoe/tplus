//
//  PoppingBaseView.h
//
//  Created by Yan Guanyu on 5/29/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "ITTXibView.h"

/*
 * ITTSlienceHintView inherits from ITTXibView, you can create an instance of ITTSlienceHintView
 * using super method:loadFromXib method
 */
@interface ITTSlienceHintView : ITTXibView

@property (strong, nonatomic) void (^onCancelBlock)(void);
@property (strong, nonatomic) void (^onConfirmBlock)(void);

@property (strong, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) IBOutlet UIButton *confirmButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

+ (void)hintWithTitle:(NSString *)title
               message:(NSString*)message
               inView:(UIView *)view;

+ (void)hintWithMessage:(NSString *)message
                 inView:(UIView *)view;

+ (void)hintWithConfirmTitle:(NSString *)confirmTitle
                  cancelTitle:(NSString *)cancelTitle
                    message:(NSString *)message
                      inView:(UIView *)view;

- (void)showInView:(UIView *)supView;

- (void)showInView:(UIView *)supView disappearDelay:(NSTimeInterval)delay;

- (void)hide;

@end