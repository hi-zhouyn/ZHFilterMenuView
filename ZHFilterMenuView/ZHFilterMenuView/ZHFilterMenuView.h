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

#define WS(weakSelf)    __weak __typeof(&*self)weakSelf = self
#define SS(strongSelf)  __strong __typeof(&*self)strongSelf = weakSelf

#define KKeyWindow    [UIApplication sharedApplication].keyWindow
#define SCREEN_WIDTH  ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define KTableViewCellHeight 44
#define KBottomViewHeight    80

#define kBaseSetHEXColor(rgbValue,al) ([UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(al)])

#define kSetHEXColor(rgbValue) kBaseSetHEXColor(rgbValue,1)

#define KTitleColor          kSetHEXColor(0x333333)
#define KTitleSelectedColor  kSetHEXColor(0x3072F5)
#define KLineColor           kSetHEXColor(0xe8e8e8)//分割线
#define KItemBGColor         kSetHEXColor(0xf5f5f5)
#define KItemBGSelectedColor kSetHEXColor(0xeef6ff)


@interface ZHFilterBottomView : UIView

@property (nonatomic, strong) UIButton * _Nonnull resetButton;
@property (nonatomic, strong) UIButton * _Nonnull confirmButton;
@property (nonatomic, strong) UIView * _Nonnull lineView;

/** 快速初始化 */
- (instancetype _Nonnull )initBottomViewWithTarget:(id  _Nonnull )target
                                       resetAction:(SEL _Nonnull )resetAction
                                     confirmAction:(SEL _Nonnull )confirmAction;

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

/** 警告类型（方便后续拓展） */
typedef NS_ENUM(NSUInteger, ZHFilterMenuViewWangType) {
    ZHFilterMenuViewWangTypeInput,    //输入框价格区间不正确
};

NS_ASSUME_NONNULL_BEGIN

@protocol ZHFilterMenuViewDelegate <NSObject>

/** 确定回调 */
- (void)menuView:(ZHFilterMenuView *)menuView didSelectConfirmAtSelectedModelArr:(NSArray *)selectedModelArr;

@optional

/** 警告回调(用于错误提示) */
- (void)menuView:(ZHFilterMenuView *)menuView wangType:(ZHFilterMenuViewWangType)wangType;

/** 消失回调 */
- (void)menuView:(ZHFilterMenuView *)menuView didHideAtSelectedModelArr:(NSArray *)selectedModelArr;

/** 列表将要显示回调 */
- (void)menuView:(ZHFilterMenuView *)menuView willShowAtTabIndex:(NSInteger)tabIndex;

/** 点击菜单回调 */
- (void)menuView:(ZHFilterMenuView *)menuView selectMenuAtTabIndex:(NSInteger)tabIndex;

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

@property (nonatomic, strong) NSMutableArray *filterDataArr;          //传入数据源(必传)
@property (nonatomic, strong) NSArray<NSString *> *titleArr;          //传入标题数据源(必传)
@property (nonatomic, strong) NSArray<NSString *> *imageNameArr;      //传入折叠图片数据源(不传不展示图片)
@property (nonatomic, strong) NSArray<NSString *> *selectImageNameArr;//传入选择状态下的折叠图片数据源(不传默认取imageNameArr里的图片)

@property (nonatomic, strong) UIColor *titleColor;           //菜单标题文本颜色（默认333333）
@property (nonatomic, strong) UIColor *titleSelectedColor;   //菜单标题选择状态下的颜色（默认3072F5）
@property (nonatomic, strong) UIColor *lineColor;            //菜单标题底部分割线颜色（默认e8e8e8）
@property (nonatomic, assign) CGFloat titleFontSize;         //菜单标题字号（默认15）

@property (nonatomic, assign) BOOL twoListToOneList;         //是否支持双列表与单列表转换（默认NO）
@property (nonatomic, assign) BOOL showLine;                 //菜单标题底部分割线是否显示（默认YES）
@property (nonatomic, assign) BOOL titleLeft;                //文字标题是否居左 不平分（默认NO）
@property (nonatomic, assign) BOOL lastTitleRight;           //最后一个文字标题是否固定居右（默认NO,为YES的情况下tab标题宽度固定为60）
@property (nonatomic, assign) BOOL showInWindow;             //下拉列表展示在window上，以应对列表视图展示的问题（默认NO）
@property (nonatomic, assign) CGFloat inWindowMinY;          //移动后的menuView坐标转换在window上的minY值，showInWindow为YES时有效（默认0）
@property (nonatomic, assign) CGFloat waitTime;              //下拉框展示等待时间，showInWindow为YES时有效（默认0）
@property (nonatomic, assign) CGFloat listHeight;            //选择列表的高度（默认44）
@property (nonatomic, assign) CGFloat bottomHeight;          //列表底部的高度（默认80）

@property (nonatomic, assign) CGFloat itemTitleFontSize;     //item标题字号大小（默认12）
@property (nonatomic, strong) UIColor *itemBGColor;          //item背景颜色（默认f5f5f5）
@property (nonatomic, strong) UIColor *itemBGSelectedColor;  //item选择时背景颜色（默认eef6ff）
@property (nonatomic, assign) CGFloat space;                 //item间隔（默认15）
@property (nonatomic, assign) CGFloat itemHeight;            //item高（默认30）
@property (nonatomic, assign) NSInteger lineNum;             //一行展示数量（默认4，当内容字符数大于7时lineNum = 2）
@property (nonatomic, assign) NSInteger maxLength;           //输入框最大文本数量（默认7位）

@property (nonatomic, strong) NSMutableArray *buttonArr;     //菜单tab标题button数据(可供外部特殊需求时使用)
@property (nonatomic, assign) BOOL isOpen;                   //展开状态(供外部取值使用)

/** 快速初始化
 *  maxHeight:下拉列表最大展示高度
 */
- (instancetype)initWithFrame:(CGRect)frame maxHeight:(CGFloat)maxHeight;

/** 参数传完后开始调用以显示 */
- (void)beginShowMenuView;

/** 外部快捷调用展开菜单列表 */
- (void)menuTappedWithIndex:(NSInteger)tapIndex;

/** 筛选菜单列表关闭消失 */
- (void)hideMenuList;

/**
 列表移除
 仅在showInWindow=YES时需要在viewWillDisappear中手动调用移除
 */
- (void)removeMenuList;

@end

NS_ASSUME_NONNULL_END
