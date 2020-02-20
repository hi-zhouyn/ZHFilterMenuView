//
//  ViewController.m
//  ZHFilterMenuView
//
//  Created by 周亚楠 on 2019/8/21.
//  Copyright © 2019 Zhou. All rights reserved.
//

#import "ViewController.h"
#import "ZHFilterTitleTableViewCell.h"
#import "FilterViewController.h"
#import "HeadFilterViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"ZHFilterMenuView";
    self.titleArr = @[@"新房筛选",@"二手房筛选",@"租房筛选",@"悬停下拉筛选"];//,@"侧边筛选"
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTranslucent:NO];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZHFilterTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZHFilterTitleTableViewCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.titleLabel.text = self.titleArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.titleArr.count - 1) {
        HeadFilterViewController *headVC = [[HeadFilterViewController alloc] init];
        [self.navigationController pushViewController:headVC animated:YES];
    }else {
        FilterViewController *filterVC = [[FilterViewController alloc] init];
        filterVC.filterType = indexPath.row + 1;
        [self.navigationController pushViewController:filterVC animated:YES];
    }
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 45;
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView registerClass:[ZHFilterTitleTableViewCell class] forCellReuseIdentifier:NSStringFromClass([ZHFilterTitleTableViewCell class])];
        _tableView.tableFooterView = [UIView new];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}


@end
