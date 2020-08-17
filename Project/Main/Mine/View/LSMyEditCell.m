//
//  LSMyEditCell.m
//  Project
//
//  Created by XuWen on 2020/2/15.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSMyEditCell.h"

@interface LSMyEditCell ()<UITextViewDelegate>
//label
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UIImageView *rightImageView;
//textfield
@property (nonatomic,strong) UITextField *textField;
//textView
@property (nonatomic,strong) UITextView *textview;
@end

@implementation LSMyEditCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self SEEKING_baseUIConfig];
        [self baseConstriantsConfig];
    }
    return self;
}


#pragma mark - baseConfig1
- (void)SEEKING_baseUIConfig
{
    [self commonTableViewCellConfig];
    self.contentView.backgroundColor = [UIColor projectBlueColor];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.rightImageView];
    [self.contentView addSubview:self.textField];
    [self.contentView addSubview:self.textview];
}

- (void)baseConstriantsConfig
{
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(16);
        make.right.equalTo(self.contentView).offset(-16);
    }];
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@15);
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.contentView);
    }];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(16);
        make.right.equalTo(self.contentView).offset(-16);
    }];
    [self.textview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(16);
        make.right.equalTo(self.contentView).offset(-16);
    }];
}


#pragma mark - setter & getter1
- (UILabel *)nameLabel
{
    if(!_nameLabel){
        _nameLabel = [UILabel createCommonLabelConfigWithTextColor:[UIColor whiteColor] font:Font(15) aliment:NSTextAlignmentLeft];
        _nameLabel.backgroundColor = [UIColor projectBlueColor];
    }
    return _nameLabel;
}

- (UIImageView *)rightImageView
{
    if(!_rightImageView){
        _rightImageView = [[UIImageView alloc]initWithImage:XWImageName(@"向右1")];
        _rightImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _rightImageView;
}

- (UITextField *)textField
{
    if(!_textField){
        _textField = [[UITextField alloc]init];
        _textField.font = Font(15);
        _textField.textColor = [UIColor whiteColor];
        _textField.backgroundColor = [UIColor projectBlueColor];
        [_textField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}

- (void)textFieldChange:(UITextField *)textField
{
    if(self.changeBlock && self.key){
        self.changeBlock(self.key,textField.text);
    }
}

- (UITextView *)textview
{
    if(!_textview){
        _textview = [[UITextView alloc]init];
        _textview.backgroundColor = [UIColor projectBlueColor];
        _textview.font = Font(15);
        _textview.textColor = [UIColor whiteColor];
        _textview.delegate = self;
    }
    return _textview;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if(self.changeBlock && self.key){
        self.changeBlock(self.key,textView.text);
    }
}

- (void)setType:(LSMyEditCellType)type
{
    _type = type;
    if(type == LSMyEditCellType_Choose){
        self.nameLabel.hidden = NO;
        self.rightImageView.hidden = NO;
        self.textField.hidden = YES;
        self.textview.hidden = YES;
    }else if(type == LSMyEditCellType_textField){
        self.nameLabel.hidden = YES;
        self.rightImageView.hidden = YES;
        self.textField.hidden = NO;
        self.textview.hidden = YES;
    }else if(type == LSMyEditCellType_textView){
        self.nameLabel.hidden = YES;
        self.rightImageView.hidden = YES;
        self.textField.hidden = YES;
        self.textview.hidden = NO;
    }
}

- (void)setName:(NSString *)name
{
    _name = name;
    self.nameLabel.text = name;
    self.textField.text = name;
    self.textview.text = name;
    
    if([name isEqualToString:kLanguage(@"Please choose")]){
        self.nameLabel.textColor = [UIColor xwColorWithHexString:@"#666666"];
    }else{
        self.nameLabel.textColor = [UIColor whiteColor];
    }
    
    if(name.length == 0){
         NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:kLanguage(@"Please input") attributes:@{NSForegroundColorAttributeName:[UIColor xwColorWithHexString:@"#666666"],NSFontAttributeName:self.textField.font}];
            self.textField.attributedPlaceholder = attrString;
    }
}


@end
