//
// Created by David Clark on 15/01/2016.
// Copyright (c) 2016 David Clark. All rights reserved.
//

#import <Masonry/MASConstraintMaker.h>
#import "HeaderCell.h"
#import "NSDate+Helper.h"
#import "UIColor+Helper.h"
#import "View+MASAdditions.h"
#import "CalendarViewController.h"

@implementation HeaderCell {
	UILabel *monthLabel;
}

// TODO: redo layout with autolayout, etc. MAYBE? WHY? Maybe...

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];

	if (self) {
		[self setBackgroundColor:[UIColor whiteColor]];
		
		UIFont *monthFont = [UIFont fontWithName:@"HelveticaNeue" size:22];
		monthLabel = [[UILabel alloc] init]; // TODO: fix this sizing
		[monthLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
		[monthLabel setFont:monthFont];
		[monthLabel setTextColor:[UIColor HCDarkGrayTextColor]];
		[monthLabel setTextAlignment:NSTextAlignmentCenter];
		[self.contentView addSubview:monthLabel];
		[monthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self.contentView).offset(controlSpacingY);
			make.leading.trailing.equalTo(self.contentView);
		}];

		UIView *daySymbolBackgroundView = [[UIView alloc] init];
		[daySymbolBackgroundView setTranslatesAutoresizingMaskIntoConstraints:NO];
		[daySymbolBackgroundView setBackgroundColor:[UIColor HCGrayColor]];
		[self.contentView addSubview:daySymbolBackgroundView];
		[daySymbolBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.leading.trailing.bottom.equalTo(self.contentView);
			make.height.mas_equalTo(22); // TODO: fix this, maybe with all of this layout...
		}];

		UIFont *dayFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
		int daysInWeek = [NSDate daysInWeek];
		for(int i = 0; i < daysInWeek; i++)
		{
			int day = i + [NSDate firstDayOfWeek];
			if(day > daysInWeek)
				day = 1;
			NSString *daySymbol = [NSDate symbolForDay:day];
			UILabel *dayLabel = [[UILabel alloc] init];
			[dayLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
			[dayLabel setFont:dayFont];
			[dayLabel setTextAlignment:NSTextAlignmentCenter];
			[dayLabel setText:daySymbol];
			[dayLabel setTextColor:[UIColor HCLightGrayTextColor]];
			[self.contentView addSubview:dayLabel];
			[dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
				make.bottom.equalTo(self.contentView);
				make.centerX.equalTo(self.contentView).multipliedBy((float)(i*2+1)/daysInWeek);
			}];
		}
	}

	return self;
}

- (void)setText:(NSString *)text {
	[monthLabel setText:text];
}

@end
