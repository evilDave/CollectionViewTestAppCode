//
// Created by David Clark on 2/03/2016.
// Copyright (c) 2016 David Clark. All rights reserved.
//

#import <Masonry/MASConstraintMaker.h>
#import "RoundedButton.h"
#import "UIImage+Helper.h"
#import "UIColor+Helper.h"
#import <Masonry/View+MASAdditions.h>


@implementation RoundedButton {
    UILabel *_subtitleLabel;
	NSMutableDictionary *_subtitleColors;
}

static NSString *const keyPathForSelected = @"selected";
static NSString *const keyPathForHighlighted = @"highlighted";

static const float titleTopEdgeInset = -20;
static const float subtitleBottomEdgeInset = 5;

static UIEdgeInsets buttonTitleEdgeInsets;
static UIEdgeInsets buttonSubtitleEdgeInsets;

- (instancetype)init {
    self = [super init];
    if (self) {
        buttonTitleEdgeInsets = UIEdgeInsetsMake(titleTopEdgeInset, 0, 0, 0);
        buttonSubtitleEdgeInsets = UIEdgeInsetsMake(0, 0, subtitleBottomEdgeInset, 0);

	    _subtitleColors = [[NSMutableDictionary alloc] init];

	    _subtitleLabel = [[UILabel alloc] init];
	    [_subtitleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
	    [_subtitleLabel setTextAlignment:NSTextAlignmentCenter];
	    [self addSubview:_subtitleLabel];
	    [_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		    make.leading.trailing.bottom.equalTo(self).insets(buttonSubtitleEdgeInsets);
	    }];

	    [self addObserver:self forKeyPath:keyPathForSelected options:NSKeyValueObservingOptionNew context:nil];
	    [self addObserver:self forKeyPath:keyPathForHighlighted options:NSKeyValueObservingOptionNew context:nil];

	    MASAttachKeys(_subtitleLabel);
    }

    return self;
}

- (void)dealloc {
	[self removeObserver:self forKeyPath:keyPathForSelected];
	[self removeObserver:self forKeyPath:keyPathForHighlighted];
}

+ (RoundedButton *)roundedButton {
	RoundedButton *button = [[RoundedButton alloc] init];

	[button setTranslatesAutoresizingMaskIntoConstraints:NO];
	[button setTitleEdgeInsets:buttonTitleEdgeInsets];
	[button setTitleColor:[UIColor HCDarkGrayTextColor] forState:UIControlStateNormal];
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected|UIControlStateHighlighted];
	[button setSubtitleColor:[UIColor HCGrayTextColor] forState:UIControlStateNormal];
	[button setSubtitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
	[button setSubtitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
	[button setSubtitleColor:[UIColor whiteColor] forState:UIControlStateSelected|UIControlStateHighlighted];
	[button setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
	[button setBackgroundImage:[UIImage imageWithColor:[UIColor HCBlueColor]] forState:UIControlStateSelected];
	[button setBackgroundImage:[UIImage imageWithColor:[UIColor HCDarkBlueColor]] forState:UIControlStateHighlighted];
	[button setBackgroundImage:[UIImage imageWithColor:[UIColor HCDarkBlueColor]] forState:UIControlStateSelected|UIControlStateHighlighted];

	return button;
}

- (void)setSubtitleColor:(UIColor *)color forState:(enum UIControlState)state {
	// TODO: do this colour / state management for the other custom buttons
	_subtitleColors[@(state)] = color;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    // TODO: only if bounds have changed
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight) cornerRadii:CGSizeMake(10.0, 10.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    [self.layer setMask:maskLayer];
}

- (void)setSubtitle:(NSString *)subtitle {
	_subtitle = subtitle;
	[_subtitleLabel setText:_subtitle];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	[_subtitleLabel setTextColor:_subtitleColors[@(self.state)]];
}

@end
