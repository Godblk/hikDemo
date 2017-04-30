//
//  ViewController.m
//  timelineCollection
//
//  Created by 张行舟 on 2017/4/29.
//  Copyright © 2017年 zxz. All rights reserved.
//

#import "CSCTimeLineLayout.h"
#import "DecorationLineView.h"
#import "ViewController.h"
#import "HeadCollectionReusableView.h"
#import "ImageCollectionViewCell.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)

@interface ViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>

@property (nonatomic ,strong) UICollectionView *collectionView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.collectionView];
}

- (void)viewDidLayoutSubviews {
    self.collectionView.frame = self.view.bounds;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *view;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head" forIndexPath:indexPath];
    }else {
        view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
    }
    return view;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 3) {
        return CGSizeMake(50, 2);
    }else {
        return CGSizeZero;
    }
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CSCTimeLineLayout *layout = [[CSCTimeLineLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake(SCREEN_WIDTH/4, SCREEN_WIDTH/4);
        layout.headerReferenceSize = CGSizeMake(50, 50);
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 50);
        if ([UIDevice currentDevice].systemVersion.floatValue >= 9.0) {
            layout.sectionHeadersPinToVisibleBounds = YES;
        }
        _collectionView  =[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource  =self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[ImageCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        [_collectionView registerClass:[HeadCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    }
    return _collectionView;
}

@end
