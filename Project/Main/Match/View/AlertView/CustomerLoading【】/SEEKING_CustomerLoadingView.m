//
//  SEEKING_CustomerLoadingView.m
//  Project
//
//  Created by XuWen on 2020/3/8.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "SEEKING_CustomerLoadingView.h"
#define kBMSCREEN_WIDTH    [[UIScreen mainScreen] bounds].size.width
#define kBMSCREEN_HEIGHT   [[UIScreen mainScreen] bounds].size.height
#define kCoverPictureHW 140
static const CGFloat kCoverPictureRippleDuration = 6;
static const CGFloat kCoverPictureRippleCount = 5;
@interface SEEKING_CustomerLoadingView ()
@property (nonatomic,strong) UIImageView *coverImageView;
@property (nonatomic,strong) UIImageView *bgImageView;

@property (nonatomic, strong) NSMutableArray<CALayer *> *rippleArray;
@property (nonatomic, strong) NSMutableArray<CALayer *> *rippleCircleArray;
@end

@implementation SEEKING_CustomerLoadingView

+ (void)showLoadingInView:(UIView *)view
{
    //没有就要新建
    SEEKING_CustomerLoadingView *loadingView = [SEEKING_CustomerLoadingView share];
    // 头像要更新
    [loadingView.coverImageView sd_setImageWithURL:[NSURL URLWithString:kUser.images] placeholderImage:XWImageName(kLanguage(@"chat_placeholder"))];
    [view addSubview:loadingView];
    [loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
}

+ (void)hideLoadinginView:(UIView *)view
{
    [[SEEKING_CustomerLoadingView share] removeFromSuperview];
}

//单例
static SEEKING_CustomerLoadingView *__singletion;
+ (instancetype)share {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __singletion = [[self alloc] initWithFrame:CGRectZero];
    });
    return __singletion;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self SEEKING_baseUIConfig];
        [self baseConstriantsConfig];
        [self animation];
        
    }
    return self;
}

#pragma mark - animation
- (void)animation
{
    //头像旋转
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.duration = 15;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.toValue = @(M_PI*2);
    [self.coverImageView.layer addAnimation:animation forKey:@"rotationAnimation"];
    
    //动画展示view
    UIView *animationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
    [self addSubview:animationView];
    [animationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@200);
        make.center.equalTo(self);
    }];
    [self bringSubviewToFront:self.coverImageView];
    
    for(int i = 0 ;i< kCoverPictureRippleCount; i++){
        CALayer *animationLayer = [CALayer layer];
        animationLayer.backgroundColor = [UIColor whiteColor].CGColor;
        animationLayer.frame = CGRectMake(0, 0, 140, 140);
        animationLayer.position = CGPointMake((animationView.width)/2, (animationView.width)/2);
        animationLayer.cornerRadius = 70;
        [animationView.layer addSublayer:animationLayer];
        
        //动画开始
        CAMediaTimingFunction * defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        
//        CAAnimationGroup * animationGroup = [CAAnimationGroup animation];
//        animationGroup.fillMode = kCAFillModeBackwards;
//        animationGroup.beginTime = CACurrentMediaTime() + i * kCoverPictureRippleDuration / kCoverPictureRippleCount;
//        animationGroup.duration = kCoverPictureRippleDuration;
//        animationGroup.repeatCount = HUGE;
//        animationGroup.timingFunction = defaultCurve;
        //放大动画
        
        CABasicAnimation * scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.fromValue = @(1.0);
        scaleAnimation.toValue = @2.5;
        scaleAnimation.beginTime = CACurrentMediaTime() + i * kCoverPictureRippleDuration / kCoverPictureRippleCount;
        scaleAnimation.fillMode = kCAFillModeBackwards;
        scaleAnimation.timingFunction = defaultCurve;
        scaleAnimation.duration = kCoverPictureRippleDuration;
        scaleAnimation.repeatCount = HUGE;
        scaleAnimation.removedOnCompletion = NO;
        
        //淡化动画
        CAKeyframeAnimation * opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.beginTime = CACurrentMediaTime() + i * kCoverPictureRippleDuration / kCoverPictureRippleCount;
        opacityAnimation.values = @[@0.3, @0.5, @0];
        opacityAnimation.keyTimes = @[@0, @0.3, @1];
        opacityAnimation.duration = kCoverPictureRippleDuration;
        opacityAnimation.repeatCount = HUGE;
        opacityAnimation.timingFunction = defaultCurve;
        opacityAnimation.removedOnCompletion = NO;
        opacityAnimation.fillMode = kCAFillModeForwards;
        
        //开始动画
        [animationLayer addAnimation:scaleAnimation forKey:@"plulsing"];
        [animationLayer addAnimation:opacityAnimation forKey:@"plulsidsadang"];
    }
}


#pragma mark - baseConfig1
- (void)SEEKING_baseUIConfig
{
    [self addSubview:self.bgImageView];
    [self addSubview:self.coverImageView];
}

- (void)baseConstriantsConfig
{
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@140);
        make.center.equalTo(self);
    }];
}


#pragma mark - setter & getter1
- (UIImageView *)bgImageView
{
    if(!_bgImageView){
//        _bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0+YH(525)*0.1, kSCREEN_WIDTH-XW(40), YH(525)-YH(525)*0.1)];
        _bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
        _bgImageView.image = XWImageName(@"commonBg");
        _bgImageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _bgImageView;
}

- (UIImageView *)coverImageView
{
    if(!_coverImageView){
        _coverImageView = [[UIImageView alloc]init];
        _coverImageView.backgroundColor = [UIColor placeholderColor];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImageView.frame = CGRectMake(0, 0, 140, 140);
        [_coverImageView xwDrawBorderWithColor:[UIColor whiteColor] radiuce:70 width:2];
    }
    return _coverImageView;
}

@end
