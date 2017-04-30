//
//  BarTableViewCell.m
//  横向柱状图
//
//  Created by 张行舟 on 2017/4/30.
//  Copyright © 2017年 zxz. All rights reserved.
//

#import "BarCell.h"
#import "BarTableViewCell.h"

@implementation BarTableViewCell{
    NSArray<NSString *> *_dataModels;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor yellowColor];
        [self.contentView addSubview:self.tableView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.tableView.frame = self.contentView.bounds;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell setRate:_dataModels[indexPath.row].doubleValue];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (void)setArray:(NSArray *)data {
    _dataModels = data;
    [self.tableView reloadData];
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled  =false;
        _tableView.dataSource  =self;
        [_tableView registerClass:[BarCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

@end
