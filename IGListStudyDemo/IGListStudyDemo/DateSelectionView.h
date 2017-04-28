//
//  DateSettingsView.h
//  iVMS-8700-MCU
//
//  Created by westke on 15/8/4.
//  Copyright (c) 2015年 HikVision. All rights reserved.
//

#import <UIKit/UIKit.h>
/*!
 *  @brief 定义日期组件的类型
 */
typedef NS_ENUM (NSUInteger, DateComponentType){
    DateComponentTypeDay = 1,
    DateComponentTypeWeek,
    DateComponentTypeMonth,
    DateComponentTypeYear
};

@protocol DateSelectionViewDelegate;

@interface DateSelectionView : UIView

@property (nonatomic, weak) id<DateSelectionViewDelegate> delegate;
@property (nonatomic, assign) DateComponentType           selectComponent;

- (void)selectDate;

@end

@protocol DateSelectionViewDelegate <NSObject>

- (void)dateSelectionViewWillShow:(DateSelectionView *)selectionView;
- (void)dateSelectionView:(DateSelectionView *)selectionView selectResult:(NSString *)result;
- (void)cancelSelectForSelectionView:(DateSelectionView *)selectionView;

@end