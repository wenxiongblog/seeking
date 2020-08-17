//
//  LSSayHiAlertView.h
//  Project
//
//  Created by XuWen on 2020/3/1.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "XWBaseAlertView.h"

typedef void(^LSDazhaohuBlock)(BOOL isDaZhaoHu,int count);

NS_ASSUME_NONNULL_BEGIN

@interface LSSayHiAlertView : XWBaseAlertView
@property (nonatomic,copy) LSDazhaohuBlock dazhaohuBlock;
+ (NSString *)zhaohuYuju;
+ (NSArray *)zhahuShortYujuArray;
@end

NS_ASSUME_NONNULL_END
