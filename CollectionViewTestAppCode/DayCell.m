//
// Created by David Clark on 15/01/2016.
// Copyright (c) 2016 David Clark. All rights reserved.
//

#import <Masonry/MASConstraintMaker.h>
#import "DayCell.h"
#import "CGRectHelper.h"
#import "UIColor+Helper.h"
#import "DayCellSelectionStateBackgroundView.h"
#import <Masonry/View+MASAdditions.h>

@implementation DayCell {
	UILabel *_label;
	NSMutableDictionary *_dayCellSelectionStateTextColors; // TODO: make static and setup?
	DayCellSelectionStateBackgroundView *_selectionStateBasedBackgroundView;
}

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];

	if (self) {
		_dayCellSelectionStateTextColors = [[NSMutableDictionary alloc] init];

		[self setTextColor:[UIColor HCGrayTextColor] forDayCellSelectionState:DayCellSelectionStateNormal];
		[self setTextColor:[UIColor whiteColor] forDayCellSelectionState:DayCellSelectionStateStart];
		[self setTextColor:[UIColor HCGrayTextColor] forDayCellSelectionState:DayCellSelectionStateDuring];
		[self setTextColor:[UIColor whiteColor] forDayCellSelectionState:DayCellSelectionStateEnd];
		[self setTextColor:[UIColor HCVeryLightGrayTextColor] forDayCellSelectionState:DayCellSelectionStateUnavailable];
		[self setTextColor:[UIColor clearColor] forDayCellSelectionState:DayCellSelectionStateInvalid];

		_label = [[UILabel alloc] initWithFrame:[CGRectHelper frameAtOrigin:frame]];
		[_label setFont:[UIFont fontWithName:@"HelveticaNeue" size:22]];
		[_label setTextAlignment:NSTextAlignmentCenter];
		[self.contentView addSubview:_label];
	}

	return self;
}

- (void)setText:(NSString *)text {
	_text = text;
	[_label setText:text];
}

- (void)prepareForReuse {
	[self setText:nil];
	[self setDayCellSelectionState:DayCellSelectionStateInvalid];
}

- (void)setDayCellSelectionState:(enum DayCellSelectionState)state {
	_dayCellSelectionState = state;

	UIColor *color = _dayCellSelectionStateTextColors[@(state)];
	[_label setTextColor:color];

	[_selectionStateBasedBackgroundView removeFromSuperview];
	_selectionStateBasedBackgroundView = nil;

	_selectionStateBasedBackgroundView = [DayCellSelectionStateBackgroundView viewForSelectionState:state];

	if(_selectionStateBasedBackgroundView) {
		[self insertSubview:_selectionStateBasedBackgroundView atIndex:0];
		[_selectionStateBasedBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.edges.equalTo(self);
		}];
	}

}

- (void)setTextColor:(UIColor *)color forDayCellSelectionState:(enum DayCellSelectionState)state {
	_dayCellSelectionStateTextColors[@(state)] = color;
}

@end
