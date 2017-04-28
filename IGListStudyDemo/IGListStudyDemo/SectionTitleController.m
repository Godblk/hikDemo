//
//  SectionTitleController.m
//  IGListStudyDemo
//
//  Created by zhangxingzhou on 2017/4/27.
//  Copyright © 2017年 hikvision. All rights reserved.
//

#import "SectionTitleCell.h"
#import "SectionTitleController.h"

@interface SectionTitleController ()
@property (nonatomic ,strong) NSString *title;

@end

@implementation SectionTitleController
- (NSInteger)numberOfItems {
    return 1;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    CGFloat itemWidth =self.collectionContext.containerSize.width-self.inset.left-self.inset.right;
    return CGSizeMake(itemWidth, itemWidth/5);
    
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    SectionTitleCell *cell = [self.collectionContext dequeueReusableCellOfClass:[SectionTitleCell class] forSectionController:self atIndex:index];
    cell.titleLable.text = self.title;
    return cell;
}

- (void)didUpdateToObject:(id)object {
    if (![object isKindOfClass:[NSString class]]) {
        return;
    }
    self.title = object;
}

- (void)didSelectItemAtIndex:(NSInteger)index {
    
}
@end
