//
// Created by David Clark on 14/01/2016.
// Copyright (c) 2016 David Clark. All rights reserved.
//

#import "ViewController.h"
#import "HeaderCell.h"
#import "DayCell.h"
#import "NSDate+Helper.h"
#import "CollectionViewFlowLayout.h"
#import "ViewController+MASAdditions.h"
#import "RoundedButton.h"
#import "IndicatorView.h"
#import <Masonry/View+MASAdditions.h>


const CGFloat controlHeight = 55;
const CGFloat controlSpacingX = 5;

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@end

@implementation ViewController {
	NSDate *minDate; // earliest selectable date
	NSDate *maxDate; // latest selectable date
	NSDate *firstDate; // first date shown
	NSDate *lastDate; // last date shown
	RoundedButton *_startButton;
	RoundedButton *_endButton;
	NSCache *daysInWeekBeforeStartForSectionCache;
	NSCache *startDateForSectionCache;
	UILabel *_startButtonText;
	UILabel *_endButtonText;
	IndicatorView *_indicatorView;
}

// TODO: pass in calendar, test some

// TODO: implement drag selection (move to next item when dragging touch down)

// TODO: make into control

// TODO: show start and end dates at top (in none edit mode)
// TODO: controller to manage state changes, editing mode changes etc
// TODO: delegate protocol
// TODO: minimum selection duration (e.g. 1 day), maximum? what to do at the end of the ranges

- (instancetype)init {
	self = [super init];
	if (self) {
		daysInWeekBeforeStartForSectionCache = [[NSCache alloc] init];
		startDateForSectionCache = [[NSCache alloc] init];
	}

	return self;
}

- (void)loadView {
	self.view = [[UIView alloc] init];
	self.view.backgroundColor = [UIColor whiteColor];

	[self.view setTranslatesAutoresizingMaskIntoConstraints:NO];

	[self setupCalendar];
	
	_startButton = [RoundedButton roundedButton];
	[_startButton setTitle:@"From" forState:UIControlStateNormal];
	[_startButton setSubtitle:@"testing"];
	[_startButton addTarget:self action:@selector(enterStartMode) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_startButton];
	[_startButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.leading.equalTo(self.view);
		make.width.equalTo(self.view).multipliedBy(0.5).offset(-controlSpacingX / 2);
		make.height.mas_equalTo(controlHeight);
	}];
	
	_endButton = [RoundedButton roundedButton];
	[_endButton setTitle:@"To" forState:UIControlStateNormal];
	[_endButton setSubtitle:@"testing"];
	[_endButton addTarget:self action:@selector(enterEndMode) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_endButton];
	[_endButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.trailing.equalTo(self.view);
		make.width.equalTo(self.view).multipliedBy(0.5).offset(-controlSpacingX / 2);
		make.height.mas_equalTo(controlHeight);
	}];

	UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0,0,0) collectionViewLayout:[[CollectionViewFlowLayout alloc] init]];
	[collectionView setDelegate:self];
	[collectionView setDataSource:self];
	[collectionView registerClass:[DayCell class] forCellWithReuseIdentifier:@"day"]; // possibly need multiple different day cell types
	[collectionView registerClass:[HeaderCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
	[collectionView setBackgroundColor:[UIColor whiteColor]];
    [collectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_startButton.mas_bottom);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
        make.leading.trailing.equalTo(self.view);
    }];

	_indicatorView = [IndicatorView indicatorView];
	[_indicatorView setLeftControl:_startButton];
	[_indicatorView setRightControl:_endButton];
	[self.view addSubview:_indicatorView];
	[_indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(_startButton.mas_bottom);
		make.leading.trailing.equalTo(self.view);
	}];

    [self enterStartMode]; // remember to just use the outer function, don't change the states or properties - this indicates that they should be hidden in a different class

	MASAttachKeys(_startButton, _endButton, collectionView, _indicatorView);
}

- (void)enterEndMode {
	[_endButton setSelected:YES]; // this is a bit low level for here
	[_startButton setSelected:NO];
	[self setStartMode:NO];
}

- (void)enterStartMode {
	[_startButton setSelected:YES];
	[_endButton setSelected:NO];
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
	NSString *text = [sectionDate symbolForMonth];

    [headerCell setBackgroundColor:[UIColor lightGrayColor]];
    [headerCell setText:text];

	return headerCell;
}

// TODO: too big
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	DayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"day" forIndexPath:indexPath];

	NSDate *sectionStartDate = [self getStartDateFor:indexPath.section];
	int daysBefore = [self daysInWeekBeforeStartForSection:indexPath.section];

	// do we need cells after the last date too? maybe could show greyed out day cell and still be able to select them? probably too messy looking
	if(indexPath.row < daysBefore)
		return [cell reset];

	NSString *text = [NSString stringWithFormat:@"%i", indexPath.row - daysBefore + 1];

	NSDate *cellDate = [sectionStartDate addUnit:NSCalendarUnitDay value:indexPath.row - daysBefore];

	// current selection
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
		[cell setBackgroundColor:[UIColor lightGrayColor]];
	}
	if(cellDate < minDate || cellDate > maxDate) {
		[cell setTextColor:[UIColor lightGrayColor]];
	}
	else{
		[cell setTextColor:[UIColor blackColor]];
	}
	[cell setSelectedBackgroundColor:[UIColor yellowColor]];
	[cell setText:text];

	return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
	CGFloat cellDimension = (CGFloat) floor((collectionView.bounds.size.width) / [NSDate daysInWeek]);
	CGFloat width = cellDimension * [NSDate daysInWeek];
	CGFloat diff = collectionView.bounds.size.width - width;
	CGFloat half = diff / 2;
	return UIEdgeInsetsMake(half, half, half, half);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
	return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
	return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	CGFloat cellDimension = floor((collectionView.bounds.size.width) / [NSDate daysInWeek]);
	return CGSizeMake(cellDimension, cellDimension);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
	return CGSizeMake(collectionView.bounds.size.width, 60);
}

// TODO: this is getting a bit big
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	// should store this for speed
	NSDate *sectionStartDate = [self getStartDateFor:indexPath.section];
	int daysBefore = [self daysInWeekBeforeStartForSection:indexPath.section];
	NSDate *cellDate = [sectionStartDate addUnit:NSCalendarUnitDay value:indexPath.row - daysBefore];
	if(cellDate < minDate || cellDate > maxDate) {
		[collectionView deselectItemAtIndexPath:indexPath animated:NO];
		return;
	}
	NSTimeInterval duration = 0;
	if(self.startDate && self.endDate) {
		duration = [self.endDate timeIntervalSinceDate:self.startDate];
	}
	if([self startMode]) {
		if(cellDate < [self startDate] || cellDate >= [self endDate]) {
			[self setEndDate:[cellDate dateByAddingTimeInterval:duration]];
			if(self.endDate > maxDate) {
				[self setEndDate:maxDate];
			}
		}
		[self setStartDate:cellDate];
		[self enterEndMode];
	}
	else {
		if(cellDate <= [self startDate]) {
			[self setStartDate:[cellDate dateByAddingTimeInterval:-duration]];
			if(self.startDate < minDate) {
				[self setStartDate:minDate];
			}
		}
		[self setEndDate:cellDate];
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

- (void)setStartDate:(NSDate *)startDate {
	_startDate = startDate;
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"dd MMM yyyy"];
	[_startButtonText setText:[formatter stringFromDate:startDate]];
}

- (void)setEndDate:(NSDate *)endDate {
	_endDate = endDate;
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"dd MMM yyyy"];
	[_endButtonText setText:[formatter stringFromDate:endDate]];
}

@end
