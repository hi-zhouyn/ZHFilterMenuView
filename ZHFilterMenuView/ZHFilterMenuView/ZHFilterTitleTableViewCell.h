//
//  ZHFilterTitleTableViewCell.h
//  ZHFilterMenuView
//
//  Created by 周亚楠 on 2019/12/10.
//  Copyright © 2019 Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHFilterModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZHFilterTitleTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) ZHFilterModel *filterModel;
@property (nonatomic, strong) ZHFilterItemModel *itemModel;
@end

NS_ASSUME_NONNULL_END
