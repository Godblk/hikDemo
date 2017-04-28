//
//  SectionTitleCell.m
//  IGListStudyDemo
//
//  Created by zhangxingzhou on 2017/4/27.
//  Copyright © 2017年 hikvision. All rights reserved.
//

#import "Masonry.h"
#import "SectionTitleCell.h"

@implementation SectionTitleCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.titleLable = [UILabel new];
        self.titleLable.textColor = [UIColor grayColor];
        self.titleLable.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.titleLable];
        [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}
@end
