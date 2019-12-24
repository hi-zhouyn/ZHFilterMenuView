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

//归档
- (void)encodeWithCoder:(NSCoder *)aCoder{
    unsigned int count;
    Ivar *ivar = class_copyIvarList([self class], &count);
    for (int i=0; i<count; i++) {
        Ivar iva = ivar[i];
        const char *name = ivar_getName(iva);
        NSString *strName = [NSString stringWithUTF8String:name];
        //利用KVC取值
        id value = [self valueForKey:strName];
        [aCoder encodeObject:value forKey:strName];
    }
    free(ivar);
}

//解档
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        unsigned int count = 0;
        Ivar *ivar = class_copyIvarList([self class], &count);
        for (int i = 0; i < count; i++) {
            Ivar iva = ivar[i];
            const char *name = ivar_getName(iva);
            NSString *strName = [NSString stringWithUTF8String:name];
            //进行解档取值
            id value = [aDecoder decodeObjectForKey:strName];
            //利用KVC对属性赋值
            [self setValue:value forKey:strName];
        }
        free(ivar);
    }
    return self;
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
