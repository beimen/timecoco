//
//  TCDairy+Manager.h
//  timecoco
//
//  Created by Hong Xie on 25/5/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import "TCDairy.h"

@interface TCDairy (Manager)

- (NSInteger)getSecondValue;

- (NSInteger)getMinuteValue;

- (NSInteger)getHourValue;

- (NSInteger)weekOrderSince1970;

- (BOOL)estimateWeekend;

- (NSInteger)dayOrderInWeek;

@end
