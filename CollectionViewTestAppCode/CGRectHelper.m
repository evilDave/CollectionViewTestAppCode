//
// Created by David Clark on 18/01/2016.
// Copyright (c) 2016 David Clark. All rights reserved.
//

#import "CGRectHelper.h"


@implementation CGRectHelper {

}

+ (CGRect)frameAtOrigin:(CGRect)rect {
	return CGRectMake(0, 0, rect.size.width, rect.size.height);
}

@end
