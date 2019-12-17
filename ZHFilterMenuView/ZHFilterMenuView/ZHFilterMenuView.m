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

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self
#define SS(strongSelf)  __strong __typeof(&*self)strongSelf = weakSelf

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define KTableViewCellHeight 44
#define KBottomViewHeight    90

#define kBaseSetHEXColor(rgbValue,al) ([UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(al)])

#define kSetHEXColor(rgbValue) kBaseSetHEXColor(rgbValue,1)

#define KTitleColor          kSetHEXColor(0x333333)
#define KTitleSelectedColor  kSetHEXColor(0x4998E8)
#define KLineColor           kSetHEXColor(0xe8e8e8)//分割线
#define KItemBGColor         kSetHEXColor(0xf5f5f5)
#define KItemBGSelectedColor kSetHEXColor(0xeef6ff)

@implementation ZHIndexPath


@end

@implementation ZHFilterBottomView

/** 快速初始化 */
- (instancetype _Nonnull )initBottomViewWithResetAction:(SEL _Nonnull )resetAction confirmAction:(SEL _Nonnull )confirmAction
{
    if (self = [super init]) {
        self.resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.resetButton.frame = CGRectMake(20, 20, CGRectGetWidth(self.frame) / 2 - 60, CGRectGetHeight(self.frame) - 40);
        [self.resetButton setTitle:@"重置" forState:UIControlStateNormal];
        [self.resetButton setTitleColor:KTitleSelectedColor forState:UIControlStateNormal];
        [self.resetButton setBackgroundColor:[UIColor whiteColor]];
        self.resetButton.layer.masksToBounds = YES;
        self.resetButton.layer.cornerRadius = 2;
        self.resetButton.layer.borderColor = KTitleSelectedColor.CGColor;
        self.resetButton.layer.borderWidth = 1;
        self.resetButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.resetButton addTarget:self action:resetAction forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.resetButton];
        
        self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.resetButton.frame = CGRectMake(CGRectGetWidth(self.frame) / 2 + 10, 20, CGRectGetWidth(self.frame) / 2 - 60, CGRectGetHeight(self.frame) - 40);
        [self.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [self.confirmButton addTarget:self action:resetAction forControlEvents:UIControlEventTouchUpInside];
        [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.confirmButton setBackgroundColor:KTitleSelectedColor];
        self.confirmButton.layer.masksToBounds = YES;
        self.confirmButton.layer.cornerRadius = 2;
        self.confirmButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:self.confirmButton];
    }
    return self;
}


- (UIButton *)resetButton
{
    if (!_resetButton) {
        
        [self addSubview:_resetButton];
    }
    return _resetButton;
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

@end

@implementation ZHFilterMenuView

- (instancetype)initWithFrame:(CGRect)frame maxHeight:(CGFloat)maxHeight
{
    if (self = [super initWithFrame:frame]) {
        self.titleColor = KTitleColor;
        self.titleSelectedColor = KTitleSelectedColor;
        self.lineColor = KLineColor;
        self.showLine = YES;
        self.titleLeft = NO;
        self.listHeight = KTableViewCellHeight;
        self.bottomHeight = KBottomViewHeight;
        
        self.itemManager = [[ZHFilterItemManger alloc] init];
        self.itemManager.titleColor = KTitleColor;
        self.itemManager.titleSelectedColor = KTitleSelectedColor;
        self.itemManager.itemBGColor = KItemBGColor;
        self.itemManager.itemBGSelectedColor = KItemBGSelectedColor;
        self.itemManager.itemTitleFontSize = 13;
        self.itemManager.width = self.frame.size.width;
        self.itemManager.space = 15;
        self.itemManager.itemHeight = 28;
        self.itemManager.lineNum = 4;
        self.itemManager.maxLength = 7;
    }
    return self;
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
    CGFloat buttonInterval = (self.frame.size.width - 60 - (_menuCount - 1) * 10) / (_menuCount - 1);
    self.buttonArr = [NSMutableArray arrayWithCapacity:_menuCount];
    for (int i = 0; i < _menuCount; i++) {
        NSString *titleString = self.titleArr[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont systemFontOfSize:_titleFontSize];
        [button setTitleColor:self.titleColor forState:UIControlStateNormal];
        [button setTitleColor:self.titleSelectedColor forState:UIControlStateSelected];
        UIImage *image = [UIImage imageNamed:self.imageNameArr[i]];
        UIImage *selectImage = [UIImage imageNamed:self.selectImageNameArr[i]];
//        image = [image imageTintedWithColor:self.textColor];
//        selectImage = [image imageTintedWithColor:self.textSelectedColor];
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
        if (i == _menuCount - 1 && ![self.titleArr lastObject].length) {
            buttonWidth = 60;
            titlePositionX = self.frame.size.width - 60;
        }
        button.tag = i;
        [button addTarget:self action:@selector(menuTapped:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(titlePositionX, 0, buttonWidth, self.frame.size.height);
        button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
//        [button layoutButtonWithEdgeInsetsStyle:(MKButtonEdgeInsetsStyleRight) imageTitleSpace:3];
        [self.buttonArr addObject:button];
    }
    
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
    if (self.selectedTabIndex == tapIndex) {
        [self animateMenuViewWithShow:NO];
    } else {
        self.selectedTabIndex = tapIndex;
        [self animateMenuViewWithShow:YES];
    }
}

/** 点击背景恢复默认 */
- (void)backGroundViewTappedClick:(UITapGestureRecognizer *)tapGesture
{
    [self hideMenuList];
}

- (void)hideMenuList
{
    
    [self animateMenuViewWithShow:NO];
}

/** 重置 */
- (void)resetAction
{
    NSArray *modelArr = [self getSelectedTabIndexFilterModelArr];
    ZHFilterModel *filterModel = [modelArr firstObject];
    for (ZHFilterModel *model in modelArr) {
        if (model.selectFirst) {
            [model setModelItemSelectesNO];
            if (model == filterModel) {
                model.selected = YES;
            }
        } else {
            [model setModelItemSelectesNO];
        }
    }
    [self.leftTableView reloadData];
    [self.rightTableView reloadData];
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
            NSLog(@"请输入正确的价格区间！");
            return;
        }
    }
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
    
    
    [self animateMenuViewWithShow:NO];
}


- (void)animateMenuViewWithShow:(BOOL)show
{
    ZHFilterMenuConfirmType confirmType = [self getConfirmTypeBySelectedTabIndex:self.selectedTabIndex];
    ZHFilterMenuDownType downType = [self getDownTypeBySelectedTabIndex:self.selectedTabIndex];
    if (show) {
        [self.superview addSubview:self.backGroundView];
        if (downType == ZHFilterMenuDownTypeTwoLists) {
            self.leftTableView.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width / 3, 0);
            self.rightTableView.frame = CGRectMake(self.frame.size.width / 3, self.frame.origin.y + self.frame.size.height, self.frame.size.width / 3 * 2, 0);
            [self.superview addSubview:self.leftTableView];
            [self.superview addSubview:self.rightTableView];
        } else {
            self.leftTableView.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, 0);
            [self.superview addSubview:self.leftTableView];
        }
        CGFloat viewHeight = [self getListHeightWithDownType:downType];
        CGFloat bottomHeight = 0.f;
        self.bottomView.hidden = YES;
        if (confirmType == ZHFilterMenuConfirmTypeBottomConfirm) {
            self.bottomView.hidden = NO;
            self.bottomView.frame = CGRectMake(self.frame.origin.x, CGRectGetMaxY(self.leftTableView.frame), self.frame.size.width, 0);
            [self.superview addSubview:self.bottomView];
            bottomHeight = self.bottomHeight;
        }
        viewHeight = MIN(viewHeight, self.maxHeight - self.frame.size.height - bottomHeight);
        
        [UIView animateWithDuration:0.3 animations:^{
            self.backGroundView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.3f];
            if (downType == ZHFilterMenuDownTypeTwoLists) {
                self.leftTableView.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width / 3, viewHeight);
                self.rightTableView.frame = CGRectMake(self.frame.size.width / 3, self.frame.origin.y + self.frame.size.height, self.frame.size.width / 3 * 2, viewHeight);
            } else {
                self.leftTableView.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, viewHeight);
            }
            if (confirmType == ZHFilterMenuConfirmTypeBottomConfirm) {
                self.bottomView.frame = CGRectMake(self.frame.origin.x, CGRectGetMaxY(self.leftTableView.frame), self.frame.size.width, bottomHeight);
            }
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            self.backGroundView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.f];
            if (downType == ZHFilterMenuDownTypeTwoLists) {
                self.leftTableView.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width / 3, 0);
                self.rightTableView.frame = CGRectMake(self.frame.size.width / 3, self.frame.origin.y + self.frame.size.height, self.frame.size.width / 3 * 2, 0);
            } else {
                self.leftTableView.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, 0);
            }
            if (confirmType == ZHFilterMenuConfirmTypeBottomConfirm) {
                self.bottomView.hidden = YES;
                self.bottomView.frame = CGRectMake(self.frame.origin.x, CGRectGetMaxY(self.leftTableView.frame), self.frame.size.width, 0);
            }
        } completion:^(BOOL finished) {
            if (downType == ZHFilterMenuDownTypeTwoLists) {
                [self.rightTableView removeFromSuperview];
            }
            [self.backGroundView removeFromSuperview];
            [self.leftTableView removeFromSuperview];
            [self.bottomView removeFromSuperview];
        }];
    }
    self.isShow = !show;
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
- (CGFloat)getListHeightWithDownType:(ZHFilterMenuDownType)downType
{
    CGFloat listHeight = 0.f;
    NSArray *sectionArr = self.dataArr[self.selectedTabIndex];
    if (!sectionArr.count) {
        NSLog(@"当前下拉列表数据为空!");
        return 0.f;
    }
    if (downType == ZHFilterMenuDownTypeTwoLists) {
        NSInteger maxCount = 0;
        for (ZHFilterModel *filterModel in sectionArr) {
            if (filterModel.itemArr.count > maxCount) {
                maxCount = filterModel.itemArr.count;
            }
        }
        return maxCount * self.listHeight;
    } else {
        for (ZHFilterModel *filterModel in sectionArr) {
            listHeight += filterModel.listHeight;
        }
    }
    return listHeight;
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
        return [[self getSelectedTabIndexFilterModelArr] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZHFilterMenuDownType downType = [self getDownTypeBySelectedTabIndex:self.selectedTabIndex];
    if (downType == ZHFilterMenuDownTypeTwoLists || downType == ZHFilterMenuDownTypeOnlyList) {
        ZHFilterTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZHFilterTitleTableViewCell class]) forIndexPath:indexPath];
        if (tableView == self.leftTableView) {
            ZHFilterModel *filterModel = [self getSelectedTabIndexFilterModelArr][indexPath.section][indexPath.row];
            cell.titleLabel.text = filterModel.title;
            cell.titleLabel.textColor = filterModel.selected?self.titleSelectedColor:self.titleColor;
        } else if (tableView == self.rightTableView) {
            ZHFilterModel *filterModel = [self getSelectedFilterModel];
            ZHFilterItemModel *itemModel = filterModel.itemArr[indexPath.row];
            cell.titleLabel.text = itemModel.name;
            cell.titleLabel.textColor = itemModel.selected?self.titleSelectedColor:self.titleColor;
        }
        
        return cell;
    } else {
        ZHFilterItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZHFilterItemTableViewCell class]) forIndexPath:indexPath];
        ZHFilterModel *filterModel = [self getSelectedTabIndexFilterModelArr][indexPath.section][indexPath.row];
        if (downType == ZHFilterMenuDownTypeOnlyItem) {
            cell.itemType = ZHFilterItemTypeOnlyItem;
        } else if (downType == ZHFilterMenuDownTypeItemInput) {
            cell.itemType = ZHFilterItemTypeItemInput;
        }
        cell.itemManager = self.itemManager;
        cell.filterModel = filterModel;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZHFilterMenuDownType downType = [self getDownTypeBySelectedTabIndex:self.selectedTabIndex];
    if (downType == ZHFilterMenuDownTypeTwoLists || downType == ZHFilterMenuDownTypeOnlyList) {
        return self.listHeight;
    } else {
        ZHFilterModel *filterModel = [self getSelectedTabIndexFilterModelArr][indexPath.section][indexPath.row];
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
    } else if (confirmType == ZHFilterMenuConfirmTypeBottomConfirm) {
        if (downType == ZHFilterMenuDownTypeTwoLists) {
            if (tableView == self.leftTableView) {
                NSArray *modelArr = [self getSelectedTabIndexFilterModelArr];
                for (ZHFilterModel *filterModel in modelArr) {
                    filterModel.selected = NO;
                }
                ZHFilterModel *tempModel = modelArr[indexPath.row];
                tempModel.selected = YES;
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
        _bottomView = [[ZHFilterBottomView alloc] initBottomViewWithResetAction:@selector(resetAction) confirmAction:@selector(confirmAction)];
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
