//
//  TCHomepageCell.h
//  timecoco
//
//  Created by Xie Hong on 3/15/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCDairyModel.h"

typedef NS_ENUM(NSUInteger, TCHomepageCellType) {
    TCHomepageCellTypeWorkday = 1,
    TCHomepageCellTypeWeekend,
    TCHomepageCellTypeHoliday,

    TCHomepageCellTypeDefault = TCHomepageCellTypeWorkday,
};

@interface TCHomepageCell : UITableViewCell

@property (nonatomic, copy) TCDairyModel *dairy;
@property (nonatomic, copy) void (^longPressBlock)(TCDairyModel *dairy);
@property (nonatomic, copy) void (^tapTagBlock)(NSString *tag);

+ (CGFloat)cellHeightWithDairy:(TCDairyModel *)dairy;

@end
