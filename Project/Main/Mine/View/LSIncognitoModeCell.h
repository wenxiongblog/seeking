//
//  LSIncognitoModeCell.h
//  Project
//
//  Created by XuWen on 2020/6/25.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
static NSString *const kLSIncognitoModeCellIdentifier = @"LSIncognitoModeCell";
@interface LSIncognitoModeCell : UITableViewCell
@property (nonatomic,strong) NSString *name;
@property (nonatomic,assign) BOOL isIncognito;
@property (nonatomic,copy) void(^ISIncognitoBlock)(int isIncoginito);
@end

NS_ASSUME_NONNULL_END
