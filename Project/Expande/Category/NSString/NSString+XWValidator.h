//
//  NSString+XWValidator.h
//  Project
//
//  Created by xuwen on 2018/4/23.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (XWValidator)
/** 是否是纯中文*/
- (BOOL)xwIsPureChinese;
/** 是否是纯数字*/
- (BOOL)xwIsPureNumber;
/** 是否为空*/
- (BOOL)xwIsNull;
/** 是否包含emoji*/
- (BOOL)xwIsContainEmoji;
/** 是否是有效的手机号*/
- (BOOL)xwIsValidPhoneNumber;
/** 判断车牌号是否合法*/
- (BOOL)xwIsValidCarNumber;
/** 判断姓名是否合法*/
- (BOOL)xwIsValidRealName;
/** 是否是有效的座机号*/
- (BOOL)xwIsVaildLandlineNum;
/** 是否是正确的邮箱格式*/
- (BOOL)xwIsValidEmail;
/** 判断是否是正确的身份证号*/
- (BOOL)xwIsValidIDCardNumber;
/** 判断是否是正确的银行卡号*/
- (BOOL)xwIsValidBankCardNumber;
/** 判断密码格式是否合法*/
- (BOOL)xwIsValidPassword;
/** 判断昵称格式是否合法*/
- (BOOL)xwIsValidNickName;
/** 判断金额格式是否合法*/
- (BOOL)xwIsValidCash;
/** 判断选择地址*/
- (BOOL)xwIsAddress;
/** 判断详细地址*/
- (BOOL)xwIsDetailAddress;
/** 判断是否是有效二维码*/
- (BOOL)xwIsValidQRCode;
/*  是否全是空格键*/
- (BOOL)xwIsSpaceEmpty;

@end
