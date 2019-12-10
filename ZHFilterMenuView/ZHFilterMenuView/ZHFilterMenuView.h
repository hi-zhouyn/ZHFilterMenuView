//
//  ZHFilterMenuView.m
//  ZHFilterMenuView
//
//  Created by 周亚楠 on 2019/12/5.
//  Copyright © 2019 Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ZHFilterMenuView;

@interface ZHIndexPath : NSObject

@property (nonatomic, assign) NSInteger tabIndex;
@property (nonatomic, assign) NSInteger sectionIndex;
@property (nonatomic, assign) NSInteger rowIndex;

@end


@interface ZHFilterBottomView : UIView

@property (nonatomic, strong) UIButton * _Nonnull resetButton;
@property (nonatomic, strong) UIButton * _Nonnull confirmButton;
@property (nonatomic, strong) UIView * _Nonnull lineView;

- (instancetype _Nonnull )init;

@end



/** 确定类型 */
typedef NS_ENUM(NSUInteger, ZHFilterMenuConfirmType) {
    ZHFilterMenuConfirmTypeSpeedConfirm,    //快速点击列表选择
    ZHFilterMenuConfirmTypeBottomConfirm,   //底部确定按钮选择
};

/** 下拉展示类型 */
typedef NS_ENUM(NSUInteger, ZHFilterMenuDownType) {
    ZHFilterMenuDownTypeTwoLists,    //双列表
    ZHFilterMenuDownTypeOnlyItem,    //可点item
    ZHFilterMenuDownTypeOnlyList,    //单列表
    ZHFilterMenuDownTypeItemInput,   //可点item加输入框
};

NS_ASSUME_NONNULL_BEGIN

@protocol ZHFilterMenuViewDelegate <NSObject>



@end


@protocol ZHFilterMenuViewDetaSource <NSObject>

/** 返回每个 tabIndex 下的确定类型 */
- (ZHFilterMenuConfirmType)menuView:(ZHFilterMenuView *)menuView confirmTypeInTabIndex:(NSInteger)tabIndex;

/** 返回每个 tabIndex 下的下拉展示类型 */
- (ZHFilterMenuDownType)menuView:(ZHFilterMenuView *)menuView downTypeInTabIndex:(NSInteger)tabIndex;



@end

@interface ZHFilterMenuView : UIView

@property (nonatomic, weak) id<ZHFilterMenuViewDelegate> zh_delegate;
@property (nonatomic, weak) id<ZHFilterMenuViewDetaSource> zh_dataSource;

@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *titleSelectedColor;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) BOOL showLine;





@end

NS_ASSUME_NONNULL_END
