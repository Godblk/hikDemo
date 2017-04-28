//
//  CommonAccController.m
//  IGListStudyDemo
//
//  Created by zhangxingzhou on 2017/4/27.
//  Copyright © 2017年 hikvision. All rights reserved.
//

#import "CommonAccCell.h"
#import "SelectionModel.h"
#import "CommonAccController.h"

@interface CommonAccController ()
@property (nonatomic,strong) SelectionModel *model;

@end

@implementation CommonAccController
- (NSInteger)numberOfItems {
    return 1;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    CGFloat itemWidth =self.collectionContext.containerSize.width-self.inset.left-self.inset.right;
    return CGSizeMake(itemWidth, itemWidth/5);
    
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    CommonAccCell *cell = [self.collectionContext dequeueReusableCellOfClass:[CommonAccCell class] forSectionController:self atIndex:index];
    cell.titleLable.text = self.model.name;
    return cell;
}

- (void)didUpdateToObject:(id)object {
    if (![object isKindOfClass:[SelectionModel class]]) {
        return;
    }
    self.model = object;
}

- (void)didSelectItemAtIndex:(NSInteger)index {
    
}
@end
