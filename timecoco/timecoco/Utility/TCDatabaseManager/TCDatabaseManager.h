//
//  TCDatabaseManager.h
//  timecoco
//
//  Created by Xie Hong on 3/15/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import "FMDatabaseQueue.h"

@class TCDairy;

@interface TCDatabaseManager : FMDatabaseQueue

+ (NSArray *)storedDairyList;

+ (NSArray *)dairyListWithTag:(NSString *)tag;

+ (NSArray *)storedDairyListFromTime:(NSTimeInterval)startTime toTime:(NSTimeInterval)endTime;

+ (BOOL)addDairy:(TCDairy *)dairy;

+ (BOOL)replaceDairy:(TCDairy *)dairy;

+ (BOOL)removeDairy:(TCDairy *)dairy;

@end
