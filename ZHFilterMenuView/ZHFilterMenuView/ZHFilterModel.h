//
//  ZHFilterModel.h
//  ZHFilterMenuView
//
//  Created by 周亚楠 on 2019/12/6.
//  Copyright © 2019 Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHFilterItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZHFilterModel : NSObject

@property (nonatomic, copy) NSString *title;             //标题
@property (nonatomic, strong) NSMutableArray *itemArr;   //item数据
@property (nonatomic, strong) NSMutableArray *selectArr; //选择的数据
@property (nonatomic, assign) BOOL multiple;             //是否多选
@property (nonatomic, assign) BOOL selected;             //是否已选
@property (nonatomic, assign) BOOL selectFirst;          //是否选择第一个
@property (nonatomic, copy) NSString *minPrice;          //输入框最低值
@property (nonatomic, copy) NSString *maxPrice;          //输入框最大值

@property (nonatomic, assign) NSInteger listHeight;        //列表高度(用于内部列表展示时使用)

/** 快速构造ZHFilterModel */
+ (ZHFilterModel *)createFilterModelWithHeadTitle:(NSString *)title modelArr:(NSArray *)modelArr selectFirst:(BOOL)selectFirst multiple:(BOOL)multiple;

/** 所有置位未选中 */
- (void)setModelItemSelectesNO;

/** 首位选中 */
- (void)setModelItemSelecteFirst;

/** 快速获取选中ZHFilterItemModel */
- (ZHFilterItemModel *)getSelectedItemModel;

- (NSString *)getSelectedItemModelCode;

- (NSMutableArray *)getSelectedItemModelArr;

- (NSMutableArray *)getSelectedItemModelCodeArr;

@end

NS_ASSUME_NONNULL_END
