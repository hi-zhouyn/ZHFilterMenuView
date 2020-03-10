//
//  ZHFilterMenuView.m
//  ZHFilterMenuView
//
//  Created by 周亚楠 on 2019/12/5.
//  Copyright © 2019 Zhou. All rights reserved.
//

#import "ZHFilterMenuView.h"
#import "ZHFilterItemTableViewCell.h"
#import "ZHFilterTitleTableViewCell.h"

@implementation ZHFilterBottomView

/** 快速初始化 */
- (instancetype _Nonnull )initBottomViewWithTarget:(id _Nonnull)target
                                       resetAction:(SEL _Nonnull )resetAction
                                     confirmAction:(SEL _Nonnull )confirmAction
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.resetButton.frame = CGRectMake(20, 20, CGRectGetWidth(self.frame) / 2 - 40, CGRectGetHeight(self.frame) - 40);
        [self.resetButton setTitle:@"重置" forState:UIControlStateNormal];
        [self.resetButton setTitleColor:KTitleSelectedColor forState:UIControlStateNormal];
        [self.resetButton setBackgroundColor:[UIColor whiteColor]];
        self.resetButton.layer.masksToBounds = YES;
        self.resetButton.layer.cornerRadius = 2;
        self.resetButton.layer.borderColor = KTitleSelectedColor.CGColor;
        self.resetButton.layer.borderWidth = 1;
        self.resetButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.resetButton addTarget:target action:resetAction forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.resetButton];
        
        self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.confirmButton.frame = CGRectMake(CGRectGetWidth(self.frame) / 2 + 20, 20, CGRectGetWidth(self.frame) / 2 - 40, CGRectGetHeight(self.frame) - 40);
        [self.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [self.confirmButton addTarget:target action:confirmAction forControlEvents:UIControlEventTouchUpInside];
        [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.confirmButton setBackgroundColor:KTitleSelectedColor];
        self.confirmButton.layer.masksToBounds = YES;
        self.confirmButton.layer.cornerRadius = 2;
        self.confirmButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:self.confirmButton];
    }
    return self;
}

@end


@interface ZHFilterMenuView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UITableView *mediumTableView;//后续拓展使用
@property (nonatomic, strong) UITableView *rightTableView;
@property (nonatomic, strong) UIView *backGroundView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) ZHFilterBottomView *bottomView;

@property (nonatomic, assign) NSInteger menuCount;
@property (nonatomic, assign) NSInteger selectedTabIndex;
@property (nonatomic, assign) CGFloat maxHeight;
@property (nonatomic, assign) BOOL isShow;//是否展开
@property (nonatomic, strong) ZHFilterItemManger *itemManager;
@property (nonatomic, strong) NSMutableArray *dataArr;//传入数据源
@end

@implementation ZHFilterMenuView

- (instancetype)initWithFrame:(CGRect)frame maxHeight:(CGFloat)maxHeight
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.itemManager = [[ZHFilterItemManger alloc] init];
        self.itemManager.width = self.frame.size.width;
        self.itemManager.maxLength = 7;
        
        self.selectedTabIndex = -1;
        self.titleColor = KTitleColor;
        self.titleSelectedColor = KTitleSelectedColor;
        self.lineColor = KLineColor;
        self.titleFontSize = 15;
        self.showLine = YES;
        self.titleLeft = NO;
        self.lastTitleRight = NO;
        self.listHeight = KTableViewCellHeight;
        self.bottomHeight = KBottomViewHeight;
        self.itemTitleFontSize = 12;
        self.itemBGColor = KItemBGColor;
        self.itemBGSelectedColor = KItemBGSelectedColor;
        self.space = 15;
        self.itemHeight = 30;
        self.lineNum = 4;
        self.showInWindow = NO;
        self.inWindowMinY = 0.f;
        
        self.maxHeight = maxHeight;
    }
    return self;
}

- (void)setTitleArr:(NSArray<NSString *> *)titleArr
{
    _titleArr = titleArr;
    self.menuCount = titleArr.count;
}

- (void)setTitleColor:(UIColor *)titleColor
{
    _titleColor = titleColor;
    self.itemManager.titleColor = titleColor;
}

- (void)setTitleSelectedColor:(UIColor *)titleSelectedColor
{
    _titleSelectedColor = titleSelectedColor;
    self.itemManager.titleSelectedColor = titleSelectedColor;
}

- (void)setShowLine:(BOOL)showLine
{
    _showLine = showLine;
    self.lineView.hidden = !showLine;
}

- (void)setLineColor:(UIColor *)lineColor
{
    _lineColor = lineColor;
    self.lineView.backgroundColor = lineColor;
}

- (void)setItemBGColor:(UIColor *)itemBGColor
{
    _itemBGColor = itemBGColor;
    self.itemManager.itemBGColor = itemBGColor;
}

- (void)setItemBGSelectedColor:(UIColor *)itemBGSelectedColor
{
    _itemBGSelectedColor = itemBGSelectedColor;
    self.itemManager.itemBGSelectedColor = itemBGSelectedColor;
}

- (void)setItemTitleFontSize:(CGFloat)itemTitleFontSize
{
    _itemTitleFontSize = itemTitleFontSize;
    self.itemManager.itemTitleFontSize = itemTitleFontSize;
}

- (void)setSpace:(CGFloat)space
{
    if (space <= 0) {
        space = 0.f;
    }
    _space = space;
    self.itemManager.space = space;
}

- (void)setItemHeight:(CGFloat)itemHeight
{
    if (itemHeight <= 0) {
        itemHeight = 1.f;
    }
    _itemHeight = itemHeight;
    self.itemManager.itemHeight = itemHeight;
}

- (void)setLineNum:(NSInteger)lineNum
{
    if (lineNum <= 0) {
        lineNum = 1;
    }
    _lineNum = lineNum;
    self.itemManager.lineNum = lineNum;
}

- (void)setMaxLength:(NSInteger)maxLength
{
    if (maxLength <= 0) {
        maxLength = 1;
    }
    _maxLength = maxLength;
    self.itemManager.maxLength = maxLength;
}


/** 参数传完后开始调用以显示 */
- (void)beginShowMenuView
{
    if (!self.selectImageNameArr.count) {
        self.selectImageNameArr = self.imageNameArr;
    }
    CGFloat buttonInterval = (self.frame.size.width - (_menuCount + 1) * 10) / _menuCount;
    self.buttonArr = [NSMutableArray arrayWithCapacity:_menuCount];
    for (int i = 0; i < _menuCount; i++) {
        NSString *titleString = self.titleArr[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.titleLabel.font = [UIFont systemFontOfSize:_titleFontSize];
        [button setTitleColor:self.titleColor forState:UIControlStateNormal];
        [button setTitleColor:self.titleSelectedColor forState:UIControlStateSelected];
        UIImage *image = nil;
        if (i < self.imageNameArr.count) {
            image = [UIImage imageNamed:self.imageNameArr[i]];
        }
        UIImage *selectImage = nil;
        if (i < self.selectImageNameArr.count) {
            selectImage = [UIImage imageNamed:self.selectImageNameArr[i]];
        } else {
            if (image) {
                selectImage = image;
            }
        }
        image = [self imageTintedWithImage:image color:self.titleColor fraction:0.f];
        selectImage = [self imageTintedWithImage:selectImage color:self.titleSelectedColor fraction:0.f];
        [button setImage:[image imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] forState:UIControlStateNormal];
        [button setImage:[selectImage imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] forState:UIControlStateSelected];
        [button setTitle:titleString forState:UIControlStateNormal];
        button.tintColor = [UIColor clearColor];
        button.adjustsImageWhenHighlighted = NO;
        button.backgroundColor = [UIColor whiteColor];
        [self addSubview:button];
        CGFloat buttonWidth = buttonInterval;
        CGFloat titlePositionX = i * buttonInterval + (i + 1) * 10;
        if (self.titleLeft) {
            buttonWidth = 60 + 30;
            titlePositionX = i * buttonWidth + (i + 1) * 10;
            buttonWidth = 80;
        }
        if (self.lastTitleRight && i == _menuCount - 1) {
            buttonWidth = 60;
            titlePositionX = self.frame.size.width - 60;
        }
        button.tag = i;
        [button addTarget:self action:@selector(menuTapped:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(titlePositionX, 0, buttonWidth, self.frame.size.height);
        button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self layoutButtonWithEdgeInsetsType:1 button:button imageTitleSpace:3];
        [self.buttonArr addObject:button];
    }
    [self bringSubviewToFront:self.lineView];
}

- (UIImage *)imageTintedWithImage:(UIImage *)fromImage color:(UIColor *)color fraction:(CGFloat)fraction
{
    if (color) {
        // Construct new image the same size as this one.
        UIImage *image;
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
        if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
            UIGraphicsBeginImageContextWithOptions([fromImage size], NO, 0.f); // 0.f for scale means "scale for device's main screen".
        } else {
            UIGraphicsBeginImageContext([fromImage size]);
        }
#else
        UIGraphicsBeginImageContext([fromImage size]);
#endif
        CGRect rect = CGRectZero;
        rect.size = [fromImage size];
        
        // Composite tint color at its own opacity.
        [color set];
        UIRectFill(rect);
        
        // Mask tint color-swatch to this image's opaque mask.
        // We want behaviour like NSCompositeDestinationIn on Mac OS X.
        [fromImage drawInRect:rect blendMode:kCGBlendModeDestinationIn alpha:1.0];
        
        // Finally, composite this image over the tinted mask at desired opacity.
        if (fraction > 0.0) {
            // We want behaviour like NSCompositeSourceOver on Mac OS X.
            [fromImage drawInRect:rect blendMode:kCGBlendModeSourceAtop alpha:fraction];
        }
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image;
    }
    return fromImage;
}

/**
 更改button图片文本位置
 type:1~文本在左，图片在右；2~图片在上，文本在下
 */
- (void)layoutButtonWithEdgeInsetsType:(NSInteger)type
                                 button:(UIButton *)button
                        imageTitleSpace:(CGFloat)space
{
    // 1. 得到imageView和titleLabel的宽、高
    CGFloat imageWith = button.imageView.frame.size.width;
    CGFloat labelWidth = button.titleLabel.intrinsicContentSize.width;
    CGFloat imageHeight = button.imageView.frame.size.height;
    CGFloat labelHeight = button.titleLabel.intrinsicContentSize.height;
    
    // 2. 声明全局的imageEdgeInsets和labelEdgeInsets
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
    
    // 3. 根据type和space得到imageEdgeInsets和labelEdgeInsets的值
    if (type == 1) {
        imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth+space/2.0, 0, -labelWidth-space/2.0);
        labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith-space/2.0, 0, imageWith+space/2.0);
    } else if (type == 2) {
        imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-space/2.0, 0, 0, -labelWidth);
        labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-space/2.0, 0);
    }
    
    // 4. 赋值
    button.titleEdgeInsets = labelEdgeInsets;
    button.imageEdgeInsets = imageEdgeInsets;
}


#pragma mark - 顶部菜单点击
- (void)menuTapped:(UIButton *)sender {
    if (self.zh_dataSource == nil) {
        return;
    }
    
    [self menuTappedWithIndex:sender.tag];
}

#pragma mark - 点击
- (void)menuTappedWithIndex:(NSInteger)tapIndex
{
    //点击菜单回调
    if (self.zh_delegate && [self.zh_delegate respondsToSelector:@selector(menuView:selectMenuAtTabIndex:)]) {
        [self.zh_delegate menuView:self selectMenuAtTabIndex:tapIndex];
    }
    if (self.selectedTabIndex == tapIndex) {
        [self animateMenuViewWithShow:NO];
    } else {
        self.selectedTabIndex = tapIndex;
        CGFloat time = self.showInWindow ? self.waitTime : 0.f;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self animateMenuViewWithShow:YES];
        });
    }
}

/** 点击背景恢复默认 */
- (void)backGroundViewTappedClick:(UITapGestureRecognizer *)tapGesture
{
    [self hideMenuList];
}

/** 隐藏 */
- (void)hideMenuList
{
    NSArray *selectedModelArr = [self getSelectedModelArrAndUpdateSelectArr];
    [self animateMenuViewWithShow:NO];
    if (self.zh_delegate && [self.zh_delegate respondsToSelector:@selector(menuView:didHideAtSelectedModelArr:)]) {
        [self.zh_delegate menuView:self didHideAtSelectedModelArr:selectedModelArr];
    }
}

/** 列表移除 */
- (void)removeMenuList
{
    [self.rightTableView removeFromSuperview];
    [self.backGroundView removeFromSuperview];
    [self.leftTableView removeFromSuperview];
    [self.bottomView removeFromSuperview];
}

/** 重置 */
- (void)resetAction
{
    NSArray *modelArr = [self getSelectedTabIndexFilterModelArr];
    ZHFilterModel *filterModel = [modelArr firstObject];
    for (ZHFilterModel *model in modelArr) {
        if (model.selectFirst) {
            model.selected = NO;
            if (model == filterModel) {
                model.selected = YES;
            }
            [model setModelItemSelectesNO];
            [[model.itemArr firstObject] setSelected:YES];
        } else {
            [model setModelItemSelectesNO];
        }
    }
    [self.leftTableView reloadData];
    [self.rightTableView reloadData];
    //通过归解档实现模型数组深拷贝
    self.filterDataArr = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self.dataArr]];
}

/** 确定 */
- (void)confirmAction
{
    NSArray *modelArr = [self getSelectedTabIndexFilterModelArr];
    ZHFilterMenuDownType downType = [self getDownTypeBySelectedTabIndex:self.selectedTabIndex];
    if (downType == ZHFilterMenuDownTypeItemInput) {
        ZHFilterModel *filterModel = [[ZHFilterModel alloc] init];
        for (ZHFilterModel *model in modelArr) {
            if (model.selected) {
                filterModel = model;
                break;
            }
        }
        if (filterModel.minPrice.integerValue > filterModel.maxPrice.integerValue) {
            //价格区间不正确
            if (self.zh_delegate && [self.zh_delegate respondsToSelector:@selector(menuView:wangType:)]) {
                [self.zh_delegate menuView:self wangType:ZHFilterMenuViewWangTypeInput];
            }
            return;
        }
    }
    NSArray *selectedModelArr = [self getSelectedModelArrAndUpdateSelectArr];
    //通过归解档实现模型数组深拷贝
    self.filterDataArr = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self.dataArr]];
    [self animateMenuViewWithShow:NO];
    if (self.zh_delegate && [self.zh_delegate respondsToSelector:@selector(menuView:didSelectConfirmAtSelectedModelArr:)]) {
        [self.zh_delegate menuView:self didSelectConfirmAtSelectedModelArr:selectedModelArr];
    }
}

/** 筛选视图显示&关闭 */
- (void)animateMenuViewWithShow:(BOOL)show
{
    ZHFilterMenuConfirmType confirmType = [self getConfirmTypeBySelectedTabIndex:self.selectedTabIndex];
    ZHFilterMenuDownType downType = [self getDownTypeBySelectedTabIndex:self.selectedTabIndex];
    
    CGRect menuViewFrom = self.frame;
    UIView *superView = self.superview;
    if (self.showInWindow) {
        menuViewFrom.origin = CGPointMake(menuViewFrom.origin.x, self.inWindowMinY);
        superView = KKeyWindow;
    }
    
    if (show) {
        //通过归解档实现模型数组深拷贝
        self.dataArr = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self.filterDataArr]];
        
        //将要显示回调
        if (self.zh_delegate && [self.zh_delegate respondsToSelector:@selector(menuView:willShowAtTabIndex:)]) {
            [self.zh_delegate menuView:self willShowAtTabIndex:self.selectedTabIndex];
        }
        self.backGroundView.frame = CGRectMake(0, CGRectGetMaxY(menuViewFrom), menuViewFrom.size.width, self.maxHeight);
        [self.superview bringSubviewToFront:self];
        [superView addSubview:self.backGroundView];
        if (downType == ZHFilterMenuDownTypeTwoLists) {
            self.leftTableView.frame = CGRectMake(menuViewFrom.origin.x, CGRectGetMaxY(menuViewFrom), menuViewFrom.size.width / 3, 0);
            self.rightTableView.frame = CGRectMake(menuViewFrom.size.width / 3, CGRectGetMaxY(menuViewFrom), menuViewFrom.size.width / 3 * 2, 0);
            [superView addSubview:self.leftTableView];
            [superView addSubview:self.rightTableView];
        } else {
            self.leftTableView.frame = CGRectMake(menuViewFrom.origin.x, CGRectGetMaxY(menuViewFrom), menuViewFrom.size.width, 0);
            [superView addSubview:self.leftTableView];
            [self.rightTableView removeFromSuperview];
        }
        CGFloat viewHeight = [self getListHeightWithDownType:downType confirmType:confirmType];
        CGFloat bottomHeight = 0.f;
        self.bottomView.hidden = YES;
        if (confirmType == ZHFilterMenuConfirmTypeBottomConfirm) {
            self.bottomView.hidden = NO;
            self.bottomView.frame = CGRectMake(menuViewFrom.origin.x, CGRectGetMaxY(self.leftTableView.frame), menuViewFrom.size.width, 0);
            self.bottomView.resetButton.frame = CGRectMake(20, 20, CGRectGetWidth(self.bottomView.frame) / 2 - 40, 0);
            self.bottomView.confirmButton.frame = CGRectMake(CGRectGetWidth(self.bottomView.frame) / 2 + 20, 20, CGRectGetWidth(self.bottomView.frame) / 2 - 40, 0);
            [superView addSubview:self.bottomView];
            bottomHeight = self.bottomHeight;
        }
        viewHeight = MIN(viewHeight, self.maxHeight - bottomHeight);
        
        [UIView animateWithDuration:0.3 animations:^{
            self.backGroundView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.3f];
            if (downType == ZHFilterMenuDownTypeTwoLists) {
                self.leftTableView.frame = CGRectMake(menuViewFrom.origin.x, menuViewFrom.origin.y + menuViewFrom.size.height, menuViewFrom.size.width / 3, viewHeight);
                self.rightTableView.frame = CGRectMake(menuViewFrom.size.width / 3, menuViewFrom.origin.y + menuViewFrom.size.height, menuViewFrom.size.width / 3 * 2, viewHeight);
            } else {
                self.leftTableView.frame = CGRectMake(menuViewFrom.origin.x, CGRectGetMaxY(menuViewFrom), menuViewFrom.size.width, viewHeight);
            }
            if (confirmType == ZHFilterMenuConfirmTypeBottomConfirm) {
                self.bottomView.frame = CGRectMake(menuViewFrom.origin.x, CGRectGetMaxY(self.leftTableView.frame), menuViewFrom.size.width, bottomHeight);
                self.bottomView.resetButton.frame = CGRectMake(20, 20, CGRectGetWidth(self.bottomView.frame) / 2 - 40, CGRectGetHeight(self.bottomView.frame) - 40);
                self.bottomView.confirmButton.frame = CGRectMake(CGRectGetWidth(self.bottomView.frame) / 2 + 20, 20, CGRectGetWidth(self.bottomView.frame) / 2 - 40, CGRectGetHeight(self.bottomView.frame) - 40);
            }
        }];
        [self.leftTableView reloadData];
        [self.rightTableView reloadData];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            self.backGroundView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.f];
            self.leftTableView.frame = CGRectMake(self.leftTableView.frame.origin.x, self.leftTableView.frame.origin.y, self.leftTableView.frame.size.width, 0);
            self.rightTableView.frame = CGRectMake(self.rightTableView.frame.origin.x, self.rightTableView.frame.origin.y, self.rightTableView.frame.size.width, 0);
            if (confirmType == ZHFilterMenuConfirmTypeBottomConfirm) {
                self.bottomView.hidden = YES;
                self.bottomView.frame = CGRectMake(menuViewFrom.origin.x, CGRectGetMaxY(self.leftTableView.frame), menuViewFrom.size.width, 0);
            }
        } completion:^(BOOL finished) {
            [self.rightTableView removeFromSuperview];
            [self.backGroundView removeFromSuperview];
            [self.leftTableView removeFromSuperview];
            [self.bottomView removeFromSuperview];
        }];
        self.selectedTabIndex = -1;
    }
    self.isShow = show;
    self.isOpen = show;
    //开始更新标题显示状态
    [self updateMenuTitle];
}

#pragma mark - 更新标题选择状态
- (void)updateMenuTitle
{
    for (int i = 0; i < self.titleArr.count; i++) {
        UIButton *tabButton = self.buttonArr[i];
        BOOL selected = NO;//设置初始值
        if (i == self.selectedTabIndex && self.isShow) {
            selected = YES;
        } else {
            NSArray *modelArr = self.filterDataArr[i];
            for (ZHFilterModel *filterModel in modelArr) {
                if (filterModel.selectFirst) {
                    if (filterModel.multiple) {
                        ZHFilterItemModel *firstModel = [filterModel.itemArr firstObject];
                        for (ZHFilterItemModel *itemModel in filterModel.itemArr) {
                            if ([itemModel.name isEqualToString:firstModel.name]) {
                                continue;
                            }
                            if (itemModel.selected) {
                                selected = YES;
                                break;
                            }
                        }
                    } else {
                        if (filterModel.itemArr.count) {
                            ZHFilterItemModel *itemModel = [filterModel.itemArr firstObject];
                            if (itemModel && itemModel.selected) {
                                continue;
                            }
                        }
                    }
                    if (selected) {
                        break;
                    }
                }
                for (ZHFilterItemModel *itemModel in filterModel.itemArr) {
                    if (itemModel.selected) {
                        selected = YES;
                        break;
                    }
                }
                if (selected) {
                    break;
                }
            }
        }
        
        tabButton.selected = selected;
        [self layoutButtonWithEdgeInsetsType:1 button:tabButton imageTitleSpace:3];
    }
}

#pragma mark - getData

- (NSArray *)getSelectedTabIndexFilterModelArr
{
    return self.dataArr[self.selectedTabIndex];
}

- (ZHFilterModel *)getSelectedFilterModel
{
    NSArray *modelArr = [self getSelectedTabIndexFilterModelArr];
    ZHFilterModel *filterModel = [modelArr firstObject];
    for (ZHFilterModel *model in modelArr) {
        if (model.selected) {
            filterModel = model;
            break;
        }
    }
    return filterModel;
}

/** tabIndex 下的确定类型 */
- (ZHFilterMenuConfirmType)getConfirmTypeBySelectedTabIndex:(NSInteger)tabIndex
{
    if (self.zh_dataSource && [self.zh_dataSource respondsToSelector:@selector(menuView:confirmTypeInTabIndex:)]) {
       return [self.zh_dataSource menuView:self confirmTypeInTabIndex:tabIndex];
    } else {
        return ZHFilterMenuConfirmTypeSpeedConfirm;
    }
}

/** tabIndex 下的下拉展示类型 */
- (ZHFilterMenuDownType)getDownTypeBySelectedTabIndex:(NSInteger)tabIndex
{
    if (self.zh_dataSource && [self.zh_dataSource respondsToSelector:@selector(menuView:downTypeInTabIndex:)]) {
        return [self.zh_dataSource menuView:self downTypeInTabIndex:tabIndex];
    } else {
        return ZHFilterMenuDownTypeOnlyList;
    }
}

/** tabIndex 下的列表高度 */
- (CGFloat)getListHeightWithDownType:(ZHFilterMenuDownType)downType confirmType:(ZHFilterMenuConfirmType)confirmType
{
    self.itemManager.lineNum = self.lineNum;
    CGFloat listHeight = 0.f;
    NSArray *sectionArr = self.dataArr[self.selectedTabIndex];
    if (!sectionArr.count) {
        NSLog(@"当前下拉列表数据为空!");
        return 0.f;
    }
    if (confirmType == ZHFilterMenuDownTypeTwoLists) {
        NSInteger maxCount = 0;
        for (ZHFilterModel *filterModel in sectionArr) {
            if (filterModel.itemArr.count > maxCount) {
                maxCount = filterModel.itemArr.count;
            }
        }
        return maxCount * self.listHeight;
    } else {
        NSInteger count = 0;
        if (downType == ZHFilterMenuDownTypeItemInput) {
            for (ZHFilterModel *filterModel in sectionArr) {
                if (filterModel.itemArr.count > count) {
                    count = filterModel.itemArr.count;
                }
            }
            //当内容字符数大于7时lineNum = 2
            ZHFilterModel *filterModel = [sectionArr firstObject];
            ZHFilterItemModel *itemModel = [filterModel.itemArr lastObject];
            if (itemModel.name.length > 7) {
                self.itemManager.lineNum = 2;
            }
            CGFloat itemHiight = 40.f;
            NSInteger lineCount = count / self.itemManager.lineNum + (count % self.itemManager.lineNum ? 1 : 0);
            if (count) {
                itemHiight += (self.itemManager.itemHeight + self.itemManager.space) * lineCount + self.itemManager.space;
            }
            itemHiight += 70;
            for (ZHFilterModel *filterModel in sectionArr) {
                filterModel.listHeight = itemHiight;
            }
            return itemHiight;
        } else {
            for (ZHFilterModel *filterModel in sectionArr) {
                CGFloat itemHiight = 40.f;
                NSInteger lineCount = filterModel.itemArr.count / self.itemManager.lineNum + (filterModel.itemArr.count % self.itemManager.lineNum ? 1 : 0);
                if (filterModel.itemArr.count) {
                    itemHiight += (self.itemManager.itemHeight + self.itemManager.space) * lineCount + self.itemManager.space;
                }
//                itemHiight += 20;
                filterModel.listHeight = itemHiight;
                listHeight += itemHiight;
            }
        }
    }
    return listHeight;
}

/** 获取所有选择的数据并更新选择数据 */
- (NSArray *)getSelectedModelArrAndUpdateSelectArr
{
    NSMutableArray *selectedModelArr = [NSMutableArray array];
    for (NSArray *modelArr in self.dataArr) {
        for (ZHFilterModel *filterModel in modelArr) {
            NSMutableArray *selectArr = [NSMutableArray array];
            if (filterModel.minPrice.length || filterModel.maxPrice.length) {
                ZHFilterItemModel *itemModel = [[ZHFilterItemModel alloc] init];
                itemModel.name = filterModel.title;
                itemModel.minPrice = filterModel.minPrice;
                itemModel.maxPrice = filterModel.maxPrice;
                itemModel.code = [NSString stringWithFormat:@"%ld",[modelArr indexOfObject:filterModel]];
                itemModel.selected = YES;
                [selectArr addObject:itemModel];
            } else {
                for (ZHFilterItemModel *itemModel in filterModel.itemArr) {
                    if (itemModel.selected) {
                        [selectArr addObject:itemModel];
                    }
                }
            }
            filterModel.selectArr = selectArr;
            [selectedModelArr addObjectsFromArray:selectArr];
        }
    }
    return selectedModelArr;
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ZHFilterMenuDownType downType = [self getDownTypeBySelectedTabIndex:self.selectedTabIndex];
    if (downType == ZHFilterMenuDownTypeItemInput) {
        return 1;
    } else {
        if (downType == ZHFilterMenuDownTypeTwoLists) {
            if (tableView == self.leftTableView) {
                return [[self getSelectedTabIndexFilterModelArr] count];
            } else if (tableView == self.rightTableView) {
                return [[self getSelectedFilterModel].itemArr count];
            }
        } else if (downType == ZHFilterMenuDownTypeOnlyList){
            return [[self getSelectedFilterModel].itemArr count];
        }
        return [[self getSelectedTabIndexFilterModelArr] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZHFilterMenuDownType downType = [self getDownTypeBySelectedTabIndex:self.selectedTabIndex];
    if (downType == ZHFilterMenuDownTypeTwoLists || downType == ZHFilterMenuDownTypeOnlyList) {
        ZHFilterTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZHFilterTitleTableViewCell class]) forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (tableView == self.leftTableView && downType == ZHFilterMenuDownTypeTwoLists) {
            ZHFilterModel *filterModel = [self getSelectedTabIndexFilterModelArr][indexPath.row];
            cell.titleLabel.text = filterModel.title;
            cell.titleLabel.textColor = filterModel.selected?self.titleSelectedColor:self.titleColor;
        } else if (tableView == self.rightTableView || downType == ZHFilterMenuDownTypeOnlyList) {
            ZHFilterModel *filterModel = [self getSelectedFilterModel];
            ZHFilterItemModel *itemModel = filterModel.itemArr[indexPath.row];
            cell.titleLabel.text = itemModel.name;
            cell.titleLabel.textColor = itemModel.selected?self.titleSelectedColor:self.titleColor;
        }
        if (tableView == self.rightTableView) {
            cell.backgroundColor = KItemBGColor;
        }
        return cell;
    } else {
        if (tableView == self.leftTableView) {
            ZHFilterItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZHFilterItemTableViewCell class]) forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            ZHFilterModel *filterModel = [self getSelectedTabIndexFilterModelArr][indexPath.row];
            if (downType == ZHFilterMenuDownTypeOnlyItem) {
                cell.itemType = ZHFilterItemTypeOnlyItem;
            } else if (downType == ZHFilterMenuDownTypeItemInput) {
                cell.itemType = ZHFilterItemTypeItemInput;
            }
            cell.itemManager = self.itemManager;
            cell.modelArr = [self getSelectedTabIndexFilterModelArr];
            cell.filterModel = filterModel;
            return cell;
        }
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZHFilterMenuDownType downType = [self getDownTypeBySelectedTabIndex:self.selectedTabIndex];
    if (downType == ZHFilterMenuDownTypeTwoLists || downType == ZHFilterMenuDownTypeOnlyList) {
        return self.listHeight;
    } else {
        ZHFilterModel *filterModel = [self getSelectedTabIndexFilterModelArr][indexPath.row];
        return filterModel.listHeight;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZHFilterMenuDownType downType = [self getDownTypeBySelectedTabIndex:self.selectedTabIndex];
    ZHFilterMenuConfirmType confirmType = [self getConfirmTypeBySelectedTabIndex:self.selectedTabIndex];
    if (confirmType == ZHFilterMenuConfirmTypeSpeedConfirm) {
        NSArray *modelArr = [self getSelectedTabIndexFilterModelArr];
        ZHFilterModel *filterModel = [modelArr firstObject];
        for (int i = 0; i < filterModel.itemArr.count; i ++) {
            ZHFilterItemModel *itemModel = filterModel.itemArr[i];
            itemModel.selected = i == indexPath.row;
        }
        [self.leftTableView reloadData];
        [self.rightTableView reloadData];
        [self confirmAction];
    } else if (confirmType == ZHFilterMenuConfirmTypeBottomConfirm) {
        if (downType == ZHFilterMenuDownTypeTwoLists) {
            if (tableView == self.leftTableView) {
                NSArray *modelArr = [self getSelectedTabIndexFilterModelArr];
                ZHFilterModel *selModel = modelArr[indexPath.row];
                for (ZHFilterModel *filterModel in modelArr) {
                    if ([selModel.title isEqualToString:filterModel.title]) {
                        filterModel.selected = YES;
                    }else {
                        filterModel.selected = NO;
                        /** 还原初始 首位选中 */
                        [filterModel setModelItemSelecteFirst];
                    }
                }
                [self.leftTableView reloadData];
                [self.rightTableView reloadData];
            } else if (tableView == self.rightTableView) {
                ZHFilterModel *filterModel = [self getSelectedFilterModel];
                [filterModel setModelItemSelectesNO];
                ZHFilterItemModel *itemModel = filterModel.itemArr[indexPath.row];
                itemModel.selected = YES;
                [self.rightTableView reloadData];
            }
        } else if (downType == ZHFilterMenuDownTypeOnlyList) {
            NSArray *modelArr = [self getSelectedTabIndexFilterModelArr];
            ZHFilterModel *filterModel = [modelArr firstObject];
            for (int i = 0; i < filterModel.itemArr.count; i ++) {
                ZHFilterItemModel *itemModel = filterModel.itemArr[i];
                itemModel.selected = i == indexPath.row;
            }
            [self.leftTableView reloadData];
            [self.rightTableView reloadData];
        }
    }
}



#pragma mark - lazyloading

- (UITableView *)leftTableView
{
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _leftTableView.rowHeight = KTableViewCellHeight;
        _leftTableView.dataSource = self;
        _leftTableView.delegate = self;
        _leftTableView.separatorColor = KLineColor;
        _leftTableView.separatorInset = UIEdgeInsetsZero;
        _leftTableView.tableFooterView = [[UIView alloc]init];
        _leftTableView.showsVerticalScrollIndicator = NO;
        [_leftTableView registerClass:[ZHFilterTitleTableViewCell class] forCellReuseIdentifier:NSStringFromClass([ZHFilterTitleTableViewCell class])];
        [_leftTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ZHFilterItemTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ZHFilterItemTableViewCell class])];
    }
    return _leftTableView;
}

- (UITableView *)mediumTableView
{
    if (!_mediumTableView) {
        _mediumTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mediumTableView.dataSource = self;
        _mediumTableView.delegate = self;
        _mediumTableView.separatorColor = KLineColor;
        _mediumTableView.separatorInset = UIEdgeInsetsZero;
        _mediumTableView.tableFooterView = [[UIView alloc]init];
        _mediumTableView.showsVerticalScrollIndicator = NO;
        [_mediumTableView registerClass:[ZHFilterTitleTableViewCell class] forCellReuseIdentifier:NSStringFromClass([ZHFilterTitleTableViewCell class])];
    }
    return _mediumTableView;
}

- (UITableView *)rightTableView
{
    if (!_rightTableView) {
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _rightTableView.rowHeight = KTableViewCellHeight;
        _rightTableView.dataSource = self;
        _rightTableView.delegate = self;
        _rightTableView.separatorColor = KLineColor;
        _rightTableView.backgroundColor = KItemBGColor;
        _rightTableView.separatorInset = UIEdgeInsetsZero;
        _rightTableView.tableFooterView = [[UIView alloc]init];
        _rightTableView.showsVerticalScrollIndicator = NO;
        [_rightTableView registerClass:[ZHFilterTitleTableViewCell class] forCellReuseIdentifier:NSStringFromClass([ZHFilterTitleTableViewCell class])];
    }
    return _rightTableView;
}

- (ZHFilterBottomView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[ZHFilterBottomView alloc] initBottomViewWithTarget:self resetAction:@selector(resetAction) confirmAction:@selector(confirmAction)];
    }
    return _bottomView;
}

- (UIView *)backGroundView
{
    if (!_backGroundView) {
        _backGroundView = [[UIView alloc] init];
        _backGroundView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.f];
        _backGroundView.opaque = NO;
        UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backGroundViewTappedClick:)];
        [_backGroundView addGestureRecognizer:gesture];
    }
    return _backGroundView;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.frame) - 0.5, CGRectGetWidth(self.frame), 0.5)];
        _lineView.backgroundColor = KLineColor;
        [self addSubview:_lineView];
    }
    return _lineView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
