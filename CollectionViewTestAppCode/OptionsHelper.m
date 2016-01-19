//
// Created by David Clark on 19/01/2016.
// Copyright (c) 2016 ___FULLUSERNAME___. All rights reserved.
//

#import "OptionsHelper.h"


@implementation OptionsHelper {

}

+ (BOOL)isSingleOption:(NSUInteger)options {
	return (options ^ (options & -options)) == 0;
}

@end
