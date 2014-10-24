//
//  MyShowNavigationBar.h
//  MyShow
//
//  Created by unakayou on 14-4-17.
//  Copyright (c) 2014年 unakayou. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NavigationBarDelegate <NSObject>
@optional
- (void)leftButtonClick;
- (void)rightButtonClick;
@end

@interface MyShowNavigationBar : UINavigationBar

- (id)initWithFrame:(CGRect)frame ColorStr:(NSString *)colorStr;

@property (nonatomic, retain) UILabel  * titleLabel;    //标题的信息
@property (nonatomic, retain) UIButton * leftButton;    //左侧button
@property (nonatomic, retain) UIButton * rightButton;   //右侧button

@property (nonatomic, assign) id <NavigationBarDelegate> delegate; //点击跳转注册页面代理

@end
