//
//  LSMyEditCell.h
//  Project
//
//  Created by XuWen on 2020/2/15.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LSMyEditCellType) {
    LSMyEditCellType_Choose =0,
    LSMyEditCellType_textField,
    LSMyEditCellType_textView,
};
typedef void(^LSMyEditChage)(NSString * _Nonnull key,NSString * _Nullable changeText);
NS_ASSUME_NONNULL_BEGIN
static NSString *const kLSMyEditCellIdentifier = @"LSMyEditCell";
@interface LSMyEditCell : UITableViewCell
@property (nonatomic,copy) LSMyEditChage changeBlock;
@property (nonatomic,assign) LSMyEditCellType type;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *key;
@end

NS_ASSUME_NONNULL_END
