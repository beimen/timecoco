//
//  TCHomepageCell.h
//  timecoco
//
//  Created by Xie Hong on 3/15/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCDairy.h"

typedef enum {
    TCHomepageCellTypeWorkday = 1,
    TCHomepageCellTypeWeekend,
    TCHomepageCellTypeHoliday,

    TCHomepageCellTypeDefault = TCHomepageCellTypeWorkday
} TCHomepageCellType;

@interface TCHomepageCell : UITableViewCell

@property (nonatomic, copy) TCDairy *dairy;
@property (nonatomic, copy) void (^longPressBlock)(TCDairy *dairy);
@property (nonatomic, copy) void (^tapTagBlock)(NSString *tag);

+ (CGFloat)cellHeightWithDairy:(TCDairy *)dairy;

@end
