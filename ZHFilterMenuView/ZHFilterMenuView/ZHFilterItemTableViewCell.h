//
//  ZHFilterItemTableViewCell.h
//  ZHFilterMenuView
//
//  Created by 周亚楠 on 2019/12/10.
//  Copyright © 2019 Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHFilterModel.h"

typedef NS_ENUM(NSUInteger, ZHFilterItemType) {
    ZHFilterItemTypeOnlyItem,    //可点item
    ZHFilterItemTypeItemInput,   //可点item加输入框
};

NS_ASSUME_NONNULL_BEGIN

@interface ZHFilterItemTableViewCell : UITableViewCell
@property (nonatomic, strong) ZHFilterModel *filterModel;
@property (nonatomic, assign) ZHFilterItemType itemType;
@end

NS_ASSUME_NONNULL_END
