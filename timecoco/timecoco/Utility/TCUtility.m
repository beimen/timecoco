//
//  TCUtility.m
//  timecoco
//
//  Created by Hong Xie on 16/3/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import "TCUtility.h"

@implementation TCUtility

CGSize getScreenSize() {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    if ((NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1) &&
        UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        return CGSizeMake(screenSize.height, screenSize.width);
    }
    return screenSize;
}

@end
