//
//  TCTimeManager.m
//  timecoco
//
//  Created by Hong Xie on 19/3/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import "TCTimeManager.h"

@implementation TCTimeManager

+ (BOOL)estimateWeekend:(TCDairy *)dairy {
    NSInteger day = (dairy.timeZoneInterval + (NSInteger) dairy.pointTime) / T_DAY + 3;
    return ((day % 7) > 4);
}

@end
