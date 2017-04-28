//
//  CommonAccCell.m
//  IGListStudyDemo
//
//  Created by zhangxingzhou on 2017/4/27.
//  Copyright © 2017年 hikvision. All rights reserved.
//

#import "Masonry.h"
#import "CommonAccCell.h"

@implementation CommonAccCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.titleLable = [UILabel new];
        self.titleLable.textColor = [UIColor grayColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.iconImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"next_icon"]];
        [self.contentView addSubview:self.titleLable];
        [self.contentView addSubview:self.iconImage];
        [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(10);
        }];
        
        [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-10);
        }];
    }
    return self;
}
@end
