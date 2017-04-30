//
//  HeadCollectionReusableView.m
//  timelineCollection
//
//  Created by 张行舟 on 2017/4/30.
//  Copyright © 2017年 zxz. All rights reserved.
//

#import "Masonry.h"
#import "HeadCollectionReusableView.h"

@implementation HeadCollectionReusableView
-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UILabel *lable = [UILabel new];
        [self addSubview:lable];
        lable.text = @"dfsdfsf";
        lable.textAlignment = NSTextAlignmentRight;
        lable.textColor = [UIColor blackColor];
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

@end
