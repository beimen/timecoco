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

@property (nonatomic, weak) TCDairyModel *dairy;
@property (nonatomic, weak) TCDairyModel *lastDairy;
@property (nonatomic, assign) NSInteger yearNowValue;
@property (nonatomic, assign) BOOL showMonth;
@property (nonatomic, copy) void (^doubleTapBlock)(TCDairyModel *dairy);

@end
