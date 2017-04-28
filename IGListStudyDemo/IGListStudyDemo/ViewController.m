//
//  ViewController.m
//  IGListStudyDemo
//
//  Created by zhangxingzhou on 2017/4/27.
//  Copyright © 2017年 hikvision. All rights reserved.
//

#import <IGListKit/IGListKit.h>
#import "ViewController.h"
#import "MessageInfo.h"
#import "GridInfo.h"
#import "StatisticInfo.h"
#import "MessageSectionController.h"
#import "GridSectionController.h"
#import "StatisticsSectionController.h"

@interface ViewController ()
<
IGListAdapterDataSource
>

@property (nonatomic ,strong)  IGListCollectionView *collectionView;
@property (nonatomic ,strong)  IGListAdapter *adapter;
@property (nonatomic ,strong)  NSArray *data;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.collectionView];
    self.adapter.collectionView = self.collectionView;
    self.adapter.dataSource = self;
}

- (void)viewDidAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = false;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.collectionView.frame = self.view.bounds;
}

#pragma mark ==IGListAdapterDataSource
- (NSArray<id<IGListDiffable>> *)objectsForListAdapter:(IGListAdapter *)listAdapter {
    return self.data;
}

- (IGListSectionController<IGListSectionType> *)listAdapter:(IGListAdapter *)listAdapter sectionControllerForObject:(id)object {
    IGListSectionController<IGListSectionType> *controller;
    if ([object isKindOfClass:[MessageInfo class]]) {
        controller = [[MessageSectionController alloc] init];
    }else if ([object isKindOfClass:[GridInfo class]]) {
        controller = [[GridSectionController alloc] init];
    }else {
        controller = [[StatisticsSectionController alloc] init];
    }
    controller.inset = UIEdgeInsetsMake(8, 16, 8, 16);
    return controller;
}

- (UIView *)emptyViewForListAdapter:(IGListAdapter *)listAdapter {
    return nil;
}

-  (IGListCollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[IGListCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    }
    return _collectionView;
}

- (IGListAdapter *)adapter {
    if (!_adapter) {
        _adapter = [[IGListAdapter alloc] initWithUpdater:[[IGListAdapterUpdater alloc] init] viewController:self workingRangeSize:0];
    }
    return _adapter;
}

- (NSArray *)data {
    if (!_data) {
        MessageInfo *messageInfo = [[MessageInfo alloc] init];
        GridInfo *gridInfo = [[GridInfo alloc] init];
        StatisticInfo *statiInfo = [[StatisticInfo alloc] init];
        _data = @[messageInfo,gridInfo,statiInfo];
    }
    return _data;
}
@end
