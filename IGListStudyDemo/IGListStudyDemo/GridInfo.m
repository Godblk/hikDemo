//
//  GridInfo.m
//  IGListStudyDemo
//
//  Created by zhangxingzhou on 2017/4/27.
//  Copyright © 2017年 hikvision. All rights reserved.
//

#import "GridInfo.h"

@implementation GridInfo
- (BOOL)isEqualToDiffableObject:(id<IGListDiffable>)object {
    return self == object ? true : [self isEqual:object];
}

- (id<NSObject>)diffIdentifier {
    return self;
}
@end
