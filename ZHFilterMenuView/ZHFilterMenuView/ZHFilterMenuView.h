//
//  ZHFilterMenuView.m
//  ZHFilterMenuView
//
//  Created by 周亚楠 on 2019/12/5.
//  Copyright © 2019 Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZHFilterMenuView;

@interface ZHIndexPath : NSObject

@property (nonatomic, assign) NSInteger tabIndex;
@property (nonatomic, assign) NSInteger sectionIndex;
@property (nonatomic, assign) NSInteger rowIndex;

@end


typedef NS_ENUM(NSUInteger, ZHFilterMenuViewConfirmType) {
    ZHFilterMenuViewConfirmTypeSpeedConfirm,
    ZHFilterMenuViewConfirmTypeBottomConfirm,
};

@protocol ZHFilterMenuViewDelegate <NSObject>



@end


@protocol ZHFilterMenuViewDetaSource <NSObject>



@end

NS_ASSUME_NONNULL_BEGIN

@interface ZHFilterMenuView : UIView

@property (nonatomic, weak) id<ZHFilterMenuViewDelegate> zh_delegate;
@property (nonatomic, weak) id<ZHFilterMenuViewDetaSource> zh_dataSource;



@end

NS_ASSUME_NONNULL_END
