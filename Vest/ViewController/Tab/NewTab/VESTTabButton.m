//
//  VESTTabButton.m
//  Project
//
//  Created by XuWen on 2020/9/4.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "VESTTabButton.h"
@interface VESTTabButton()
@property (nonatomic,strong) UIImageView *bgImageView;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIImage *image;
@end


@implementation VESTTabButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bgImageView];
        [self addSubview:self.imageView];
        [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@50);
            make.top.equalTo(self);
            make.centerX.equalTo(self);
        }];
    }
    return self;
}

- (void)setItem:(UITabBarItem *)item
{
    _item = item;
        // 清空监听的内容
        [self observeValueForKeyPath:nil ofObject:nil change:nil context:nil];
        /**
         *  给item添加观察者self
         *
         *  @param observer NSObject 观察者
         *  @param keyPath NSString 要监听的属性的名称
         *  @param options NSKeyValueObservingOptions 监听值变化的方式
         *  @param context 上下文
         */
        [item addObserver:self forKeyPath:@"title"
                  options:NSKeyValueObservingOptionNew
                  context:nil];
        [item addObserver:self forKeyPath:@"image"
                  options:NSKeyValueObservingOptionNew
                  context:nil];
        [item addObserver:self forKeyPath:@"selectedImage"
                  options:NSKeyValueObservingOptionNew
                  context:nil];
}

// 只要监听到有属性有新值，就会调用该方法
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context
{
    self.image = _item.image;
    self.imageView.image = self.image;
}

#pragma mark - setter & getter
- (UIImageView *)bgImageView
{
    if(!_bgImageView){
        _bgImageView = [[UIImageView alloc]init];
        _bgImageView.image = XWImageName(@"vest_tab_selected");
        _bgImageView.hidden = YES;
    }
    return _bgImageView;
}
- (UIImageView *)imageView
{
    if(!_imageView){
        _imageView = [[UIImageView alloc]init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

- (void)setSelected:(BOOL)selected
{
    [self selectedAnimation:selected];
    [super setSelected:selected];
}

#pragma mark - private
- (void)selectedAnimation:(BOOL)selected
{
    if(selected){
        self.bgImageView.hidden = NO;
    }else{
        self.bgImageView.hidden = YES;
    }
}

@end
