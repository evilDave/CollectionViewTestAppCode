//
// Created by David Clark on 14/01/2016.
// Copyright (c) 2016 ___FULLUSERNAME___. All rights reserved.
//

#import "UIKit/UIColor.h"
#import "UIColor+Helper.h"


@implementation UIColor (Helper)

- (UIColor *)darker {

    CGFloat hue = 0;
    CGFloat saturation = 0;
    CGFloat brightness = 0;
    CGFloat alpha = 0;
    [self getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];

    brightness *= 0.9;

    UIColor *darkerColor = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha];
    return darkerColor;
}

@end