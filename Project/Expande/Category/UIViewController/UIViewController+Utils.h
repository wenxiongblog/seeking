//
//  ViewController+Utils.h
//  SCGov
//
//  Created by solehe on 2019/7/29.
//  Copyright © 2019 solehe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Utils)

/**
 自定义返回按钮

 @param imageName 图片名称
 */
- (void)customNaviBackItem:(NSString *)imageName;

@end

NS_ASSUME_NONNULL_END
