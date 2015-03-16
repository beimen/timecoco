//
//  TCColorManager.m
//  timecoco
//
//  Created by Xie Hong on 3/14/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import "TCColorManager.h"

@implementation TCColorManager

+ (UIColor *)changeColorForType:(NSUInteger)type {
    UIColor *color = [UIColor new];
    if (type == 1) {
        color = TC_GRAY_COLOR;
    } else if (type == 2) {
        color = TC_RED_COLOR;
    }
    return color;
}

@end
