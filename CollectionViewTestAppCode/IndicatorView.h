//
// Created by David Clark on 2/03/2016.
// Copyright (c) 2016 David Clark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RoundedButton.h"

const float IndicatorViewBarHeight = 8; // TODO: move consts

@interface IndicatorView : UIView

+ (IndicatorView *)indicatorView;

@property(nonatomic, strong) UIControl *leftControl;
@property(nonatomic, strong) UIControl *rightControl;

@end
