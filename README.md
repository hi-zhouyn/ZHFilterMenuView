# ZHFilterMenuView
一款类似贝壳找房的通用筛选控件，当然此控件不局限用于房屋筛选，也可用于其他类型的筛选，如果有其它项目或功能需求筛选，修改展示数据源即可！
* 提供新房、二手房、租房的完整筛选功能实现
* 支持固定和列表sectionHead悬停下拉筛选两种模式
* 支持单列表、双列表、滑动列表、切换列表、列表输入等多种下拉筛选样式
* 展示样式支持自定义调节
* 展示数据支持自定义设置
* 双列表模式支持快速选择
* 新增支持单双列表切换筛选
## 预览
#### 顶部固定模式
![ZHFilterMenuView](/Image/filter.gif)

![ZHFilterMenuView](/Image/IMG_4274.PNG)
![ZHFilterMenuView](/Image/IMG_4276.PNG)
#### 列表悬停下拉筛选模式（新增）
![ZHFilterMenuView](/Image/filter2.gif)
#### 单双列表切换筛选模式（新增）
![ZHFilterMenuView](/Image/filter3.gif)

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
## 意见建议
如果感觉此项目对你有帮助，欢迎Star！如果使用过程中遇到问题或者有更好的建议,欢迎在Issues提出！
## 更新记录
* 2020-4-26  新增支持单双列表切换筛选
* 2020-3-12  双列表模式新增支持快速选择
* 2020-3-10  修复悬停筛选展开后页面退出列表未消失的问题
* 2020-2-20  新增列表悬停下拉筛选解决方案
* 2019-12-25 修复双列表点重置出错的问题，增加预览GIF图，完善菜单图片展示判断
