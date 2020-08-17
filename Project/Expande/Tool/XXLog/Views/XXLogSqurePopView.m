//
//  XXLogSqurePopView.m
//  SCGov
//
//  Created by solehe on 2019/10/24.
//  Copyright © 2019 solehe. All rights reserved.
//

#import "XXLogSqurePopView.h"

@interface XXLogSqurePopView ()
<
    UITableViewDelegate,
    UITableViewDataSource
>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation XXLogSqurePopView

- (NSArray<NSString *> *)itmes {
    if (!_itmes) {
        _itmes = @[@"清空日志", @"修改网络请求地址"];
    }
    return _itmes;
}


- (instancetype)init {
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    
    self.tableView = [[UITableView alloc] init];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    [self addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itmes.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    cell.contentView.backgroundColor = [UIColor whiteColor];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        cell.contentView.backgroundColor = [UIColor whiteColor];
//        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14.f];
    }
    
    [cell.textLabel setText:self.itmes[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.itmes[indexPath.row] isEqualToString:@"清空日志"]) {
        [self setHidden:YES];
        [XXLog clear];
    } else if ([self.itmes[indexPath.row] isEqualToString:@"修改网络请求地址"]) {
        [self showInputView:^(NSString *text) {
            [[NSUserDefaults standardUserDefaults] setObject:text forKey:@"BASE_URL"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }];
    }
    
}

- (void)showInputView:(void(^)(NSString *text))block {
    XXLogSqureInputView *inputView = [[XXLogSqureInputView alloc] initWithFrame:CGRectMake(5, kSCREEN_HEIGHT, kSCREEN_WIDTH-10, kSCREEN_HEIGHT-100)];
    [inputView setBackgroundColor:[UIColor whiteColor]];
    [inputView.layer setShadowColor:[UIColor blackColor].CGColor];
    [inputView.layer setShadowOffset:CGSizeMake(0, 0)];
    [inputView.layer setShadowOpacity:0.2f];
    [inputView.layer setShadowRadius:5.f];
    [inputView.layer setCornerRadius:5.f];
    [inputView show:block];
}

@end



#pragma mark - XXLogSqureInputView

@interface XXLogSqureInputView()
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, copy) void(^ResultBlock)(NSString *url);
@end

@implementation XXLogSqureInputView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    
    UILabel *label = [[UILabel alloc] init];
    [label setFont:[UIFont systemFontOfSize:14.f]];
    [label setText:@"请输入接口请求地址："];
    [self addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(15);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(20);
    }];
    
    
    UIView *contentView = [[UIView alloc] init];
    [contentView.layer setBorderColor:[UIColor colorWithWhite:0.f alpha:0.2f].CGColor];
    [contentView.layer setBorderWidth:0.5f];
    [self addSubview:contentView];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).mas_offset(10);
        make.left.and.right.equalTo(label);
        make.height.mas_equalTo(50);
    }];
    
    self.textField = [[UITextField alloc] init];
    [self.textField setFont:[UIFont systemFontOfSize:14.f]];
    [self.textField setPlaceholder:@"示例：http://www.sczwfw.gov.cn/mobileApi/"];
    self.textField.textColor = [UIColor blackColor];
    [contentView addSubview:self.textField];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(contentView);
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
    }];
    
    kXWWeakSelf(weakself);
    UIButton *testButton = [UIButton creatCommonButtonConfigWithTitle:@"  测试环境：http://47.114.7.228:10003/" font:Font(11) titleColor:[UIColor lightGrayColor] aliment:UIControlContentHorizontalAlignmentLeft];
    [testButton xwDrawBorderWithColor:[UIColor lightGrayColor] radiuce:4 width:0.5];
    [testButton setAction:^{
        weakself.textField.text = @"http://47.114.7.228:10003/";
    }];
    
    UIButton *distributeButton = [UIButton creatCommonButtonConfigWithTitle:@"  正式环境：https://meetdating.com.cn/" font:Font(11) titleColor:[UIColor lightGrayColor] aliment:UIControlContentHorizontalAlignmentLeft];
    [distributeButton xwDrawBorderWithColor:[UIColor lightGrayColor] radiuce:4 width:0.5];
    [distributeButton setAction:^{
        weakself.textField.text = @"https://meetdating.com.cn/";
    }];
    
    [self addSubview:testButton];
    [self addSubview:distributeButton];
    
    [testButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
        make.left.and.right.equalTo(label);
        make.top.equalTo(contentView.mas_bottom).mas_offset(20);
    }];
    [distributeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(testButton);
        make.top.equalTo(testButton.mas_bottom).mas_offset(10);
    }];
    
    UIButton *button = [[UIButton alloc] init];
    [button setBackgroundColor:RGB16(0x2B77E7)];
    [button setTitle:@"修改" forState:UIControlStateNormal];
    [button.titleLabel setTextColor:[UIColor whiteColor]];
    [button.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
    [button.layer setCornerRadius:5.f];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(label);
        make.top.equalTo(distributeButton.mas_bottom).mas_offset(40);
        make.height.mas_equalTo(45);
    }];
}

- (void)buttonAction:(UIButton *)button {
    
    if (self.ResultBlock) {
        self.ResultBlock(self.textField.text);
    }
    
    [self dismiss];
}

- (void)show:(void (^)(NSString * _Nonnull))block {
    
    [self setResultBlock:block];
    
    __weak typeof(self) weakSelf = self;
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        [weakSelf setFrame:CGRectMake(5, 110, kSCREEN_WIDTH-10, kSCREEN_HEIGHT-100)];
    }];
}

- (void)dismiss {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        [weakSelf setFrame:CGRectMake(5, kSCREEN_HEIGHT, kSCREEN_WIDTH-10, kSCREEN_HEIGHT-100)];
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

@end
