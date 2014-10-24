//
//  CameraView.m
//  MyShow
//
//  Created by unakayou on 14-5-22.
//  Copyright (c) 2014年 unakayou. All rights reserved.
//

#import "CameraView.h"

@interface CameraView ()

@end

@implementation CameraView
@synthesize backgroundView;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithImages:(NSArray *)images backgroundImage:(UIImage *)backgroundImage
{
    if (self = [super init])
    {
        backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
        self.backgroundView.userInteractionEnabled = YES;
        [self addSubview:self.backgroundView];
        
        NSArray * titleArray = @[@"相册",@"拍照"];
        
        for (int i = 0; i < [images count]; i++)
        {
            if (i >= 2) break;
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = i + 11;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [button setImage:[images objectAtIndex:i] forState:UIControlStateNormal];
            [self.backgroundView addSubview:button];
            
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectZero];
            label.tag = button.tag + 100;
            label.textAlignment = UITextAlignmentCenter;
            label.textColor = [UIColor blackColor];
            label.font = [UIFont boldSystemFontOfSize:13];
            label.text = titleArray[i];
            [self.backgroundView addSubview:label];
        }
    }
    return self;
}

- (void)layoutSubviews
{
    self.backgroundView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    for (UIButton * button in self.backgroundView.subviews)
    {
        if ([button isKindOfClass:[UIButton class]])
        {
            int i = button.tag - 11;
            float buttonX = i % 2 ? 1 : -1;
            button.bounds = CGRectMake(0, 0, 30, 30);
            button.center = CGPointMake(self.backgroundView.center.x + buttonX * 48,
                                        self.backgroundView.center.y - 4);
            
            UILabel * label = (UILabel *)[self.backgroundView viewWithTag:button.tag + 100];
            label.frame = CGRectMake(button.left, button.bottom, button.width, 13);
        }
    }
    
    
}

- (void)buttonClick:(UIButton *)sender
{
    if (sender.tag - 11 == 0 && [self.delegate respondsToSelector:@selector(openAlbumButtonClick:)])
    {
        [self.delegate openAlbumButtonClick:self];
    }
    else if ([self.delegate respondsToSelector:@selector(openCameraButtonClick:)])
    {
        [self.delegate openCameraButtonClick:self];
    }
}

@end
