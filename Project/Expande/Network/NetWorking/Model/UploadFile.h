//
//  UploadFile.h
//  SCGov
//
//  Created by solehe on 2019/8/30.
//  Copyright © 2019 solehe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UploadFile : NSObject

@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSData *data;

@property (nonatomic, strong, readonly) NSString *mimeType;

@end

NS_ASSUME_NONNULL_END
