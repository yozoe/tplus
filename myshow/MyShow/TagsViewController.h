//
//  TagsViewController.h
//  MyShow
//
//  Created by max on 14-7-25.
//  Copyright (c) 2014年 maxingchuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyShowNavigationBar.h"
#import "BaseViewController.h"
#import "ITTMaskActivityView.h"

@interface TagsViewController : BaseViewController<NavigationBarDelegate>
{
    MyShowNavigationBar * _navigationBar;
    ITTMaskActivityView * _maskActivityView;
}

@property (nonatomic, strong) NSArray * tagsArray;
@property (nonatomic, strong) NSMutableArray * selectedArray;
@property (nonatomic, strong) NSMutableArray * selectedNames;
@property (nonatomic, strong) NSMutableDictionary * stateDict;
@property (nonatomic, assign) int homeTagIndex;


@property (nonatomic, copy) NSString * uploadText;          //上传文字
@property (nonatomic, strong) NSArray * uploadImages;       //上传图片
@property (nonatomic, strong) NSArray * uploadTags;         //上传标签

@property (nonatomic, strong) NSDictionary * uploadImagesDict; //上传图片路径


@property (nonatomic, copy) void(^didDistributeSuccess)();
@property (nonatomic, copy) void(^didDistributeFail)();

@end
