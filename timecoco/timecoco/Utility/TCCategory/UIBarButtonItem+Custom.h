//
//  UIBarButtonItem+Custom.h
//  timecoco
//
//  Created by Xie Hong on 3/15/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Custom)

+ (UIBarButtonItem *)createBarButtonItemWithImage:(UIImage *)image Target:(id)target Selector:(SEL)selector;

+ (UIBarButtonItem *)createBarButtonItemWithImages:(NSArray *)images Target:(id)target Selector:(SEL)selector;

@end
