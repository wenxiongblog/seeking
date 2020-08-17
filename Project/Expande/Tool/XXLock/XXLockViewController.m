/***************************************************************************************************
 **  Copyright © 2016年 Jinn Chang. All rights reserved.
 **  Giuhub: https://github.com/Jinnchang
 **
 **  FileName: XXLockViewController.m
 **  Description: 解锁密码控制器
 **
 **  Author:  Jinnchang
 **  Date:    2016/9/22
 **  Version: 1.0.0
 **  Remark:  Create New File
 **************************************************************************************************/

#import "XXLockViewController.h"
#import <LocalAuthentication/LAContext.h>
#import "Masonry.h"
#import "XXLockConfig.h"

typedef NS_ENUM(NSInteger, XXLockStep)
{
    XXLockStepNone = 0,
    XXLockStepCreateNew,
    XXLockStepCreateAgain,
    XXLockStepCreateNotMatch,
    XXLockStepCreateReNew,
    XXLockStepModifyOld,
    XXLockStepModifyOldError,
    XXLockStepModifyReOld,
    XXLockStepModifyNew,
    XXLockStepModifyAgain,
    XXLockStepModifyNotMatch,
    XXLockStepModifyReNew,
    XXLockStepVerifyOld,
    XXLockStepVerifyOldError,
    XXLockStepVerifyReOld,
    XXLockStepRemoveOld,
    XXLockStepRemoveOldError,
    XXLockStepRemoveReOld
};

@interface XXLockViewController () <XXLockSudokoDelegate>

@property (nonatomic, weak) id<XXLockViewControllerDelegate> delegate;
@property (nonatomic, assign) XXLockType       type;
@property (nonatomic, assign) XXLockAppearMode appearMode;

@property (nonatomic, strong) XXLockIndicator  *indicator;
@property (nonatomic, strong) XXLockSudoko     *sudoko;
@property (nonatomic, strong) UILabel          *noticeLabel;
@property (nonatomic, strong) UIButton         *resetButton;
@property (nonatomic, strong) UIButton         *forgetButton;
@property (nonatomic, strong) UIButton         *touchIdButton;

@property (nonatomic, assign) XXLockStep       step;
@property (nonatomic, strong) NSString         *passcodeTemp;
@property (nonatomic, strong) LAContext        *context;

@end

@implementation XXLockViewController

#pragma mark - Override

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setup];
    [self createViews];
    
    switch (self.type)
    {
        case XXLockTypeCreate:
        {
            [self updateUiForStep:XXLockStepCreateNew];
        }
            break;
        case XXLockTypeModify:
        {
            [self updateUiForStep:XXLockStepModifyOld];
        }
            break;
        case XXLockTypeVerify:
        {
            [self updateUiForStep:XXLockStepVerifyOld];
            
            if ([XXLockTool isTouchIdUnlockEnabled] && [XXLockTool isTouchIdSupported])
            {
                [self showTouchIdView];
            }
        }
            break;
        case XXLockTypeRemove:
        {
            [self updateUiForStep:XXLockStepRemoveOld];
        }
            break;
        default:
            break;
    }
}

#pragma mark - Init

- (instancetype)initWithDelegate:(id<XXLockViewControllerDelegate>)delegate
                            type:(XXLockType)type
                      appearMode:(XXLockAppearMode)appearMode
{
    self = [super init];
    
    if (self)
    {
        self.delegate   = delegate;
        self.type       = type;
        self.appearMode = appearMode;
    }
    
    return self;
}

- (void)setup
{
    self.view.backgroundColor = XX_LOCK_COLOR_BACKGROUND;
    self.step = XXLockStepNone;
    self.context = [[LAContext alloc] init];
}

- (void)createViews
{
    XXLockSudoko *sudoko = [[XXLockSudoko alloc] init];
    [sudoko setDelegate:self];
    [self.view addSubview:sudoko];
    [self setSudoko:sudoko];
    [sudoko mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(kSudokoSideLength, kSudokoSideLength));
    }];
    
    XXLockIndicator *indicator = [[XXLockIndicator alloc] init];
    [self.view addSubview:indicator];
    [self setIndicator:indicator];
    [indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(sudoko.mas_top).offset(-20);
        make.size.mas_equalTo(CGSizeMake(kIndicatorSideLength, kIndicatorSideLength));
    }];
    
    UILabel *noticeLabel = [[UILabel alloc] init];
    [noticeLabel setFont:[UIFont systemFontOfSize:14]];
    [noticeLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:noticeLabel];
    [self setNoticeLabel:noticeLabel];
    [noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(indicator.mas_top).offset(-30);
        make.height.mas_equalTo(20);
    }];
    
    UIButton *resetButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [resetButton setTitle:kXXLockResetText forState:UIControlStateNormal];
    [resetButton setTitleColor:XX_LOCK_COLOR_BUTTON forState:UIControlStateNormal];
    [resetButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [resetButton addTarget:self action:@selector(resetButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resetButton];
    [self setResetButton:resetButton];
    [resetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(sudoko.mas_bottom).offset(20);
        make.height.mas_equalTo(20);
    }];
    
    UIButton *forgetButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [forgetButton setTitle:kXXLockForgetText forState:UIControlStateNormal];
    [forgetButton setTitleColor:XX_LOCK_COLOR_BUTTON forState:UIControlStateNormal];
    [forgetButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [forgetButton addTarget:self action:@selector(forgetButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetButton];
    [self setForgetButton:forgetButton];
    [forgetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(sudoko.mas_bottom).offset(20);
        make.height.mas_equalTo(20);
    }];
    
    UIButton *touchIdButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [touchIdButton setTitle:kXXLockTouchIdText forState:UIControlStateNormal];
    [touchIdButton setTitleColor:XX_LOCK_COLOR_BUTTON forState:UIControlStateNormal];
    [touchIdButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [touchIdButton addTarget:self action:@selector(touchIdButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:touchIdButton];
    [self setTouchIdButton:touchIdButton];
    [touchIdButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(sudoko.mas_bottom).offset(20);
        make.height.mas_equalTo(20);
    }];
}

#pragma mark - Private

- (void)showTouchIdView
{
    [self.context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                 localizedReason:@"通过验证指纹解锁"
                           reply:^(BOOL success, NSError * _Nullable error) {
                               if (success)
                               {
                                   [self hide];
                               }
                           }];
}

- (void)updateUiForStep:(XXLockStep)step
{
    self.step = step;
    
    switch (step)
    {
        case XXLockStepCreateNew:
        {
            self.noticeLabel.text = kXXLockNewText;
            self.noticeLabel.textColor = XX_LOCK_COLOR_NORMAL;
            self.indicator.hidden = YES;
            self.resetButton.hidden = YES;
            self.touchIdButton.hidden = YES;
            self.forgetButton.hidden = YES;
        }
            break;
        case XXLockStepCreateAgain:
        {
            self.noticeLabel.text = kXXLockAgainText;
            self.noticeLabel.textColor = XX_LOCK_COLOR_NORMAL;
            self.indicator.hidden = NO;
            self.resetButton.hidden = NO;
            self.touchIdButton.hidden = YES;
            self.forgetButton.hidden = YES;
        }
            break;
        case XXLockStepCreateNotMatch:
        {
            self.noticeLabel.text = kXXLockNotMatchText;
            self.noticeLabel.textColor = XX_LOCK_COLOR_ERROR;
            self.indicator.hidden = YES;
            self.resetButton.hidden = YES;
            self.touchIdButton.hidden = YES;
            self.forgetButton.hidden = YES;
        }
            break;
        case XXLockStepCreateReNew:
        {
            self.noticeLabel.text = kXXLockReNewText;
            self.noticeLabel.textColor = XX_LOCK_COLOR_NORMAL;
            self.indicator.hidden = YES;
            self.resetButton.hidden = YES;
            self.touchIdButton.hidden = YES;
            self.forgetButton.hidden = YES;
        }
            break;
        case XXLockStepModifyOld:
        {
            self.noticeLabel.text = kXXLockOldText;
            self.noticeLabel.textColor = XX_LOCK_COLOR_NORMAL;
            self.indicator.hidden = YES;
            self.resetButton.hidden = YES;
            self.touchIdButton.hidden = YES;
            self.forgetButton.hidden = YES;
        }
            break;
        case XXLockStepModifyOldError:
        {
            self.noticeLabel.text = kXXLockOldErrorText;
            self.noticeLabel.textColor = XX_LOCK_COLOR_ERROR;
            self.indicator.hidden = YES;
            self.resetButton.hidden = YES;
            self.touchIdButton.hidden = YES;
            self.forgetButton.hidden = YES;
        }
            break;
        case XXLockStepModifyReOld:
        {
            self.noticeLabel.text = kXXLockReOldText;
            self.noticeLabel.textColor = XX_LOCK_COLOR_NORMAL;
            self.indicator.hidden = YES;
            self.resetButton.hidden = YES;
            self.touchIdButton.hidden = YES;
            self.forgetButton.hidden = YES;
        }
            break;
        case XXLockStepModifyNew:
        {
            self.noticeLabel.text = kXXLockNewText;
            self.noticeLabel.textColor = XX_LOCK_COLOR_NORMAL;
            self.indicator.hidden = YES;
            self.resetButton.hidden = YES;
            self.touchIdButton.hidden = YES;
            self.forgetButton.hidden = YES;
        }
            break;
        case XXLockStepModifyAgain:
        {
            self.noticeLabel.text = kXXLockAgainText;
            self.noticeLabel.textColor = XX_LOCK_COLOR_NORMAL;
            self.indicator.hidden = NO;
            self.resetButton.hidden = NO;
            self.touchIdButton.hidden = YES;
            self.forgetButton.hidden = YES;
        }
            break;
        case XXLockStepModifyNotMatch:
        {
            self.noticeLabel.text = kXXLockNotMatchText;
            self.noticeLabel.textColor = XX_LOCK_COLOR_ERROR;
            self.indicator.hidden = YES;
            self.resetButton.hidden = YES;
            self.touchIdButton.hidden = YES;
            self.forgetButton.hidden = YES;
        }
            break;
        case XXLockStepModifyReNew:
        {
            self.noticeLabel.text = kXXLockReNewText;
            self.noticeLabel.textColor = XX_LOCK_COLOR_NORMAL;
            self.indicator.hidden = YES;
            self.resetButton.hidden = YES;
            self.touchIdButton.hidden = YES;
            self.forgetButton.hidden = YES;
        }
            break;
        case XXLockStepVerifyOld:
        {
            self.noticeLabel.text = kXXLockVerifyText;
            self.noticeLabel.textColor = XX_LOCK_COLOR_NORMAL;
            self.indicator.hidden = YES;
            self.resetButton.hidden = YES;
            self.forgetButton.hidden = YES;
            
            if ([XXLockTool isTouchIdUnlockEnabled] && [XXLockTool isTouchIdSupported])
            {
                self.touchIdButton.hidden = NO;
            }
            else
            {
                self.touchIdButton.hidden = YES;
            }
        }
            break;
        case XXLockStepVerifyOldError:
        {
            self.noticeLabel.text = kXXLockOldErrorText;
            self.noticeLabel.textColor = XX_LOCK_COLOR_ERROR;
            self.indicator.hidden = YES;
            self.resetButton.hidden = YES;
            self.touchIdButton.hidden = YES;
            self.forgetButton.hidden = YES;
        }
            break;
        case XXLockStepVerifyReOld:
        {
            self.noticeLabel.text = kXXLockReVerifyText;
            self.noticeLabel.textColor = XX_LOCK_COLOR_NORMAL;
            self.indicator.hidden = YES;
            self.resetButton.hidden = YES;
            self.forgetButton.hidden = YES;
            
            if ([XXLockTool isTouchIdUnlockEnabled] && [XXLockTool isTouchIdSupported])
            {
                self.touchIdButton.hidden = NO;
            }
            else
            {
                self.touchIdButton.hidden = YES;
            }
        }
            break;
        case XXLockStepRemoveOld:
        {
            self.noticeLabel.text = kXXLockOldText;
            self.noticeLabel.textColor = XX_LOCK_COLOR_NORMAL;
            self.indicator.hidden = YES;
            self.resetButton.hidden = YES;
            self.touchIdButton.hidden = YES;
            self.forgetButton.hidden = YES;
        }
            break;
        case XXLockStepRemoveOldError:
        {
            self.noticeLabel.text = kXXLockOldErrorText;
            self.noticeLabel.textColor = XX_LOCK_COLOR_ERROR;
            self.indicator.hidden = YES;
            self.resetButton.hidden = YES;
            self.touchIdButton.hidden = YES;
            self.forgetButton.hidden = NO;
        }
            break;
        case XXLockStepRemoveReOld:
        {
            self.noticeLabel.text = kXXLockReOldText;
            self.noticeLabel.textColor = XX_LOCK_COLOR_NORMAL;
            self.indicator.hidden = YES;
            self.resetButton.hidden = YES;
            self.touchIdButton.hidden = YES;
            self.forgetButton.hidden = NO;
        }
        default:
            break;
    }
}

- (void)shakeAnimationForView:(UIView *)view
{
    CALayer *viewLayer = view.layer;
    CGPoint position = viewLayer.position;
    CGPoint left = CGPointMake(position.x - 10, position.y);
    CGPoint right = CGPointMake(position.x + 10, position.y);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setFromValue:[NSValue valueWithCGPoint:left]];
    [animation setToValue:[NSValue valueWithCGPoint:right]];
    [animation setAutoreverses:YES];
    [animation setDuration:0.08];
    [animation setRepeatCount:3];
    [viewLayer addAnimation:animation forKey:nil];
}

#pragma mark - Action

- (void)hide
{
    if (self.appearMode == XXLockAppearModePush)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (self.appearMode == XXLockAppearModePresent)
    {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

- (void)resetButtonClicked
{
    if (self.type == XXLockTypeCreate)
    {
        [self updateUiForStep:XXLockStepCreateNew];
    }
    else if (self.type == XXLockTypeModify)
    {
        [self updateUiForStep:XXLockStepModifyNew];
    }
}

- (void)forgetButtonClicked
{
    if ([self.delegate respondsToSelector:@selector(passcodeDidForget)]) {
        [self.delegate passcodeDidForget];
    }
}

- (void)touchIdButtonClicked
{
    [self showTouchIdView];
}

#pragma mark - XXLockSudokoDelegate

- (void)sudoko:(XXLockSudoko *)sudoko passcodeDidCreate:(NSString *)passcode
{
    if ([passcode length] < kConnectionMinNum)
    {
        [self.noticeLabel setText:XX_LOCK_NOT_ENOUGH];
        [self.noticeLabel setTextColor:XX_LOCK_COLOR_ERROR];
        [self shakeAnimationForView:self.noticeLabel];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self updateUiForStep:self.step];
        });
        
        return;
    }
    
    switch (self.step)
    {
        case XXLockStepCreateNew:
        case XXLockStepCreateReNew:
        {
            self.passcodeTemp = passcode;
            [self updateUiForStep:XXLockStepCreateAgain];
        }
            break;
        case XXLockStepCreateAgain:
        {
            if ([passcode isEqualToString:self.passcodeTemp])
            {
                [XXLockTool setGestureUnlockEnabled:YES];
                [XXLockTool setGesturePasscode:passcode];
                
                if ([self.delegate respondsToSelector:@selector(passcodeDidCreate:)])
                {
                    [self.delegate passcodeDidCreate:passcode];
                }
                
                [self hide];
            }
            else
            {
                [self updateUiForStep:XXLockStepCreateNotMatch];
                [self.sudoko showErrorPasscode:passcode];
                [self shakeAnimationForView:self.noticeLabel];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self updateUiForStep:XXLockStepCreateReNew];
                });
            }
        }
            break;
        case XXLockStepModifyOld:
        case XXLockStepModifyReOld:
        {
            if ([passcode isEqualToString:[XXLockTool currentGesturePasscode]])
            {
                [self updateUiForStep:XXLockStepModifyNew];
            }
            else
            {
                [self updateUiForStep:XXLockStepModifyOldError];
                [self.sudoko showErrorPasscode:passcode];
                [self shakeAnimationForView:self.noticeLabel];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self updateUiForStep:XXLockStepModifyReOld];
                });
            }
        }
            break;
        case XXLockStepModifyNew:
        case XXLockStepModifyReNew:
        {
            self.passcodeTemp = passcode;
            [self updateUiForStep:XXLockStepModifyAgain];
        }
            break;
        case XXLockStepModifyAgain:
        {
            if ([passcode isEqualToString:self.passcodeTemp])
            {
                [XXLockTool setGestureUnlockEnabled:YES];
                [XXLockTool setGesturePasscode:passcode];
                
                if ([self.delegate respondsToSelector:@selector(passcodeDidModify:)])
                {
                    [self.delegate passcodeDidModify:passcode];
                }
                
                [self hide];
            }
            else
            {
                [self updateUiForStep:XXLockStepModifyNotMatch];
                [self.sudoko showErrorPasscode:passcode];
                [self shakeAnimationForView:self.noticeLabel];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self updateUiForStep:XXLockStepModifyReNew];
                });
            }
        }
            break;
        case XXLockStepVerifyOld:
        case XXLockStepVerifyReOld:
        {
            if ([passcode isEqualToString:[XXLockTool currentGesturePasscode]])
            {
                if ([self.delegate respondsToSelector:@selector(passcodeDidVerify:)])
                {
                    [self.delegate passcodeDidVerify:passcode];
                }
                
                [self hide];
            }
            else
            {
                [self updateUiForStep:XXLockStepVerifyOldError];
                [self.sudoko showErrorPasscode:passcode];
                [self shakeAnimationForView:self.noticeLabel];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self updateUiForStep:XXLockStepVerifyReOld];
                });
            }
        }
            break;
        case XXLockStepRemoveOld:
        case XXLockStepRemoveReOld:
        {
            if ([passcode isEqualToString:[XXLockTool currentGesturePasscode]])
            {
                [XXLockTool setGestureUnlockEnabled:NO];
                
                if ([self.delegate respondsToSelector:@selector(passcodeDidRemove)])
                {
                    [self.delegate passcodeDidRemove];
                }
                
                [self hide];
            }
            else
            {
                [self updateUiForStep:XXLockStepRemoveOldError];
                [self.sudoko showErrorPasscode:passcode];
                [self shakeAnimationForView:self.noticeLabel];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self updateUiForStep:XXLockStepRemoveReOld];
                });
            }
        }
            break;
        default:
            break;
    }
    
    [self.indicator showPasscode:passcode];
}

@end
