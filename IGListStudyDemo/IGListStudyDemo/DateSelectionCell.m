//
//  DateSelectionCell.m
//  IGListStudyDemo
//
//  Created by zhangxingzhou on 2017/4/27.
//  Copyright © 2017年 hikvision. All rights reserved.
//

#import "Masonry.h"
#import "DateSelectionView.h"
#import "DateSelectionCell.h"

@interface DateSelectionCell ()
@property (nonatomic ,strong) DateSelectionView *selectionView;
@end

@implementation DateSelectionCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.selectionView = [[DateSelectionView alloc] init];
        self.selectionView.backgroundColor =[UIColor whiteColor];
        
        [self.contentView addSubview:self.selectionView];
        [self.selectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}
@end
