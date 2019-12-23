//
//  ZHFilterModel.m
//  ZHFilterMenuView
//
//  Created by 周亚楠 on 2019/12/6.
//  Copyright © 2019 Zhou. All rights reserved.
//

#import "ZHFilterModel.h"

@implementation ZHFilterModel

+ (ZHFilterModel *)createFilterModelWithHeadTitle:(NSString *)title modelArr:(NSArray *)modelArr selectFirst:(BOOL)selectFirst multiple:(BOOL)multiple
{
    ZHFilterModel *model = [[ZHFilterModel alloc] init];
    ZHFilterItemModel *infoModel = [modelArr firstObject];
    infoModel.selected = selectFirst;
    model.selectFirst = selectFirst;
    model.title = title;
    model.itemArr = [NSMutableArray arrayWithArray:modelArr];
    model.multiple = multiple;
    return model;
}

- (void)setModelItemSelectesNO
{
    self.minPrice = @"";
    self.maxPrice = @"";
    self.selectArr = [NSMutableArray array];
    for (ZHFilterItemModel *infoModel in self.itemArr) {
        infoModel.selected = NO;
    }
}

- (void)setModelItemSelecteFirst
{
    for (int i = 0; i < self.itemArr.count; i ++) {
        ZHFilterItemModel *infoModel = self.itemArr[i];
        infoModel.selected = !i;
    }
}

- (ZHFilterItemModel *)getSelectedItemModel
{
    ZHFilterItemModel *infoModel = [[ZHFilterItemModel alloc] init];
    for (ZHFilterItemModel *model in self.itemArr) {
        if (model.selected) {
            infoModel = model;
            break;
        }
    }
    return infoModel;
}

- (NSString *)getSelectedItemModelCode
{
    NSString *code = [NSString string];
    for (ZHFilterItemModel *model in self.itemArr) {
        if (model.selected) {
            code = model.code;
            break;
        }
    }
    return code;
}

- (NSMutableArray *)getSelectedItemModelArr
{
    NSMutableArray *selectArr = [NSMutableArray array];
    for (ZHFilterItemModel *model in self.itemArr) {
        if (model.selected) {
            [selectArr addObject:model];
        }
    }
    return selectArr;
}

- (NSMutableArray *)getSelectedItemModelCodeArr
{
    NSMutableArray *selectArr = [NSMutableArray array];
    for (ZHFilterItemModel *model in self.itemArr) {
        if (model.selected) {
            [selectArr addObject:model.code];
        }
    }
    return selectArr;
}

@end
