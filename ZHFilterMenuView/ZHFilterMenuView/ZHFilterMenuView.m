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

@implementation ZHIndexPath


@end

@implementation ZHFilterBottomView




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
@property (nonatomic, strong) UITableView *mediumTableView;
@property (nonatomic, strong) UITableView *rightTableView;
@property (nonatomic, strong) UIView *backGroundView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) ZHFilterBottomView *bottomView;

@property (nonatomic, assign) NSInteger selectedTabIndex;

@end

@implementation ZHFilterMenuView





- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}








- (UITableView *)leftTableView
{
    if (!_leftTableView) {
        
    }
    return _leftTableView;
}

- (UITableView *)mediumTableView
{
    if (!_mediumTableView) {
        _mediumTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
    }
    return _mediumTableView;
}

- (UITableView *)rightTableView
{
    if (!_rightTableView) {
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
    }
    return _rightTableView;
}

- (ZHFilterBottomView *)bottomView
{
    if (!_bottomView) {
        
    }
    return _bottomView;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
