//
//  MyShowPopUpView.m
//  MyShow
//
//  Created by unakayou on 14-4-20.
//  Copyright (c) 2014年 unakayou. All rights reserved.
//

#import "MyShowPopUpView.h"
#import "MyShowSegmentedView.h"
#import "MyShowDefine.h"
#import "MyShowTools.h"

@implementation MyShowPopUpView
@synthesize segmentedView;

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        
        NSArray * segmentTextContent = @[@{@"text":@"标签"},@{@"text":@"评论"},@{@"text":@"喜欢"},@{@"text":@"分享"}];
        segmentedView = [[MyShowSegmentedView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, ICON_LENGTH) items:segmentTextContent];
        segmentedView.textColor = [UIColor blackColor];
        segmentedView.textHighLightColor = [UIColor whiteColor];
        segmentedView.backgroundColor = [UIColor whiteColor];
        segmentedView.selectedColor = [MyShowTools hexStringToColor:@"#f92b51"];
        self.segmentedView.delegate = self;
        [self addSubview:self.segmentedView];
    }
    return self;
}

#pragma mark - segment delegate
- (void)segmentedClickAtIndex:(int)index
{
    NSLog(@"%@ %d",[self class],index);
}

- (void)segmentedDragingGestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer
{
    static CGPoint fromLocation;
    CGPoint toLocation;
    CGPoint changeLocation;
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) //拖动开始
    {
        fromLocation = [gestureRecognizer locationInView:self];
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) //拖动过程中
    {
        toLocation = [gestureRecognizer locationInView:self.superview];
        changeLocation = CGPointMake(toLocation.x - fromLocation.x, toLocation.y - fromLocation.y);

        if (self.superview.frame.size.height - changeLocation.y > self.frame.size.height) //拉到最长的地方需要停止
            return;
        else if (self.superview.frame.size.height - changeLocation.y < self.segmentedView.frame.size.height) //拉到最短的地方需要停止
            return;
        
        self.frame = CGRectMake(self.frame.origin.x, changeLocation.y, self.frame.size.width, self.frame.size.height);
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded |
             gestureRecognizer.state == UIGestureRecognizerStateCancelled) //拖动结束
    {
        float minHeight = self.superview.frame.size.height - self.frame.size.height / 2; //中间的位置

        //如果拉出超过一半高度则弹出
        if (self.frame.origin.y <= minHeight) {
            [UIView animateWithDuration:0.3 animations:^{
                self.frame = CGRectMake(self.frame.origin.x,
                                        self.superview.frame.size.height - self.frame.size.height,
                                        self.frame.size.width,
                                        self.frame.size.height);
            } completion:^(BOOL finished) {
            }];
        }
        else //否则缩回
        {
            [UIView animateWithDuration:0.3 animations:^{
                self.frame = CGRectMake(self.frame.origin.x,
                                        self.superview.frame.size.height - self.segmentedView.frame.size.height,
                                        self.frame.size.width,
                                        self.frame.size.height);
            } completion:^(BOOL finished) {
            }];
        }
    }
}

@end
