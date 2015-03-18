//
//  TCDatabaseManager.h
//  timecoco
//
//  Created by Xie Hong on 3/15/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import "FMDatabaseQueue.h"

#define DB_FULL_NAME @"timecoco.db"

@class TCDairy;

@interface TCDatabaseManager : FMDatabaseQueue

+ (NSString *)getDatabasePathWithName:(NSString *)databaseName;

+ (void)createTable;

+ (NSArray *)storedDairyList;

+ (BOOL)addDairy:(TCDairy *)dairy;

+ (BOOL)removeDairy:(TCDairy *)dairy;

@end
