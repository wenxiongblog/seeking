//
//  LSSignUpBaseVC.h
//  Project
//
//  Created by XuWen on 2020/2/13.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LSSignUpBaseVC : LSBaseViewController
@property (nonatomic,strong) UILabel *titleLabel;
////更新用户信息
//- (void)updateUserInfo:(void(^)(BOOL finished))finished;
/**
    更新用户位置
 */
//- (void)UpdateLocation:(void(^)(BOOL finished))finished;

//请求登录
- (void)loginWithPlatform:(NSString *)platform uid:(NSString *)uid identityToken:(NSString *)identityToken;
@end

NS_ASSUME_NONNULL_END
