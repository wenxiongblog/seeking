//
//  LSMineSectionHeader.h
//  Project
//
//  Created by XuWen on 2020/6/8.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSMineSectionHeader : UIView
@property (nonatomic,assign) BOOL vipSection;
@property (nonatomic,copy) void(^SectionHeaderBlock)(void);
@end

NS_ASSUME_NONNULL_END
