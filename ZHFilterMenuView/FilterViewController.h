//
//  FilterViewController.h
//  ZHFilterMenuView
//
//  Created by 周亚楠 on 2019/12/11.
//  Copyright © 2019 Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterDataUtil.h"

NS_ASSUME_NONNULL_BEGIN

@interface FilterViewController : UIViewController
@property (nonatomic, assign) FilterType filterType;
@property (nonatomic, assign) BOOL twoListCanSpeedSelect;
@end

NS_ASSUME_NONNULL_END
