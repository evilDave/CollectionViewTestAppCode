//
// Created by David Clark on 18/01/2016.
// Copyright (c) 2016 David Clark. All rights reserved.
//

#import "UIImage+Helper.h"

static NSCache *imageWithColorCache;

@implementation UIImage (Helper)

+ (void)initialize {
	imageWithColorCache = [[NSCache alloc] init];
}

+ (UIImage *)imageWithColor:(UIColor *)color {
	UIImage *image = [imageWithColorCache objectForKey:color];

	if(!image) {
		image = [self generateImageWithColor:color];
		[imageWithColorCache setObject:image forKey:color];
	}

	return image;
}

+ (UIImage *)generateImageWithColor:(UIColor *)color {
	CGRect rect = CGRectMake(0, 0, 1, 1);

	UIGraphicsBeginImageContextWithOptions(rect.size, false, 0);

	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(context, [color CGColor]);
	CGContextFillRect(context, rect);

	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

	UIGraphicsEndImageContext();

	return image;
}

@end
