//
//  RYTMD5Encryptor.m
//  SMSCodeFramework
//
//  Created by timmy on 16/11/1.
//  Copyright © 2016年 timmy. All rights reserved.
//

#import "MD5Encryptor.h"
#import <CommonCrypto/CommonDigest.h>

@implementation MD5Encryptor

+ (NSString *)stringTo32BitsLowcaseMD5:(NSString *)inputStr {
    
    return [[self md532:inputStr] lowercaseString];
    
}

+ (NSString *)stringTo32BitsUppercaseMD5:(NSString *)inputStr {

    return [[self md532:inputStr] uppercaseString];

}

+ (NSString *)md532:(NSString *)inputStr {

    const char *cStr = [inputStr UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (unsigned int)strlen(cStr), result);
    NSString *resultStr = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",result[0], result[1], result[2], result[3],result[4], result[5], result[6], result[7],result[8], result[9], result[10], result[11],result[12], result[13], result[14], result[15]];
    return resultStr;
}


@end
