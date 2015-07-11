//
//  TCHomepageHeader.h
//  timecoco
//
//  Created by Xie Hong on 3/16/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TCHomepageHeaderType) {
    TCHomepageHeaderTypeWorkday = 1,
    TCHomepageHeaderTypeWeekend,
    TCHomepageHeaderTypeHoliday,

    TCHomepageHeaderTypeDefault = TCHomepageHeaderTypeWorkday,
};

@interface TCHomepageHeader : UITableViewHeaderFooterView

@property (nonatomic, weak) TCDairy *dairy;
@property (nonatomic, weak) TCDairy *lastDairy;
@property (nonatomic, assign) NSInteger yearNowValue;
@property (nonatomic, assign) BOOL showMonth;

@end
