//
//  FilterDataUtil.h
//  ZHFilterMenuView
//
//  Created by 周亚楠 on 2019/12/19.
//  Copyright © 2019 Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

/** 筛选类型 */
typedef NS_ENUM(NSUInteger, FilterType) {
    FilterTypeIsNewHouse = 1,  //新房
    FilterTypeSecondHandHouse, //二手房
    FilterTypeISRent,          //租房
};

typedef NS_ENUM(NSUInteger, FilterDataType) {
    FilterDataType_GG_QY,   //公共-区域-001
    FilterDataType_GG_FJ,   //公共-附近-002
    FilterDataType_GG_ZJ,   //新房-总价-003
    FilterDataType_XF_DJ,   //新房-单价-004
    FilterDataType_GG_HX,   //公共-户型-005
    FilterDataType_XF_MJ,   //新房-面积-006
    FilterDataType_GG_LX,   //公共-类型-007
    FilterDataType_GG_ZT,   //公共-状态-008
    FilterDataType_XF_SJ,   //新房-时间-009
    FilterDataType_XF_PX,   //新房-排序-010
    FilterDataType_ESF_MJ,  //二手房-面积-011
    FilterDataType_GG_LC,   //公共-楼层-012
    FilterDataType_ESF_LL,  //二手房-楼龄-013
    FilterDataType_GG_ZX,   //公共-装修-014
    FilterDataType_GG_DT,   //公共-电梯-015
    FilterDataType_GG_YT,   //公共-用途-016
    FilterDataType_GG_QS,   //公共-权属-017
    FilterDataType_ESF_PX,  //二手房-排序-018
    FilterDataType_ZF_ZJ,   //租房-租金-019
    FilterDataType_ZF_ZZ,   //租房-整租-020
    FilterDataType_ZF_HZ,   //租房-合租-021
    FilterDataType_ZF_ZQ,   //租房-租期-022
    FilterDataType_ZF_PX,   //租房-排序-023
    FilterDataType_GG_CX,   //公共-朝向-024
};
//extern NSMutableArray *FilterDataTypeArr(FilterDataType type);

NS_ASSUME_NONNULL_BEGIN

@interface FilterDataUtil : NSObject
- (NSMutableArray *)getTabDataByType:(FilterType)type;
@end

NS_ASSUME_NONNULL_END
