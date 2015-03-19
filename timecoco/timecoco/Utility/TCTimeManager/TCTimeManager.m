//
//  TCTimeManager.m
//  timecoco
//
//  Created by Hong Xie on 19/3/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import "TCTimeManager.h"

@implementation TCTimeManager

+ (NSInteger)getSecondValue:(TCDairy *)dairy {
    NSInteger secondValue = 0;
    secondValue = (dairy.timeZoneInterval + (NSInteger) dairy.pointTime) % T_MINUTE;
    return secondValue;
}

+ (NSInteger)getMinuteValue:(TCDairy *)dairy {
    NSInteger minuteValue = 0;
    minuteValue = ((dairy.timeZoneInterval + (NSInteger) dairy.pointTime) % T_HOUR) / T_MINUTE;
    return minuteValue;
}

+ (NSInteger)getHourValue:(TCDairy *)dairy {
    NSInteger hourValue = 0;
    hourValue = ((dairy.timeZoneInterval + (NSInteger) dairy.pointTime) % T_DAY) / T_HOUR;
    return hourValue;
}

+ (BOOL)estimateWeekend:(TCDairy *)dairy {
    NSInteger order = [self weekdayOrder:(dairy.timeZoneInterval + (NSInteger) dairy.pointTime)];
    return (order == 5) || (order == 6); //基于1970年1月1日星期四，算出如果余数=5或者=6时，为周六和周天
}

+ (NSInteger)weekdayOrder:(NSInteger)intervalSince1970 {
    NSInteger order = (intervalSince1970 / T_DAY + 3) % 7;
    return order;
}

@end
