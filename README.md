# ZHFilterMenuView
一款类似贝壳找房的通用筛选控件，支持单列表、双列表、滑动列表、切换列表、列表输入等多种展示样式，可通过传入参数进行控制！为方便演示，demo中提供新房、二手房、租房的完整筛选功能实现！当然此控件不局限用于房屋筛选，也可用于其他类型的筛选，如果有其它项目或功能需求筛选，修改展示数据源即可！
## 预览
![ZHFilterMenuView](/Image/filter.gif)

![ZHFilterMenuView](/Image/IMG_4274.PNG)
![ZHFilterMenuView](/Image/IMG_4276.PNG)
## 简书文章
更多了解可以查看[详细文章](https://www.jianshu.com/p/0f0638eef65f)
## 调用示例
```
FilterDataUtil *dataUtil = [[FilterDataUtil alloc] init];
self.menuView.filterDataArr = [dataUtil getTabDataByType:self.filterType];
//开始显示
[self.menuView beginShowMenuView];
```
```
/** 确定回调 */
- (void)menuView:(ZHFilterMenuView *)menuView didSelectConfirmAtSelectedModelArr:(NSArray *)selectedModelArr
{
    NSArray *dictArr = [ZHFilterItemModel mj_keyValuesArrayWithObjectArray:selectedModelArr];
    NSLog(@"结果回调：%@",dictArr.mj_JSONString);
}

/** 警告回调(用于错误提示) */
- (void)menuView:(ZHFilterMenuView *)menuView wangType:(ZHFilterMenuViewWangType)wangType
{
    if (wangType == ZHFilterMenuViewWangTypeInput) {
        NSLog(@"请输入正确的价格区间！");
    }
}

/** 返回每个 tabIndex 下的确定类型 */
- (ZHFilterMenuConfirmType)menuView:(ZHFilterMenuView *)menuView confirmTypeInTabIndex:(NSInteger)tabIndex
{
    if (tabIndex == 4) {
        return ZHFilterMenuConfirmTypeSpeedConfirm;
    }
    return ZHFilterMenuConfirmTypeBottomConfirm;
}

/** 返回每个 tabIndex 下的下拉展示类型 */
- (ZHFilterMenuDownType)menuView:(ZHFilterMenuView *)menuView downTypeInTabIndex:(NSInteger)tabIndex
{
    if (tabIndex == 0) {
        return ZHFilterMenuDownTypeTwoLists;
    } else if (tabIndex == 1) {
        if (self.filterType == FilterTypeISRent) {
            return ZHFilterMenuDownTypeOnlyItem;
        } else {
            return ZHFilterMenuDownTypeItemInput;
        }
    } else if (tabIndex == 2) {
        if (self.filterType == FilterTypeISRent) {
            return ZHFilterMenuDownTypeItemInput;
        } else {
            return ZHFilterMenuDownTypeOnlyItem;
        }
    } else if (tabIndex == 3) {
        return ZHFilterMenuDownTypeOnlyItem;
    } else if (tabIndex == 4) {
        return ZHFilterMenuDownTypeOnlyList;
    }
    return ZHFilterMenuDownTypeOnlyList;
}


- (ZHFilterMenuView *)menuView
{
    if (!_menuView) {
        _menuView = [[ZHFilterMenuView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 45) maxHeight:CGRectGetHeight(self.view.frame) - 45];
        _menuView.zh_delegate = self;
        _menuView.zh_dataSource = self;
        if (self.filterType == FilterTypeIsNewHouse) {
            _menuView.titleArr = @[@"区域",@"价格",@"户型",@"更多",@"排序"];
            _menuView.imageNameArr = @[@"x_arrow",@"x_arrow",@"x_arrow",@"x_arrow",@"x_arrow"];
        } else if (self.filterType == FilterTypeSecondHandHouse) {
            _menuView.titleArr = @[@"区域",@"价格",@"房型",@"更多",@"排序"];
            _menuView.imageNameArr = @[@"x_arrow",@"x_arrow",@"x_arrow",@"x_arrow",@"x_arrow"];
        } else if (self.filterType == FilterTypeISRent) {
            _menuView.titleArr = @[@"位置",@"方式",@"租金",@"更多",@""];
            _menuView.imageNameArr = @[@"x_arrow",@"x_arrow",@"x_arrow",@"x_arrow",@"x_px"];
        }
        [self.view addSubview:_menuView];
    }
    return _menuView;
}
```
## 方法定义
```
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

@property (nonatomic, assign) BOOL showLine;                 //菜单标题底部分割线是否显示（默认YES）
@property (nonatomic, assign) BOOL titleLeft;                //文字标题是否居左 不平分（默认NO）
@property (nonatomic, assign) BOOL lastTitleRight;           //最后一个文字标题是否固定居右（默认NO,为YES的情况下tab标题宽度固定为60）
@property (nonatomic, assign) CGFloat listHeight;            //选择列表的高度（默认44）
@property (nonatomic, assign) CGFloat bottomHeight;          //列表底部的高度（默认80）

@property (nonatomic, assign) CGFloat itemTitleFontSize;     //item标题字号大小（默认12）
@property (nonatomic, strong) UIColor *itemBGColor;          //item背景颜色（默认f5f5f5）
@property (nonatomic, strong) UIColor *itemBGSelectedColor;  //item选择时背景颜色（默认eef6ff）
@property (nonatomic, assign) CGFloat space;                 //item间隔（默认15）
@property (nonatomic, assign) CGFloat itemHeight;            //item高（默认30）
@property (nonatomic, assign) NSInteger lineNum;             //一行展示数量（默认4，当内容字符数大于7时lineNum = 2）
@property (nonatomic, assign) NSInteger maxLength;           //输入框最大文本数量（默认7位）

@property (nonatomic, strong) NSMutableArray *buttonArr;//菜单tab标题button数据


/** 快速初始化
 *  maxHeight:下拉列表最大展示高度
 */
- (instancetype)initWithFrame:(CGRect)frame maxHeight:(CGFloat)maxHeight;

/** 参数传完后开始调用以显示 */
- (void)beginShowMenuView;

/** 外部快捷调用展开菜单列表 */
- (void)menuTappedWithIndex:(NSInteger)tapIndex;

/** 菜单列表消失 */
- (void)hideMenuList;
```
## 意见建议
如果感觉此项目对你有帮助，欢迎Star！如果使用过程中遇到问题或者有更好的建议,欢迎在Issues提出！
## 更新记录
* 2019-12-25 修复双列表点重置出错的问题，增加预览GIF图，完善菜单图片展示判断
