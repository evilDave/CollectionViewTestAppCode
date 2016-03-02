//
// Created by David Clark on 14/01/2016.
// Copyright (c) 2016 David Clark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// TODO: move consts

const CGFloat controlHeight = 55;
const CGFloat controlSpacingX = 5;
const CGFloat controlSpacingY = 18;


@interface CalendarViewController : UIViewController

@property(nonatomic) NSDate *startDate;
@property(nonatomic) NSDate *endDate;
@property(nonatomic) BOOL startMode;

@end
