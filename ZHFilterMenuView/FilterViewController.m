//
//  FilterViewController.m
//  ZHFilterMenuView
//
//  Created by 周亚楠 on 2019/12/11.
//  Copyright © 2019 Zhou. All rights reserved.
//

#import "FilterViewController.h"
#import "ZHFilterMenuView.h"
#import "ZHFilterRightView.h"
#import "FilterDataUtil.h"

@interface FilterViewController ()<ZHFilterMenuViewDelegate,ZHFilterMenuViewDetaSource>
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) ZHFilterMenuView *menuView;
@end

@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setTranslucent:NO];
    self.view.backgroundColor = [UIColor whiteColor];
    FilterDataUtil *dataUtil = [[FilterDataUtil alloc] init];
    self.menuView.dataArr = [dataUtil getTabDataByType:self.filterType];
    [self.menuView beginShowMenuView];
}

/** 确定回调 */
- (void)menuView:(ZHFilterMenuView *)menuView didSelectConfirmAtSelectedModelArr:(NSArray *)selectedModelArr
{
    
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
    return 1;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
