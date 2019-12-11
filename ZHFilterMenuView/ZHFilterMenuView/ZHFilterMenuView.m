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

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define KTableViewCellHeight 44

#define kBaseSetHEXColor(rgbValue,al) ([UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(al)])

#define kSetHEXColor(rgbValue) kBaseSetHEXColor(rgbValue,1)

#define KTitleColor         kSetHEXColor(0x333333)
#define KTitleSelectedColor kSetHEXColor(0x4998E8)
#define KLineColor          kSetHEXColor(0xe8e8e8)//分割线


@implementation ZHIndexPath


@end

@implementation ZHFilterBottomView

/** 快速初始化 */
- (instancetype _Nonnull )initBottomViewWithResetAction:(SEL _Nonnull )resetAction confirmAction:(SEL _Nonnull )confirmAction
{
    if (self = [super init]) {
        self.resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
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
        
        
        //        _bottomView.frame = CGRectMake(0, CGRectGetMaxY(self.backGroundView.frame), 0, 0)
        
        
    }
    return self;
}

/** 参数传完后开始调用 */
- (void)beginShow
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
    if (_zh_dataSource == nil) {
        return;
    }
    [self menuTappedWithIndex:sender.tag];
}

#pragma mark - 点击
- (void)menuTappedWithIndex:(NSInteger)tapIndex
{
    
}

/** 点击背景回复默认 */
- (void)backGroundViewTappedClick:(UITapGestureRecognizer *)tapGesture
{
    
}

/** 重置 */
- (void)resetAction
{
    
}

/** 确定 */
- (void)confirmAction
{
    
}



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
