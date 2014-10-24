//
//  UIPlaceHolderTextView.m
//  RongXin
//
//  Created by melody on 14-1-20.
//  Copyright (c) 2014年 KSY. All rights reserved.
//

#import "UIPlaceHolderTextView.h"


#define IOS7_OR_LATER ([[[UIDevice currentDevice] systemVersion]compare:@"7.0"]!=NSOrderedAscending)

@interface UIPlaceHolderTextView ()

@property (nonatomic, retain) UILabel *placeHolderLabel;

@end
@implementation UIPlaceHolderTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if( (self = [super initWithFrame:frame]) )
        {
            [self setPlaceholder:@""];
            [self setPlaceholderColor:[UIColor lightGrayColor]];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
        }
        return self;
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
#if __has_feature(objc_arc)
#else
    [_placeHolderLabel release]; _placeHolderLabel = nil;
    [_placeholderColor release]; _placeholderColor = nil;
    [_placeholder release]; _placeholder = nil;
    [super dealloc];
#endif
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    if (!self.placeholder) {
        [self setPlaceholder:@""];
    }
    
    if (!self.placeholderColor) {
        [self setPlaceholderColor:[UIColor lightGrayColor]];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
}
/*!
 @method
 @abstract   文本改变通知方法
 @discussion 注册通知,接受通知触发
 @param      notification textView内容监听通知
 @result     无
 */
- (void)textChanged:(NSNotification *)notification
{
    if([[self placeholder] length] == 0)
    {
        return;
    }
    
    if([[self text] length] == 0)
    {
        [[self viewWithTag:999] setAlpha:1];
    }
    else
    {
        [[self viewWithTag:999] setAlpha:0];
    }
}
/*!
 @method
 @abstract   重写父类set方法
 @discussion 一般结合属性,对象初始化调用
 @param      text 文本内容
 @result     无
 */
- (void)setText:(NSString *)text {
    [super setText:text];
    [self textChanged:nil];
}

- (void)drawRect:(CGRect)rect
{
    if( [[self placeholder] length] > 0 )
    {
        if (_placeHolderLabel == nil )
        {
            if (IOS7_OR_LATER) {
                _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,8,self.bounds.size.width - 16,0)];
            } else {
                _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,8,self.bounds.size.width - 16,0)];
            }
            _placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
            _placeHolderLabel.numberOfLines = 0;
            _placeHolderLabel.font = self.font;
            _placeHolderLabel.backgroundColor = [UIColor clearColor];
            _placeHolderLabel.textColor = self.placeholderColor;
            _placeHolderLabel.alpha = 0;
            _placeHolderLabel.tag = 999;
            [self addSubview:_placeHolderLabel];
        }
        
        _placeHolderLabel.text = self.placeholder;
        [_placeHolderLabel sizeToFit];
        [self sendSubviewToBack:_placeHolderLabel];
    }
    
    if( [[self text] length] == 0 && [[self placeholder] length] > 0 )
    {
        [[self viewWithTag:999] setAlpha:1];
    }
    
    [super drawRect:rect];
}

@end
