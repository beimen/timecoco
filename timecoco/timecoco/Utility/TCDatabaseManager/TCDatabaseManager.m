//
//  TCDatabaseManager.m
//  timecoco
//
//  Created by Xie Hong on 3/15/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import "TCDatabaseManager.h"
#import "TCDairy.h"
#import "FMDatabase.h"

@implementation TCDatabaseManager

static TCDatabaseManager *manager;
dispatch_queue_t queue;

+ (void)initialize {
    manager = [[TCDatabaseManager alloc] initWithPath:[self getDatabasePathWithName:DB_FULL_NAME]];
    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    [self createTable];
}

+ (NSString *)getDatabasePathWithName:(NSString *)databaseName {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *datebasePath = [documentPath stringByAppendingPathComponent:databaseName];
    return datebasePath;
}

+ (void)createTable {
    [manager inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS timecoco_dairy (pointTime DOUBLE NOT NULL , timeZoneInterval INTEGER NOT NULL , content VARCHAR NOT NULL , type INTEGER NOT NULL DEFAULT 0, primaryId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE)"];
        
        NSLog(@"%@",db.lastErrorMessage);
    }];
}

+ (NSArray *)storedDairyList {
    __block NSMutableArray *items = [NSMutableArray new];
    [manager inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQuery:@"select pointTime,timeZoneInterval,content,type,primaryId from timecoco_dairy order by pointTime asc, type desc"];
        while (set.next) {
            TCDairy *dairy = [TCDairy new];
            dairy.pointTime = [set doubleForColumnIndex:0];
            dairy.timeZoneInterval = [set intForColumnIndex:1];
            dairy.content = [set stringForColumnIndex:2];
            dairy.type = [set intForColumnIndex:3];
            dairy.primaryId = [set intForColumnIndex:4];
            
            [items addObject:dairy];
        }
    }];
    return items;
}

+ (NSArray *)storedDairyListFromTime:(NSTimeInterval)startTime toTime:(NSTimeInterval)endTime {
    __block NSMutableArray *items = [NSMutableArray new];
    [manager inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQueryWithFormat:@"select pointTime,timeZoneInterval,content,type,primaryId from timecoco_dairy where pointTime > %f order by pointTime asc, type desc",startTime];
        while (set.next) {
            TCDairy *dairy = [TCDairy new];
            dairy.pointTime = [set doubleForColumnIndex:0];
            dairy.timeZoneInterval = [set intForColumnIndex:1];
            dairy.content = [set stringForColumnIndex:2];
            dairy.type = [set intForColumnIndex:3];
            dairy.primaryId = [set intForColumnIndex:4];
            
            [items addObject:dairy];
        }
    }];
    return items;
}

+ (BOOL)addDairy:(TCDairy *)dairy {
    __block BOOL addResult = NO;
    [manager inDatabase:^(FMDatabase *db) {
        addResult = [db executeUpdateWithFormat:@"replace into timecoco_dairy (pointTime,timeZoneInterval,content,type) values(%f, %ld, %@, %ld)",dairy.pointTime, (long)dairy.timeZoneInterval, dairy.content, (long)dairy.type];
        
        NSLog(@"%i,%@", addResult, db.lastErrorMessage);
    }];
    return addResult;
}

+ (BOOL)removeDairy:(TCDairy *)dairy {
    __block BOOL removeResult = NO;
    [manager inDatabase:^(FMDatabase *db) {
        removeResult = [db executeUpdateWithFormat:@"delete from timecoco_dairy where primaryId = %ld", (long)dairy.primaryId];
        
        NSLog(@"%@", db.lastErrorMessage);
    }];
    return removeResult;
}

+ (BOOL)replaceDairy:(TCDairy *)dairy {
    __block BOOL replaceResult = NO;
    [manager inDatabase:^(FMDatabase *db) {
        replaceResult = [db executeUpdateWithFormat:@"replace into timecoco_dairy (pointTime,timeZoneInterval,content,type,primaryId) values(%f, %ld, %@, %ld, %ld)",dairy.pointTime, (long)dairy.timeZoneInterval, dairy.content, (long)dairy.type, (long)dairy.primaryId];
        
        NSLog(@"%i,%@", replaceResult, db.lastErrorMessage);
    }];
    return replaceResult;
}

@end
