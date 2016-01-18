//
// Created by David Clark on 15/01/2016.
// Copyright (c) 2016 ___FULLUSERNAME___. All rights reserved.
//

#import "NSDate+Helper.h"
#import "NSDateComponents+Helper.h"

@implementation NSDate (Helper)

static NSCalendar *calendar;

+ (void)initialize {
	calendar = [NSCalendar currentCalendar];
	[calendar setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
}

- (NSDate *)truncateTo:(enum NSCalendarUnit)unit {
	// would need to check if only one bit is set
	unit = (unit - 2) | unit;
	NSDateComponents *components = [[NSCalendar currentCalendar] components:unit fromDate:self];
	return [calendar dateFromComponents:components];
}

- (NSDate *)addUnit:(enum NSCalendarUnit)unit value:(int)value {
	return [calendar dateByAddingUnit:unit value:value toDate:self options:nil];
}

- (NSInteger)toDate:(NSDate *)date in:(enum NSCalendarUnit)unit {
	// handle reversed ranges
	// check that +1 is the correct behaviour
	return [[calendar components:unit fromDate:self toDate:date options:nil] component:unit] + 1;
}

- (NSInteger)daysInMonth {
	return [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self].length;
}

- (int)daysInWeekBefore {
	int weekday = [calendar component:NSCalendarUnitWeekday fromDate:self];
	int firstWeekday = [calendar firstWeekday];
	weekday += firstWeekday > weekday ? weekday : 0;
	int daysBefore = weekday -firstWeekday;
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

@end
