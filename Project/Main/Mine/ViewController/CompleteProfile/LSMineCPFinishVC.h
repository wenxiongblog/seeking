//
//  LSMineCPFinishVC.h
//  Project
//
//  Created by XuWen on 2020/5/5.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSBaseViewController.h"
typedef void(^CloseBlock)(BOOL isClose);

NS_ASSUME_NONNULL_BEGIN

@interface LSMineCPFinishVC : LSBaseViewController
//关闭
@property (nonatomic,copy) CloseBlock closeBlock;

@end

NS_ASSUME_NONNULL_END
