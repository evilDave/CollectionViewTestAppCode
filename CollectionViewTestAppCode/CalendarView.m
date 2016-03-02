//
// Created by David Clark on 2/03/2016.
// Copyright (c) 2016 David Clark. All rights reserved.
//

#import "CalendarView.h"
#import "CollectionViewFlowLayout.h"
#import "DayCell.h"
#import "HeaderCell.h"


static NSString *const identifierDay = @"day";
static NSString *const identifierHeader = @"header";

@implementation CalendarView {

}

+ (CalendarView *)calendarView {
	CalendarView *view = [[CalendarView alloc] initWithFrame:CGRectMake(0,0,0,0) collectionViewLayout:[[CollectionViewFlowLayout alloc] init]];

	[view setTranslatesAutoresizingMaskIntoConstraints:NO];

	[view setBackgroundColor:[UIColor whiteColor]];

	[view registerClass:[DayCell class] forCellWithReuseIdentifier:identifierDay]; // possibly need multiple day cell types
	[view registerClass:[HeaderCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifierHeader];

	return view;
}

@end
