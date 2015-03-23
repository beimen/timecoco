//
//  TCTimeManager.h
//  timecoco
//
//  Created by Hong Xie on 19/3/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCTimeManager : NSObject

//这里的方法都是获取对应时区的时间的

+ (NSInteger)getSecondValue:(TCDairy *)dairy;

+ (NSInteger)getMinuteValue:(TCDairy *)dairy;

+ (NSInteger)getHourValue:(TCDairy *)dairy;

+ (NSInteger)weekOrderSince1970:(TCDairy *)dairy;

+ (BOOL)estimateWeekend:(TCDairy *)dairy;

+ (NSInteger)dayOrderInWeek:(TCDairy *)dairy;

@end
