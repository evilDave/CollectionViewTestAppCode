//
// Created by David Clark on 2/03/2016.
// Copyright (c) 2016 David Clark. All rights reserved.
//

#import "RoundedButton.h"


@implementation RoundedButton {

}

- (void)layoutSubviews {
    // TODO: only if bounds have changed
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight) cornerRadii:CGSizeMake(10.0, 10.0)];

    // TODO: do this like the tonight button
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    [self.layer setMask:maskLayer];
}

@end
