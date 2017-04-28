//
//  ConfirmCell.m
//  IGListStudyDemo
//
//  Created by zhangxingzhou on 2017/4/27.
//  Copyright © 2017年 hikvision. All rights reserved.
//

#import "Masonry.h"
#import "ConfirmCell.h"

@implementation ConfirmCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.confirmButton = [UIButton new];
        [self.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [self.confirmButton setBackgroundColor:[UIColor orangeColor]];
        [self.contentView addSubview:self.confirmButton];
        [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(4, 8, 4, 8));
        }];
    }
    return self;
}
@end
