//
//  DateSelectionController.m
//  IGListStudyDemo
//
//  Created by zhangxingzhou on 2017/4/27.
//  Copyright © 2017年 hikvision. All rights reserved.
//

#import "DateSelectionCell.h"
#import "DateSelectionController.h"

@implementation DateSelectionController
- (NSInteger)numberOfItems {
    return 1;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    CGFloat itemWidth =self.collectionContext.containerSize.width-self.inset.left-self.inset.right;
    return CGSizeMake(itemWidth, itemWidth/5);
    
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    DateSelectionCell *cell = [self.collectionContext dequeueReusableCellOfClass:[DateSelectionCell class] forSectionController:self atIndex:index];
    return cell;
}

- (void)didUpdateToObject:(id)object {
    
}

- (void)didSelectItemAtIndex:(NSInteger)index {
    
}
@end
