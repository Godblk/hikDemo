//
//  DateSettingCell.m
//  iVMS-8700-MCU
//
//  Created by westke on 15/8/4.
//  Copyright (c) 2015年 HikVision. All rights reserved.
//

#import "Masonry.h"
#import "DateComponentCell.h"

static CGFloat const kPadding = 2;

@interface DateComponentCell ()

@property (nonatomic, strong) UIButton *dateComponentButton; /** 组件按钮 */
@property (nonatomic, strong) UIView   *bottomLineView;      /** 底部的下划线 */

@end

@implementation DateComponentCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = [UIColor whiteColor];
    _dateComponentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _dateComponentButton.frame = CGRectZero;
    [_dateComponentButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _dateComponentButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_dateComponentButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [_dateComponentButton addTarget:self action:@selector(select) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_dateComponentButton];
    
    _bottomLineView = [[UIView alloc] init];
    _bottomLineView.backgroundColor = [UIColor orangeColor];
    _bottomLineView.hidden = YES;
    [self.contentView addSubview:_bottomLineView];
}

#pragma mark - Event Response
- (void)select {
    self.selected = YES;
    [_delegate dateComponentCell:self didSelectedAtIndex:self.index];
}

#pragma mark - Private
- (void)layoutSubviews {
    [super layoutSubviews];
    [_dateComponentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.bottomLineView.mas_top);
    }];
    [_bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kPadding);
        make.right.equalTo(self.contentView).with.offset(-kPadding);
        make.bottom.equalTo(self.contentView);
        make.height.equalTo(@(kPadding));
    }];
    if ([[UIDevice currentDevice].systemVersion floatValue] < 8.2) {
        [super layoutSubviews];
    }
}

#pragma mark - Setter
- (void)setComponentName:(NSString *)componentName {
    if (![_componentName isEqualToString:componentName]) {
        _componentName = [componentName copy];
    }
    [_dateComponentButton setTitle:_componentName forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    _dateComponentButton.selected = selected;
    [UIView animateWithDuration:0.25 animations:^{
        _bottomLineView.hidden = !selected;
    }];
}

@end
