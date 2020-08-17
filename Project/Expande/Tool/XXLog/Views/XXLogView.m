//
//  XXLogView.m
//  SCGov
//
//  Created by solehe on 2019/7/22.
//  Copyright © 2019 solehe. All rights reserved.
//

#import "XXLogView.h"
#import "XXLogSqureView.h"
#import "XXLogCircleView.h"

@interface XXLogView ()
<
    XXLogSqureViewDelegate,
    XXLogCircleViewDelegate
>

// 控件是否在拖动中
@property (nonatomic, assign) BOOL running;
// 上次拖拽位置
@property (nonatomic, assign) CGPoint point;

// 圆形悬浮界面
@property (nonatomic, strong) XXLogCircleView *circleView;
// 矩形日志界面
@property (nonatomic, strong) XXLogSqureView *squreView;

@end


@implementation XXLogView

- (void)initialization {
    [self setEnabelDrag:YES];
}

- (void)setCenter:(CGPoint)center {
    [super setCenter:center];
    [self setPoint:center];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialization];
        [self createUI];
    }
    return self;
}

- (void)createUI {
    
    // 缩略界面
    self.circleView = [[XXLogCircleView alloc] init];
    [self.circleView setBackgroundColor:[UIColor redColor]];
    [self.circleView setDelegate:self];
    [self addSubview:self.circleView];
    
    [self.circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    // 展开界面
    self.squreView = [[XXLogSqureView alloc] init];
    [self.squreView setBackgroundColor:[UIColor blueColor]];
    [self.squreView setDelegate:self];
    [self.squreView setHidden:YES];
    [self addSubview:self.squreView];
    
    [self.squreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
}

// 修改日志控件展示样式
- (void)setLogStyle:(XXLogStyle)logStyle {
    
    if (_logStyle != logStyle) {
        _logStyle = logStyle;
        
        [self updateShowLoginModel];
    }
}

- (void)updateShowLoginModel {
    
    __weak typeof(self) weakSelf = self;
    if (_logStyle == XXLogStyleSquare) {
        
        [weakSelf.circleView setHidden:YES];
        [weakSelf.squreView setHidden:NO];
        [self.squreView setAlpha:0.f];
        
        [UIView animateWithDuration:0.3f animations:^{
            [weakSelf setFrame:CGRectMake(0, kSCREEN_HEIGHT-YH(350), kSCREEN_WIDTH, YH(350))];
            [weakSelf.layer setCornerRadius:0.f];
            [weakSelf.squreView setAlpha:1.f];
        } completion:^(BOOL finished) {
            [weakSelf.layer setMasksToBounds:YES];
        }];
        
    } else {
        
        [self.squreView setHidden:YES];
        
        [UIView animateWithDuration:0.3f animations:^{
            [weakSelf setFrame:CGRectMake(self.point.x-30, self.point.y-30, 60, 60)];
            [weakSelf.layer setCornerRadius:30.f];
        } completion:^(BOOL finished) {
            [weakSelf.layer setMasksToBounds:YES];
            
            [weakSelf.circleView setHidden:NO];
            [weakSelf.circleView setAlpha:0.f];
            [UIView animateWithDuration:0.2 animations:^{
                [weakSelf.circleView setAlpha:1.f];
            }];
        }];
    }
}

#pragma mark - delegate
- (void)logSqureViewDidClose:(XXLogSqureView *)squreView {
    [self setLogStyle:XXLogStyleCircle];
}

- (void)logCircleViewDidClose:(XXLogCircleView *)circleView {
    [self setLogStyle:XXLogStyleSquare];
}


#pragma mark - drag

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (self.logStyle == XXLogStyleCircle) {
        
        CGPoint point = [[touches anyObject] locationInView:[UIApplication sharedApplication].delegate.window];
        
        if (self.running || [self allow:point]) {
            [self moveToPoint:point];
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self adjustLoction:[[touches anyObject] locationInView:[UIApplication sharedApplication].delegate.window]];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self adjustLoction:[[touches anyObject] locationInView:[UIApplication sharedApplication].delegate.window]];
}

// 调整拖动结束时的h悬浮位置
- (void)adjustLoction:(CGPoint)point {
    
    CGFloat x = point.x;
    if (x < -CGRectGetWidth(self.frame)/2) {
        x = -CGRectGetWidth(self.frame)/2;
    } else if (x > kSCREEN_WIDTH + CGRectGetWidth(self.frame)/2) {
        x = kSCREEN_WIDTH + CGRectGetWidth(self.frame)/2;
    }
    
    CGFloat y = point.y;
    if (y < -CGRectGetHeight(self.frame)/2) {
        y = -CGRectGetHeight(self.frame)/2;
    } else if (y > kSCREEN_HEIGHT + CGRectGetHeight(self.frame)/2) {
        y = kSCREEN_HEIGHT + CGRectGetHeight(self.frame)/2;
    }
    
    [self moveToPoint:CGPointMake(x, y)];
    
    // 结束移动
    [self setRunning:NO];
}

// 移动日志悬浮控件
- (void)moveToPoint:(CGPoint)point {
    if (self.logStyle == XXLogStyleCircle && self.running && self.enabelDrag) {
        [self setCenter:point];
        [self setPoint:point];
    }
}

// 首次必须移动超过一定距离才能继续，防止误点
- (BOOL)allow:(CGPoint)point {
    
    CGPoint center = self.center;
    
    CGFloat x = fabs(point.x - center.x);
    CGFloat y = fabs(point.y - center.y);
    
    if (sqrt(x * x + y * y) >= 30.f) {
        [self setRunning:YES];
    }
    
    return self.running;
}

#pragma mark -
// 添加日志
- (void)addLog:(XXLogModel *)log {
    [self.squreView addLog:log];
}

// 清空日志
- (void)clear {
    [self.squreView clear];
}

@end
