//
//  myTableViewCell.m
//  MyShow
//
//  Created by max on 14/11/3.
//  Copyright (c) 2014年 maxingchuan. All rights reserved.
//

#import "myTableViewCell.h"
#import "DefaultTagModel.h"
#import "CoverImageModel.h"



@implementation myTableViewCell


- (IBAction)handleOneButtonClick:(UIButton *)sender {
    if (_oneBlock) {
        _oneBlock();
    }
}

- (IBAction)handleTwoButtonClick:(UIButton *)sender {
    if (_twoBlock) {
        _twoBlock();
    }
}

- (void)awakeFromNib {
    // Initialization code
    self.labelOne.backgroundColor = RGBACOLOR(0, 0, 0, .5);
    self.labelTwo.backgroundColor = RGBACOLOR(0, 0, 0, .5);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setCellArray:(NSArray *)cellArray
{
    _cellArray = cellArray;
    if (cellArray.count == 1) {
        
        DefaultTagModel * modelOne = [cellArray objectAtIndex:0];
        CoverImageModel * imageModelOne = [modelOne.atlasImagesArray objectAtIndex:0];
        [self.imageViewOne loadImage:imageModelOne.thumb.url];
        self.labelOne.text = modelOne.name;
        
        self.labelTwo.hidden = YES;
        self.imageViewTwo.hidden = YES;
        self.buttonTwo.hidden = YES;
        
    }else if(cellArray.count == 2){
        
        DefaultTagModel * modelOne = [cellArray objectAtIndex:0];
        CoverImageModel * imageModelOne = [modelOne.atlasImagesArray objectAtIndex:0];
        [self.imageViewOne loadImage:imageModelOne.thumb.url];
        self.labelOne.text = modelOne.name;
        
        DefaultTagModel * modelTwo = [cellArray objectAtIndex:1];
        CoverImageModel * imageModelTwo = [modelTwo.atlasImagesArray objectAtIndex:0];
        [self.imageViewTwo loadImage:imageModelTwo.thumb.url];
        self.labelTwo.text = modelTwo.name;
        
        self.labelTwo.hidden = NO;
        self.imageViewTwo.hidden = NO;
        self.buttonTwo.hidden = NO;
        
    }
    
}

@end
