//
//  CSCCarouselView.h
//  storeselectDemo
//
//  Created by 张行舟 on 2017/2/10.
//  Copyright © 2017年 hikvision. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CSCCarouselViewState)
{
    carouselStateCommon = 0,
    carouselStateDeleting
};

@class CSCCarouselView;
@protocol CSCCarouselViewDelegate <NSObject>

- (UIView *)carousel:(CSCCarouselView *)carousel viewForItemAtIndex:(NSInteger)index;
- (void)carousel:(CSCCarouselView *)carousel willDeleteItemAtIndex:(NSInteger)index;
- (void)carouselWillDeleteAllItem:(CSCCarouselView *)carousel;

@optional
- (void)carousel:(CSCCarouselView *)carousel didSelectItemAtIndex:(NSInteger)index;
@end

@interface CSCCarouselView : UIView
@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, assign) CSCCarouselViewState state;
@property (nonatomic, weak) id<CSCCarouselViewDelegate> delegate;

- (void)insertItemAtIndex:(NSInteger)index animated:(BOOL)animated;
- (void)removeItemAtIndex:(NSInteger)index animated:(BOOL)animated;
- (void)removeAllItemsAnimated:(BOOL)animated;
@end
