//
//  LSPictureScrollView.m
//  Project
//
//  Created by XuWen on 2020/5/28.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSPictureScrollView.h"
#import "LSPictureView.h"

@interface LSPictureScrollView ()<UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView *scrollView; //ScrollView
@property (nonatomic,strong) UIView *contentView;
//当前页面
@property (nonatomic,assign) NSInteger currentPage;

@end

@implementation LSPictureScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self SEEKING_baseUIConfig];
        [self SEEKING_baseConstraintsConfig];
    }
    return self;
}

#pragma mark - delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat x = scrollView.contentOffset.x;
    self.currentPage = x/kSCREEN_WIDTH;
    if(self.ScrollToPageBlock){
        self.ScrollToPageBlock(self.currentPage);
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    CGFloat x = scrollView.contentOffset.x;
    self.currentPage = x/kSCREEN_WIDTH;
    if(self.ScrollToPageBlock){
        self.ScrollToPageBlock(self.currentPage);
    }
}



#pragma mark - public
- (void)scrollToPage:(NSInteger)page
{
    [self.scrollView scrollRectToVisible:CGRectMake(page*kSCREEN_WIDTH, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT) animated:YES];
}


#pragma mark - baseConfig1
- (void)SEEKING_baseUIConfig
{
    [self addSubview:self.scrollView];
}

- (void)SEEKING_baseConstraintsConfig
{
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark - private

- (void)configImages:(NSArray *)imageList
{
    //先删除照片
    for(UIView *view in self.contentView.subviews){
        [view removeFromSuperview];
    }
    
    LSPictureView *preImageView = nil;
    int i = 0;
    for(NSString *imageStr in imageList){
        LSPictureView *imageView = [[LSPictureView alloc]init];
        [imageView xwDrawCornerWithRadiuce:0];
        
        //如果 是第三张照片以后  并且 个人相册少于两张，就要显示上传
        
        NSArray *array = nil;
        if(kUser.imageslist.length > 10){
            [kUser.imageslist componentsSeparatedByString:@","];
        }
        if(i>=2 && array.count < 2){
            imageView.showUpload = YES;
        }else{
            imageView.showUpload = NO;
        }
        
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:XWImageName(kLanguage(@"Honey-place"))];
        [self.contentView addSubview:imageView];
        if(preImageView == nil){
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(self.contentView);
                make.width.equalTo(self.scrollView);
                make.left.mas_equalTo(0);
            }];
        }else{
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(self.contentView);
                make.width.equalTo(self.scrollView);
                make.left.mas_equalTo(preImageView.mas_right);
            }];
        }
        preImageView = imageView;
        i++;
    }
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(preImageView.mas_right);
    }];
}


#pragma mark - setter & getter1

- (UIScrollView *)scrollView
{
    if(!_scrollView){
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.pagingEnabled = YES;
        _scrollView.userInteractionEnabled = NO;
        
        [_scrollView addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.scrollView);
            make.height.equalTo(self.scrollView);
        }];
    }
    return _scrollView;
}

- (UIView *)contentView
{
    if(!_contentView){
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = [UIColor blackColor];
    }
    return _contentView;
}

- (void)setImageArray:(NSArray *)imageArray
{
    _imageArray = imageArray;
    if(imageArray.count > 0){
        [self configImages:imageArray];
    }
}

- (void)setScrollEnable:(BOOL)scrollEnable
{
    _scrollEnable = scrollEnable;
    if(scrollEnable){
        self.scrollView.scrollEnabled = YES;
        self.scrollView.pagingEnabled = YES;
        _scrollView.userInteractionEnabled = YES;
    }
}
@end
