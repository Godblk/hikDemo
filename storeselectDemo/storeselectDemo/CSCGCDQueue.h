//
//  CSCGCDQueue.h
//  ChainStoreCloud
//
//  Created by zhangxingzhou on 17/1/6.
//  Copyright © 2017年 hikvision. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSCGCDQueue : NSObject

+ (void)executeInMainQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec;

@end
