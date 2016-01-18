//
// Created by David Clark on 15/01/2016.
// Copyright (c) 2016 ___FULLUSERNAME___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Helper)
- (NSDate *)truncateTo:(enum NSCalendarUnit)unit;
- (NSDate *)addUnit:(enum NSCalendarUnit)unit value:(int)value;

- (NSInteger)toDate:(NSDate *)date in:(enum NSCalendarUnit)in;

- (NSInteger)daysInMonth;

- (void)weekday;

- (int)daysInWeekBefore;

- (BOOL)onOrBefore:(NSDate *)date;

- (BOOL)onOrAfter:(NSDate *)date;
@end
