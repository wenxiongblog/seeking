/***************************************************************************************************
 **  Copyright © 2016年 Jinn Chang. All rights reserved.
 **  Giuhub: https://github.com/Jinnchang
 **
 **  FileName: XXLockSudoko.h
 **  Description: 解锁九宫格
 **
 **  Author:  Jinnchang
 **  Date:    2016/9/22
 **  Version: 1.0.0
 **  Remark:  Create New File
 **************************************************************************************************/

#import <UIKit/UIKit.h>

@class XXLockSudoko;

@protocol XXLockSudokoDelegate <NSObject>

- (void)sudoko:(XXLockSudoko *)sudoko passcodeDidCreate:(NSString *)passcode;

@end

@interface XXLockSudoko : UIView

@property (nonatomic, weak) id<XXLockSudokoDelegate> delegate;

- (instancetype)init;
- (void)showErrorPasscode:(NSString *)errorPasscode;
- (void)reset;

@end
