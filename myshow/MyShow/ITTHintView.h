//
//  PoppingBaseView.h
//
//  Created by Yan Guanyu on 5/29/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "ITTXibView.h"

@interface ITTHintView : ITTXibView

@property (strong, nonatomic) void (^onCancelBlock)(void);
@property (strong, nonatomic) void (^onConfirmBlock)(void);

@property (strong, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) IBOutlet UIButton *confirmButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

+ (void)hintWithTitle:(NSString *)title
               message:(NSString*)message
                  inView:(UIView *)view
                onCancel:(void (^)(void))onCancelBlock
               onConfirm:(void (^)(void))onConfirmBlock;

+ (void)hintWithMessage:(NSString *)message
                  inView:(UIView *)view
                onCancel:(void (^)(void))onCancelBlock
               onConfirm:(void (^)(void))onConfirmBlock;

+ (void)hintWithConfirmTitle:(NSString *)confirmTitle
                  cancelTitle:(NSString *)cancelTitle
                    message:(NSString *)message
                       inView:(UIView *)view
                     onCancel:(void (^)(void))onCancelBlock
                    onConfirm:(void (^)(void))onConfirmBlock;

- (void)showInView:(UIView *)supView
          onCancel:(void (^)(void))onCancelBlock
         onConfirm:(void (^)(void))onConfirmBlock;

@end