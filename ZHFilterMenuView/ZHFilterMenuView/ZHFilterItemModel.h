//
//  ZHFilterItemModel.h
//  ZHFilterMenuView
//
//  Created by 周亚楠 on 2019/12/6.
//  Copyright © 2019 Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZHFilterItemModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *parentCode;
@property (nonatomic, assign) BOOL selected;

@end

NS_ASSUME_NONNULL_END
