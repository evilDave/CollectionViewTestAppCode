//
// Created by David Clark on 14/01/2016.
// Copyright (c) 2016 ___FULLUSERNAME___. All rights reserved.
//

#import "ViewController.h"
#import "UIColor+Helper.h"
#import "HeaderCell.h"
#import "DayCell.h"
#import "NSDate+Helper.h"
#import "UIImage+Helper.h"
#import "CollectionViewFlowLayout.h"


@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@end

@implementation ViewController {
	NSDate *minDate; // earliest selectable date
	NSDate *maxDate; // latest selectable date
	NSDate *firstDate; // first date shown
	NSDate *lastDate; // last date shown
	UIButton *startButton; // start date selected by user
	UIButton *endButton; // end date selected by user
	NSCache *daysInWeekBeforeStartForSectionCache;
	NSCache *startDateForSectionCache;
}

// TODO: implement exact item cell spacing layout
// TODO: implement no grid border between items (border is in cell rather than in the container)
// TODO: implement drag selection (move to next item when dragging touch down)

- (instancetype)init {
	self = [super init];
	if (self) {
		daysInWeekBeforeStartForSectionCache = [[NSCache alloc] init];
		startDateForSectionCache = [[NSCache alloc] init];
	}

	return self;
}

- (void)loadView {
	CGRect bounds = [[UIScreen mainScreen] bounds];
	self.view = [[UIView alloc] initWithFrame:bounds];
	self.view.backgroundColor = [UIColor lightGrayColor];

	[self setupCalendar];

	[self setupSubviewsWithFrame:bounds];

	[self enterStartMode]; // remember to just use the outer function, don't change the states or properties - this indicates that they should be hidden in a different class
}

- (void)setupSubviewsWithFrame:(CGRect)frame {
	// TODO: view sizing code is wrong/demo only

	CGFloat buttonWidth = (frame.size.width-20)/2;
	startButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 50, buttonWidth, 50)];
	[startButton setTitle:@"Start" forState:UIControlStateNormal];
	[startButton addTarget:self action:@selector(enterStartMode) forControlEvents:UIControlEventTouchUpInside];
	[startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[startButton setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];
	[startButton setBackgroundImage:[UIImage imageWithColor:[[UIColor lightGrayColor] darker:3]] forState:UIControlStateSelected];
	[startButton setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateNormal];
	[self.view addSubview:startButton];

	endButton = [[UIButton alloc] initWithFrame:CGRectMake(10+buttonWidth, 50, buttonWidth, 50)];
	[endButton setTitle:@"End" forState:UIControlStateNormal];
	[endButton addTarget:self action:@selector(enterEndMode) forControlEvents:UIControlEventTouchUpInside];
	[endButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[endButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
	[endButton setBackgroundImage:[UIImage imageWithColor:[[UIColor lightGrayColor] darker:3]] forState:UIControlStateSelected];
	[endButton setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateNormal];
	[self.view addSubview:endButton];

	UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 50+50, frame.size.width-20, frame.size.height-60-50) collectionViewLayout:[[CollectionViewFlowLayout alloc] init]];
	[collectionView setDelegate:self];
	[collectionView setDataSource:self];
	[collectionView registerClass:[DayCell class] forCellWithReuseIdentifier:@"day"]; // possibly need different day cell types
	[collectionView registerClass:[HeaderCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
	[self.view addSubview:collectionView];
}

- (void)enterEndMode {
	[endButton setSelected:YES]; // this is a bit low level for here
	[startButton setSelected:NO];
	[self setStartMode:NO];
}

- (void)enterStartMode {
	[startButton setSelected:YES];
	[endButton setSelected:NO];
	[self setStartMode:YES];
}

- (void)setupCalendar {
	NSDate *now = [NSDate new];

	minDate = [now truncateTo:NSCalendarUnitDay];
	maxDate = [minDate addUnit:NSCalendarUnitYear value:1];
	firstDate = [minDate truncateTo:NSCalendarUnitMonth];
	lastDate = [[[maxDate truncateTo:NSCalendarUnitMonth] addUnit:NSCalendarUnitMonth value:1] addUnit:NSCalendarUnitDay value:-1];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return [firstDate toDate:lastDate in:NSCalendarUnitMonth];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	NSDate *sectionDate = [self getStartDateFor:section];
	int daysBefore = [self daysInWeekBeforeStartForSection:section];
	return [sectionDate daysInMonth] + daysBefore;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    HeaderCell *headerCell = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];

	NSDate *sectionDate = [self getStartDateFor:indexPath.section];
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"MMMM"];

	NSString *text = [formatter stringFromDate:sectionDate];

    [headerCell setBackgroundColor:[[UIColor lightGrayColor] darker:3]];
    [headerCell setText:text];

	return headerCell;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	DayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"day" forIndexPath:indexPath];

	NSDate *sectionStartDate = [self getStartDateFor:indexPath.section];
	int daysBefore = [self daysInWeekBeforeStartForSection:indexPath.section];

	// do we need cells after the last date too? maybe could show greyed out day cell and still be able to select them? probably too messy looking
	if(indexPath.row < daysBefore)
		return [cell reset];

	NSString *text = [NSString stringWithFormat:@"%i", indexPath.row - daysBefore + 1];

	NSDate *cellDate = [sectionStartDate addUnit:NSCalendarUnitDay value:indexPath.row - daysBefore];
	if([self.startDate onOrBefore:cellDate] && [self.endDate onOrAfter:cellDate]){
		if([self.startDate isEqualToDate:cellDate]) {
			[cell setBackgroundColor:[UIColor greenColor]];
		}
		else if([self.endDate isEqualToDate:cellDate]) {
			[cell setBackgroundColor:[UIColor redColor]];
		}
		else {
			[cell setBackgroundColor:[UIColor blueColor]];
		}
	}
	else {
		[cell setBackgroundColor:[[UIColor lightGrayColor] darker]];
	}
	[cell setSelectedBackgroundColor:[UIColor yellowColor]];
	[cell setText:text];

	return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
	return UIEdgeInsetsMake(2, 2, 2, 2);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
	return 2;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
	return 2;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	CGFloat cellDimension = (collectionView.bounds.size.width - 18) / 7;
	return CGSizeMake(cellDimension, cellDimension);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
	return CGSizeMake(collectionView.bounds.size.width, 50);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	// should store this for speed
	NSDate *sectionStartDate = [self getStartDateFor:indexPath.section];
	int daysBefore = [self daysInWeekBeforeStartForSection:indexPath.section];
	NSDate *cellDate = [sectionStartDate addUnit:NSCalendarUnitDay value:indexPath.row - daysBefore];
	if([self startMode]) {
		[self setStartDate:cellDate];
		if(![[self endDate] onOrAfter:cellDate]) {
			[self setEndDate:cellDate];
		}
		[self enterEndMode];
	}
	else {
		[self setEndDate:cellDate];
		if (![[self startDate] onOrBefore:cellDate]) {
			[self setStartDate:cellDate];
		}
	}
	[collectionView reloadData];
}

- (NSDate *)getStartDateFor:(NSInteger)section {
	NSDate *date = [startDateForSectionCache objectForKey:@(section)];
	if(!date){
		date = [[firstDate addUnit:NSCalendarUnitMonth value:section] truncateTo:NSCalendarUnitMonth];
		[startDateForSectionCache setObject:date forKey:@(section)];
	}
	return date;
}

- (int)daysInWeekBeforeStartForSection:(NSInteger)section {
	NSNumber *days = [daysInWeekBeforeStartForSectionCache objectForKey:@(section)];
	if(!days){
		days = @([[[firstDate addUnit:NSCalendarUnitMonth value:section] truncateTo:NSCalendarUnitMonth] daysInWeekBefore]);
		[daysInWeekBeforeStartForSectionCache setObject:days forKey:@(section)];
	}
	return [days intValue];
}

@end
