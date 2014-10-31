//
//  defaultTagCollectionViewCell.h
//  MyShow
//
//  Created by max on 14/10/31.
//  Copyright (c) 2014年 maxingchuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DefaultTagModel.h"
#import "ITTImageView.h"

@interface defaultTagCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong)DefaultTagModel * model;


@property (weak, nonatomic) IBOutlet ITTImageView *tagImageView;


@property (weak, nonatomic) IBOutlet UILabel *tagLabel;

@end
