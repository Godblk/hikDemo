//
//  ViewController.m
//  imageInImageDemo
//
//  Created by 张行舟 on 2017/8/9.
//  Copyright © 2017年 zxz. All rights reserved.
//

#import "UIImage+ZXZ.h"
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self init1];
    [self init2];
}

- (void)init1 {
    UIImage *image1 = [UIImage imageNamed:@"test1"];
    NSString *title = @"标题";
    CGRect rect = (CGRect){0.f,0.f,image1.size.width/2,image1.size.height/2};
    UIGraphicsBeginImageContextWithOptions(image1.size, NO, [UIScreen mainScreen].scale);
    CGContextAddPath(UIGraphicsGetCurrentContext(), [UIBezierPath bezierPathWithRect:(CGRect){0.f,0.f,image1.size}].CGPath);
    [image1 drawInRect:(CGRect){0.f,0.f,image1.size}];
    //根据矩形画带圆角的曲线
    CGContextAddPath(UIGraphicsGetCurrentContext(), [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:image1.size.width/4].CGPath);
    
    UIImage *image2 = [[UIImage imageNamed:@"test3"] circleImage];
    [image2 drawInRect:rect];
    [title drawAtPoint:CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect)) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor redColor]}];
    //图片缩放，是非线程安全的
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭上下文
    UIGraphicsEndImageContext();
    
    UIImageView *imageView=  [[UIImageView alloc] initWithImage:image];
    imageView.frame = (CGRect){0.f,0.f,image1.size};
    [self.view addSubview:imageView];
}

- (void)init2 {
    CGRect rect = CGRectMake(0, 0, 100, 200);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect aRect= CGRectMake(0, 150, 100,50);
    CGContextSetFillColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextAddEllipseInRect(context, aRect); //椭圆
    CGContextDrawPath(context, kCGPathStroke);
    
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView *imageView=  [[UIImageView alloc] initWithImage:image];
    imageView.frame = rect;
    [self.view addSubview:imageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
