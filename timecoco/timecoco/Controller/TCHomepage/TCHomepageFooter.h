//
//  TCHomepageFooter.h
//  timecoco
//
//  Created by Xie Hong on 3/16/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    TCHomepageFooterTypeWorkday = 1,
    TCHomepageFooterTypeWeekend,
    TCHomepageFooterTypeHoliday,

    TCHomepageFooterTypeDefault = TCHomepageFooterTypeWorkday
} TCHomepageFooterType;

@interface TCHomepageFooter : UITableViewHeaderFooterView

@property (nonatomic, assign) TCHomepageFooterType footerType;

@end
