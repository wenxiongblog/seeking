//
//  NSString+Format.h
//  ClassExtension
//
//  Created by solehe on 2018/9/19.
//  Copyright © 2018年 solehe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Format)

// 邮箱格式校验
- (BOOL)isEmail;

// 手机号码校验
- (BOOL)isTelPhoneNumber;

// 电话、传真号码校验
- (BOOL)isPhoneAndFaxNumber;

// 密码校验（大小写英文字母和数字）
- (BOOL)isPassword;

// 密码校验（大小写英文字母、数字和特殊字符）
- (BOOL)isLawfulPwd;

// 用户名校验
- (BOOL)isNick;

// 金额校验（只能是数字和小数点）
- (BOOL)isAmount;

// 银行卡号校验
- (BOOL)isBankCardNo;

// 身份证号码校验
- (BOOL)isIdentifityCardNo;

// 军官证号码校验
- (BOOL)isOfficerCardNo;

// 护照号码校验
- (BOOL)isPassportCardNo;

// 车牌号码校验
- (BOOL)isCarNo;


@end

NS_ASSUME_NONNULL_END
