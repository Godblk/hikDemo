//
//  BarCell.m
//  横向柱状图
//
//  Created by 张行舟 on 2017/4/30.
//  Copyright © 2017年 zxz. All rights reserved.
//

#import "BarCell.h"

@implementation BarCell{
    CGFloat _rate;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIBezierPath* path = [UIBezierPath bezierPathWithRect:CGRectMake(10, 5, 0, 30)];
        self.fillShapeLayer             = [CAShapeLayer layer];
        self.fillShapeLayer.path        = path.CGPath;
        self.fillShapeLayer.fillColor   = [UIColor greenColor].CGColor;
        self.backgroundColor = [UIColor grayColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView.layer addSublayer:self.fillShapeLayer];
    }
    return self;
}

- (void)prepareForReuse {
    UIBezierPath* path = [UIBezierPath bezierPathWithRect:CGRectMake(10, 5, 0, 30)];
    self.fillShapeLayer.path        = path.CGPath;
}

-(void)drawRect:(CGRect)rect {
    rect = UIEdgeInsetsInsetRect(rect, UIEdgeInsetsMake(5, 10, 5, 10));
    CGFloat rate = _rate/100;
    CGFloat width = CGRectGetWidth(rect)*rate;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(rect.origin.x, rect.origin.y, width, CGRectGetHeight(rect))];
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    basicAnimation.duration          = 0.7;
    basicAnimation.fromValue         = (__bridge id)(self.fillShapeLayer.path);
    basicAnimation.toValue           = (__bridge id)path.CGPath;
    self.fillShapeLayer.path         = path.CGPath;
    [self.fillShapeLayer addAnimation:basicAnimation forKey:@"fillShapeLayerPath"];
}


- (void)setRate:(CGFloat)rate { 
    _rate  =rate;
    [self setNeedsDisplay];
}

@end
