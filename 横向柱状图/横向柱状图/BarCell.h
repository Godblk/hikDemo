//
//  BarCell.h
//  横向柱状图
//
//  Created by 张行舟 on 2017/4/30.
//  Copyright © 2017年 zxz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BarCell : UITableViewCell
@property (nonatomic, strong) CAShapeLayer *fillShapeLayer;

- (void)setRate:(CGFloat )rate;
@end
