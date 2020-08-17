//
//  UploadFile.m
//  SCGov
//
//  Created by solehe on 2019/8/30.
//  Copyright © 2019 solehe. All rights reserved.
//

#import <MobileCoreServices/MobileCoreServices.h>
#import "UploadFile.h"

@implementation UploadFile

- (NSString *)mimeType {
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)[self.name pathExtension], NULL);
    CFStringRef MIMEType = UTTypeCopyPreferredTagWithClass (UTI, kUTTagClassMIMEType);
    CFRelease(UTI);
    if (!MIMEType) {
        return @"application/octet-stream";
    }
    return (__bridge NSString *)(MIMEType);
}


@end
