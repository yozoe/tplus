//
//  DetailTagView.m
//  MyShow
//
//  Created by wang dong on 8/7/14.
//  Copyright (c) 2014 maxingchuan. All rights reserved.
//

#import "DetailTagView.h"

@interface DetailTagView()
{
    CGFloat _lastLabelRight;
    CGFloat _lastLabelBottom;
}

@end

@implementation DetailTagView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (void)configData
{
    NSInteger total;
    total = [_tagDataSource numberOfTags];
    CGFloat startLeft = 10;
    CGFloat startTop = 10;
    for (int i = 0; i < total; i++) {
        TagModel *tm = [_tagDataSource tagItemAtIndex:i];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(startLeft, startTop, 60, 25)];

        CGSize size = [tm.name sizeWithFont:[UIFont systemFontOfSize:14.f]];

        label.width += (size.width - 28);

        if (_lastLabelRight != 0) {

            if (_lastLabelRight + label.left > 250) {
                label.left = startLeft;
                startTop += 35;
                label.top = startTop;
            } else {
                label.left = _lastLabelRight + 10;
            }

        }

        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14.f];
        label.backgroundColor = [UIColor redColor];
        label.textColor = [UIColor whiteColor];
        label.text = tm.name;
        [self addSubview:label];
        _lastLabelRight = label.right;
        _lastLabelBottom = label.bottom;
    }
    total = [_tagDataSource numberOfLinks];
    for (int i = 0; i < total; i++) {
        LinksModel *lm = [_tagDataSource linkItemAtIndex:i];
        LinkLabel *lb = [LinkLabel new];
        lb.tag = i;
        lb.userInteractionEnabled = YES;
        lb.textColor = [UIColor blueColor];
        lb.text = lm.name;
        [lb sizeToFit];
        lb.top = _lastLabelBottom + 5;
        lb.left = 20;
        [self addSubview:lb];
        _lastLabelBottom = lb.bottom;
    }
    self.contentSize = CGSizeMake(self.contentSize.width, _lastLabelBottom);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches  anyObject];
    CGPoint point = [touch locationInView:self];
    UIView *hitView = [self hitTest:point withEvent:event];
    if ([hitView isKindOfClass:[LinkLabel class]]) {
        if ([_tagDelegate respondsToSelector:@selector(didClickLink:)]) {
            [_tagDelegate didClickLink:hitView.tag];
        }
    }
}

@end

@implementation LinkLabel

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGSize fontSize =[self.text sizeWithFont:self.font forWidth:self.bounds.size.width lineBreakMode:NSLineBreakByTruncatingTail];

    [[UIColor blueColor] setStroke];
    CGContextSetLineWidth(ctx, 2.0f);
    CGPoint l = CGPointMake(self.frame.size.width - fontSize.width - 2, self.frame.size.height - 3);
    CGPoint r = CGPointMake(self.frame.size.width, self.frame.size.height - 3);

    CGContextMoveToPoint(ctx, l.x, l.y);
    CGContextAddLineToPoint(ctx, r.x, r.y);
    CGContextStrokePath(ctx);
}

@end
