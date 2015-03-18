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

@property (nonatomic, assign) TCHomepageCellType cellType;
@property (nonatomic, strong) TCDairy *dairy;

@end
