//
//  NSString+Password.h
//  SCGOV
//
//  Created by solehe on 2019/5/29.
//  Copyright © 2019 Enrising. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, PwdStrengthLevel) {
    PwdStrengthLevelInvalid= -1,
    PwdStrengthLevelEasy,
    PwdStrengthLevelMidium,
    PwdStrengthLevelStrong,
    PwdStrengthLevelVeryStrong,
    PwdStrengthLevelExtlyStrong
};

@interface NSString (Password)

/**
 获取密码强度等级
 */
- (PwdStrengthLevel)passwordLevel;
- (PwdStrengthLevel)pwdlevel;

@end

NS_ASSUME_NONNULL_END
