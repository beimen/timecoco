//
//  TCDairyManager.m
//  timecoco
//
//  Created by Xie Hong on 7/11/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import "TCDairyManager.h"

@implementation TCDairyManager

+ (NSArray *)generateDateIndexFromDairyList:(NSArray *)dairyList {
    NSMutableArray *dateIndex = [NSMutableArray new];
    __block NSInteger lastDate = 0;
    __block NSInteger lastTimeZoneInterval = 0;
    [dairyList enumerateObjectsUsingBlock:^(TCDairy *dairy, NSUInteger idx, BOOL *stop) {
        NSInteger date = (NSInteger)(dairy.pointTime + dairy.timeZoneInterval) / T_DAY;
        if ([dateIndex lastObject] && (date == lastDate) && (lastTimeZoneInterval == dairy.timeZoneInterval)) {
            int lastDateCount = [[dateIndex lastObject] intValue];
            [dateIndex replaceObjectAtIndex:(dateIndex.count - 1) withObject:[NSNumber numberWithInteger:(lastDateCount + 1)]];
        } else {
            [dateIndex addObject:[NSNumber numberWithInteger:1]];
            lastDate = date;
            lastTimeZoneInterval = dairy.timeZoneInterval;
        }
    }];
    return dateIndex;
}

+ (NSInteger)getDairySumBeforeSection:(NSUInteger)section withDateIndex:(NSArray *)dateIndex {
    __block NSInteger count = 0;
    [dateIndex enumerateObjectsUsingBlock:^(NSNumber *num, NSUInteger idx, BOOL *stop) {
        if (idx < section) {
            count += [num integerValue];
        } else {
            *stop = YES;
        }
    }];
    return count;
}

@end
