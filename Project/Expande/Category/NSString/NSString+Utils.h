//
//  NSString+Trim.h
//  SCZW
//
//  Created by solehe on 2018/10/29.
//  Copyright © 2018 solehe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Utils)

// 去除前后空白字符串
- (NSString *)trim;

// 去除空白字符串
- (NSString *)trimAll;

// 去除字符串中的(null)
- (NSString *)trimNull;

// url编码
- (NSString *)urlEncoding;

// 身份证号码脱敏
- (NSString *)securetyIdentifityCardNo;

// 电话号码脱敏
- (NSString *)securetyTelPhoneNumber;

// 统一社会信用代码脱敏
- (NSString *)securetySetupCode;

// 真实姓名脱敏
- (NSString *)securetyRealName;

// Json字符串转字典
- (NSDictionary *)josnToDictionary;

// 日期时间(字符串格式需为：MMM d, yyyy h:m:s aa)
- (NSString *)dateTime;
- (NSString *)date;

// 转为base64编码格式字符串
- (NSString *)base64String;

// base64编码格式的字符串转为普通字符串
- (NSString *)stringFromBase64;

// base64字符串转图片
- (UIImage *)base64ToImage;

// 获取拼音首字母(传入汉字字符串, 返回大写拼音首字母)
- (NSString *)firstCharactor;

// 获取拼音
- (NSString *)pinyin;

// 过滤违规字
- (NSString *)filter;

//随机姓名
+ (NSString *)randomName;

@end

NS_ASSUME_NONNULL_END
