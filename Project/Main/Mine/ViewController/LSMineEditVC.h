//
//  LSMineEditVC.h
//  Project
//
//  Created by XuWen on 2020/2/28.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSBaseViewController.h"
#import "LSMyEditCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface LSMineEditVC : LSBaseViewController

@end

@interface LSMineEditModel : NSObject
+ (LSMineEditModel *)createWithType:(LSMyEditCellType)type title:(NSString *)title content:(NSArray *)content;

@property (nonatomic,assign) LSMyEditCellType type;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSArray *content;
@property (nonatomic,strong) NSString *key;
@end

NS_ASSUME_NONNULL_END
