//
// Created by David Clark on 2/03/2016.
// Copyright (c) 2016 David Clark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DayCell.h"

@interface DayCellSelectionStateBackgroundView : UIView

@property(nonatomic) enum DayCellSelectionState selectionState;

+ (DayCellSelectionStateBackgroundView *)viewForSelectionState:(enum DayCellSelectionState)state;
+ (DayCellSelectionStateBackgroundView *)view;

@end
