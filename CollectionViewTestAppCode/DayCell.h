//
// Created by David Clark on 15/01/2016.
// Copyright (c) 2016 David Clark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DayCell : UICollectionViewCell

typedef NS_ENUM(NSUInteger, DayCellSelectionState) {
	DayCellSelectionStateNormal,
	DayCellSelectionStateStart,
	DayCellSelectionStateDuring,
	DayCellSelectionStateEnd,
	DayCellSelectionStateUnavailable,
	DayCellSelectionStateInvalid
};

@property(nonatomic) NSString *text;
@property(nonatomic) enum DayCellSelectionState dayCellSelectionState;

- (void)setTextColor:(UIColor *)color forDayCellSelectionState:(enum DayCellSelectionState)state;

@end
