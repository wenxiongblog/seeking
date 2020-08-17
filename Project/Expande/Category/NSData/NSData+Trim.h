//
//  NSData+Trim.h
//  SCGOV
//
//  Created by solehe on 2019/4/16.
//  Copyright © 2019 Enrising. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (Trim)

- (NSString *)hexString;
/**融云deviceToken转换*/
- (NSString *)deviceTokenHexStringForData;
@end

NS_ASSUME_NONNULL_END
