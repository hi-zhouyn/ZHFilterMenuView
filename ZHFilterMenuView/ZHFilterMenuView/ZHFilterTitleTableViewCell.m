//
//  ZHFilterTitleTableViewCell.m
//  ZHFilterMenuView
//
//  Created by 周亚楠 on 2019/12/10.
//  Copyright © 2019 Zhou. All rights reserved.
//

#import "ZHFilterTitleTableViewCell.h"

@implementation ZHFilterTitleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self titleLabel];
}


- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.contentView.frame.size.width - 30, self.contentView.frame.size.height)];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
