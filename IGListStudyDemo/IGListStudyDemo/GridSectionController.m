//
//  GridSectionController.m
//  IGListStudyDemo
//
//  Created by zhangxingzhou on 2017/4/27.
//  Copyright © 2017年 hikvision. All rights reserved.
//

#import "CenterLableCell.h"
#import "GridSectionController.h"

@implementation GridSectionController
- (instancetype)init {
    if (self = [super init]) {
        self.minimumLineSpacing = 5;
        self.minimumInteritemSpacing = 4.5;
    }
    return self;
}

- (NSInteger)numberOfItems {
    return 4;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    CGFloat totalWidth = self.collectionContext.containerSize.width-self.inset.left-self.inset.right;
    CGFloat itemWidth = (totalWidth-10)/3;
    if (index == 0) {
        return CGSizeMake(totalWidth, itemWidth);
    }else {
        return CGSizeMake(itemWidth, itemWidth);
    }
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    CenterLableCell *cell = [self.collectionContext dequeueReusableCellOfClass:[CenterLableCell class] forSectionController:self atIndex:index];
    cell.textlable.text = [NSString stringWithFormat:@"%ld",(long)index];
    cell.backgroundColor = [UIColor redColor];
    return cell;
}

- (void)didUpdateToObject:(id)object {
    
}

- (void)didSelectItemAtIndex:(NSInteger)index {
    
}
@end
