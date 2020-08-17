//
//  LSImageVC.m
//  Project
//
//  Created by XuWen on 2020/8/11.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSImageVC.h"

@interface LSImageVC ()
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIButton *button;
@end

@implementation LSImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.button];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@320);
        make.height.equalTo(@320);
        make.center.equalTo(self.view);
    }];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.height.equalTo(@40);
        make.width.equalTo(@100);
        make.top.equalTo(self.imageView.mas_bottom).offset(30);
    }];
}

- (UIImageView *)imageView
{
    if(!_imageView){
        _imageView = [[UIImageView alloc]initWithImage:XWImageName(@"asdf")];
    }
    return _imageView;
}

- (UIButton *)button
{
    if(!_button){
        _button = [UIButton creatCommonButtonConfigWithTitle:@"完成" font:Font(15) titleColor:[UIColor redColor] aliment:UIControlContentHorizontalAlignmentCenter];
        _button.backgroundColor = [UIColor blueColor];
        kXWWeakSelf(weakself);
        [_button setAction:^{
            NSLog(@"添加一个水印");
            weakself.imageView.image = [UIImage jx_WaterImageWithImage:weakself.imageView.image text:@"asdf" textPoint:CGPointMake(0, 0)];
            
        }];
    }
    return _button;
}

@end
