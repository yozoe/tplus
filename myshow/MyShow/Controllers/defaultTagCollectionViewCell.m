//
//  defaultTagCollectionViewCell.m
//  MyShow
//
//  Created by max on 14/10/31.
//  Copyright (c) 2014年 maxingchuan. All rights reserved.
//

#import "defaultTagCollectionViewCell.h"

@implementation defaultTagCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    self.tagLabel.backgroundColor = RGBACOLOR(0, 0, 0, .5);
}


-(void)setModel:(DefaultTagModel *)model
{
    _model = model;
    
    self.tagLabel.text = model.name;
    
    NSString * url = model.coverImage.url;
    [self.tagImageView loadImage:url];
    
}

@end
