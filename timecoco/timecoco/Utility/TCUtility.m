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
    return createTitleViewForTitleWithMaxWidth(title, nil, titleColor, fontSize, CGFLOAT_MAX);
}

UIView *createTitleViewForTitleWithMaxWidth(NSString *title, NSString *subtitle, UIColor *titleColor, CGFloat fontSize, CGFloat maxWidth) {
    UIView *titleView = [[UIView alloc] init];

    UILabel *titleText = [[UILabel alloc] init];
    titleText.backgroundColor = [UIColor clearColor];
    titleText.adjustsFontSizeToFitWidth = YES;
    [titleText setText:title];
    titleText.textAlignment = NSTextAlignmentCenter;
    [titleText setTextColor:titleColor];
    [titleText setFont:[UIFont systemFontOfSize:fontSize]];
    [titleText sizeToFit];
    [titleView addSubview:titleText];
    
    UILabel *subTitleText = [[UILabel alloc] init];

    if (subtitle != nil) {
        subTitleText.backgroundColor = [UIColor clearColor];
        [subTitleText setText:subtitle];
        subTitleText.textAlignment = NSTextAlignmentCenter;
        [subTitleText setFont:[UIFont systemFontOfSize:11.0f]];
        [subTitleText setTextColor:titleColor];
        [subTitleText sizeToFit];
        [titleView addSubview:subTitleText];
        titleView.size = CGSizeMake(MIN(titleText.size.width, maxWidth), titleText.size.height + subTitleText.size.height);
    } else {
        titleView.size = CGSizeMake(MIN(titleText.size.width, maxWidth), titleText.size.height);
    }
    
    titleText.width = subTitleText.width = titleView.width;
    subTitleText.y = titleView.height - subTitleText.height;

    return titleView;
}

@end
