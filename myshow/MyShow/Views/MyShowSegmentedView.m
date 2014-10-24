//
//  MyShowSegmentedView.m
//  MyShow
//
//  Created by unakayou on 14-4-19.
//  Copyright (c) 2014年 unakayou. All rights reserved.
//
//  下方的切换按钮

@interface SegmentedViewButton : UIButton

@end

@implementation SegmentedViewButton

@end

#import "MyShowSegmentedView.h"
#import "MyShowTools.h"
@implementation MyShowSegmentedView

- (id)initWithFrame:(CGRect)frame items:(NSArray*)items
{
    self = [super initWithFrame:frame];
    if (self)
    {
        float buttonWith = frame.size.width / items.count;
        int i = 0;

        for(NSDictionary * item in items)
        {
            UIPanGestureRecognizer * panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(btnLong:)];

            NSString * text = item[@"text"];
            SegmentedViewButton * button = [SegmentedViewButton buttonWithType:UIButtonTypeCustom];
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            button.userInteractionEnabled = YES;
            [button setFrame:CGRectMake(buttonWith * i, 0, buttonWith, frame.size.height)];
            [button setTitle:text forState:UIControlStateNormal];
            [button setBackgroundImage:[MyShowTools createImageWithColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
            [button addTarget:self action:@selector(segmentSelected:) forControlEvents:UIControlEventTouchUpInside];
            [button addGestureRecognizer:panGestureRecognizer];
            [self.segments addObject:button];
            [self addSubview:button];
//            [button release];
            
            //Adding separator
            if(i != 0)
            {
                UIView *separatorView=[[UIView alloc] initWithFrame:CGRectMake(i * buttonWith, 0, self.borderWidth, frame.size.height)];
                [self addSubview:separatorView];
                [self.separators addObject:separatorView];
            }
            
            i++;
        }
        
        _currentSelected = 0;
        _lastSelected = 0;
    }
    return self;
}

-(void)btnLong:(UIPanGestureRecognizer *)recognizer
{
    if ([self.delegate respondsToSelector:@selector(segmentedDragingGestureRecognizer:)])
        [self.delegate segmentedDragingGestureRecognizer:recognizer];
}

- (id)initWithFrame:(CGRect)frame images:(NSArray *)images
{
    if (self = [super initWithFrame:frame])
    {
        float buttonWith = frame.size.width / images.count;
        int i = 0;
        
        for (id obj in images)
        {
            if ([obj isKindOfClass:[UIImage class]])
            {
                UIPanGestureRecognizer * panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(btnLong:)];
                SegmentedViewButton * button = [SegmentedViewButton buttonWithType:UIButtonTypeCustom];
                button.userInteractionEnabled = YES;
                [button setFrame:CGRectMake(buttonWith * i, 0, buttonWith, frame.size.height)];
                [button setBackgroundColor:[UIColor blackColor]];
                [button setImage:obj forState:UIControlStateNormal];
//                [button setImage:[MyShowTools createImageWithColor:[UIColor blackColor]] forState:UIControlStateSelected | UIControlStateHighlighted];
                [button addTarget:self action:@selector(segmentSelected:) forControlEvents:UIControlEventTouchUpInside];
                [button addGestureRecognizer:panGestureRecognizer];
                [self.segments addObject:button];
                [self addSubview:button];
//                [button release];
                
                i++;
            }
        }
        _currentSelected = 0;
        _lastSelected = 0;
    }
    return self;
}

#pragma mark - Lazy instantiations
-(NSMutableArray*)segments
{
    if(!_segments)
        _segments = [[NSMutableArray alloc] init];
    
    return _segments;
}
-(NSMutableArray*)separators
{
    if(!_separators)
        _separators=[[NSMutableArray alloc] init];
    return _separators;
}
#pragma mark - Actions
-(void)segmentSelected:(id)sender
{
    if (YES) //nowTime - lastTime > 1)
    {
        if(sender)
        {
            NSUInteger selectedIndex = [self.segments indexOfObject:sender];
            [self setEnabled:YES forSegmentAtIndex:selectedIndex];
            
            if ([self.delegate respondsToSelector:@selector(segmentedClickAtIndex:)] /*&& self.lastSelected != self.currentSelected*/)
            {
                [self.delegate segmentedClickAtIndex:(int)selectedIndex];
            }
            self.lastSelected = self.currentSelected;
        }
    }
}
#pragma mark - Getters
-(BOOL)isEnabledForSegmentAtIndex:(NSUInteger)index
{
    return (index == self.currentSelected);
}

#pragma mark - Setters
-(void)updateSegmentsFormat
{
    if(self.borderColor)
    {
        self.layer.borderWidth = self.borderWidth;
        self.layer.borderColor = self.borderColor.CGColor;
    }
    else
    {
        self.layer.borderWidth = 0;
    }
    
    for(UIView * separator in self.separators)
    {
        separator.backgroundColor = self.borderColor;
        separator.frame = CGRectMake(separator.frame.origin.x, separator.frame.origin.y,self.borderWidth , separator.frame.size.height);
    }
    
    for (UIButton * segment in self.segments)
    {
        if([self.segments indexOfObject:segment] == self.currentSelected)
        {
            if(self.selectedColor)
            {
                [segment setBackgroundImage:[MyShowTools createImageWithColor:self.selectedColor] forState:UIControlStateNormal];
            }
            if (self.textHighLightColor)
            {
                [segment setTitleColor:self.textHighLightColor forState:UIControlStateNormal];
            }
        }
        else
        {
            if (self.backgroundColor)
            {
                [segment setBackgroundImage:[MyShowTools createImageWithColor:self.backgroundColor] forState:UIControlStateNormal];
            }
            if (self.textColor)
            {
                [segment setTitleColor:self.textColor forState:UIControlStateNormal];
            }
        }
    }
}

-(void)setSelectedColor:(UIColor *)selectedColor
{

    
    _selectedColor = selectedColor;
    
    [self updateSegmentsFormat];
}

-(void)setBackgroundColor:(UIColor *)backgroundColor
{

    
    _backgroundColor = backgroundColor;
    [self updateSegmentsFormat];
}

- (void)setTextColor:(UIColor *)textColor
{

    
    _textColor = textColor;
    [self updateSegmentsFormat];
//    for (UIButton * button in self.segments)
//    {
//        [button setTitleColor:textColor forState:UIControlStateNormal];
//    }
}
- (void)setTextHighLightColor:(UIColor *)textHighLightColor
{

    
    _textHighLightColor = textHighLightColor;
    [self updateSegmentsFormat];
//    for (UIButton * button in self.segments)
//    {
//        [button setTitleColor:textHighLightColor forState:UIControlStateHighlighted];
//    }
}

-(void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    [self updateSegmentsFormat];
}

-(void)setTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)index
{
    if(index < self.segments.count)
    {
        UIButton * segment = self.segments[index];
        if([title isKindOfClass:[NSString class]])
        {
            [segment setTitle:title forState:UIControlStateNormal];
        }
    }
}

-(void)setBorderColor:(UIColor *)borderColor
{

    
    _borderColor = borderColor;
    [self updateSegmentsFormat];
}

-(void)setEnabled:(BOOL)enabled forSegmentAtIndex:(NSUInteger)segment
{
    if(enabled)
    {
        self.currentSelected = segment;
        [self updateSegmentsFormat];
    }
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}

- (void)layoutSubviews
{
    float buttonWith = self.frame.size.width / self.segments.count;
    for (int i = 0; i < self.segments.count; i++)
    {
        UIButton * button = [self.segments objectAtIndex:i];
        [button setFrame:CGRectMake(buttonWith * i, 0, buttonWith, self.frame.size.height)];
    }
    for (int j = 0; j < self.separators.count; j++)
    {
        UIView * separator = [self.separators objectAtIndex:j];
        separator.frame =CGRectMake(j * buttonWith, 0, self.borderWidth, self.frame.size.height);
    }
}


@end
