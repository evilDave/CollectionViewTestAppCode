//
// Created by David Clark on 15/01/2016.
// Copyright (c) 2016 ___FULLUSERNAME___. All rights reserved.
//

#import "HeaderCell.h"

@implementation HeaderCell {
	UILabel *label;
}

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	
	if (self) {
		UIFont *font = [UIFont systemFontOfSize:22];

		label = [[UILabel alloc] init];
		
		[label setFont:font];

		[self.contentView addSubview:label];
	}

	return self;
}

- (void)setText:(NSString *)text {
	[label setText:text];
	[label sizeToFit];
}

@end
