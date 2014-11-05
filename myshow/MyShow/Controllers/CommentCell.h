//
//  CommentCell.h
//  MyShow
//
//  Created by wang dong on 8/10/14.
//  Copyright (c) 2014 maxingchuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"

typedef void (^PortraitButtonBlock)();

@interface CommentCell : UITableViewCell

@property (strong, nonatomic) UIButton *portraitButton;
@property (copy, nonatomic) PortraitButtonBlock portraitButtonBlock;

- (void)configModel:(CommentModel *)model;

@end
