//
//  LSDetailDefaultCell.m
//  Project
//
//  Created by XuWen on 2020/4/23.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSDetailDefaultCell.h"

@implementation LSDetailDefaultCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self SEEKING_baseUIConfig];
    }
    return self;
}

#pragma mark - SEEKING_baseUIConfig
- (void)SEEKING_baseUIConfig
{
    [self commonTableViewCellConfig];
    self.contentView.backgroundColor = [UIColor projectBackGroudColor];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:XWImageName(@"detail_defailt")];
    [self.contentView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.top.equalTo(self.contentView).offset(10);
        make.bottom.equalTo(self.contentView);
        make.height.equalTo(@(XW(300)));
    }];
}


@end
