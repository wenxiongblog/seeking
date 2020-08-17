//
//  LSDetactFace.h
//  Project
//
//  Created by XuWen on 2020/2/29.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSDetactFace : NSObject
+ (void)detactImage:(UIImage *)image haveFace:(void(^)(NSInteger faceCount))complete;
@end

NS_ASSUME_NONNULL_END
