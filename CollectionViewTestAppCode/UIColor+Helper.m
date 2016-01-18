//
// Created by David Clark on 14/01/2016.
// Copyright (c) 2016 ___FULLUSERNAME___. All rights reserved.
//

#import "UIKit/UIColor.h"
#import "UIColor+Helper.h"


@implementation UIColor (Helper)

- (UIColor *)darker {
	return [self darker:1];
}

- (UIColor *)darker:(int)factor {
	CGFloat hue = 0;
	CGFloat saturation = 0;
	CGFloat brightness = 0;
	CGFloat alpha = 0;
	[self getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];

	brightness *= pow(0.9, factor); // this is a bit silly

	UIColor *darkerColor = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha];
	return darkerColor;
}

@end
