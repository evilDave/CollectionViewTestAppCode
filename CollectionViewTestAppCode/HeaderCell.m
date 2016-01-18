//
// Created by David Clark on 15/01/2016.
// Copyright (c) 2016 ___FULLUSERNAME___. All rights reserved.
//

#import "HeaderCell.h"
#import "CGRectHelper.h"

@implementation HeaderCell {
	UILabel *label;
}

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	
	if (self) {
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

@end
