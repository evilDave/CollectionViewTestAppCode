//
// Created by David Clark on 15/01/2016.
// Copyright (c) 2016 David Clark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Helper)
- (NSDate *)truncateTo:(enum NSCalendarUnit)unit;

+ (int)daysInWeek;

- (NSDate *)addUnit:(enum NSCalendarUnit)unit value:(int)value;

+ (int)firstDayOfWeek;

- (NSInteger)toDate:(NSDate *)date in:(enum NSCalendarUnit)in;

+ (NSString *)symbolForDay:(int)day;

- (NSInteger)daysInMonth;

- (int)daysInWeekBefore;

- (BOOL)onOrBefore:(NSDate *)date;

- (BOOL)onOrAfter:(NSDate *)date;

- (NSString *)symbolForMonth;
@end
