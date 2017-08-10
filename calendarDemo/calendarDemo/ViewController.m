//
//  ViewController.m
//  calendarDemo
//
//  Created by 张行舟 on 2017/8/10.
//  Copyright © 2017年 zxz. All rights reserved.
//
#import "FSCalendar.h"
#import "ViewController.h"

static const CGFloat kHeadHeight = 50.0f;
static const CGFloat kWeekHeight = 80.0f;

@interface ViewController ()<FSCalendarDataSource,FSCalendarDelegate,FSCalendarDelegateAppearance>
@property (weak, nonatomic) FSCalendar *calendar;
@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) NSCalendar *gregorian;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    CGFloat height = 300;
    CGRect rect = CGRectMake(25, 64, self.view.bounds.size.width-50, height);
    
    
    self.containerView = [[UIView alloc] initWithFrame:rect];
    
    self.containerView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.containerView.layer.shadowOffset = CGSizeMake(3, 3);
    self.containerView.layer.shadowRadius = 3;
    self.containerView.layer.shadowOpacity = 0.5;
    self.containerView.clipsToBounds  =false;
    
    rect.origin.x = 0;
    rect.origin.y = 0;
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:rect];
    [self.view addSubview:self.containerView];
    [self.containerView addSubview:calendar];
    
    UIView *buttonBack = [UIView new];
    buttonBack.frame = CGRectMake(0, 0, self.view.bounds.size.width-50, kHeadHeight);
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, 50, kHeadHeight)];
    [button setTitle:@"点击" forState:UIControlStateNormal];
    [buttonBack addSubview:button];
    [self.containerView addSubview:buttonBack];
    
    
    calendar.dataSource = self;
    calendar.delegate = self;
    calendar.allowsMultipleSelection = false;
    calendar.swipeToChooseGesture.enabled = false;
    calendar.backgroundColor = [UIColor whiteColor];
    calendar.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
    calendar.today = nil;
    calendar.headerHeight = kHeadHeight;
    calendar.weekdayHeight = kWeekHeight;
    calendar.appearance.headerMinimumDissolvedAlpha = 0;
//    calendar.placeholderType = FSCalendarPlaceholderTypeNone;
    calendar.appearance.caseOptions = FSCalendarCaseOptionsHeaderUsesUpperCase|FSCalendarCaseOptionsWeekdayUsesSingleUpperCase;
    calendar.appearance.headerDateFormat = @"yyyy年MM月";
    self.calendar = calendar;
    [calendar selectDate:[NSDate date]];
    calendar.layer.cornerRadius = 10.0f;
    calendar.layer.masksToBounds = YES;
    calendar.layer.borderColor = [UIColor blackColor].CGColor;
    calendar.layer.borderWidth = 1;
    
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
