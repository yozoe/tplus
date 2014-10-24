//
//  TagTableViewCell.h
//  MyShow
//
//  Created by unakayou on 14-4-19.
//  Copyright (c) 2014年 unakayou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommodityClassificationScrollView.h"

@interface TagTableViewCell : UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier array:(NSArray *)array;

@property (nonatomic, retain) CommodityClassificationScrollView * horizontalView; //横着的标签列表。里面有可以滑动的scrollView

@end
