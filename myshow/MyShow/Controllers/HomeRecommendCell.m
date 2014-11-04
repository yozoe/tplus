//
//  HomeRecommendCell.m
//  MyShow
//
//  Created by wang dong on 7/30/14.
//  Copyright (c) 2014 maxingchuan. All rights reserved.
//

#import "HomeRecommendCell.h"
#import "ImgsModel.h"
#import "UIImageView+AFNetworking.h"

@interface HomeRecommendCell()
{
    CABasicAnimation *_fadeAnimation;
}

@end

@implementation HomeRecommendCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initHeader];
        [self initBody];
        [self initFooter];
        _fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        _fadeAnimation.duration = 0.3f;
        _fadeAnimation.fromValue = [NSNumber numberWithInt:0.f];
        _fadeAnimation.toValue = [NSNumber numberWithFloat:1.f];
        _fadeAnimation.removedOnCompletion = NO;
        _fadeAnimation.fillMode = kCAFillModeForwards;

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)initHeader
{
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    _headerView.backgroundColor = RGBCOLOR(244, 244, 241);

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 320, 50)];
    view.backgroundColor = [UIColor whiteColor];
    [_headerView addSubview:view];

    _portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 40, 40)];
    _portraitImageView.layer.masksToBounds = YES;
    _portraitImageView.layer.cornerRadius = 20.f;
    [view addSubview:_portraitImageView];

    _usernameLabel = [[UILabel alloc] init];
    _usernameLabel.font = [UIFont systemFontOfSize:14.f];

    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font = [UIFont systemFontOfSize:14.f];

    _usernameLabel.left = _portraitImageView.right + 10;
    _usernameLabel.top = 8;

    _timeLabel.left = _portraitImageView.right + 10;
    _timeLabel.top = _usernameLabel.bottom + 16;

    [view addSubview:_usernameLabel];
    [view addSubview:_timeLabel];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(_portraitImageView.left, _portraitImageView.top, _usernameLabel.right, _portraitImageView.height);
    [view addSubview:button];
    [button addTarget:self action:@selector(handleUserButtonEvent) forControlEvents:UIControlEventTouchUpInside];

    [self.contentView addSubview:_headerView];
}

- (void)initBody
{
    _imagesView = [[UIView alloc] initWithFrame:CGRectMake(0, _headerView.bottom, 320, 0)];
    [self.contentView addSubview:_imagesView];
}

- (void)initFooter
{
    _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, HOME_CELL_FOOT_HEIGHT)];
    _publichLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 0)];
    _publichLabel.font = [UIFont systemFontOfSize:14.f];
    _publichLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _publichLabel.numberOfLines = 0;
    [_footerView addSubview:_publichLabel];

    [self.contentView addSubview:_footerView];
}

- (void)setItemModel:(ItemModel *)itemModel
{
    _itemModel = itemModel;
    [self configHeaderView];
}

- (void)setIncrementHeight:(NSInteger)incrementHeight
{
    _incrementHeight = incrementHeight;

    _footerView.height = HOME_CELL_FOOT_HEIGHT;

    if (!_fixImageHeight) {
        NSInteger size = _itemModel.atlas.imageNum.integerValue;
        if (self.isSquare) {
            _imagesView.height = 320;
        } else {
            if (size > 6) {
                size = 6;
            }
            switch (size) {
                case 1:
                    _imagesView.height = 320;
                    break;
                case 2:
                    _imagesView.height = 160;
                    break;
                case 3:
                    _imagesView.height = 106;
                    break;
                case 4:
                    _imagesView.height = 321;
                    break;
                case 5:
                    _imagesView.height = 213;
                case 6:
                    _imagesView.height = 213;
                    break;
            }
        }
    }

    _footerView.top = _imagesView.bottom;
    _publichLabel.text = _itemModel.atlas.content;

    _publichLabel.height = self.incrementHeight;

    _footerView.height += self.incrementHeight;

    self.contentView.height = _footerView.bottom;

    [self configFooterView];
}

- (void)refresh
{
    int count = _itemModel.atlas.imgsArray.count;
    int size = count;
    if (size > 6) {
        size = 6;
    }
    [_imagesView removeAllSubviews];
    switch (size) {
        case 1:
            [self createOneImageView];
            break;
        case 2:
            [self createTwoImageView];
            break;
        case 4:
            [self createFourImageView];
            break;
        default:
            [self createRandomTileWithCount:size];
            break;
    }
    if (!_locaitonView) {
        _locaitonView = [[UIView alloc] init];
        _locaitonView.backgroundColor = RGBACOLOR(0, 0, 0, 0.2);
        _locaitonView.top = _imagesView.top + 15;
        _locaitonView.height = 22;
        _locaitonView.layer.cornerRadius = 5.f;
        _locaitonView.clipsToBounds = YES;
        [self.contentView addSubview:_locaitonView];

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
        _publishNumberView.right = _imagesView.right;
        UIImage *image = [UIImage imageNamed:@"zhangshu"];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:_publishNumberView.bounds];
        imageView.image = image;
        [_publishNumberView addSubview:imageView];
        [self.contentView addSubview:_publishNumberView];

        _publishNumberLabel = [[UILabel alloc] init];
        _publishNumberLabel.top = 15;
        _publishNumberLabel.left = 15;
        _publishNumberLabel.font = [UIFont systemFontOfSize:12.f];
        _publishNumberLabel.textColor = [UIColor whiteColor];
        [_publishNumberView addSubview:_publishNumberLabel];
    }

    _publishNumberView.bottom = _imagesView.bottom - 8;

    _locationLabel.text = self.itemModel.atlas.location;
    [_locationLabel sizeToFit];
    _locaitonView.width = _locationLabel.right + 10;
    _locaitonView.right = 310;

    _publishNumberLabel.text = [NSString stringWithFormat:@"X %@", self.itemModel.atlas.imageNum];
    [_publishNumberLabel sizeToFit];
    [self updateLike];
}

- (void)updateLike
{
    [self isLike:[self.itemModel.isLike isEqualToString:@"1"]];
    [_tagButton setNumberText:[NSString stringWithFormat:@"%d", _itemModel.labelsArray.count]];
    [_commentButton setNumberText:_itemModel.atlas.commentNum];
    [_favourButton setNumberText:_itemModel.atlas.praiseNum];
}

- (void)isLike:(BOOL)isLike
{
    if (isLike) {
        [_favourButton setImage:[UIImage imageNamed:@"xihuan_select"] forState:UIControlStateNormal];
    } else {
         [_favourButton setImage:[UIImage imageNamed:@"xihuan"] forState:UIControlStateNormal];
    }
}

- (void)configHeaderView
{
    [_portraitImageView setImageWithURL:[NSURL URLWithString:_itemModel.user.headUrl] placeholderImage:nil];
    _usernameLabel.text = _itemModel.user.nickname;
    _timeLabel.text = [NSDate timeStringWithInterval:[_itemModel.atlas.createDate  doubleValue] / 1000];

    [_usernameLabel sizeToFit];
    [_timeLabel sizeToFit];
}

- (void)configFooterView
{
    if (!_tagButton) {
        _tagButton = [TextActionButton createWithTitle:@"标签"];
        [_tagButton addTarget:self action:@selector(handleTagButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:_tagButton];
        _tagButton.left = 10;
    }
    if (!_commentButton) {
        _commentButton = [TextActionButton createWithTitle:@"评论"];
        [_commentButton addTarget:self action:@selector(handleCommentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _commentButton.left = _tagButton.right + 10;
        [_footerView addSubview:_commentButton];
    }
    if (!_favourButton) {
        _favourButton = [ImageActionButton createWithImage:[UIImage imageNamed:@"xihuan"]];
        [_favourButton addTarget:self action:@selector(handleFavourButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _favourButton.left = _commentButton.right + 50;
        [_footerView addSubview:_favourButton];
    }
    if (!_shareButton) {
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareButton setImage:[UIImage imageNamed:@"fenxiang"] forState:UIControlStateNormal];
        _shareButton.width = 32;
        _shareButton.height = 32;
        _shareButton.imageEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);
        _shareButton.right = self.right - 2;
        [_footerView addSubview:_shareButton];
    }
    _tagButton.top = _publichLabel.bottom;
    _commentButton.top = _tagButton.top;
    _favourButton.top = _tagButton.top;
    _shareButton.centerY = _favourButton.centerY;

    [_tagButton setNumberText:[NSString stringWithFormat:@"%d", _itemModel.labelsArray.count]];
    [_commentButton setNumberText:_itemModel.atlas.commentNum];
    [_favourButton setNumberText:_itemModel.atlas.praiseNum];
}

- (void)createOneImageView
{
    ImgsModel *im = _itemModel.atlas.imgsArray.lastObject;
    NSURL *url = [[NSURL alloc] initWithString:im.url];
    [self createTapGestureImageView:CGRectMake(0, 0, 320, 320) tag:[self createTag:0] url:url];
    _imagesView.height = 320;
}

- (void)createTwoImageView
{
    int x = 0;
    for (int i = 0; i < 2; i++) {
        int offset = 0;
        ImgsModel *im = _itemModel.atlas.imgsArray[i];
        NSURL *url = [[NSURL alloc] initWithString:im.url];
        [self createTapGestureImageView:CGRectMake((161 * x++) + offset, 0, 160, 160) tag:[self createTag:i] url:url];
    }
    _imagesView.height = 160;
}

- (void)createFourImageView
{
    int x = 0;
    int y = 0;
    for (int i = 0; i < 4; i++) {
        int offset = 0;
        if (i == 2) {
            y = 161;
            x = 0;
        }
        ImgsModel *im = _itemModel.atlas.imgsArray[i];
        NSURL *url = [[NSURL alloc] initWithString:im.url];
        [self createTapGestureImageView:CGRectMake((161 * x++) + offset, y, 160, 160) tag:[self createTag:i] url:url];
    }
    _imagesView.height = 321;
}

- (void)createRandomTileWithCount:(NSInteger)count
{
    if (count > 6) {
        return;
    }
    int x = 0;
    int y = 0;
    int initializeIndex = 0;

    int line = count > 3 ? 2 : 1;

    if (line > 1) {
        initializeIndex = 3;
    }

    for (int i = 0; i < count; i++) {
        int offset = 0;
        if (i == initializeIndex && line > 1) {
            y = 107;
            x = 0;
        }

        ImgsModel *im = _itemModel.atlas.imgsArray[i];
        NSURL *url = [[NSURL alloc] initWithString:im.url];
        [self createTapGestureImageView:CGRectMake((107 * x++) + offset, y, 106, 106) tag:[self createTag:i] url:url];
    }
    if (line == 1) {
        _imagesView.height = 106;
    } else {
        _imagesView.height = 213;
    }
}

- (void)createTapGestureImageView:(CGRect)rect tag:(NSInteger)tag url:(NSURL *)url
{
    UIImageView *iv = [[UIImageView alloc] initWithFrame:rect];
    [iv setContentMode:UIViewContentModeScaleAspectFill];
    iv.clipsToBounds = YES;

    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    __block UIImageView *imageView = iv;

    [iv setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        if (request && response && image) {
            imageView.layer.opacity = 0.f;
            [imageView.layer addAnimation:_fadeAnimation forKey:nil];
        } else {
            [self.layer removeAllAnimations];
        }
        imageView.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = iv.frame;
    [button addTarget:self action:@selector(handleImageViewButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = tag;

    [_imagesView addSubview:iv];
    [_imagesView addSubview:button];
}

- (void)handleTagButtonAction:(UIButton *)sender
{
    if (_tagBlock) {
        _tagBlock();
    }
}

- (void)handleCommentButtonAction:(UIButton *)sender
{
    if (_commentBlock) {
        _commentBlock();
    }
}

- (void)handleFavourButtonAction:(UIButton *)sender
{
    if (_favourBlock) {
        _favourBlock();
    }
}

- (void)handleUserButtonEvent
{
    if (_portraitHandleBlock) {
        _portraitHandleBlock();
    }
}

- (NSInteger)createTag:(NSInteger)tag
{
    return tag + 100;
}

- (NSInteger)fixTag:(NSInteger)tag
{
    return tag - 100;
}

- (void)handleImageViewButtonEvent:(UIButton *)button
{
    if (_imageViewClickHandlerBlock) {
        _imageViewClickHandlerBlock([self fixTag:button.tag]);
    }
}

@end
