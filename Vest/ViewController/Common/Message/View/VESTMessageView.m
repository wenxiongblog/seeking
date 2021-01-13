//
//  VESTMessageView.m
//  Project
//
//  Created by XuWen on 2020/8/26.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "VESTMessageView.h"
#import "VESTSendCell.h"
#import "VESTReceiveCell.h"

@interface VESTMessageView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *mainTableView;

@end

@implementation VESTMessageView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self baseUIConfig];
    }
    return self;
}

#pragma mark - baseUIConfig
- (void)baseUIConfig
{
    [self addSubview:self.mainTableView];
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VESTMessageModel *model = self.messageArray[indexPath.row];
    if(model.direction){
        VESTSendCell *cell = [tableView dequeueReusableCellWithIdentifier:kVESTSendCellIdentifier forIndexPath:indexPath];
        cell.message = model;
        return cell;
    }else{
        VESTReceiveCell *cell = [tableView dequeueReusableCellWithIdentifier:kVESTReceiveCellIdentifier forIndexPath:indexPath];
        cell.message = model;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"asdf");
}
#pragma mark - setter & getter
- (UITableView *)mainTableView
{
    if(!_mainTableView){
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_mainTableView commonTableViewConfig];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.estimatedRowHeight=100;
        _mainTableView.rowHeight=UITableViewAutomaticDimension;
        [_mainTableView registerClass:[VESTSendCell class] forCellReuseIdentifier:kVESTSendCellIdentifier];
        [_mainTableView registerClass:[VESTReceiveCell class] forCellReuseIdentifier:kVESTReceiveCellIdentifier];
    }
    return _mainTableView;
}

- (void)setMessageArray:(NSMutableArray<VESTMessageModel *> *)messageArray
{
    _messageArray = messageArray;
    [self.mainTableView reloadData];
    if(self.messageArray.count > 0){
        [self.mainTableView scrollToRowAtIndexPath: [NSIndexPath indexPathForRow:self.messageArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
  
}


@end
