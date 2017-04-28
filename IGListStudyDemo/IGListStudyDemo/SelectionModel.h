//
//  SelectionModel.h
//  IGListStudyDemo
//
//  Created by zhangxingzhou on 2017/4/27.
//  Copyright © 2017年 hikvision. All rights reserved.
//

#import <IGListKit/IGListKit.h>
#import <Foundation/Foundation.h>

@interface SelectionModel : NSObject<IGListDiffable>
@property (nonatomic ,copy) NSString *name;

- (instancetype)initWithName:(NSString *)name;
@end
