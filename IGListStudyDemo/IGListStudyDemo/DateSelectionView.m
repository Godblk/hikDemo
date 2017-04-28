//
//  DateSettingsView.m
//  iVMS-8700-MCU
//
//  Created by westke on 15/8/4.
//  Copyright (c) 2015年 HikVision. All rights reserved.
//
#import "Masonry.h"
#import "DateComponentCell.h"
#import "DateSelectionView.h"

static NSInteger const kComponentCount = 4;  /** 组件的数量 */
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
@interface DateSelectionView ()
<
UICollectionViewDelegateFlowLayout,
UICollectionViewDataSource,
UICollectionViewDelegate,
DateComponentCellDelagate
>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray          *dataSource;

@end

@implementation DateSelectionView

#pragma mark - life circle
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupViews];
        
    }
    return self;
}

- (void)setupViews {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView                 = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[DateComponentCell class] forCellWithReuseIdentifier:NSStringFromClass([DateComponentCell class])];
    _collectionView.delegate   = self;
    _collectionView.dataSource = self;
    _collectionView.scrollEnabled = NO;
    [self addSubview:_collectionView];
}

#pragma mark - Private
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
    }];
    if ([[UIDevice currentDevice].systemVersion floatValue] < 8.2) {
        [super layoutSubviews];
    }
    //切换横屏的时候 日期选择组件进行屏幕适配。
    [_collectionView reloadData];
}

#pragma mark - UICollectionViewLayoutDelegate
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(SCREEN_WIDTH / kComponentCount, CGRectGetHeight(self.frame));
}

#pragma mark - UICollectionViewDateSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DateComponentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([DateComponentCell class]) forIndexPath:indexPath];
    cell.delegate = self;
    cell.index = indexPath.row;
    if (self.selectComponent - 1 == indexPath.row) {
        cell.selected = YES;
    }
    cell.componentName = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark - DateComponentCell
- (void)dateComponentCell:(DateComponentCell *)cell didSelectedAtIndex:(NSInteger)index {
    if (_delegate && [_delegate respondsToSelector:@selector(dateSelectionViewWillShow:)]) {
        [_delegate dateSelectionViewWillShow:self];
    }
    self.selectComponent = (DateComponentType)(index + 1);
    [self selectDate];
}

#pragma mark - Event Response
- (void)selectDate {
    [self.collectionView reloadData];
   
}

- (void)callback:(NSString *)result {
    if (_delegate && [_delegate respondsToSelector:@selector(dateSelectionView:selectResult:)]) {
        [_delegate dateSelectionView:self selectResult:result];
    }
}

- (void)cancelPick {
    if (_delegate && [_delegate respondsToSelector:@selector(cancelSelectForSelectionView:)]) {
        [_delegate cancelSelectForSelectionView:self];
    }
}

#pragma mark - Getter
- (void)setSelectComponent:(DateComponentType)selectComponent {
    _selectComponent = selectComponent;
    [_collectionView reloadData];
}

- (NSArray *)dataSource {
    if (!_dataSource) {
        _dataSource = @[@"日", @"周", @"月", @"年"];
    }
    return _dataSource;
}

@end
