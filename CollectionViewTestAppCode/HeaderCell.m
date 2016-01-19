//
// Created by David Clark on 15/01/2016.
// Copyright (c) 2016 ___FULLUSERNAME___. All rights reserved.
//

#import "HeaderCell.h"
#import "NSDate+Helper.h"

@implementation HeaderCell {
	UILabel *monthLabel;
}

// TODO: redo layout with autolayout, etc.

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];

	if (self) {
		UIFont *monthFont = [UIFont systemFontOfSize:22];
		monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 40)];
		[monthLabel setFont:monthFont];
		[monthLabel setTextAlignment:NSTextAlignmentCenter];
		[self.contentView addSubview:monthLabel];

		UIFont *dayFont = [UIFont systemFontOfSize:12];
		int daysInWeek = [NSDate daysInWeek];
		CGFloat dayLabelWidth = frame.size.width/daysInWeek;
		for(int i = 0; i < daysInWeek; i++)
		{
			int day = i + [NSDate firstDayOfWeek];
			if(day > daysInWeek)
				day = 1;
			NSString *daySymbol = [NSDate symbolForDay:day];
			UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(dayLabelWidth*i, 40, dayLabelWidth, 20)];
			[dayLabel setFont:dayFont];
			[dayLabel setTextAlignment:NSTextAlignmentCenter];
			[dayLabel setText:daySymbol];
			[self.contentView addSubview:dayLabel];
		}
	}

	return self;
}

- (void)setText:(NSString *)text {
	[monthLabel setText:text];
}

@end
