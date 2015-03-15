//
//  UIBarButtonItem+TCButtonManager.m
//  timecoco
//
//  Created by Xie Hong on 3/15/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import "UIBarButtonItem+TCButtonManager.h"

@implementation UIBarButtonItem (TCButtonManager)

+ (UIBarButtonItem *)createBarButtonItemWithImage:(UIImage *)image
                                           Target:(id)target
                                         Selector:(SEL)selector {
    return [self createBarButtonItemWithImages:@[image] Target:target Selector:selector];
}

+ (UIBarButtonItem *)createBarButtonItemWithImages:(NSArray *)images
                                            Target:(id)target
                                          Selector:(SEL)selector {
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
