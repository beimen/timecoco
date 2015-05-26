//
//  TCDairy+Manager.m
//  timecoco
//
//  Created by Hong Xie on 25/5/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import "TCDairy+Manager.h"

@implementation TCDairy (Manager)

- (NSInteger)getSecondValue {
    NSInteger secondValue = 0;
    secondValue = (NSInteger)self.pointTime % T_MINUTE;
    return secondValue;
}

- (NSInteger)getMinuteValue {
    NSInteger minuteValue = 0;
    minuteValue = ((NSInteger)self.pointTime % T_HOUR) / T_MINUTE;
    return minuteValue;
}

- (NSInteger)getHourValue {
    NSInteger hourValue = 0;
    hourValue = (self.timeZoneOffsetInterval % T_DAY) / T_HOUR;
    return hourValue;
}

- (NSInteger)yearOrderSince1970 {
    NSInteger order = (self.timeZoneOffsetInterval / T_DAY - 4) / 7;
    return order;
}

- (NSInteger)weekOrderSince1970 {
    NSInteger order = (self.timeZoneOffsetInterval / T_DAY + 3) / 7;
    return order;
}

- (BOOL)estimateWeekend {
    NSInteger order = [self dayOrderInWeek];
    return (order == 5) || (order == 6); //基于1970年1月1日星期四，算出如果余数=5或者=6时，为周六和周天
}

- (NSInteger)dayOrderInWeek {
    NSInteger order = (self.timeZoneOffsetInterval / T_DAY + 3) % 7;
    return order;
}

@end
