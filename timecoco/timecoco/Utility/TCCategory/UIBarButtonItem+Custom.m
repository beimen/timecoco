//
//  UIBarButtonItem+Custom.m
//  timecoco
//
//  Created by Xie Hong on 3/15/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import "UIBarButtonItem+Custom.h"

@implementation UIBarButtonItem (Custom)

+ (UIBarButtonItem *)createBarButtonItemWithTitle:(NSString *)title
                                           target:(id)target
                                         selector:(SEL)selector {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont fontWithName:CUSTOM_FONT_NAME size:15];
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    button.titleLabel.minimumScaleFactor = 0.5f;
    [button setTitleColor:TC_RED_COLOR forState:UIControlStateNormal];
    [button setTitleColor:TC_DARK_RED_COLOR forState:UIControlStateHighlighted];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    [button sizeToFit];
    if (button.size.width > 50) {
        button.width = 50.0f;
    }
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (UIBarButtonItem *)createBarButtonItemWithImage:(UIImage *)image
                                           target:(id)target
                                         selector:(SEL)selector {
    return [self createBarButtonItemWithImages:@[ image ] target:target selector:selector];
}

+ (UIBarButtonItem *)createBarButtonItemWithImages:(NSArray *)images
                                            target:(id)target
                                          selector:(SEL)selector {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [button setImage:images[0] forState:UIControlStateNormal];
    if (images.count > 1) {
        [button setImage:images[1] forState:UIControlStateDisabled];
    } else if (images.count > 2) {
        [button setImage:images[2] forState:UIControlStateSelected];
    } else if (images.count > 3) {
        [button setImage:images[3] forState:UIControlStateHighlighted];
    }
    [button sizeToFit];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

@end
