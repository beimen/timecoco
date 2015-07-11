//
//  UIBarButtonItem+Custom.h
//  timecoco
//
//  Created by Xie Hong on 3/15/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Custom)

+ (UIBarButtonItem *)createBarButtonItemWithTitle:(NSString *)title target:(id)target selector:(SEL)selector;

+ (UIBarButtonItem *)createBarButtonItemWithImage:(UIImage *)image target:(id)target selector:(SEL)selector;

+ (UIBarButtonItem *)createBarButtonItemWithImages:(NSArray *)images target:(id)target selector:(SEL)selector;

@end
