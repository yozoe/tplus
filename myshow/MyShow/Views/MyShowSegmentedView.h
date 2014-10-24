//
//  MyShowSegmentedView.h
//  MyShow
//
//  Created by unakayou on 14-4-19.
//  Copyright (c) 2014年 unakayou. All rights reserved.
//
#import <UIKit/UIKit.h>

#define segment_corner 3.0
@protocol MyShowSegmentedDelegate <NSObject>
@optional
- (void)segmentedClickAtIndex:(int)index;
- (void)segmentedDragingGestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer;
@end

@interface MyShowSegmentedView : UIView
@property (nonatomic, retain) UIColor * selectedColor;   //选中的颜色
@property (nonatomic, retain) UIColor * backgroundColor; //背景颜色
@property (nonatomic, retain) UIColor * borderColor; //边框颜色
@property (nonatomic, retain) UIColor * textColor;   //字体颜色
@property (nonatomic, retain) UIColor * textHighLightColor; //字体选中颜色
@property (nonatomic, assign) CGFloat borderWidth;   //分离器宽度
@property (nonatomic, retain) UIFont  * textFont;    //字体

@property (nonatomic, retain) NSMutableArray * segments;  //button数组
@property (nonatomic, assign) NSInteger lastSelected;    //上一个选中
@property (nonatomic, assign) NSInteger currentSelected; //当前选中
@property (nonatomic, retain) NSMutableArray *separators;//分离器
@property (nonatomic, assign) id <MyShowSegmentedDelegate> delegate;

- (id)initWithFrame:(CGRect)frame items:(NSArray*)items; //用标题初始化
- (id)initWithFrame:(CGRect)frame images:(NSArray *)images; //用图片初始化
- (void)setEnabled:(BOOL)enabled forSegmentAtIndex:(NSUInteger)segment;
- (BOOL)isEnabledForSegmentAtIndex:(NSUInteger)index;
- (void)setTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)index;
@end
