//
//  ViewController.m
//  calendarDemo
//
//  Created by 张行舟 on 2017/8/10.
//  Copyright © 2017年 zxz. All rights reserved.
//
#import "FSCalendar.h"
#import "ViewController.h"

@interface ViewController ()<FSCalendarDataSource,FSCalendarDelegate,FSCalendarDelegateAppearance>
@property (weak, nonatomic) FSCalendar *calendar;
@property (strong, nonatomic) NSCalendar *gregorian;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    CGFloat height = 300;
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, height)];
    calendar.dataSource = self;
    calendar.delegate = self;
    calendar.allowsMultipleSelection = false;
    calendar.swipeToChooseGesture.enabled = false;
    calendar.backgroundColor = [UIColor whiteColor];
    calendar.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
    calendar.today = nil;
//    calendar.placeholderType = FSCalendarPlaceholderTypeNone;
    calendar.appearance.caseOptions = FSCalendarCaseOptionsHeaderUsesUpperCase|FSCalendarCaseOptionsWeekdayUsesSingleUpperCase;
    calendar.appearance.headerDateFormat = @"yyyy年MM月";
    [self.view addSubview:calendar];
    self.calendar = calendar;
    [calendar selectDate:[NSDate date]];
    
    UITapGestureRecognizer *gesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap)];
    [self.calendar.calendarHeaderView addGestureRecognizer:gesture];
    self.gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
}

- (void)didTap {
    NSLog(@"点击了");
}

#pragma mark ===FSCalendarDataSource
- (nullable NSString *)calendar:(FSCalendar *)calendar titleForDate:(NSDate *)date {
    if ([self.gregorian isDate:date inSameDayAsDate:[NSDate date]]) {
        return @"今天";
    }
//    if (date.timeIntervalSince1970 > [NSDate date].timeIntervalSince1970) {
//        return @"";
//    }
    return nil;
}

- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar {
    return [NSDate date];
}

#pragma mark === FSCalendarDelegate
- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated
{
    calendar.frame = (CGRect){calendar.frame.origin,bounds.size};
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    if (monthPosition != FSCalendarMonthPositionCurrent) {
        [calendar setCurrentPage:date animated:YES];
    }
}

#pragma mark ==== FSCalendarDelegateAppearance
- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleSelectionColorForDate:(NSDate *)date {
    return [UIColor orangeColor];
}

- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillSelectionColorForDate:(NSDate *)date {
    return [UIColor whiteColor];
}

@end
