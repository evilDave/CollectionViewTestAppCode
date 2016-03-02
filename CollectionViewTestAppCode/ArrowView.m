//
// Created by David Clark on 2/03/2016.
// Copyright (c) 2016 David Clark. All rights reserved.
//

#import "ArrowView.h"
#import "UIColor+Helper.h"


@implementation ArrowView {

	CAShapeLayer *_shapeLayer;
}

+ (ArrowView *)arrowView {
	ArrowView *view = [[ArrowView alloc] init];

	[view setTranslatesAutoresizingMaskIntoConstraints:NO];

	return view;
}

- (instancetype)init {
	self = [super init];
	if (self) {
		_shapeLayer = [CAShapeLayer layer];
		[_shapeLayer setFillColor:[UIColor HCBlueColor].CGColor];
		[self.layer addSublayer:_shapeLayer];
	}

	return self;
}


- (void)layoutSubviews {
	[super layoutSubviews];

	UIBezierPath *path = [UIBezierPath bezierPath];
	[path moveToPoint:CGPointMake(CGRectGetMinX(self.bounds), CGRectGetMinY(self.bounds))];
	[path addLineToPoint:CGPointMake(CGRectGetMaxX(self.bounds), CGRectGetMinY(self.bounds))];
	[path addLineToPoint:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds))];
	[path closePath];
	[_shapeLayer setPath:path.CGPath];
}

@end
