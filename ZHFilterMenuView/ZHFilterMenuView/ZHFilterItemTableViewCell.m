//
//  ZHFilterItemTableViewCell.m
//  ZHFilterMenuView
//
//  Created by 周亚楠 on 2019/12/10.
//  Copyright © 2019 Zhou. All rights reserved.
//

#import "ZHFilterItemTableViewCell.h"

@implementation ZHFilterItemManger


@end

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
@property (nonatomic, assign) NSInteger maxCount;
@end

@implementation ZHFilterItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.buttonArr = [NSMutableArray array];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.minTextField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.maxTextField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (void)setItemType:(ZHFilterItemType)itemType
{
    _itemType = itemType;
    if (itemType == ZHFilterItemTypeOnlyItem) {
        self.titleLabel.hidden = NO;
        self.leftButton.hidden = YES;
        self.rightButton.hidden = YES;
        self.bottomView.hidden = YES;
        self.bottomViewBottom.constant = 0;
    } else if (itemType == ZHFilterItemTypeItemInput) {
        self.titleLabel.hidden = YES;
        self.leftButton.hidden = NO;
        self.rightButton.hidden = NO;
        self.bottomView.hidden = NO;
        self.bottomViewBottom.constant = 90;
    }
}

- (void)setItemManager:(ZHFilterItemManger *)itemManager
{
    _itemManager = itemManager;
    [self.leftButton setTitleColor:[itemManager.titleColor colorWithAlphaComponent:0.6] forState:UIControlStateNormal];
    [self.leftButton setTitleColor:itemManager.titleSelectedColor forState:UIControlStateSelected];
    [self.rightButton setTitleColor:[itemManager.titleColor colorWithAlphaComponent:0.6] forState:UIControlStateNormal];
    [self.rightButton setTitleColor:itemManager.titleSelectedColor forState:UIControlStateSelected];
}

- (void)setModelArr:(NSArray *)modelArr
{
    _modelArr = modelArr;
    for (ZHFilterModel *filterModel in modelArr) {
        if (filterModel.itemArr.count > self.maxCount) {
            self.maxCount = filterModel.itemArr.count;
        }
    }
    if (self.itemType == ZHFilterItemTypeItemInput) {
        if (modelArr.count > 1) {
            [self.leftButton setTitle:[[modelArr firstObject] title] forState:UIControlStateNormal];
            [self.rightButton setTitle:[[modelArr lastObject] title] forState:UIControlStateNormal];
            if (!self.leftButton.selected && !self.rightButton.selected) {
                self.leftButton.selected = YES;
                self.filterModel = [modelArr firstObject];
                self.filterModel.selected = YES;
            }
        } else {
            self.titleLabel.hidden = NO;
            self.leftButton.hidden = YES;
            self.rightButton.hidden = YES;
        }
    }
}

- (void)setFilterModel:(ZHFilterModel *)filterModel
{
    _filterModel = filterModel;
    if (self.itemType == ZHFilterItemTypeItemInput) {
        self.minTextField.text = filterModel.minPrice;
        self.maxTextField.text = filterModel.maxPrice;
    }
    self.titleLabel.text = filterModel.title;
    [self createButtonItem];
}

- (void)textFieldChanged:(UITextField *)textField
{
    [self strLengthLimitWithTextField:textField maxLength:self.itemManager.maxLength];
    if (textField.tag == 101) {
        self.filterModel.minPrice = textField.text;
    } else if (textField.tag == 102) {
        self.filterModel.maxPrice = textField.text;
    }
}

- (IBAction)leftButtonClick:(id)sender {
    if (self.leftButton.selected) {
        return;
    }
    for (UIButton *button in self.itemView.subviews) {
        [button removeFromSuperview];
    }
    [self.buttonArr removeAllObjects];
    self.leftButton.selected = YES;
    self.rightButton.selected = NO;
    ZHFilterModel *filterModel = [self.modelArr firstObject];
    filterModel.selected = YES;
    [[self.modelArr lastObject] setSelected:NO];
    [filterModel setModelItemSelectesNO];
    self.filterModel = filterModel;
}

- (IBAction)rightButtonClick:(id)sender {
    if (self.rightButton.selected) {
        return;
    }
    for (UIButton *button in self.itemView.subviews) {
        [button removeFromSuperview];
    }
    [self.buttonArr removeAllObjects];
    self.leftButton.selected = NO;
    self.rightButton.selected = YES;
    ZHFilterModel *filterModel = [self.modelArr lastObject];
    filterModel.selected = YES;
    [[self.modelArr firstObject] setSelected:NO];
    [filterModel setModelItemSelectesNO];
    self.filterModel = filterModel;
}


- (void)itemButtonClick:(UIButton *)sender
{
    self.minTextField.text = nil;
    self.maxTextField.text = nil;
    self.filterModel.minPrice = @"";
    self.filterModel.maxPrice = @"";
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
    for (UIButton *button in self.itemView.subviews) {
        [button removeFromSuperview];
    }
    [self.buttonArr removeAllObjects];
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
        CGFloat offictY = (i / self.itemManager.lineNum) * (self.itemManager.space + self.itemManager.itemHeight) + self.itemManager.space;
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

/**
 输入框字符数限制 并且未确定文字不做截取处理
 */
- (void)strLengthLimitWithTextField:(UITextField *)textField maxLength:(NSInteger)maxLength
{
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (textField.text.length > maxLength) {
                textField.text = [textField.text substringToIndex:maxLength];
            }
        }else{
            // 有高亮选择的字符串，则暂不对文字进行统计和限制
        }
    }else{
        // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (textField.text.length > maxLength) {
            textField.text = [textField.text substringToIndex:maxLength];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
