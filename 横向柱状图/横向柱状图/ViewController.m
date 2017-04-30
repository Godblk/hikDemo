//
//  ViewController.m
//  横向柱状图
//
//  Created by 张行舟 on 2017/4/30.
//  Copyright © 2017年 zxz. All rights reserved.
//

#import "ViewController.h"
#import "BarTableViewCell.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) NSArray *data;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.=
    self.data = @[@"19",@"90",@"1",@"30",@"19",@"90",@"1",@"30"];
    [self.view addSubview:self.tableView];
}

- (void)viewDidLayoutSubviews {
    self.tableView.frame = self.view.bounds;
}
- (IBAction)click:(id)sender {
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor grayColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor grayColor];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell setArray:self.data];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.data.count > 0) {
        return self.data.count*40;
    }
    return 0;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[BarTableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}
@end
