//
// Created by David Clark on 15/01/2016.
// Copyright (c) 2016 ___FULLUSERNAME___. All rights reserved.
//

#import "DayCell.h"

@implementation DayCell {
	UILabel *label;
}

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	
	if (self) {
		UIFont *font = [UIFont systemFontOfSize:22];
		label = [[UILabel alloc] init];
		[label setFont:font];

		[self.contentView addSubview:label];

		self.backgroundView = [[UIView alloc] initWithFrame:frame];
		self.selectedBackgroundView = [[UIView alloc] initWithFrame:frame];

	}

	return self;
}

- (void)setText:(NSString *)text {
	[label setText:text];
	[label sizeToFit];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
	[self.backgroundView setBackgroundColor:backgroundColor];
}

- (void)setSelectedBackgroundColor:(UIColor *)backgroundColor {
	[self.selectedBackgroundView setBackgroundColor:backgroundColor];
}

- (UICollectionViewCell *)reset {
	[self setBackgroundColor:nil];
	[label setText:nil];
	return self;
}

@end
