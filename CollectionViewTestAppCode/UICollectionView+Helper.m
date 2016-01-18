//
// Created by David Clark on 18/01/2016.
// Copyright (c) 2016 ___FULLUSERNAME___. All rights reserved.
//

#import "UICollectionView+Helper.h"


@implementation UICollectionView (Helper)

- (BOOL)willShow:(UICollectionViewLayoutAttributes *)attributes {
	CGPoint contentOrigin = [self contentOffset];
	return attributes.frame.origin.y + attributes.frame.size.height > contentOrigin.y;
}

@end
