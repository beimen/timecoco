//
//  TCHomepageHeader.h
//  timecoco
//
//  Created by Xie Hong on 3/16/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    TCHomepageHeaderTypeWorkday = 1,
    TCHomepageHeaderTypeWeekend,
    TCHomepageHeaderTypeHoliday,
    
    TCHomepageHeaderTypeDefault = TCHomepageHeaderTypeWorkday
} TCHomepageHeaderType;

@interface TCHomepageHeader : UITableViewHeaderFooterView

@property (nonatomic, weak) TCDairy *dairy;
@property (nonatomic, weak) TCDairy *lastDairy;

@end
