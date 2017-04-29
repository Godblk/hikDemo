//
//  CALayer+Extension.m
//  drawDemo
//
//  Created by 张行舟 on 2017/4/29.
//  Copyright © 2017年 zxz. All rights reserved.
//

#import "CALayer+Extension.h"

@implementation CALayer (Extension)
- (CGFloat)transformScaleX {
    NSNumber *v = [self valueForKeyPath:@"transform.scale.x"];
    return v.doubleValue;
}

- (void)setTransformScaleX:(CGFloat)v {
    [self setValue:@(v) forKeyPath:@"transform.scale.x"];
}

- (CGFloat)transformScaleY {
    NSNumber *v = [self valueForKeyPath:@"transform.scale.y"];
    return v.doubleValue;
}

- (void)setTransformScaleY:(CGFloat)v {
    [self setValue:@(v) forKeyPath:@"transform.scale.y"];
}
@end
