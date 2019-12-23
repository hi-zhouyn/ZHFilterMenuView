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

@interface ZHFilterItemManger : NSObject
@property (nonatomic, strong) UIColor * _Nullable titleColor;
@property (nonatomic, strong) UIColor * _Nullable titleSelectedColor;
@property (nonatomic, strong) UIColor * _Nullable itemBGColor;
@property (nonatomic, strong) UIColor * _Nullable itemBGSelectedColor;
@property (nonatomic, assign) CGFloat itemTitleFontSize;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat space;//item间隔（默认15）
@property (nonatomic, assign) CGFloat itemHeight;//item高（默认30）
@property (nonatomic, assign) NSInteger lineNum;//一行展示数量（默认4，当内容字符数大于7时lineNum = 2）
@property (nonatomic, assign) NSInteger maxLength;//输入框最大文本数量（默认7）
@end

NS_ASSUME_NONNULL_BEGIN

@interface ZHFilterItemTableViewCell : UITableViewCell
@property (nonatomic, assign) ZHFilterItemType itemType;
@property (nonatomic, strong) ZHFilterItemManger *itemManager;
@property (nonatomic, strong) NSArray *modelArr;
@property (nonatomic, strong) ZHFilterModel *filterModel;

@end

NS_ASSUME_NONNULL_END
