//
//  LSWelcomeVC.m
//  Project
//
//  Created by XuWen on 2020/1/13.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSWelcomeVC.h"

@interface LSWelcomeVC ()
@property (nonatomic,strong) UIImageView *imageView;
@end

@implementation LSWelcomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SEEKING_baseUIConfig];
    [self baseConstriantsConfig];
    
    [JumpUtils jumpMainModel];

}


#pragma mark - SEEKING_baseUIConfig
- (void)SEEKING_baseUIConfig
{
    [self.view addSubview:self.imageView];
}

- (void)baseConstriantsConfig
{
    
}



#pragma mark - setter & getter1
- (UIImageView *)imageView
{
    if(!_imageView){
        _imageView = [[UIImageView alloc]initWithImage:XWImageName(@"welcome")];
        _imageView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
    }
    return _imageView;
}

@end
