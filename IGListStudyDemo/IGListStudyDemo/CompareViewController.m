//
//  CompareViewController.m
//  IGListStudyDemo
//
//  Created by zhangxingzhou on 2017/4/27.
//  Copyright © 2017年 hikvision. All rights reserved.
//

#import "Masonry.h"
#import "SelectionModel.h"
#import "SectionTitleController.h"
#import "DateSelectionController.h"
#import "CommonAccController.h"
#import "ConfirmController.h"
#import <IGListKit/IGListKit.h>
#import "CompareViewController.h"

const static CGFloat kTopHeight = 64;
const static CGFloat kArrowHeight = 10;

@interface CompareViewController ()
<
IGListAdapterDataSource
>

@property (nonatomic ,strong)  UIButton *timeButton;
@property (nonatomic ,strong)  UIButton *backButton;
@property (nonatomic ,strong)  UIButton *storeButton;
@property (nonatomic ,strong)  UIButton *selectButton;
@property (nonatomic, strong) CAShapeLayer *fillShapeLayer;
@property (nonatomic ,strong)  IGListCollectionView *collectionView;
@property (nonatomic ,strong)  IGListAdapter *adapter;
@property (nonatomic ,strong)  NSMutableArray *data;
@end

@implementation CompareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.timeButton];
    [self.view addSubview:self.storeButton];
    [self.view addSubview:self.backButton];
    self.view.backgroundColor = [UIColor grayColor];
    [self.timeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_centerX).offset(-5);
        make.bottom.equalTo(self.view.mas_top).offset(kTopHeight-kArrowHeight);
    }];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.timeButton);
        make.left.equalTo(self.view).offset(10);
    }];
    
    [self.storeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_centerX).offset(5);
        make.bottom.equalTo(self.view.mas_top).offset(kTopHeight-kArrowHeight);
    }];
    
    self.selectButton = self.timeButton;
    UIBezierPath *path = [self shapPath];
    // shape
    self.fillShapeLayer             = [CAShapeLayer layer];
    self.fillShapeLayer.path        = path.CGPath;
    self.fillShapeLayer.strokeColor = [UIColor grayColor].CGColor;
    self.fillShapeLayer.fillColor   = [UIColor whiteColor].CGColor;
    self.fillShapeLayer.lineWidth   = 1.f;
    //    self.fillShapeLayer.frame       = CGRectMake(0, kTopHeight,
    //                                                 CGRectGetWidth(self.view.frame),
    //                                                 CGRectGetHeight(self.view.frame)-kTopHeight);
    [self.view.layer addSublayer:self.fillShapeLayer];
    [self.view addSubview:self.collectionView];
    self.adapter.collectionView = self.collectionView;
    self.adapter.dataSource = self;
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kTopHeight+5);
        make.left.equalTo(self.view).offset(5);
        make.right.bottom.equalTo(self.view).offset(-5);
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    // path animation.
    UIBezierPath *newPath            = [self shapPath];
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    basicAnimation.duration          = 0.3;
    basicAnimation.fromValue         = (__bridge id)(self.fillShapeLayer.path);
    basicAnimation.toValue           = (__bridge id)newPath.CGPath;
    self.fillShapeLayer.path         = newPath.CGPath;
    [self.fillShapeLayer addAnimation:basicAnimation forKey:@"fillShapeLayerPath"];
    
    // fillColor animation.
    UIColor *newColor                = [self typeColor];
    CABasicAnimation *colorAnimation = [CABasicAnimation animationWithKeyPath:@"fillColor"];
    colorAnimation.duration          = 0.3;
    colorAnimation.fromValue         = (__bridge id)(self.fillShapeLayer.fillColor);
    colorAnimation.toValue           = (__bridge id)newColor.CGColor;
    self.fillShapeLayer.fillColor    = newColor.CGColor;
    [self.fillShapeLayer addAnimation:colorAnimation forKey:@"fillShapeLayerColor"];
}

#pragma mark ==IGListAdapterDataSource
- (NSArray<id<IGListDiffable>> *)objectsForListAdapter:(IGListAdapter *)listAdapter {
    return self.data;
}

- (IGListSectionController<IGListSectionType> *)listAdapter:(IGListAdapter *)listAdapter sectionControllerForObject:(id)object {
    IGListSectionController<IGListSectionType> *controller;
    if ([object isKindOfClass:[NSString class]]) {
        controller = [[SectionTitleController alloc] init];
    }else if ([object isKindOfClass:[NSNumber class]]) {
        NSNumber *number = object;
        if (number.intValue == 1) {
            controller = [[DateSelectionController alloc] init];
        }else {
            controller = [[ConfirmController alloc] init];
        }
        
    }else {
        controller = [[CommonAccController alloc] init];
    }
    controller.inset = UIEdgeInsetsMake(8, 16, 8, 16);
    return controller;
}

- (UIView *)emptyViewForListAdapter:(IGListAdapter *)listAdapter {
    return nil;
}

- (void)timeClick {
    if (self.selectButton == self.timeButton) {
        return;
    }
    self.selectButton = self.timeButton;
    self.timeButton.selected = YES;
    self.storeButton.selected = false;
    self.data[0] = @"选择2个对比时间";
    self.data[4] = @"选择分析对象";
    ((SelectionModel *)self.data[1]).name = @"选择对比时间";
    ((SelectionModel *)self.data[2]).name = @"选择对比时间";
    ((SelectionModel *)self.data[6]).name = @"全部门店";
    NSNumber *number = self.data[5];
    [self.data removeObject:number];
    [self.data insertObject:number atIndex:1];
    
    [self.data removeObjectAtIndex:4];
    [self.adapter performUpdatesAnimated:YES completion:^(BOOL finished) {
        [self.adapter reloadDataWithCompletion:nil];
    }];
    [self.view setNeedsLayout];
}

- (void)storeClick {
    if (self.selectButton == self.storeButton) {
        return;
    }
    self.selectButton = self.storeButton;
    self.timeButton.selected = false;
    self.storeButton.selected = YES;
    self.data[0] = @"选择2个或3个对比门店";
    self.data[4] = @"选择分析时间";
    ((SelectionModel *)self.data[2]).name = @"选择对比门店";
    ((SelectionModel *)self.data[3]).name = @"选择对比门店";
    ((SelectionModel *)self.data[5]).name = @"今天";
    NSNumber *number = self.data[1];
    [self.data removeObject:number];
    [self.data insertObject:number atIndex:4];
    [self.data insertObject:[[SelectionModel alloc] initWithName:@"选择对比门店"] atIndex:3];
    [self.adapter performUpdatesAnimated:YES completion:^(BOOL finished) {
        [self.adapter reloadDataWithCompletion:nil];
    }];
    [self.view setNeedsLayout];
    
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIBezierPath *)shapPath {
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    CGPoint point1 = CGPointMake(0, kTopHeight);
    UIView *controlView;
    if (self.timeButton.isSelected) {
        controlView = self.timeButton;
    }else {
        controlView = self.storeButton;
    }
    CGPoint point2 = CGPointMake(controlView.center.x-8, kTopHeight);
    CGPoint point3 = CGPointMake(controlView.center.x, kTopHeight-kArrowHeight);
    CGPoint point4 = CGPointMake(controlView.center.x+8, kTopHeight);
    CGPoint point5 = CGPointMake(CGRectGetWidth(self.view.frame), kTopHeight);
    CGPoint point6 = CGPointMake(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    CGPoint point7 = CGPointMake(0, CGRectGetHeight(self.view.frame));
    [bezierPath moveToPoint:point1];
    [bezierPath addLineToPoint:point2];
    [bezierPath addLineToPoint:point3];
    [bezierPath addLineToPoint:point4];
    [bezierPath addLineToPoint:point5];
    [bezierPath addLineToPoint:point6];
    [bezierPath addLineToPoint:point7];
    [bezierPath closePath];
    return bezierPath;
}

- (UIColor *)typeColor {
    if (self.timeButton.isSelected) {
        return [UIColor whiteColor];
    }else {
        return [UIColor greenColor];
    }
}
- (UIButton *)storeButton {
    if (!_storeButton) {
        _storeButton = [UIButton new];
        [_storeButton setTitle:@"门店选择" forState:UIControlStateNormal];
        [_storeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _storeButton.selected = false;
        [_storeButton addTarget:self action:@selector(storeClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _storeButton;
}

- (UIButton *)timeButton {
    if (!_timeButton) {
        _timeButton = [UIButton new];
        [_timeButton setTitle:@"时间对比" forState:UIControlStateNormal];
        [_timeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _timeButton.selected = YES;
        [_timeButton addTarget:self action:@selector(timeClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _timeButton;
}

-  (IGListCollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[IGListCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
    }
    return _collectionView;
}

- (IGListAdapter *)adapter {
    if (!_adapter) {
        _adapter = [[IGListAdapter alloc] initWithUpdater:[[IGListAdapterUpdater alloc] init] viewController:self workingRangeSize:0];
    }
    return _adapter;
}

- (NSMutableArray *)data {
    if (!_data) {
        _data = [NSMutableArray arrayWithArray:@[@"选择2个对比时间",@(1),[[SelectionModel alloc] initWithName:@"选择对比时间"],[[SelectionModel alloc] initWithName:@"选择对比时间"],@"选择分析对象",[[SelectionModel alloc] initWithName:@"全部门店"],@(2)]];
    }
    return _data;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton new];
        [_backButton setTitle:@"返回" forState:UIControlStateNormal];
        [_backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}
@end
