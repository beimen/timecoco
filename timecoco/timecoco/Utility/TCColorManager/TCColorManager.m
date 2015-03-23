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
    if (type == 1) {
        return TC_GRAY_COLOR;
    } else if (type == 2) {
        return TC_RED_COLOR;
    } else {
        return TC_CLEAR_COLOR;
    }
}

+ (UIColor *)changeTextColorForType:(NSUInteger)type {
    if (type == 1) {
        return TC_TEXT_COLOR;
    } else if (type == 2) {
        return TC_RED_COLOR;
    } else {
        return TC_CLEAR_COLOR;
    }
}

@end
