//
//  XXLogSqureView.m
//  SCGov
//
//  Created by solehe on 2019/7/22.
//  Copyright © 2019 solehe. All rights reserved.
//

#import "XXLogSqureView.h"
#import "XXLogSqurePopView.h"

@interface XXLogSqureView ()
<
    UITableViewDelegate,
    UITableViewDataSource,
    UIGestureRecognizerDelegate
>

// 日志显示列表
@property (nonatomic, strong) UITableView *tableView;
// 拖拽控件
@property (nonatomic, strong) XXLogSqureDragView *dragView;
// 选择弹出框
@property (nonatomic, strong) XXLogSqurePopView *popView;
// 日志数据
@property (nonatomic, strong) NSMutableArray<XXLogModel *> *logs;

@end

@implementation XXLogSqureView

- (NSMutableArray<XXLogModel *> *)logs {
    if (!_logs) {
        _logs = [NSMutableArray array];
    }
    return _logs;
}

- (XXLogSqurePopView *)popView {
    
    if (!_popView) {
        
        _popView = [[XXLogSqurePopView alloc] init];
        [_popView setBackgroundColor:[UIColor whiteColor]];
        [_popView setHidden:YES];
        [self addSubview:_popView];
        
        [_popView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.dragView.mas_bottom);
            make.left.and.right.and.bottom.mas_equalTo(0);
        }];
    }
    return _popView;
}

- (instancetype)init {
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    
    // 拖拽控件
    self.dragView = [[XXLogSqureDragView alloc] init];
    [self.dragView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:self.dragView];
    
    [self.dragView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.right.mas_equalTo(0);
        make.height.mas_equalTo(30);
    }];
    
    // 日志展示列表
    self.tableView = [[UITableView alloc] init];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dragView.mas_bottom);
        make.left.and.bottom.right.mas_equalTo(0);
    }];
    
    // 添加向右滑动关闭手势
    UISwipeGestureRecognizer *swipeRightGesture = [[UISwipeGestureRecognizer alloc] init];
    [swipeRightGesture setDirection:UISwipeGestureRecognizerDirectionRight];
    [swipeRightGesture addTarget:self action:@selector(swipeRightAction:)];
    [swipeRightGesture setDelegate:self];
    [self.dragView addGestureRecognizer:swipeRightGesture];
    
    // 添加向左滑动控制菜单手势
    UISwipeGestureRecognizer *swipeLeftGesture = [[UISwipeGestureRecognizer alloc] init];
    [swipeLeftGesture setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeLeftGesture addTarget:self action:@selector(swipeLeftAction:)];
    [swipeLeftGesture setDelegate:self];
    [self.dragView addGestureRecognizer:swipeLeftGesture];
    
    // 改变页面大小
    __weak typeof(self) weakSelf = self;
    [self.dragView setDragBlock:^(CGPoint point) {
        [weakSelf adjust:point];
    }];
}

#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.logs.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XXLogSqureViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[XXLogSqureViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    [cell.timeLabel setText:self.logs[indexPath.row].time];
    [cell.contentLabel setText:self.logs[indexPath.row].msg];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 复制到剪切板
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:self.logs[indexPath.row].msg];
    [AlertView toast:@"Copyed" inView:self];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return ![self.dragView enableDrag];
}

#pragma mark - action
- (void)swipeRightAction:(UISwipeGestureRecognizer *)swipeGesture {
    if ([self.delegate respondsToSelector:@selector(logSqureViewDidClose:)]) {
        [self.delegate logSqureViewDidClose:self];
    }
}

- (void)swipeLeftAction:(UISwipeGestureRecognizer *)swipeGesture {
    [self.popView setHidden:!self.popView.hidden];
}

- (void)adjust:(CGPoint)point {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.01 animations:^{
        [weakSelf.superview setFrame:CGRectMake(0, point.y, kSCREEN_WIDTH, kSCREEN_HEIGHT-point.y)];
    }];
}

#pragma mark -
- (void)addLog:(XXLogModel *)model {
    
    [self.logs insertObject:model atIndex:0];
    
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView endUpdates];
}

- (void)clear {
    [self.logs removeAllObjects];
    [self.tableView reloadData];
}

@end


#pragma mark - XXLogSqureDragView

@interface XXLogSqureDragView ()

@property (nonatomic, assign) BOOL running;

@end

@implementation XXLogSqureDragView

- (instancetype)init {
    if (self = [super init]) {
        
        [self.layer setBorderColor:[UIColor colorWithWhite:0.9 alpha:1.0].CGColor];
        [self.layer setBorderWidth:1.f];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xxlog_drag"]];
        [self addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(CGPointZero);
        }];
    }
    return self;
}

#pragma mark -

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.running || [self allow:[[touches anyObject] locationInView:self.superview]]) {
        [self adjustLoction:[[touches anyObject] locationInView:[UIApplication sharedApplication].delegate.window]];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self adjustLoction:[[touches anyObject] locationInView:[UIApplication sharedApplication].delegate.window]];
    [self setRunning:NO]; // 结束移动
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self adjustLoction:[[touches anyObject] locationInView:[UIApplication sharedApplication].delegate.window]];
    [self setRunning:NO]; // 结束移动
}

// 调整拖动结束时的h悬浮位置
- (void)adjustLoction:(CGPoint)point {
    
    CGFloat y = point.y;
    if (y > kSCREEN_HEIGHT - CGRectGetHeight(self.frame)) {
        y = kSCREEN_HEIGHT - CGRectGetHeight(self.frame);
    } else if (y < CGRectGetHeight(self.frame)) {
        y = CGRectGetHeight(self.frame);
    }
    
    [self moveToPoint:CGPointMake(kSCREEN_WIDTH/2, y)];
}

// 移动到指定位置
- (void)moveToPoint:(CGPoint)point {
    if (self.running && self.dragBlock) {
        self.dragBlock(point);
    }
}

// 首次必须移动超过一定距离才能继续，防止误点
- (BOOL)allow:(CGPoint)point {
    
    CGPoint center = self.center;
    
    CGFloat y = fabs(point.y - center.y);
    
    if (y >= 15.f) {
        [self setRunning:YES];
    }
    
    return self.running;
}

- (BOOL)enableDrag {
    return self.running;
}

@end


#pragma mark - XXLogSqureViewCell

@interface XXLogSqureViewCell ()

@end

@implementation XXLogSqureViewCell

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        
        _timeLabel = [[UILabel alloc] init];
        [_timeLabel setBackgroundColor:[UIColor clearColor]];
        [_timeLabel setFont:[UIFont systemFontOfSize:14.f weight:UIFontWeightThin]];
        [self addSubview:_timeLabel];
        
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.top.mas_equalTo(8);
            make.width.mas_equalTo(60);
            make.bottom.mas_lessThanOrEqualTo(-8);
        }];
    }
    return _timeLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        
        _contentLabel = [[UILabel alloc] init];
        [_contentLabel setBackgroundColor:[UIColor clearColor]];
        [_contentLabel setFont:[UIFont systemFontOfSize:14.f weight:UIFontWeightThin]];
        [_contentLabel setNumberOfLines:0];
        [self addSubview:_contentLabel];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.timeLabel.mas_right).mas_offset(8);
            make.top.equalTo(self.timeLabel.mas_top);
            make.right.and.bottom.mas_equalTo(-8);
        }];
    }
    return _contentLabel;
}

@end
