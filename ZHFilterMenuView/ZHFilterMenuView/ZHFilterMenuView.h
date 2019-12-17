//
//  ZHFilterMenuView.m
//  ZHFilterMenuView
//
//  Created by 周亚楠 on 2019/12/5.
//  Copyright © 2019 Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHFilterModel.h"

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

/** 快速初始化 */
- (instancetype _Nonnull )initBottomViewWithResetAction:(SEL _Nonnull )resetAction confirmAction:(SEL _Nonnull )confirmAction;

@end



/** 确定类型 */
typedef NS_ENUM(NSUInteger, ZHFilterMenuConfirmType) {
    ZHFilterMenuConfirmTypeSpeedConfirm,    //列表快速点击选择
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

/** 点击确定回调 */
- (void)menuView:(ZHFilterMenuView *)menuView didSelectConfirm:(NSArray *)selectedModelArr;

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
@property (nonatomic, assign) CGFloat titleFontSize;

@property (nonatomic, assign) BOOL showLine;
@property (nonatomic, assign) CGFloat listHeight;  //选择列表的高度（默认44）
@property (nonatomic, assign) CGFloat bottomHeight;//列表底部的高度（默认90）

@property (nonatomic, assign) CGFloat itemTitleFontSize;
@property (nonatomic, strong) UIColor *itemBGColor;//item背景颜色（默认f5f5f5）
@property (nonatomic, strong) UIColor *itemBGSelectedColor;//item选择时背景颜色（默认eef6ff）
@property (nonatomic, assign) CGFloat space;//item间隔（默认15）
@property (nonatomic, assign) CGFloat itemHeight;//item高（默认28）
@property (nonatomic, assign) NSInteger lineNum;//一行展示数量（默认4）
@property (nonatomic, assign) NSInteger maxLength;//输入框最大文本数量（默认7位）

@property (nonatomic, strong) NSMutableArray *dataArr;//传入数据源
@property (nonatomic, strong) NSArray<NSString *> *titleArr;
@property (nonatomic, strong) NSArray<NSString *> *imageNameArr;
@property (nonatomic, strong) NSArray<NSString *> *selectImageNameArr;
@property (nonatomic, assign) BOOL titleLeft; // 文字标题是否居左 不平分 default NO
@property (nonatomic, strong) NSMutableArray *buttonArr;


/** 快速初始化 */
- (instancetype)initWithFrame:(CGRect)frame maxHeight:(CGFloat)maxHeight;

/** 参数传完后开始调用以显示 */
- (void)beginShowMenuView;

/** 外部快捷调用展开菜单列表 */
- (void)menuTappedWithIndex:(NSInteger)tapIndex;

/** 菜单列表消失 */
- (void)hideMenuList;

@end

NS_ASSUME_NONNULL_END
