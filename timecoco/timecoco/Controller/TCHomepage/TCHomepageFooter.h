//
//  TCHomepageFooter.h
//  timecoco
//
//  Created by Xie Hong on 3/16/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TCHomepageFooterType) {
    TCHomepageFooterTypeWorkday = 1,
    TCHomepageFooterTypeWeekend,
    TCHomepageFooterTypeHoliday,

    TCHomepageFooterTypeDefault = TCHomepageFooterTypeWorkday,
};

@interface TCHomepageFooter : UITableViewHeaderFooterView

@property (nonatomic, weak) TCDairy *dairy;

@end
