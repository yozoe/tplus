//
//  CommentCell.m
//  MyShow
//
//  Created by wang dong on 8/10/14.
//  Copyright (c) 2014 maxingchuan. All rights reserved.
//

#import "CommentCell.h"
#import "UIImageView+AFNetworking.h"

@interface CommentCell()
{
    UIImageView *_portraitImageView;
    UILabel *_nameLabel;
    UILabel *_txtLabel;
    UILabel *_dateLabel;
    UIView *_lineView;
}

@end

@implementation CommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)initView
{
    _portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 6, 24, 24)];

    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont systemFontOfSize:12.f];

    _nameLabel.left = _portraitImageView.right + 6;
    _nameLabel.top = 5;

    _txtLabel = [[UILabel alloc] init];
    _txtLabel.width = 268;
    _txtLabel.left = _portraitImageView.right + 6;
    _txtLabel.font = [UIFont systemFontOfSize:12.f];
    _txtLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _txtLabel.numberOfLines = 0;
    _txtLabel.top = 20;

    _dateLabel = [[UILabel alloc] init];
    _dateLabel.font = [UIFont systemFontOfSize:12.f];
    _dateLabel.text = @"0000-00-00";
    [_dateLabel sizeToFit];
    _dateLabel.right = self.right - 5;
    _dateLabel.top = 5;

    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    _lineView.backgroundColor = RGBCOLOR(243, 243, 243);

    [self.contentView addSubview:_nameLabel];
    [self.contentView addSubview:_portraitImageView];
    [self.contentView addSubview:_txtLabel];
    [self.contentView addSubview:_dateLabel];
    [self addSubview:_lineView];
}

- (void)configModel:(CommentModel *)model
{
    [_portraitImageView setImageWithURL:[NSURL URLWithString:model.headUrl]];
    _nameLabel.text = model.nickname;
    [_nameLabel sizeToFit];

    _txtLabel.text = model.content;
    CGSize size = [model.content sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(268, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    _txtLabel.height = size.height;
    self.contentView.height = _txtLabel.bottom;
    _lineView.bottom = self.contentView.bottom + 5;

    NSTimeInterval time = [model.createDate doubleValue] / 1000;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];

    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:time];;
    _dateLabel.text = [formatter stringFromDate:date];
}

@end
