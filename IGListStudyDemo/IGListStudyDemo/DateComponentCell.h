//
//  DateSettingCell.h
//  iVMS-8700-MCU
//
//  Created by westke on 15/8/4.
//  Copyright (c) 2015年 HikVision. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DateComponentCellDelagate;

@interface DateComponentCell : UICollectionViewCell

@property (nonatomic, weak) id<DateComponentCellDelagate> delegate;
@property (nonatomic, copy) NSString *componentName;
@property (nonatomic, assign) NSInteger index;

@end

@protocol DateComponentCellDelagate <NSObject>

- (void)dateComponentCell:(DateComponentCell *)cell didSelectedAtIndex:(NSInteger)index;

@end