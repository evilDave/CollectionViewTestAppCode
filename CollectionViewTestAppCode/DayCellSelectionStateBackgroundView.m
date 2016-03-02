//
// Created by David Clark on 2/03/2016.
// Copyright (c) 2016 David Clark. All rights reserved.
//

#import "DayCellSelectionStateBackgroundView.h"
#import "UIColor+Helper.h"


@implementation DayCellSelectionStateBackgroundView {
	CAShapeLayer *_shapeLayerBottom;
	CAShapeLayer *_shapeLayerTop;
}

+ (DayCellSelectionStateBackgroundView *)viewForSelectionState:(enum DayCellSelectionState)state {
	DayCellSelectionStateBackgroundView *view = [DayCellSelectionStateBackgroundView view];

	[view setSelectionState:state];

	return view;
}

+ (DayCellSelectionStateBackgroundView *)view {
	DayCellSelectionStateBackgroundView *view = [[DayCellSelectionStateBackgroundView alloc] init];

	[view setTranslatesAutoresizingMaskIntoConstraints:NO];

	return view;
}

- (instancetype)init {
	self = [super init];
	if (self) {
		_shapeLayerBottom = [CAShapeLayer layer];
		[_shapeLayerBottom setFillColor:[UIColor HCLightBlueColor].CGColor];
		[self.layer addSublayer:_shapeLayerBottom];

		_shapeLayerTop = [CAShapeLayer layer];
		[_shapeLayerTop setFillColor:[UIColor HCBlueColor].CGColor];
		[self.layer addSublayer:_shapeLayerTop];
	}

	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];

	if(_selectionState == DayCellSelectionStateStart || _selectionState == DayCellSelectionStateEnd) {
		UIBezierPath *path = [UIBezierPath bezierPath];
		[path addArcWithCenter:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds)) radius:CGRectGetMidX(self.bounds) startAngle:0 endAngle:2*M_PI clockwise:YES];
		[_shapeLayerTop setPath:path.CGPath];
	}

	if(_selectionState == DayCellSelectionStateStart || _selectionState == DayCellSelectionStateDuring || _selectionState == DayCellSelectionStateEnd) {
		UIBezierPath *path = [UIBezierPath bezierPath];

		CGPoint topLeftPoint = CGPointMake(_selectionState == DayCellSelectionStateStart ? CGRectGetMidX(self.bounds) : CGRectGetMinX(self.bounds), CGRectGetMinY(self.bounds));
		CGPoint topRightPoint = CGPointMake(_selectionState == DayCellSelectionStateEnd ? CGRectGetMidX(self.bounds) : CGRectGetMaxX(self.bounds), CGRectGetMinY(self.bounds));
		CGPoint bottomRightPoint = CGPointMake(_selectionState == DayCellSelectionStateEnd ? CGRectGetMidX(self.bounds) : CGRectGetMaxX(self.bounds), CGRectGetMaxY(self.bounds));;
		CGPoint bottomLeftPoint = CGPointMake(_selectionState == DayCellSelectionStateStart ? CGRectGetMidX(self.bounds) : CGRectGetMinX(self.bounds), CGRectGetMaxY(self.bounds));;

		[path moveToPoint:topLeftPoint];
		[path addLineToPoint:topRightPoint];
		[path addLineToPoint:bottomRightPoint];
		[path addLineToPoint:bottomLeftPoint];
		[path closePath];

		[_shapeLayerBottom setPath:path.CGPath];
	}
}

@end
