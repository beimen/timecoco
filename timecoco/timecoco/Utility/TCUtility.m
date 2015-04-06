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

UIView *createTitleViewForTitle(NSString *title, UIColor *titleColor, CGFloat fontSize) {
    UIView *titleView = [[UIView alloc] init];

    UILabel *titleText = [[UILabel alloc] init];
    titleText.backgroundColor = [UIColor clearColor];
    [titleText setText:title];
    titleText.textAlignment = NSTextAlignmentCenter;
    [titleText setTextColor:titleColor];
    [titleText setFont:[UIFont systemFontOfSize:fontSize]];
    [titleText sizeToFit];
    [titleView addSubview:titleText];

    titleView.size = titleText.size;

    return titleView;
}

@end
