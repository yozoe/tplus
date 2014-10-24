//
//  CommodityClassificationScrollView.h
//  MyShow
//
//  Created by unakayou on 14-4-18.
//  Copyright (c) 2014年 unakayou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommodityClassificationScrollView : UIView

- (id)initWithFrame:(CGRect)frame contentArray:(NSArray *)contentArray; //通过Frame、数据初始化商品分类滑动条

@property (nonatomic, retain) NSArray * scrollViewArray;
@property (nonatomic, retain) UIScrollView * scrollView;

@end
