//
//  XXLockTouchIdTool.h
//  SCGov
//
//  Created by solehe on 2019/8/20.
//  Copyright © 2019 solehe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXLockTouchIdTool : NSObject

// 验证指纹
+ (void)touch:(void(^)(BOOL success, NSString *error))block;

@end

NS_ASSUME_NONNULL_END
