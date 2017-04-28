//
//  StatisticsSectionController.m
//  IGListStudyDemo
//
//  Created by zhangxingzhou on 2017/4/27.
//  Copyright © 2017年 hikvision. All rights reserved.
//

#import "CenterLableCell.h"
#import "StatisticsSectionController.h"

@implementation StatisticsSectionController
- (instancetype)init {
    if (self = [super init]) {
        self.minimumLineSpacing = 5;
        self.minimumInteritemSpacing = 5;
    }
    return self;
}

- (NSInteger)numberOfItems {
    return 3;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    CGFloat itemWidth = self.collectionContext.containerSize.width-self.inset.left-self.inset.right;
    return CGSizeMake(itemWidth, itemWidth/4);
    
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    CenterLableCell *cell = [self.collectionContext dequeueReusableCellOfClass:[CenterLableCell class] forSectionController:self atIndex:index];
    cell.textlable.text = [NSString stringWithFormat:@"%ld",(long)index];
    cell.backgroundColor = [UIColor greenColor];
    return cell;
}

- (void)didUpdateToObject:(id)object {
    
}

- (void)didSelectItemAtIndex:(NSInteger)index {
    
}
@end
