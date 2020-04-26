//
//  ChangeViewController.m
//  ZHFilterMenuView
//
//  Created by 周亚楠 on 2020/4/24.
//  Copyright © 2020 Zhou. All rights reserved.
//

#import "ChangeViewController.h"
#import "ZHFilterMenuView.h"
#import "FilterDataUtil.h"
#import "HouseTableViewCell.h"

@interface ChangeViewController ()<ZHFilterMenuViewDelegate,ZHFilterMenuViewDetaSource>
@property (nonatomic, strong) ZHFilterMenuView *menuView;
@end

@implementation ChangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];

    //便于演示房源展示数据源暂时是写在本地，可根据自身情况，如果需从接口请求可自行做下调整
    FilterDataUtil *dataUtil = [[FilterDataUtil alloc] init];
    self.menuView.filterDataArr = [dataUtil getTabDataByType:FilterTypeISQuery];
    //开始显示
    [self.menuView beginShowMenuView];
}


/** 确定回调 */
- (void)menuView:(ZHFilterMenuView *)menuView didSelectConfirmAtSelectedModelArr:(NSArray *)selectedModelArr
{
    NSArray *dictArr = [ZHFilterItemModel mj_keyValuesArrayWithObjectArray:selectedModelArr];
    NSLog(@"结果回调：%@",dictArr.mj_JSONString);
}


/** 返回每个 tabIndex 下的确定类型 */
- (ZHFilterMenuConfirmType)menuView:(ZHFilterMenuView *)menuView confirmTypeInTabIndex:(NSInteger)tabIndex
{
    if (tabIndex == 2) {
        return ZHFilterMenuConfirmTypeSpeedConfirm;
    }
    return ZHFilterMenuConfirmTypeBottomConfirm;
}

/** 返回每个 tabIndex 下的下拉展示类型 */
- (ZHFilterMenuDownType)menuView:(ZHFilterMenuView *)menuView downTypeInTabIndex:(NSInteger)tabIndex
{
    if (tabIndex == 2) {
        return ZHFilterMenuDownTypeOnlyList;
    }
    return ZHFilterMenuDownTypeTwoLists;
}


- (ZHFilterMenuView *)menuView
{
    if (!_menuView) {
        _menuView = [[ZHFilterMenuView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 45) maxHeight:CGRectGetHeight(self.view.frame) - 45];
        _menuView.zh_delegate = self;
        _menuView.zh_dataSource = self;
        _menuView.titleLeft = YES;
        _menuView.lastTitleRight = YES;
        _menuView.twoListToOneList = YES;
        _menuView.titleArr = @[@"类型",@"状态",@""];
        _menuView.imageNameArr = @[@"x_arrow",@"x_arrow",@"x_px"];
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
