//
//  CSCCarouselView.m
//  storeselectDemo
//
//  Created by 张行舟 on 2017/2/10.
//  Copyright © 2017年 hikvision. All rights reserved.
//

#import "CSCCarouselView.h"
#import <objc/message.h>

static const CGFloat kCarouselViewAnimateTime = 0.4;
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
@interface CSCCarouselView ()
<
UIGestureRecognizerDelegate
>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIPanGestureRecognizer *itemPangesture;
@property (nonatomic, strong) NSMutableArray<UIView *> *itemViews;
@property (nonatomic, strong) NSMutableDictionary *itemViewsPool;
@end

@implementation CSCCarouselView{
    CGFloat _foldItemsWidth;
    CGFloat _foldItemsOffset;
}

#pragma mark ========Life cycle
- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    _itemViews = [NSMutableArray array];
    _itemViewsPool = [NSMutableDictionary new];
    _contentView = [[UIView alloc] initWithFrame:self.bounds];
    _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //add tap gesture recogniser
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    tapGesture.delegate = (id <UIGestureRecognizerDelegate>)self;
    [_contentView addGestureRecognizer:tapGesture];
    _foldItemsOffset = 0;
    _itemPangesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPanItemView:)];
    //set up accessibility
    self.accessibilityTraits = UIAccessibilityTraitAllowsDirectInteraction;
    self.isAccessibilityElement = YES;
    
    [self addSubview:_contentView];
}

#pragma mark =======private actions
- (void)insertItemAtIndex:(NSInteger)index animated:(BOOL)animated{
    [self loadViewAtIndex:index];
    self.userInteractionEnabled = false;
    if (animated) {
        [UIView animateWithDuration:kCarouselViewAnimateTime animations:^{
            [self transformItemViews];
        } completion:^(BOOL finished) {
            [self depthSortViews];
        }];
    }else {
        [self transformItemViews];
        [self depthSortViews];
    }
}

- (void)removeItemAtIndex:(NSInteger)index animated:(BOOL)animated {
    UIView *view = _itemViews.lastObject;
    [self removeView:view];
    self.userInteractionEnabled = false;
    if (animated) {
        [UIView animateWithDuration:kCarouselViewAnimateTime animations:^{
            view.superview.transform = CGAffineTransformMakeTranslation(_itemWidth*2, 0);
            [self transformItemViews];
        } completion:^(BOOL finished) {
            [view.superview removeFromSuperview];
            [self depthSortViews];
            _state = carouselStateCommon;
        }];
    }else {
        [self transformItemViews];
        [self depthSortViews];
        _state = carouselStateCommon;
    }
}

- (void)transformItemViews {
    for (UIView *view in _itemViews) {
        [self transformItemView:view atIndex:[_itemViews indexOfObject:view]];
    }
}

- (void)transformItemView:(UIView *)view atIndex:(NSInteger)index {
    CGFloat offsetX;
    if (index == 0) {
        offsetX = 0;
    }else if (index == _itemViews.count -1) {
        offsetX = _itemWidth;
    }else if (index == _itemViews.count -2){
        offsetX = _itemWidth/4;
    }else {
        offsetX = (CGFloat)(index)/(CGFloat)(_itemViews.count -2)*_itemWidth/4;
    }
    view.superview.transform = CGAffineTransformMakeTranslation(offsetX, 0);
}

#pragma mark ====== view loading
- (void)loadViewAtIndex:(NSInteger)index {
    UIView *view = nil;
    if (_delegate && [_delegate respondsToSelector:@selector(carousel:viewForItemAtIndex:)]) {
        view = [_delegate carousel:self viewForItemAtIndex:index];
    }
    if (!view) {
        view = [UIView new];
    }
    [self addView:view];
    [_contentView addSubview:[self wrapView:view]];
    view.superview.transform = CGAffineTransformMakeTranslation(_itemWidth*2, 0);
}

- (void)depthSortViews {
    self.userInteractionEnabled = YES;
    for (UIView *view in _itemViews) {
        NSInteger index = [_itemViews indexOfObject:view];
        view.superview.tag = index;
        [view.superview removeGestureRecognizer:_itemPangesture];
        if (_itemViews.count > 1 && index == _itemViews.count -1) {
            [view.superview addGestureRecognizer:_itemPangesture];
        }
    }
    [self focusView];
}


- (UIView *)wrapView:(UIView *)view {
    UIView *containerView = [[UIView alloc] initWithFrame:view.frame];
    [containerView addSubview:view];
    return containerView;
}

#pragma mark ======Gesture actions
- (NSInteger)viewOrSuperviewIndex:(UIView *)view
{
    if (view == nil || view == _contentView)
    {
        return NSNotFound;
    }
    NSInteger index = [self indexOfItemView:view];
    if (index == NSNotFound)
    {
        return [self viewOrSuperviewIndex:view.superview];
    }
    return index;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gesture shouldReceiveTouch:(UITouch *)touch {
    if ([gesture isKindOfClass:[UITapGestureRecognizer class]])
    {
        //handle tap
        NSInteger index = [self viewOrSuperviewIndex:[self itemViewAtPoint:[touch locationInView:self]]];
        UIView *itemView = [self itemViewAtIndex:index];
//        if ([_contentView.subviews.lastObject isEqual:itemView.superview]) {
//            return false;
//        }
        if (_itemViews.count > 2 && index >= _itemViews.count - 2) {
            return false;
        }else if ([_contentView.subviews.lastObject isEqual:itemView.superview]) {
            return false;
        }
        
    }
    return YES;
}

- (void)didTap:(UITapGestureRecognizer *)tapGesture {
    //check for tapped view
    UIView *itemView = [self itemViewAtPoint:[tapGesture locationInView:_contentView]];
    if (itemView) {
        NSInteger index = [self indexOfItemView:itemView];
        if (index == _itemViews.count - 2) {
            if (_delegate && [_delegate respondsToSelector:@selector(carousel:willDeleteItemAtIndex:)]) {
                [_delegate carousel:self willDeleteItemAtIndex:_itemViews.count-1];
            }
//            if (_itemViews.count ==2) {
//                if (_delegate && [_delegate respondsToSelector:@selector(carousel:willDeleteItemAtIndex:)]) {
//                    [_delegate carousel:self willDeleteItemAtIndex:_itemViews.count-1];
//                }
//                return;
//            }else {
//                self.userInteractionEnabled = false;
//                _foldItemsOffset = _itemWidth/3;
//                [UIView animateWithDuration:kCarouselViewAnimateTime animations:^{
//                    [self transformItemViews];
//                } completion:^(BOOL finished) {
//                    _foldItemsOffset = 0;
//                    self.userInteractionEnabled = YES;
//                    [_contentView bringSubviewToFront:itemView.superview];
//                    [self focusViewAtIndex:index];
//                }];
//            }
            
        }else if (index == _itemViews.count - 1) {
            self.userInteractionEnabled = false;
            [UIView animateWithDuration:kCarouselViewAnimateTime animations:^{
                [_contentView bringSubviewToFront:itemView.superview];
                itemView.superview.transform = CGAffineTransformMakeTranslation(_itemWidth, 0);
            } completion:^(BOOL finished) {
                self.userInteractionEnabled = YES;
                [self focusView];
            }];
        }else {
            if (_delegate && [_delegate respondsToSelector:@selector(carouselWillDeleteAllItem:)]) {
                [_delegate carouselWillDeleteAllItem:self];
            }
        }
    }
}

- (void)didPanItemView:(UIPanGestureRecognizer *)panGesture {
    CGPoint translation = [panGesture translationInView:self];
    if (panGesture.state == UIGestureRecognizerStateEnded && translation.x > 20 && translation.y < 30 && _state != carouselStateDeleting) {
        _state = carouselStateDeleting;
        [panGesture setTranslation:CGPointZero inView:self];
        [panGesture.view removeGestureRecognizer:panGesture];
        [panGesture setTranslation:CGPointZero inView:self];
        self.userInteractionEnabled = false;
        if (_delegate && [_delegate respondsToSelector:@selector(carousel:willDeleteItemAtIndex:)]) {
            [_delegate carousel:self willDeleteItemAtIndex:panGesture.view.tag];
        }
    }
}

#pragma mark ====== 数组操作
- (void)addView:(UIView *)view{
    [_itemViews addObject:view];
}

- (void)removeView:(UIView *)view {
    [_itemViews removeObject:view];
}

- (NSInteger)indexOfItemView:(UIView *)view
{
    NSInteger index = [_itemViews indexOfObject:view];
    if (index != NSNotFound)
    {
        return index;
    }
    return NSNotFound;
}

- (UIView *)itemViewAtIndex:(NSInteger )index {
    if (index >= 0 && index < _itemViews.count) {
        return _itemViews[index];
    }
    return nil;
}

- (void)focusView{
    for (UIView *view in _itemViews)
    {
        NSInteger index = [_itemViews indexOfObject:view];
        if (_itemViews.count > 2) {
            if (index >= _itemViews.count-2) {
                view.superview.userInteractionEnabled = YES;
            }else {
                view.superview.userInteractionEnabled = false;
            }
        }else {
            if (index == _itemViews.count-1) {
                view.superview.userInteractionEnabled = YES;
            }else {
                view.superview.userInteractionEnabled = false;
            }
        }
    }
}

- (UIView *)itemViewAtPoint:(CGPoint)point
{
    for (UIView *view in [_itemViews reverseObjectEnumerator])
    {
        if ([view.superview.layer hitTest:point])
        {
            return view;
        }
    }
    return nil;
}

#pragma mark === Setter and Getter
- (void)setItemWidth:(CGFloat)itemWidth {
    _itemWidth = itemWidth;
    _foldItemsWidth = SCREEN_WIDTH-itemWidth;
}
@end
