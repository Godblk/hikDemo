//
//  DecorationLineView.m
//  timelineCollection
//
//  Created by 张行舟 on 2017/4/29.
//  Copyright © 2017年 zxz. All rights reserved.
//

#import "DecorationLineView.h"

@implementation DecorationLineView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}
@end
