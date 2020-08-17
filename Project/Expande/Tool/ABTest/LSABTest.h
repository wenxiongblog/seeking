//
//  LSABTest.h
//  Project
//
//  Created by XuWen on 2020/6/28.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSABTest : NSObject
- (void)ABTest:(void (^)(int testResult)) ABTestBlock;
@end

NS_ASSUME_NONNULL_END
