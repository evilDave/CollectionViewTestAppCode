//
// Created by David Clark on 15/01/2016.
// Copyright (c) 2016 ___FULLUSERNAME___. All rights reserved.
//

#import "NSDateComponents+Helper.h"


@implementation NSDateComponents (Helper)

static NSCalendar *calendar;

+ (void)initialize {
	calendar = [NSCalendar currentCalendar];
	[calendar setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
}

- (int)component:(enum NSCalendarUnit)unit {
	switch (unit) {
		case NSCalendarUnitEra:break;
		case NSCalendarUnitYear:return [self year];
		case NSCalendarUnitMonth:return [self month];
		case NSCalendarUnitDay:return [self day];
		case NSCalendarUnitHour:return [self hour];
		case NSCalendarUnitMinute:return [self minute];
		case NSCalendarUnitSecond:return [self second];
		case NSCalendarUnitWeekday:break;
		case NSCalendarUnitWeekdayOrdinal:break;
		case NSCalendarUnitQuarter:break;
		case NSCalendarUnitWeekOfMonth:break;
		case NSCalendarUnitWeekOfYear:break;
		case NSCalendarUnitYearForWeekOfYear:break;
		case NSCalendarUnitNanosecond:break;
		case NSCalendarUnitCalendar:break;
		case NSCalendarUnitTimeZone:break;
		case NSWeekCalendarUnit:break;
	}
	return 0;
}

@end
