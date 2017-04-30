//
//  CSCTimeLineLayout.m
//  timelineCollection
//
//  Created by 张行舟 on 2017/4/29.
//  Copyright © 2017年 zxz. All rights reserved.
//

#import "CSCTimeLineLayout.h"
#import "DecorationLineView.h"



static NSString *decorationLineViewKind = @"lineView";

@interface CSCTimeLineLayout ()


@end

@implementation CSCTimeLineLayout{
    CGFloat _footerXOffset;
    CGFloat _decorationLineXOffset;
}

- (instancetype)init {
    if (self = [super init]) {
        _footerXOffset = 8.0f;
        _decorationLineXOffset = 18.0f;
        [self registerClass:[DecorationLineView class] forDecorationViewOfKind:decorationLineViewKind];
        self.footerReferenceSize = CGSizeMake(10, 2);
        self.sectionInset = UIEdgeInsetsMake(10, 48, 10, 50);
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _footerXOffset = 8.0f;
        _decorationLineXOffset = 18.0f;
        [self registerClass:[DecorationLineView class] forDecorationViewOfKind:decorationLineViewKind];
        self.footerReferenceSize = CGSizeMake(10, 2);
        self.sectionInset = UIEdgeInsetsMake(10, 48, 10, 50);
    }
    return self;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray<UICollectionViewLayoutAttributes *> *layoutAttrs = [NSMutableArray arrayWithArray:[super layoutAttributesForElementsInRect:rect]];
    NSMutableArray *headers = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes *attr in layoutAttrs) {
        if ([attr.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            [headers addObject:attr];
        }
    }
    if (headers.count > 0) {
        NSInteger sectionCount = [self.collectionView.dataSource numberOfSectionsInCollectionView:self.collectionView];
        for (UICollectionViewLayoutAttributes *headAttr in headers) {
            UICollectionViewLayoutAttributes *decorationViewLayoutAttr = [self layoutAttributesForDecorationViewOfKind:decorationLineViewKind atIndexPath:headAttr.indexPath];
            if (decorationViewLayoutAttr) {
                [layoutAttrs addObject:decorationViewLayoutAttr];
            }
            CGSize headSize = headAttr.size;
            CGFloat lineLength = 0;
            if (headAttr.indexPath.section < sectionCount-1) {
                UICollectionViewLayoutAttributes *nexHeaderLayoutAttr = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:headAttr.indexPath.section+1]];
                if (nexHeaderLayoutAttr) {
                    lineLength = nexHeaderLayoutAttr.frame.origin.y - headAttr.frame.origin.y;
                }
            }else {
                NSMutableArray *footers = [NSMutableArray array];
                for (UICollectionViewLayoutAttributes *attr in layoutAttrs) {
                    if ([attr.representedElementKind isEqualToString:UICollectionElementKindSectionFooter] && attr.indexPath.section == headAttr.indexPath.section) {
                        [footers addObject:attr];
                    }
                }
                if (footers.count == 1) {
                    UICollectionViewLayoutAttributes *footerLayoutAttr = footers.firstObject;
                    CGFloat y = footerLayoutAttr.frame.origin.y;
                    footerLayoutAttr.frame = CGRectMake(_footerXOffset, y, 20, 2);
                    lineLength =  y - headAttr.frame.origin.y - headSize.height / 2;
                }else{
                    lineLength = rect.size.height + rect.origin.y - headAttr.frame.origin.y - headSize.height / 2;
                }
            }
            decorationViewLayoutAttr.frame = CGRectMake(headAttr.frame.size.width - _decorationLineXOffset, headAttr.frame.origin.y + headSize.height / 2, 0.55, lineLength);
        }
    }
    return layoutAttrs;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    CGRect oldBounds = self.collectionView.bounds;
    if (CGRectEqualToRect(oldBounds, newBounds)) {
        return false;
    }else{
        return true;
    }
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    return [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:elementKind withIndexPath:indexPath];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *layoutAttr = [super layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
    if ([elementKind isEqualToString:UICollectionElementKindSectionFooter]){
        CGPoint origin = layoutAttr.frame.origin;
        layoutAttr.frame = CGRectMake(_footerXOffset, origin.y, 20, 2);
    }
    return layoutAttr;
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingSupplementaryElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)elementIndexPath {
    UICollectionViewLayoutAttributes *layoutAttr = [super initialLayoutAttributesForAppearingSupplementaryElementOfKind:elementKind atIndexPath:elementIndexPath];
    if ([elementKind isEqualToString:UICollectionElementKindSectionFooter]){
        layoutAttr.size = CGSizeZero;
    }
    return layoutAttr;
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingDecorationElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)decorationIndexPath {
    UICollectionViewLayoutAttributes *layoutAttr = [super initialLayoutAttributesForAppearingDecorationElementOfKind:elementKind atIndexPath:decorationIndexPath];
    UICollectionViewLayoutAttributes *headerLayoutAttr = [self initialLayoutAttributesForAppearingSupplementaryElementOfKind:UICollectionElementKindSectionHeader atIndexPath:decorationIndexPath];
    CGFloat offsetY  = 0;
    if (headerLayoutAttr){
        offsetY = headerLayoutAttr.frame.origin.y + headerLayoutAttr.size.height / 2;
    }
    layoutAttr.frame = CGRectMake(_decorationLineXOffset, offsetY, 1.0, 1.0);
    
    return layoutAttr;
}

@end
