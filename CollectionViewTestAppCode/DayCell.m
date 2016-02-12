//
// Created by David Clark on 15/01/2016.
// Copyright (c) 2016 ___FULLUSERNAME___. All rights reserved.
//

#import "DayCell.h"
#import "CGRectHelper.h"

@implementation DayCell {
	UILabel *label;
}

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	
	if (self) {
		self.backgroundView = [[UIView alloc] initWithFrame:frame];
		self.selectedBackgroundView = [[UIView alloc] initWithFrame:frame];

		UIFont *font = [UIFont systemFontOfSize:22];

		label = [[UILabel alloc] initWithFrame:[CGRectHelper frameAtOrigin:frame]];

		[label setFont:font];
		[label setTextAlignment:NSTextAlignmentCenter];

		[self.contentView addSubview:label];
	}

	return self;
}

- (void)setText:(NSString *)text {
	[label setText:text];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
	[self.backgroundView setBackgroundColor:backgroundColor];
}

- (void)setSelectedBackgroundColor:(UIColor *)backgroundColor {
	[self.selectedBackgroundView setBackgroundColor:backgroundColor];
}

// TODO: use prepareForReuse
- (UICollectionViewCell *)reset {
	[self setBackgroundColor:nil];
	[label setText:nil];
	return self;
}

- (void)setTextColor:(UIColor *)color {
	[label setTextColor:color];
}

@end
