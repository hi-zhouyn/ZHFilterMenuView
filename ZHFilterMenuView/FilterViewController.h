//
//  FilterViewController.h
//  ZHFilterMenuView
//
//  Created by 周亚楠 on 2019/12/11.
//  Copyright © 2019 Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 筛选类型 */
typedef NS_ENUM(NSUInteger, FilterVCType) {
    FilterVCTypeIsNewHouse = 1,  //新房
    FilterVCTypeSecondHandHouse, //二手房
    FilterVCTypeISRent,          //租房
    FilterVCTypeIntermediary,    //中介
    FilterVCTypeRight,           //侧边筛选
};

NS_ASSUME_NONNULL_BEGIN

@interface FilterViewController : UIViewController
@property (nonatomic, assign) FilterVCType filterType;
@end

NS_ASSUME_NONNULL_END
