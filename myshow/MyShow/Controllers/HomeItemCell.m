//
//  HomeItemCell.m
//  MyShow
//
//  Created by wang dong on 8/3/14.
//  Copyright (c) 2014 maxingchuan. All rights reserved.
//

#import "HomeItemCell.h"
#import "UIImageView+AFNetworking.h"

@interface HomeItemCell()
{
    BOOL _fixImageHeight;
}

@end

@implementation HomeItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

- (void)refresh
{
    _imagesView.height = 320;

    _coverImageView.image = nil;

    CoverKeyModel *ckm = (CoverKeyModel *)[self.itemModel.coverKeyArray lastObject];

    [_coverImageView setImageWithURL:[NSURL URLWithString:ckm.url] placeholderImage:nil];

    if (!_locaitonView) {
        _locaitonView = [[UIView alloc] init];
        _locaitonView.backgroundColor = RGBACOLOR(0, 0, 0, 0.2);
        _locaitonView.top = _coverImageView.top + 15;
        _locaitonView.height = 22;
        _locaitonView.layer.cornerRadius = 5.f;
        _locaitonView.clipsToBounds = YES;
        [_imagesView addSubview:_locaitonView];

        UIImage *locationImage = [UIImage imageNamed:@"didian"];
        UIImageView *locationImageView = [[UIImageView alloc] initWithImage:locationImage];
        locationImageView.width = 15;
        locationImageView.height = 15;
        locationImageView.top = 4;
        locationImageView.left = 4;
        [_locaitonView addSubview:locationImageView];

        _locationLabel = [[UILabel alloc] init];
        _locationLabel.textColor = [UIColor whiteColor];
        [_locaitonView addSubview:_locationLabel];
        _locationLabel.left = locationImageView.right + 5;
        _locationLabel.top = 4;
        _locationLabel.font = [UIFont systemFontOfSize:12.f];
    }

    if (!_publishNumberView) {
        _publishNumberView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 46, 46)];
        _publishNumberView.right = _coverImageView.right;
        UIImage *image = [UIImage imageNamed:@"zhangshu"];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:_publishNumberView.bounds];
        imageView.image = image;
        [_publishNumberView addSubview:imageView];
        [_imagesView addSubview:_publishNumberView];

        _publishNumberLabel = [[UILabel alloc] init];
        _publishNumberLabel.top = 15;
        _publishNumberLabel.left = 15;
        _publishNumberLabel.font = [UIFont systemFontOfSize:12.f];
        _publishNumberLabel.textColor = [UIColor whiteColor];
        [_publishNumberView addSubview:_publishNumberLabel];
    }

    _publishNumberView.bottom = _coverImageView.bottom - 8;

    _locationLabel.text = self.itemModel.atlas.location;
    [_locationLabel sizeToFit];
    _locaitonView.width = _locationLabel.right + 10;
    _locaitonView.right = 310;

    _publishNumberLabel.text = [NSString stringWithFormat:@"X %@", self.itemModel.atlas.imageNum];
    [_publishNumberLabel sizeToFit];

    [self updateLike];
}

- (void)setIncrementHeight:(NSInteger)incrementHeight
{
    CoverKeyModel *ckm = (CoverKeyModel *)[self.itemModel.coverKeyArray lastObject];

    NSArray *sizeArray = [ckm.size componentsSeparatedByString:@"*"];
    CGFloat width = [sizeArray[0] floatValue];
    CGFloat height = [sizeArray[1] floatValue];

    NSInteger imageHeight;

    if (width == height) {
        imageHeight = 320;
        self.isSquare = YES;
    } else {
        imageHeight = 320 * height / width;
        self.fixImageHeight = YES;
    }

    _imagesView.height = imageHeight;
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] initWithFrame:_imagesView.bounds];
        [_imagesView addSubview:_coverImageView];
    }
    _coverImageView.height = imageHeight;
    [super setIncrementHeight:incrementHeight];
}

@end
