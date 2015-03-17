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
        [db open];
        
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS timecoco_dairy (pointTime DOUBLE NOT NULL , content VARCHAR NOT NULL , type INTEGER NOT NULL DEFAULT 0, primaryId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE)"];
        
        NSLog(@"%@",db.lastErrorMessage);
        
        [db close];
    }];
}

+ (NSArray *)storedDairyList {
    __block NSMutableArray *items = [NSMutableArray new];
    [manager inDatabase:^(FMDatabase *db) {
        [db open];
        
        FMResultSet *set = [db executeQuery:@"select pointTime,content,type,primaryId from timecoco_dairy order by pointTime asc"];
        while (set.next) {
            TCDairy *dairy = [TCDairy new];
            dairy.pointTime = [set doubleForColumnIndex:0];
            dairy.content = [set stringForColumnIndex:1];
            dairy.type = [set intForColumnIndex:2];
            dairy.primaryId = [set intForColumnIndex:3];
            
            [items addObject:dairy];
        }
        
        [set close];
        [db close];
    }];
    return items;
}

+ (void)addDairy:(TCDairy *)dairy {
    [manager inDatabase:^(FMDatabase *db) {
        [db open];

        [db executeUpdateWithFormat:@"replace into timecoco_dairy (pointTime,content,type) values(%f, %@, %ld)",
                                    dairy.pointTime,
                                    dairy.content,
                                    (long) dairy.type];

        NSLog(@"%@", db.lastErrorMessage);
        
        [db close];
    }];
}

+ (void)removeDairy:(TCDairy *)dairy {
    [manager inDatabase:^(FMDatabase *db) {
        [db open];
        
        [db executeUpdateWithFormat:@"delete from timecoco_dairy where primaryId = %ld", (long)dairy.primaryId];
        
        NSLog(@"%@", db.lastErrorMessage);
        
        [db close];
    }];
}

@end
