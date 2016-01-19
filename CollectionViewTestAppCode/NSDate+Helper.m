//
// Created by David Clark on 15/01/2016.
// Copyright (c) 2016 ___FULLUSERNAME___. All rights reserved.
//

#import "NSDate+Helper.h"
#import "NSDateComponents+Helper.h"
#import "OptionsHelper.h"

@implementation NSDate (Helper)

static NSCalendar *calendar; // TODO: make this a calendar model helper, pass it the calendar and use it when needed (it can still have the NSDate category)

// TODO: hmm: could make this a singleton, have the calendar as a property, let it be mutable, then still have all the categories on it

+ (void)initialize {
	calendar = [NSCalendar currentCalendar]; // TODO: maybe pass in and share this?
	[calendar setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
}

- (NSDate *)truncateTo:(enum NSCalendarUnit)unit {
	unit = [self unitsFromYearTo:unit];
	NSDateComponents *components = [calendar components:unit fromDate:self];
	return [calendar dateFromComponents:components];
}

- (enum NSCalendarUnit)unitsFromYearTo:(enum NSCalendarUnit)unit {
	if([OptionsHelper isSingleOption:unit]) {
		unit = (unit - 2) | unit;
	}
	return unit;
}

+ (int)daysInWeek {
	return [calendar maximumRangeOfUnit:NSCalendarUnitWeekday].length;
}

- (NSDate *)addUnit:(enum NSCalendarUnit)unit value:(int)value {
	return [calendar dateByAddingUnit:unit value:value toDate:self options:nil];
}

+ (int)firstDayOfWeek {
	return [calendar firstWeekday];
}

- (NSInteger)toDate:(NSDate *)date in:(enum NSCalendarUnit)unit {
	// handle reversed ranges
	// check that +1 is the correct behaviour
	return [[calendar components:unit fromDate:self toDate:date options:nil] component:unit] + 1;
}

+ (NSString *)symbolForDay:(int)day {
	return [calendar veryShortStandaloneWeekdaySymbols][(NSUInteger) (day - 1)];
}

- (NSInteger)daysInMonth {
	return [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self].length;
}

- (int)daysInWeekBefore {
	int weekday = [calendar component:NSCalendarUnitWeekday fromDate:self];
	int firstWeekday = [calendar firstWeekday];
	weekday += firstWeekday > weekday ? weekday : 0;
	int daysBefore = weekday - firstWeekday;
	return daysBefore;
}

- (BOOL)onOrBefore:(NSDate *)date {
	NSComparisonResult result = [self compare:date];
	return result == NSOrderedAscending || result == NSOrderedSame;
}

- (BOOL)onOrAfter:(NSDate *)date {
	NSComparisonResult result = [self compare:date];
	return result == NSOrderedDescending || result == NSOrderedSame;
}

- (NSString *)symbolForMonth {
	return [calendar monthSymbols][(NSUInteger) ([calendar component:NSCalendarUnitMonth fromDate:self] - 1)];
}

@end
