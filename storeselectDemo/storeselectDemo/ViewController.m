//
//  ViewController.m
//  storeselectDemo
//
//  Created by zhangxingzhou on 17/2/7.
//  Copyright © 2017年 hikvision. All rights reserved.
//

#import "ViewController.h"
#import "iCarousel.h"
#import "CSCGCDQueue.h"
#import "Masonry.h"

#pragma mark --屏幕长宽
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface ViewController ()
<
iCarouselDelegate,
iCarouselDataSource,
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic ,strong) iCarousel *icarousel;
@property (nonatomic ,assign) BOOL      canSelectItem;
@property (nonatomic ,strong) NSMutableArray *dataArray;
@property (nonatomic ,strong) UITableView *mainTableView;
@property (nonatomic, assign) NSTimeInterval                 lastClickTime;        /**< 防暴力点击计时*/
@end

@implementation ViewController
- (void)dealloc
{
    self.icarousel.delegate = nil;
    self.icarousel.dataSource = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars =NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self initUI];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.icarousel = nil;
}


#pragma mark - ===============Init UI   =============
- (void)initUI {
    self.title = @"总报表统计";
    _canSelectItem = YES;
    self.dataArray = [NSMutableArray array];
    self.icarousel = [iCarousel new];
    self.icarousel.type = iCarouselTypeTimeMachine;
    self.icarousel.perspective = 0;
    self.icarousel.delegate = self;
    self.icarousel.scrollEnabled = false;
    self.icarousel.dataSource = self;
    self.icarousel.contentOffset = CGSizeMake(SCREEN_WIDTH/4, 0);
    
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    _mainTableView.backgroundColor = [UIColor whiteColor];
    _mainTableView.dataSource = self;
    _mainTableView.delegate = self;
    _mainTableView.tag = 0;
    
    [self.view addSubview:_mainTableView];
    [_mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}
#pragma mark - ===============Net  Working ==========
#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return self.dataArray.count;
}



- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    CGFloat width;
    //    if (index == 0) {
    //        width =  SCREEN_WIDTH;
    //    }else {
    width = SCREEN_WIDTH/2;
    //    }
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, width, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    tableView.backgroundColor = index % 2 == 0 ? [UIColor whiteColor] : [UIColor grayColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.tag = index+1;
    return tableView;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
    if ([NSDate date].timeIntervalSince1970 - self.lastClickTime < 0.5) {
        return;
    }
    self.lastClickTime = [NSDate date].timeIntervalSince1970;
    if (index == self.dataArray.count - 2) {
        [carousel offsetSecondView];
        
    }else if (index == self.dataArray.count -1) {
        [carousel offsetLastView];
    }
}

- (void)carousel:(iCarousel *)carousel willDeleteItemAtIndex:(NSInteger)index {
    if (index < self.dataArray.count && self.dataArray.count > 0) {
        [carousel removeItemAtIndex:index animated:YES];
        [self.dataArray removeObjectAtIndex:index];
        if (self.dataArray.count == 0) {
            [CSCGCDQueue executeInMainQueue:^{
                [self.icarousel removeFromSuperview];
                _mainTableView.userInteractionEnabled = YES;
            } afterDelaySecs:0.5];
        }
    }
}

- (void)carouselWillEndAnimation:(iCarousel *)carousel {
    _canSelectItem = YES;
}

- (void)carouselWillDeleteAllItem:(iCarousel *)carousel {
    for (NSInteger i = 0; i<self.dataArray.count; i++) {
        [carousel removeItemAtIndex:i animated:YES];
    }
    [self.dataArray removeAllObjects];
    [CSCGCDQueue executeInMainQueue:^{
        [self.icarousel removeFromSuperview];
        _mainTableView.userInteractionEnabled = YES;
    } afterDelaySecs:0.4];
}

#pragma mark -
#pragma mark Table methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1000;
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
    if (tableView.tag == 0) {
        if (!self.icarousel.superview) {
            
            [self.view addSubview:self.icarousel];
            [self.icarousel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view);
            }];
            _mainTableView.userInteractionEnabled = false;
            [CSCGCDQueue executeInMainQueue:^{
                [self.dataArray addObject:@""];
                [self.icarousel insertItemAtIndex:self.dataArray.count - 1 animated:YES];
                [self.icarousel scrollToItemAtIndex:self.dataArray.count - 1 animated:YES];
            } afterDelaySecs:0.1];
        }
    }else {
        [CSCGCDQueue executeInMainQueue:^{
            [self.dataArray addObject:@""];
            [self.icarousel insertItemAtIndex:self.dataArray.count - 1 animated:YES];
            [self.icarousel scrollToItemAtIndex:self.dataArray.count - 1 animated:YES];
        } afterDelaySecs:0.1];
    }
    
}

@end
