//
//  UIView+Utils.m
//  SCGOV
//
//  Created by solehe on 2019/3/15.
//  Copyright © 2019 Enrising. All rights reserved.
//

#import "UIView+Utils.h"
#import <objc/runtime.h>

static const void *XWBottomLineKey = &XWBottomLineKey;

@implementation UIView (Utils)

static char *changeScopeKey;

// 加载Xib创建的View
+ (UIView *)loadNibNamed:(NSString *)name owner:(id)owner {
    return [[NSBundle mainBundle] loadNibNamed:name owner:owner options:nil][0];
}

// 生成高斯模糊图片
+ (UIVisualEffectView *)visualEffectView:(CGSize)size {
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0, 0, size.width, size.height);
    
    // 加上以下代码可以使毛玻璃特效更明亮点
    UIVibrancyEffect *vibrancyView = [UIVibrancyEffect effectForBlurEffect:effect];
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:vibrancyView];
    [visualEffectView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [effectView.contentView addSubview:visualEffectView];
    
    return effectView;
}

// 截图
- (UIImage *)snapshotImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    [self drawViewHierarchyInRect:self.frame afterScreenUpdates:YES];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshotImage;
}



/**
    添加阴影
 */
- (void)addShadowColor:(UIColor *)theColor offSet:(CGSize)offSet {
    // 阴影颜色
    self.layer.shadowColor = theColor.CGColor;
    // 阴影偏移，默认(0, -3)
    self.layer.shadowOffset = offSet;
    // 阴影透明度，默认0
    self.layer.shadowOpacity = 0.5;
    // 阴影半径，默认3
    self.layer.shadowRadius = 5;
}

- (void)addShadowColor:(UIColor *)theColor offSet:(CGSize)offSet radius:(CGFloat)radius{
    
    self.layer.cornerRadius= radius;
    self.layer.shadowColor= theColor.CGColor;
    self.layer.shadowOffset= offSet;
    self.layer.shadowOpacity= 0.5;
    self.layer.shadowRadius= 3;
}

/**
 渐变色
 */

+ (Class)layerClass {
    return [CAGradientLayer class];
}

+ (UIView *)az_gradientViewWithColors:(NSArray<UIColor *> *)colors locations:(NSArray<NSNumber *> *)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    UIView *view = [[self alloc] init];
    [view az_setGradientBackgroundWithColors:colors locations:locations startPoint:startPoint endPoint:endPoint];
    return view;
}

- (void)az_setGradientBackgroundWithColors:(NSArray<UIColor *> *)colors locations:(NSArray<NSNumber *> *)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    NSMutableArray *colorsM = [NSMutableArray array];
    for (UIColor *color in colors) {
        [colorsM addObject:(__bridge id)color.CGColor];
    }
    self.az_colors = [colorsM copy];
    self.az_locations = locations;
    self.az_startPoint = startPoint;
    self.az_endPoint = endPoint;
}

#pragma mark- Getter&Setter

- (NSArray *)az_colors {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setAz_colors:(NSArray *)colors {
    objc_setAssociatedObject(self, @selector(az_colors), colors, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if ([self.layer isKindOfClass:[CAGradientLayer class]]) {
        [((CAGradientLayer *)self.layer) setColors:self.az_colors];
    }
}

- (NSArray<NSNumber *> *)az_locations {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setAz_locations:(NSArray<NSNumber *> *)locations {
    objc_setAssociatedObject(self, @selector(az_locations), locations, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if ([self.layer isKindOfClass:[CAGradientLayer class]]) {
        [((CAGradientLayer *)self.layer) setLocations:self.az_locations];
    }
}

- (CGPoint)az_startPoint {
    return [objc_getAssociatedObject(self, _cmd) CGPointValue];
}

- (void)setAz_startPoint:(CGPoint)startPoint {
    objc_setAssociatedObject(self, @selector(az_startPoint), [NSValue valueWithCGPoint:startPoint], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([self.layer isKindOfClass:[CAGradientLayer class]]) {
        [((CAGradientLayer *)self.layer) setStartPoint:self.az_startPoint];
    }
}

- (CGPoint)az_endPoint {
    return [objc_getAssociatedObject(self, _cmd) CGPointValue];
}

- (void)setAz_endPoint:(CGPoint)endPoint {
    objc_setAssociatedObject(self, @selector(az_endPoint), [NSValue valueWithCGPoint:endPoint], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([self.layer isKindOfClass:[CAGradientLayer class]]) {
        [((CAGradientLayer *)self.layer) setEndPoint:self.az_endPoint];
    }
}


#pragma mark - Scale.

NSString * const _recognizerScale = @"_recognizerScale";

- (void)setScale:(CGFloat)scale {
    
    objc_setAssociatedObject(self, (__bridge const void *)(_recognizerScale), @(scale), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.transform = CGAffineTransformMakeScale(scale, scale);
}

- (CGFloat)scale {
    
    NSNumber *scaleValue = objc_getAssociatedObject(self, (__bridge const void *)(_recognizerScale));
    return scaleValue.floatValue;
}

#pragma mark - Angle.

NSString * const _recognizerAngle = @"_recognizerAngle";

- (void)setAngle:(CGFloat)angle {
    
    objc_setAssociatedObject(self, (__bridge const void *)(_recognizerAngle), @(angle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.transform = CGAffineTransformMakeRotation(angle);
}

- (CGFloat)angle {
    
    NSNumber *angleValue = objc_getAssociatedObject(self, (__bridge const void *)(_recognizerAngle));
    return angleValue.floatValue;
}


- (void)setChangeScope:(NSString *)changeScope
{
    objc_setAssociatedObject(self, &changeScopeKey, changeScope, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)changeScope
{
    return objc_getAssociatedObject(self, &changeScopeKey);
}

- (void)changeViewScope:(UIEdgeInsets)changeInsets
{
    self.changeScope = NSStringFromUIEdgeInsets(changeInsets);
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    UIEdgeInsets changeInsets = UIEdgeInsetsFromString(self.changeScope);
    if (changeInsets.left != 0 || changeInsets.top != 0 || changeInsets.right != 0 || changeInsets.bottom != 0) {
        CGRect myBounds = self.bounds;
        myBounds.origin.x = myBounds.origin.x + changeInsets.left;
        myBounds.origin.y = myBounds.origin.y + changeInsets.top;
        myBounds.size.width = myBounds.size.width - changeInsets.left - changeInsets.right;
        myBounds.size.height = myBounds.size.height - changeInsets.top - changeInsets.bottom;
        return CGRectContainsPoint(myBounds, point);
    } else {
        return CGRectContainsPoint(self.bounds,point);
    }
}
- (void)showBottomLineWithXSpace:(CGFloat)xSpace andColor:(UIColor *)color
{
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = color;
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self);
        make.height.mas_offset(@1.);
        make.left.equalTo(self).offset(xSpace);
    }];
    [self setCustomBottomLine:line];
}

- (void)showBottomLineWithHeight:(CGFloat)height
{
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = RGB16(0xeeeeee);
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(@(height));
        make.left.equalTo(self);
    }];
    [self setCustomBottomLine:line];
}

- (void)showBottomLineWithXSpace:(CGFloat)xSpace {
    [self showBottomLineWithXSpace:xSpace andColor:[UIColor xwColorWithHexString:@"#EEEEEE"]];
}

- (void)showBottomLineWithLeftSpace:(CGFloat)leftSpace RightSpace:(CGFloat)rightSpace
{
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor xwColorWithHexString:@"#EEEEEE"];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.height.mas_offset(@1.);
        make.left.equalTo(self).offset(leftSpace);
        make.right.equalTo(self).offset(rightSpace);
    }];
    [self setCustomBottomLine:line];
}

- (void)showTopLineWithXSpace:(CGFloat)xSpace
{
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor xwColorWithHexString:@"#E4E4E4"];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self);
        make.height.mas_offset(@1.);
        make.left.equalTo(self).offset(xSpace);
    }];
    [self setCustomBottomLine:line];
}
- (void)showTopLineWithHeight:(CGFloat)height
{
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor xwColorWithHexString:@"#EEEEEE"];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self);
        make.height.equalTo(@(height));
        make.left.equalTo(self).offset(0);
    }];
    [self setCustomBottomLine:line];
}

- (void)setCustomBottomLine:(UIView *)customBottomLine{
    objc_setAssociatedObject(self, XWBottomLineKey, customBottomLine, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/** 画圆角*/
- (void)xwDrawCornerWithRadiuce:(CGFloat)radiuce
{
    [self xwDrawBorderWithColor:[UIColor clearColor] radiuce:radiuce width:1.0f];
}

//某几个边写圆角
- (void)xwDrawbyRoundingCorners:(UIRectCorner)corners withRadiuce:(CGFloat)radiuce
{
    if (@available(iOS 11.0, *)) {
        self.layer.cornerRadius = radiuce;
        self.layer.maskedCorners = (CACornerMask)corners;
    } else {
        UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:radiuce cornerRadii:CGSizeMake(radiuce, radiuce)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        maskLayer.path = path.CGPath;
        self.layer.mask = maskLayer;
    }
}

- (void)xwDrawbyRoundingCorners:(UIRectCorner)corners withRadiuce:(CGFloat)radiuce width:(CGFloat)width color:(UIColor *)color
{
    if (@available(iOS 11.0, *)) {
        self.layer.cornerRadius = radiuce;
        self.layer.maskedCorners = (CACornerMask)corners;
        self.layer.borderWidth = width;
        self.layer.borderColor = color.CGColor;
    } else {
        UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:radiuce cornerRadii:CGSizeMake(radiuce, radiuce)];
        path.lineWidth = width;
        [color set];
        [path stroke];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        maskLayer.path = path.CGPath;
        
        self.layer.mask = maskLayer;
    }
}

/** 绘制边框*/
- (void)xwDrawBorderWithColor:(UIColor *)color radiuce:(CGFloat)radiuce width:(CGFloat)width
{
    if (color) {
        self.layer.borderColor = color.CGColor;
    }
    self.layer.borderWidth = width;
    self.layer.cornerRadius = radiuce;
    self.layer.masksToBounds = YES;
}

- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x {
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (CGFloat)left
{
    return self.frame.origin.x;
}
- (void)setLeft:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}
- (void)setRight:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}
- (void)setBottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)top
{
    return self.frame.origin.y;
}
- (void)setTop:(CGFloat)top
{
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}
- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}
- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;}

- (CGFloat)centerX
{
    return self.center.x;
}
- (void)setCenterX:(CGFloat)centerX
{
    self.center = CGPointMake(centerX, self.center.y);
    
}

- (CGFloat)centerY
{
    return self.center.y;
}
- (void)setCenterY:(CGFloat)centerY
{
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGPoint)origin
{
    return self.frame.origin;
}
- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}
- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}


@end
