//
// Created by David Clark on 2/03/2016.
// Copyright (c) 2016 David Clark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RoundedButton : UIButton

+ (RoundedButton *)roundedButton;

@property(nonatomic, copy) NSString *subtitle;

- (void)setSubtitleColor:(UIColor *)color forState:(enum UIControlState)state;

@end
