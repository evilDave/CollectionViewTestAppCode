//
// Created by David Clark on 2/03/2016.
// Copyright (c) 2016 David Clark. All rights reserved.
//

#import <Masonry/MASConstraintMaker.h>
#import <Masonry/View+MASAdditions.h>
#import "IndicatorView.h"
#import "UIColor+Helper.h"
#import "ArrowView.h"


@implementation IndicatorView {
	float arrowWidth;
	ArrowView *_arrow;
	MASConstraint *_arrowCenterXConstraint;
}

static NSString *const keyPathForSelected = @"selected";

static const float animationDuration = 0.2;
static const float barHeight = 8;
static const float arrowHeight = 22;

+ (IndicatorView *)indicatorView {
	IndicatorView *view = [[IndicatorView alloc] init];

	[view setTranslatesAutoresizingMaskIntoConstraints:NO];

	return view;
}

- (instancetype)init {
	self = [super init];
	if (self) {
		arrowWidth = sqrtf(arrowHeight*arrowHeight*2);

		UIView *bar = [[UIView alloc] init];
		[bar setTranslatesAutoresizingMaskIntoConstraints:NO];
		[bar setBackgroundColor:[UIColor HCBlueColor]];
		[self addSubview:bar];
		[bar mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.leading.trailing.equalTo(self);
			make.height.mas_equalTo(barHeight);
		}];

		_arrow = [ArrowView arrowView];
		[self addSubview:_arrow];
		[_arrow mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(bar.mas_bottom);
			make.height.mas_equalTo(arrowHeight);
			make.width.mas_equalTo(arrowWidth);
		}];

		MASAttachKeys(bar, _arrow);
	}

	return self;
}

- (void)dealloc {
	if(_leftControl) {
		[_leftControl removeObserver:self forKeyPath:keyPathForSelected];
	}
	if(_rightControl) {
		[_rightControl removeObserver:self forKeyPath:keyPathForSelected];
	}
}

- (CGSize)intrinsicContentSize {
	return CGSizeMake(-1, barHeight+arrowHeight);
}

- (void)setLeftControl:(UIControl *)control {
	if(_leftControl) {
		[_leftControl removeObserver:self forKeyPath:keyPathForSelected];
	}
	_leftControl = control;
	[_leftControl addObserver:self forKeyPath:keyPathForSelected options:NSKeyValueObservingOptionNew context:nil];
}

- (void)setRightControl:(UIControl *)control {
	if(_rightControl) {
		[_rightControl removeObserver:self forKeyPath:keyPathForSelected];
	}
	_rightControl = control;
	[_rightControl addObserver:self forKeyPath:keyPathForSelected options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if([change[@"new"] boolValue]){
		[self layoutIfNeeded];
		[_arrowCenterXConstraint uninstall];
		[_arrow mas_makeConstraints:^(MASConstraintMaker *make) {
			_arrowCenterXConstraint = make.centerX.equalTo(self.mas_centerX).multipliedBy([object isEqual:_rightControl] ? 1.5f : 0.5f);
		}];
		[UIView animateWithDuration:animationDuration animations:^{
			[self layoutIfNeeded];
		}];
	}
}

@end
