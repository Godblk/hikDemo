//
//  CSCGCDQueue.m
//  ChainStoreCloud
//
//  Created by zhangxingzhou on 17/1/6.
//  Copyright © 2017年 hikvision. All rights reserved.
//

#import "CSCGCDQueue.h"

static CSCGCDQueue *mainQueue;

@implementation CSCGCDQueue

#pragma mark - 便利的构造方法
+ (void)executeInMainQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec {
    
    NSParameterAssert(block);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * sec),dispatch_get_main_queue(), block);
}

@end
