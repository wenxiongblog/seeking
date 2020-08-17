//
//  NSString+Trim.m
//  SCZW
//
//  Created by solehe on 2018/10/29.
//  Copyright © 2018 solehe. All rights reserved.
//

#import "NSString+Utils.h"

@implementation NSString (Utils)

// 去除前后空白字符串
- (NSString *)trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

// 去除空白字符串
- (NSString *)trimAll {
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

// 去除字符串中的(null)
- (NSString *)trimNull {
    return [self stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
}

// url编码
- (NSString *)urlEncoding {
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

// 身份证号码脱敏
- (NSString *)securetyIdentifityCardNo {
    if ([self isIdentifityCardNo]) {
        return [self stringByReplacingCharactersInRange:NSMakeRange(0, 14) withString:@"********************"];
    }
    return self;
}

// 电话号码脱敏
- (NSString *)securetyTelPhoneNumber {
    if ([self isTelPhoneNumber]) {
        return [self stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }
    return self;
}

// 统一社会信用代码脱敏
- (NSString *)securetySetupCode {
    if (self.length > 12) {
        return [self stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];;
    }
    return self;
}

// 真实姓名脱敏
- (NSString *)securetyRealName {
    if (self.length > 1) {
        NSMutableString *names = [NSMutableString string];
        for (int i=0; i<self.length-1; i++) {
            [names appendString:@"*"];
        }
        [names appendString:[self substringFromIndex:self.length-1]];
        return [names copy];
    }
    return self;
}

// Json字符串转字典
- (NSDictionary *)josnToDictionary {
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
}

// 日期时间(字符串格式需为：MMM d, yyyy h:m:s aa)
- (NSString *)dateTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, yyyy h:m:s aa"];
    NSDate *date = [formatter dateFromString:self];
    // 重新格式化
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter stringFromDate:date];
}

- (NSString *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, yyyy h:m:s aa"];
    NSDate *date = [formatter dateFromString:self];
    // 重新格式化
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:date];
}

// 转为base64编码格式字符串
- (NSString *)base64String {
    NSData *encodeData = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [encodeData base64EncodedStringWithOptions:0];
}

// base64编码格式的字符串转为普通字符串
- (NSString *)stringFromBase64 {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:self options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}

// base64字符串转图片
- (UIImage *)base64ToImage {
    // 将base64字符串转为NSData
    NSData *decodeData = [[NSData alloc]initWithBase64EncodedString:self options:(NSDataBase64DecodingIgnoreUnknownCharacters)];
    // 将NSData转为UIImage
    return [UIImage imageWithData: decodeData];
}

//获取拼音首字母(传入汉字字符串, 返回大写拼音首字母)
- (NSString *)firstCharactor {
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:self];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    //转化为大写拼音
    NSString *pinYin = [str capitalizedString];
    //获取字符串中的大写字母
    NSCharacterSet *nonDigitCharacterSet = [[NSCharacterSet uppercaseLetterCharacterSet] invertedSet];
    //获取并返回首字母
    return [[pinYin componentsSeparatedByCharactersInSet:nonDigitCharacterSet] componentsJoinedByString:@""];
}

// 获取拼音
- (NSString *)pinyin {
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:self];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics,NO);
    //转化为大写拼音
    NSString *pinYin = [str capitalizedString];
    //获取拼音
    return [pinYin stringByReplacingOccurrencesOfString:@" " withString:@""].uppercaseString;
}

- (NSString *)filter
{
    NSArray *array = @[@"Sugar",@"sugar",
                       @"Sweet",@"sweet",
                       @"escort",@"Escort",
                       @"Sex",@"sex",
                       @"Nude",@"nude",
                       @"Porn",@"porn",
                       @"Naked",@"naked",
                       @"Financial",@"financial",
                       @"Money",@"money"];
    NSString *string = [NSString stringWithString:self];
    for(NSString *str in array){
        if([string containsString:str]){
            string = [string stringByReplacingOccurrencesOfString:str withString:@"**"];
        }
    }
    return string;
}


+ (NSString *)randomName{
     NSString *letters = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *randomString = [NSMutableString string];
    for (NSInteger i = 0; i < 1; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
    }
    NSString *letters2 = @"abcdefghijklmnopqrstuvwxyz";
    for (NSInteger i = 0; i < 5; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters2 length])]];
    }
    
    return randomString;
}

@end
