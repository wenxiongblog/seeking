//
//  LSBaseViewController.h
//  Project
//
//  Created by XuWen on 2020/1/7.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^NavItemClickedBlock)(void);

@interface LSBaseViewController : UIViewController

@property (nonatomic,strong) UIImageView *bgImageView;

@property (nonatomic,strong)UIView *navBarView;
@property (nonatomic,strong)UIButton *backButton;
@property (nonatomic,strong)UILabel *navTitleLabel;
@property (nonatomic,strong)UIButton *rightItemButton;
//@property (nonatomic,strong)UIImageView *shandowColorView;//底部条
@property (nonatomic, strong) NSString *titleString;

//特殊格式
- (void)speciceNavWithTitle:(NSString *)title;

//隐藏Nav
- (void)hideNav;
//隐藏返回按钮
- (void)hideBackButton;
- (void)addRightItemWithImage:(UIImage *)image clickBlock:(NavItemClickedBlock)clickBlock;
- (void)addRightItemWithString:(NSString *)string clickBlock:(NavItemClickedBlock)clickBlock;
- (void)backButtonClicked;


// 控制器跳转传入参数
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, copy, nullable) void(^resultBlock)(NSDictionary * __nullable dict);


// 页面跳转（不带参数、不带返回结果）
- (void)pushViewController:(NSString *)className;
- (void)presentViewController:(NSString *)className;

// 页面跳转（不带参数、带返回结果）
- (void)pushViewController:(NSString *)className result:(void(^)(NSDictionary *dict))block;
- (void)presentViewController:(NSString *)className result:(void(^)(NSDictionary *dict))block;

// 页面跳转（带参数）
- (void)pushViewController:(NSString *)className params:(NSDictionary *)params;
- (void)presentViewController:(NSString *)className params:(NSDictionary *)params;

// 页面跳转（带参数、带返回结果）
- (void)pushViewController:(NSString *)className params:(NSDictionary *)params result:(void(^)(NSDictionary *dict))block;
- (void)presentViewController:(NSString *)className params:(NSDictionary *)params result:(void(^)(NSDictionary *dict))block;


//公共请求 - 更新用户数据
- (void)updateUserInfoWithLoading:(BOOL)loading finish :(void(^)(BOOL finished))finished;
- (void)updateUserInfo:(void(^)(BOOL finished))finished;
//更新用户位置
- (void)UpdateLocation:(void(^)(BOOL finished))finished;
@end

NS_ASSUME_NONNULL_END
