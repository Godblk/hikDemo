//
//  CenterLableCell.m
//  IGListStudyDemo
//
//  Created by zhangxingzhou on 2017/4/27.
//  Copyright © 2017年 hikvision. All rights reserved.
//

#import "CenterLableCell.h"

@implementation CenterLableCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.textlable = [UILabel new];
        self.textlable.backgroundColor = [UIColor clearColor];
        self.textlable.textAlignment = NSTextAlignmentCenter;
        self.textlable.textColor = [UIColor whiteColor];
        self.textlable.font = [UIFont boldSystemFontOfSize:18];
        [self.contentView addSubview:self.textlable];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textlable.frame = self.contentView.bounds;
}
@end
