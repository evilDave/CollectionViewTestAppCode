//
// Created by David Clark on 14/01/2016.
// Copyright (c) 2016 David Clark. All rights reserved.
//

#import "UIKit/UIColor.h"
#import "UIColor+Helper.h"


@implementation UIColor (Helper)

+ (UIColor *)HCBlueColor {
	// #00aef0
	return [UIColor colorWithRed:0.0f/255 green:174.0f/255 blue:240.0f/255 alpha:1.0f];
}

+ (UIColor *)HCDarkBlueColor {
	// #008cc0
	return [UIColor colorWithRed:0.0f/255 green:140.0f/255 blue:192.0f/255 alpha:1.0f];
}

+ (UIColor *)HCLightBlueColor {
	// #d2effb // TODO: this is NOT the right color
	return [UIColor colorWithRed:210.0f/255 green:239.0f/255 blue:251.0f/255 alpha:1.0f];
}

+ (UIColor *)HCGrayTextColor {
	// #6e6e6e
	return [UIColor colorWithRed:110.0f/255 green:110.0f/255 blue:110.0f/255 alpha:1.0f];
}

+ (UIColor *)HCDarkGrayTextColor {
	// #4e4e4e
	return [UIColor colorWithRed:78.0f/255 green:78.0f/255 blue:78.0f/255 alpha:1.0f];
}

+ (UIColor *)HCLightGrayTextColor {
	// #969696
	return [UIColor colorWithRed:150.0f/255 green:150.0f/255 blue:150.0f/255 alpha:1.0f];
}

+ (UIColor *)HCVeryLightGrayTextColor {
	// #dbdbdb
	return [UIColor colorWithRed:219.0f/255 green:219.0f/255 blue:219.0f/255 alpha:1.0f];
}

+ (UIColor *)HCGrayColor {
	// #f4f4f4
	return [UIColor colorWithRed:244.0f/255 green:244.0f/255 blue:244.0f/255 alpha:1.0f];
}

@end
