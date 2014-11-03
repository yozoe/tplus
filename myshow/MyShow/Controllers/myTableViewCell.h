//
//  myTableViewCell.h
//  MyShow
//
//  Created by max on 14/11/3.
//  Copyright (c) 2014年 maxingchuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITTImageView.h"


typedef void (^imageOneHanlderBlock)();
typedef void (^imageTwoHanlderBlock)();

@interface myTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet ITTImageView *imageViewOne;
@property (weak, nonatomic) IBOutlet ITTImageView *imageViewTwo;
@property (weak, nonatomic) IBOutlet UILabel *labelOne;
@property (weak, nonatomic) IBOutlet UILabel *labelTwo;


@property (nonatomic, strong)NSArray * cellArray;


@property (copy, nonatomic) imageOneHanlderBlock oneBlock;
@property (copy, nonatomic) imageTwoHanlderBlock twoBlock;

@end
