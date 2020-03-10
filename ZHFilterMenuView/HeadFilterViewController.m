//
//  HeadFilterViewController.m
//  ZHFilterMenuView
//
//  Created by 周亚楠 on 2020/2/11.
//  Copyright © 2020 Zhou. All rights reserved.
//

#import "HeadFilterViewController.h"
#import "ZHFilterMenuView.h"
#import "FilterDataUtil.h"
#import "HouseTableViewCell.h"

#define KStatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height
#define KNavBarHeight self.navigationController.navigationBar.frame.size.height
#define KNavbarAndStatusHieght (KStatusBarHeight+KNavBarHeight)
#define KHeadImageViewHeight 250
#define KMenuViewHeight      45

@interface HeadFilterViewController ()
<ZHFilterMenuViewDelegate,
ZHFilterMenuViewDetaSource,
UITableViewDelegate,
UITableViewDataSource,
UIScrollViewDelegate>
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) ZHFilterMenuView *menuView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *headImageView;
@end

@implementation HeadFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self tableView];
    //便于演示房源展示数据源暂时是写在本地，可根据自身情况，如果需从接口请求可自行做下调整
    FilterDataUtil *dataUtil = [[FilterDataUtil alloc] init];
    self.menuView.filterDataArr = [dataUtil getTabDataByType:FilterTypeIsNewHouse];
    //开始显示
    [self.menuView beginShowMenuView];
}

//视图将要消失时需要手动移除视图
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.menuView removeMenuList];
}

//下拉菜单展示时禁止点击状态栏回到顶部，避免滑动后下拉框未消失的情况（贝壳找房是存在这样的问题）
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    return !self.menuView.isOpen;
}

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

/** 点击菜单回调 */
- (void)menuView:(ZHFilterMenuView *)menuView selectMenuAtTabIndex:(NSInteger)tabIndex
{
    if (self.tableView.contentOffset.y < KHeadImageViewHeight) {
        //设置等待时间，等区头悬停后再允许下拉框展示
        menuView.waitTime = 0.2f;
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:(UITableViewScrollPositionTop)];
    } else {
        menuView.waitTime = 0.f;
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
        return ZHFilterMenuDownTypeItemInput;
    } else if (tabIndex == 2) {
        return ZHFilterMenuDownTypeOnlyItem;
    } else if (tabIndex == 3) {
        return ZHFilterMenuDownTypeOnlyItem;
    } else if (tabIndex == 4) {
        return ZHFilterMenuDownTypeOnlyList;
    }
    return ZHFilterMenuDownTypeOnlyList;
}


#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 25;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HouseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HouseTableViewCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.menuView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return KMenuViewHeight;
}

- (ZHFilterMenuView *)menuView
{
    if (!_menuView) {
        _menuView = [[ZHFilterMenuView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), KMenuViewHeight) maxHeight:CGRectGetHeight(self.view.frame) - KMenuViewHeight];
        _menuView.zh_delegate = self;
        _menuView.zh_dataSource = self;
        //下拉列表展示在window上，以应对列表视图展示的问题
        _menuView.showInWindow = YES;
        //移动后的menuView坐标转换在window上的minY值，showInWindow为YES时有效
        _menuView.inWindowMinY = KNavbarAndStatusHieght;
        _menuView.titleArr = @[@"区域",@"价格",@"户型",@"更多",@"排序"];
        _menuView.imageNameArr = @[@"x_arrow",@"x_arrow",@"x_arrow",@"x_arrow",@"x_arrow"];
    }
    return _menuView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - KNavbarAndStatusHieght) style:UITableViewStylePlain];
        _tableView.rowHeight = 115;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _headImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xq_ban"]];
        _headImageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), KHeadImageViewHeight);
        _tableView.tableHeaderView = _headImageView;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HouseTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HouseTableViewCell class])];
        [self.view addSubview:_tableView];
    }
    return _tableView;
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
