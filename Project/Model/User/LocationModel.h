//
//  LocationModel.h
//  SCGov
//
//  Created by solehe on 2019/8/23.
//  Copyright © 2019 solehe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LocationModel : NSObject

@property (nonatomic, strong) NSString *areaName;
@property (nonatomic, strong) NSString *areaNames;
@property (nonatomic, strong) NSString *areaSimpleName;
@property (nonatomic, strong) NSString *areaCode;
@property (nonatomic, strong) NSNumber *areaLevel;
@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSString *abbr;
@property (nonatomic, strong) NSString *pinyin;

// 默认地区
+ (LocationModel *)defaultLocation;

@end

NS_ASSUME_NONNULL_END
