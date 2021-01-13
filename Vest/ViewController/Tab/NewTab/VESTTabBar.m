//
//  VESTTabBar.m
//  Project
//
//  Created by XuWen on 2020/9/4.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "VESTTabBar.h"
#import "VESTTabButton.h"

@interface VESTTabBar ()
/** buttonItems，有多少控制器就有多少*/
@property (nonatomic, strong) NSMutableArray *buttons;

/** 当前选中的buttonItem*/
@property (nonatomic, weak) VESTTabButton *selectedButton;
@end

@implementation VESTTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        //背后形状
        UIView *shapeView = [[UIView alloc]init];
        shapeView.frame = CGRectMake(0, 25, kSCREEN_WIDTH, kTabbarHeight-25);
        shapeView.backgroundColor = [UIColor whiteColor];
        [self addSubview:shapeView];
        //切形状
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, 15, 0.0);
        CGPathAddLineToPoint(path, NULL, kSCREEN_WIDTH-30, 0.0);
        CGPathAddLineToPoint(path, NULL, kSCREEN_WIDTH, kTabbarHeight-25);
        CGPathAddLineToPoint(path, NULL, 0, kTabbarHeight-25);
        CGPathCloseSubpath(path);
        [shapeLayer setPath:path];
        shapeView.layer.mask = shapeLayer;
        
        //背景图
        UIImageView *imageView = [[UIImageView alloc]initWithImage:XWImageName(@"tab-背景")];
        [self addSubview:imageView];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.userInteractionEnabled = YES;
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
    }
    return self;
}

#pragma mark - setter & getter
- (NSMutableArray *)buttons
{
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

- (void)setItems:(NSArray *)items
{
    _items = items;
    
    // 根据items的数量创建button
    for (UITabBarItem *item in items) {
        VESTTabButton *button = [[VESTTabButton alloc]initWithFrame:CGRectMake(20+((kSCREEN_WIDTH-40)/items.count)*self.buttons.count, 0, ((kSCREEN_WIDTH-40)/items.count), self.frame.size.height)];
        button.item = item;
        button.tag = self.buttons.count;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        if (button.tag == 0) {
            [self buttonClick:button];
        }
        [self addSubview:button];
        [self.buttons addObject:button];
    }
}

#pragma mark - event
- (void)buttonClick:(VESTTabButton *)button
{
    if ([_delegate respondsToSelector:@selector(tabBar:didSelectedItemFrom:to:)]) {
        [_delegate tabBar:self didSelectedItemFrom:self.selectedButton.tag to:button.tag];
    }
    //选定button 缩放图片
    _selectedButton.selected = NO;
    button.selected = YES;
    _selectedButton = button;
}

@end
