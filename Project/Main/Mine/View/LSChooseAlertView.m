//
//  LSChooseAlertView.m
//  Project
//
//  Created by XuWen on 2020/3/9.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSChooseAlertView.h"

typedef void(^SelectedBlock)(NSString *title);

@interface LSChooseAlertView ()

@property (nonatomic,strong)UIView *contentView;
@property (nonatomic,strong) UIButton *cancelButton;
@property (nonatomic,strong) NSMutableArray *buttonArray;

@property (nonatomic,strong) NSArray *titleArray;

@property (nonatomic,copy) SelectedBlock selectedBlock;

@end

@implementation LSChooseAlertView

+ (void)showWithTileArray:(NSArray *)array select:(void(^)(NSString *title))selectedBlock
{
    LSChooseAlertView *alertView = [[LSChooseAlertView alloc]initWithStyle:XWBaseAlertViewStyleBottom];
    alertView.selectedBlock = selectedBlock;
    [[UIApplication sharedApplication].keyWindow addSubview:alertView];
    alertView.titleArray = array;
    [alertView appearAnimation];
}

-  (instancetype)initWithStyle:(XWBaseAlertViewStyle)style
{
    self = [super initWithStyle:style];
    if(self){
        [self SEEKING_baseUIConfig];
        [self SEEKING_baseConstraintsConfig];
    }
    return self;
}


#pragma mark - baseConfig1
- (void)SEEKING_baseUIConfig
{
    [self.placeView addSubview:self.contentView];
    [self.contentView addSubview:self.cancelButton];
}

- (void)SEEKING_baseConstraintsConfig
{
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.placeView);
    }];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-20-kSafeAreaBottomHeight);
        make.width.equalTo(@(XW(340)));
        make.height.equalTo(@64);
        make.centerX.equalTo(self.contentView);
    }];
}


#pragma mark - titleArray
- (void)titleConfig
{
    UIButton *preButton = nil;
    int i = 0;
    for(NSString *title in self.titleArray){
        UIButton *button = [UIButton creatCommonButtonConfigWithTitle:kLanguage(title) font:Font(24) titleColor:[UIColor xwColorWithHexString:@"#0078FF"] aliment:UIControlContentHorizontalAlignmentCenter];
        button.tag = i;
        button.backgroundColor = [UIColor whiteColor];
        
        [button addTarget:self action:@selector(chooseButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(XW(340)));
            make.height.equalTo(@64);
            make.centerX.equalTo(self.contentView);
        }];
        if(preButton == nil){
            [button xwDrawbyRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight withRadiuce:18];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.cancelButton.mas_top).offset(-16);
            }];
        }else{
            [button showBottomLineWithXSpace:0];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(preButton.mas_top).offset(0);
            }];
        }
        preButton = button;
        i++;
    }
    
    [preButton xwDrawbyRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight withRadiuce:18];
}

#pragma mark - event
- (void)chooseButtonClicked:(UIButton *)sender
{
    NSString *title = self.titleArray[sender.tag];
    NSLog(@"%@",title);
    if(self.selectedBlock){
        [self disappearAnimation];
        self.selectedBlock(title);
    }
}

#pragma mark - setter & gette
- (UIView *)contentView
{
    if(!_contentView){
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = [UIColor clearColor];
        [_contentView xwDrawCornerWithRadiuce:10];
    }
    return _contentView;
}

- (UIButton *)cancelButton
{
    if(!_cancelButton){
        _cancelButton = [UIButton creatCommonButtonConfigWithTitle:kLanguage(@"Cancel") font:Font(24) titleColor:[UIColor themeColor] aliment:UIControlContentHorizontalAlignmentCenter];
        [_cancelButton xwDrawCornerWithRadiuce:18];
        _cancelButton.backgroundColor = [UIColor whiteColor];
        kXWWeakSelf(weakself);
        [_cancelButton setAction:^{
            [weakself disappearAnimation];
        }];
    }
    return _cancelButton;
}


- (void)setTitleArray:(NSArray *)titleArray
{
    //进行数组翻转
    NSMutableArray * tmpArr = [NSMutableArray arrayWithArray:titleArray];
    NSArray *arr = [[tmpArr reverseObjectEnumerator] allObjects];
    _titleArray = [NSArray arrayWithArray:arr];
    [self titleConfig];
}


@end
