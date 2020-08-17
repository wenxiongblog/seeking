//
//  LSMineCPBaseVC.h
//  Project
//
//  Created by XuWen on 2020/4/30.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSBaseViewController.h"

//关闭按钮，更新信息
typedef void(^CloseBlock)(BOOL isClose);
//上一步
typedef void(^BackBlock)(BOOL isBack,NSString *key);
//下一步
typedef void(^NextBlock)(BOOL isSkip,NSString *key, NSString *value);

typedef NS_ENUM(NSInteger, LSMineProfieType) {
    LSMineProfieTypeInput = 0,
    LSMineProfieTypeChoose,
};

NS_ASSUME_NONNULL_BEGIN

@interface LSMineCPBaseVC : LSBaseViewController

//数据可key值
@property (nonatomic,strong) NSString *key;
@property (nonatomic,strong) NSString *value;
// 页面类型 是 填写 还是选择？
@property (nonatomic,assign) LSMineProfieType type;

@property (nonatomic,strong) NSString *profileTitle;
//选择的类型
@property (nonatomic,strong) NSArray *titleArray;
//输入的类型
@property (nonatomic,strong) NSString *placeholder;
//next
@property (nonatomic,copy) NextBlock nextBlock;
//back
@property (nonatomic,copy) BackBlock backBlock;
//关闭
@property (nonatomic,copy) CloseBlock closeBlock;
//number 
@property (nonatomic,strong) NSString *number;
//
@property (nonatomic,assign) BOOL hiddenBack;

@property (nonatomic,assign) BOOL isSingleLine; //一行是单个数据选择

@end

NS_ASSUME_NONNULL_END
