//
//  ZHFilterItemTableViewCell.m
//  ZHFilterMenuView
//
//  Created by 周亚楠 on 2019/12/10.
//  Copyright © 2019 Zhou. All rights reserved.
//

#import "ZHFilterItemTableViewCell.h"

@interface ZHFilterItemTableViewCell ()
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *leftButton;
@property (strong, nonatomic) IBOutlet UIButton *rightButton;
@property (strong, nonatomic) IBOutlet UIView *itemView;
@property (strong, nonatomic) IBOutlet UITextField *minTextField;
@property (strong, nonatomic) IBOutlet UITextField *maxTextField;
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomViewBottom;

@end

@implementation ZHFilterItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
