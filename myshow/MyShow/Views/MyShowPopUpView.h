//
//  MyShowPopUpView.h
//  MyShow
//
//  Created by unakayou on 14-4-20.
//  Copyright (c) 2014年 unakayou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyShowSegmentedView.h"

@interface MyShowPopUpView : UIView <MyShowSegmentedDelegate>

@property (nonatomic, retain, readonly) MyShowSegmentedView * segmentedView;

@end
