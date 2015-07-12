//
//  TCDatabaseManager.m
//  timecoco
//
//  Created by Xie Hong on 3/15/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import "TCDatabaseManager.h"
#import "TCDairyModel.h"
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

        NSLog(@"%@", db.lastErrorMessage);
    }];
}

+ (NSArray *)containHashKeyList {
    __block NSMutableArray *items = [NSMutableArray new];
    [manager inDatabase:^(FMDatabase *db) {
        NSString *searchString = @"%%#%%";
        FMResultSet *set = [db executeQuery:@"select content from timecoco_dairy where content like ?", searchString];
        while (set.next) {
            NSString *content = [set stringForColumnIndex:0];
            [items addObject:content];
        }
    }];
    return items;
}

+ (NSArray *)storedDairyList {
    __block NSMutableArray *items = [NSMutableArray new];
    [manager inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQuery:@"select pointTime,timeZoneInterval,content,type,primaryId from timecoco_dairy order by pointTime asc, type desc"];
        while (set.next) {
            TCDairyModel *dairy = [TCDairyModel new];
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

+ (NSArray *)dairyListWithTag:(NSString *)tag {
    return [self dairyListWithKeyword:tag];
}

+ (NSArray *)dairyListWithKeyword:(NSString *)keyword {
    __block NSMutableArray *items = [NSMutableArray new];
    [manager inDatabase:^(FMDatabase *db) {
        NSString *searchString = [NSString stringWithFormat:@"%%%@%%", keyword];
        FMResultSet *set = [db executeQuery:@"select pointTime,timeZoneInterval,content,type,primaryId from timecoco_dairy where content like ? order by pointTime asc, type desc", searchString];
        while (set.next) {
            TCDairyModel *dairy = [TCDairyModel new];
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

+ (NSArray *)sameDayDairyListWithDairy:(TCDairyModel *)dairy {
    NSInteger date = (NSInteger)((dairy.pointTime + dairy.timeZoneInterval) / T_DAY);
    NSTimeInterval startTime = date * T_DAY - dairy.timeZoneInterval;
    NSTimeInterval endTime = (date + 1) * T_DAY - dairy.timeZoneInterval;
    return [self storedDairyListFromTime:startTime toTime:endTime];
}

+ (NSArray *)storedDairyListFromTime:(NSTimeInterval)startTime toTime:(NSTimeInterval)endTime {
    __block NSMutableArray *items = [NSMutableArray new];
    [manager inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQueryWithFormat:@"select pointTime,timeZoneInterval,content,type,primaryId from timecoco_dairy where pointTime between %f and %f order by pointTime asc, type desc", startTime, endTime];
        while (set.next) {
            TCDairyModel *dairy = [TCDairyModel new];
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

+ (BOOL)addDairy:(TCDairyModel *)dairy {
    __block BOOL addResult = NO;
    [manager inDatabase:^(FMDatabase *db) {
        addResult = [db executeUpdateWithFormat:@"replace into timecoco_dairy (pointTime,timeZoneInterval,content,type) values(%f, %ld, %@, %ld)", dairy.pointTime, (long) dairy.timeZoneInterval, dairy.content, (long) dairy.type];
        NSDictionary *userInfo = @{ @"animated" : @(YES),
                                    @"scrollEnabled" : @(YES) };
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ADD_DAIRY_SUCCESS object:nil userInfo:userInfo];
        NSLog(@"%i,%@", addResult, db.lastErrorMessage);
    }];
    return addResult;
}

+ (BOOL)removeDairy:(TCDairyModel *)dairy {
    __block BOOL removeResult = NO;
    [manager inDatabase:^(FMDatabase *db) {
        removeResult = [db executeUpdateWithFormat:@"delete from timecoco_dairy where primaryId = %ld", (long) dairy.primaryId];
        NSDictionary *userInfo = @{ @"animated" : @(YES),
                                    @"scrollEnabled" : @(YES) };
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REMOVE_DAIRY_SUCCESS object:nil userInfo:userInfo];
        NSLog(@"%@", db.lastErrorMessage);
    }];
    return removeResult;
}

+ (BOOL)replaceDairy:(TCDairyModel *)dairy {
    __block BOOL replaceResult = NO;
    [manager inDatabase:^(FMDatabase *db) {
        replaceResult = [db executeUpdateWithFormat:@"replace into timecoco_dairy (pointTime,timeZoneInterval,content,type,primaryId) values(%f, %ld, %@, %ld, %ld)", dairy.pointTime, (long) dairy.timeZoneInterval, dairy.content, (long) dairy.type, (long) dairy.primaryId];
        NSDictionary *userInfo = @{ @"animated" : @(YES),
                                    @"scrollEnabled" : @(NO) };
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REPLACE_DAIRY_SUCCESS object:nil userInfo:userInfo];
        NSLog(@"%i,%@", replaceResult, db.lastErrorMessage);
    }];
    return replaceResult;
}

@end
