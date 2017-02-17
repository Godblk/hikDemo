//
//  CSCViewController.m
//  storeselectDemo
//
//  Created by 张行舟 on 2017/2/10.
//  Copyright © 2017年 hikvision. All rights reserved.
//

#import "CSCViewController.h"
#import "CSCCarouselView.h"
#import "Masonry.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
@interface CSCViewController ()
<
CSCCarouselViewDelegate,
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, assign) NSTimeInterval                 lastClickTime;        /**< 防暴力点击计时*/
@property (nonatomic ,strong) CSCCarouselView *carouseView;
@end

@implementation CSCViewController{
    NSInteger _itemIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars =NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    self.carouseView = [[CSCCarouselView alloc] init];
    self.carouseView.delegate = self;
    self.carouseView.itemWidth = SCREEN_WIDTH/2;
    [self.view addSubview:self.carouseView];
    [self.carouseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.carouseView insertItemAtIndex:_itemIndex animated:NO];
    _itemIndex++;
}

#pragma mark ==CSCCarouselViewDelegate
- (UIView *)carousel:(CSCCarouselView *)carousel viewForItemAtIndex:(NSInteger)index {
    CGFloat width;
    if (index == 0) {
        width = SCREEN_WIDTH;
    }else {
        width = SCREEN_WIDTH/2;
    }
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, width, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    tableView.backgroundColor = index % 2 == 0 ? [UIColor whiteColor] : [UIColor grayColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.tag = index;
    
    return tableView;
}

- (void)carousel:(CSCCarouselView *)carousel willDeleteItemAtIndex:(NSInteger)index {
    _itemIndex--;
    [carousel removeItemAtIndex:index animated:YES];
}

- (void)carouselWillDeleteAllItem:(CSCCarouselView *)carousel {
    for (NSInteger i = 1; i<_itemIndex; i++) {
        [carousel removeItemAtIndex:i animated:YES];
    }
    _itemIndex = 1;
}

#pragma mark -
#pragma mark Table methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.contentView.backgroundColor = tableView.backgroundColor;
    cell.textLabel.text = [NSString stringWithFormat:@"杭州%ld",(long)tableView.tag];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([NSDate date].timeIntervalSince1970 - self.lastClickTime < 0.5) {
        return;
    }
    self.lastClickTime = [NSDate date].timeIntervalSince1970;
    if (tableView.tag < _itemIndex-1) {
        //        [self.carouseView removeItemAtIndex:_itemIndex animated:YES];
        //        _itemIndex--;
        return;
    }
    [self.carouseView insertItemAtIndex:_itemIndex animated:YES];
    _itemIndex++;
    
}

@end
