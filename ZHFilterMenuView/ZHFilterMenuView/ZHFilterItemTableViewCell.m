//
//  ZHFilterItemTableViewCell.m
//  ZHFilterMenuView
//
//  Created by 周亚楠 on 2019/12/10.
//  Copyright © 2019 Zhou. All rights reserved.
//

#import "ZHFilterItemTableViewCell.h"

@interface ZHFilterItemTableViewCell ()
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *leftButton;
@property (strong, nonatomic) IBOutlet UIButton *rightButton;
@property (strong, nonatomic) IBOutlet UIView *itemView;
@property (strong, nonatomic) IBOutlet UITextField *minTextField;
@property (strong, nonatomic) IBOutlet UITextField *maxTextField;
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomViewBottom;

@property (nonatomic, strong) NSMutableArray *buttonArr;
@end

@implementation ZHFilterItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (void)setItemType:(ZHFilterItemType)itemType
{
    _itemType = itemType;
    if (itemType == ZHFilterItemTypeOnlyItem) {
        self.titleLabel.hidden = NO;
        self.leftButton.hidden = YES;
        self.rightButton.hidden = YES;
        self.bottomView.hidden = YES;
    } else if (itemType == ZHFilterItemTypeItemInput) {
        self.titleLabel.hidden = YES;
        self.leftButton.hidden = NO;
        self.rightButton.hidden = NO;
        self.bottomView.hidden = NO;
    }
}

- (void)setItemManager:(ZHFilterItemManger *)itemManager
{
    _itemManager = itemManager;
    _itemManager.space = 15;
    _itemManager.itemHeight = 28;
    _itemManager.lineNum = 4;
}

- (void)setModelArr:(NSArray *)modelArr
{
    _modelArr = modelArr;
    if (!self.leftButton.selected && !self.rightButton.selected) {
        self.leftButton.selected = YES;
        self.filterModel = [modelArr firstObject];
    }
}

- (void)setFilterModel:(ZHFilterModel *)filterModel
{
    _filterModel = filterModel;
    CGFloat listHiight = 0.f;
    if (self.itemType == ZHFilterItemTypeOnlyItem) {
        
    } else if (self.itemType == ZHFilterItemTypeItemInput) {
        
    }
    [self createButtonItem];
}

- (IBAction)leftButtonClick:(id)sender {
    if (self.leftButton.selected) {
        return;
    }
    for (UIButton *button in self.buttonArr) {
        [button removeFromSuperview];
    }
    [self.buttonArr removeAllObjects];
    self.filterModel = [self.modelArr firstObject];
}

- (IBAction)rightButtonClick:(id)sender {
    if (self.rightButton.selected) {
        return;
    }
    for (UIButton *button in self.buttonArr) {
        [button removeFromSuperview];
    }
    [self.buttonArr removeAllObjects];
    self.filterModel = [self.modelArr lastObject];
}


- (void)itemButtonClick:(UIButton *)sender
{
    if (self.filterModel.multiple) {
        sender.selected = !sender.selected;
        ZHFilterItemModel *itemModel = self.filterModel.itemArr[sender.tag];
        itemModel.selected = sender.selected;
        NSMutableArray *selectArr = [NSMutableArray array];
        for (ZHFilterItemModel *itemModel in self.filterModel.itemArr) {
            if (itemModel.selected) {
                [selectArr addObject:itemModel];
            }
        }
        self.filterModel.selectArr = selectArr;
    } else {
        for (UIButton *button in self.buttonArr) {
            if (button == sender) {
                button.selected = YES;
            }else{
                button.selected = NO;
            }
        }
        self.filterModel.selectArr = [NSMutableArray array];;
        for (int i = 0; i < self.filterModel.itemArr.count; i ++) {
            ZHFilterItemModel *itemModel = self.filterModel.itemArr[i];
            if (i == sender.tag) {
                itemModel.selected = YES;
                NSMutableArray *selectArr = [NSMutableArray arrayWithObjects:itemModel, nil];
                self.filterModel.selectArr = selectArr;
            }else{
                itemModel.selected = NO;
            }
        }
    }
}

- (void)createButtonItem
{
    [self layoutIfNeeded];
    UIButton *tempButton = [UIButton buttonWithType:UIButtonTypeCustom];
    for (int i = 0; i < self.filterModel.itemArr.count; i ++) {
        ZHFilterItemModel *model = self.filterModel.itemArr[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 2;
        button.tintColor = [UIColor clearColor];
        [button setTitle:model.name forState:UIControlStateNormal];
        [button setTitleColor:self.itemManager.titleColor forState:UIControlStateNormal];
        [button setTitleColor:self.itemManager.titleSelectedColor forState:UIControlStateSelected];
        [button setBackgroundImage:[self imageWithColor:self.itemManager.itemBGColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[self imageWithColor:self.itemManager.itemBGSelectedColor] forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:self.itemManager.itemTitleFontSize];
        button.tag = i;
        [button addTarget:self action:@selector(itemButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.itemView addSubview:button];
        CGFloat itemWidth = (self.itemManager.width - self.itemManager.space * (self.itemManager.lineNum + 1)) / self.itemManager.lineNum;
        CGFloat offictX = (i % self.itemManager.lineNum + 1) * (self.itemManager.space + itemWidth) - itemWidth;
        CGFloat offictY = (i / self.itemManager.lineNum) * (self.itemManager.space + self.itemManager.itemHeight);
        button.frame = CGRectMake(offictX, offictY, itemWidth, self.itemManager.itemHeight);
        tempButton = button;
        [self.buttonArr addObject:button];
        button.selected = model.selected;
    }
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
