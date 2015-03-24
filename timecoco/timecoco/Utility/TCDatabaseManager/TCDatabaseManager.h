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

+ (BOOL)addDairy:(TCDairy *)dairy;

+ (BOOL)replaceDairy:(TCDairy *)dairy;

+ (BOOL)removeDairy:(TCDairy *)dairy;

@end
