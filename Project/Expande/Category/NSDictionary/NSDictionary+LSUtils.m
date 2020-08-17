//
//  NSDictionary+LSUtils.m
//  Project
//
//  Created by XuWen on 2020/3/5.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "NSDictionary+LSUtils.h"

@implementation NSDictionary (LSUtils)

-(NSString*)DataTOjsonString
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
    options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
    error:&error];
    if (! jsonData) {
    NSLog(@"Got an error: %@", error);
    } else {
    jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

@end
