//
//  TagTableViewCell.m
//  MyShow
//
//  Created by unakayou on 14-4-19.
//  Copyright (c) 2014年 unakayou. All rights reserved.
//
//  上方的滑动标签
#import "TagTableViewCell.h"
#import "MyShowDefine.h"

@implementation TagTableViewCell
@synthesize horizontalView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier array:(NSArray *)array
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self initCommodityClassificationScrollViewWithArray:array];
    }
    return self;
}

//分类选择的滑动视图
- (void)initCommodityClassificationScrollViewWithArray:(NSArray *)array
{
    horizontalView = [[CommodityClassificationScrollView alloc] initWithFrame:self.bounds
                                                                 contentArray:array]; //初始化的时候需要标题数组
    
    self.horizontalView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.horizontalView];
}

- (void)layoutSubviews
{
    self.horizontalView.frame = self.bounds;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
