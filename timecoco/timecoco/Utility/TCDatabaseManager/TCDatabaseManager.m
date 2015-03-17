//
//  TCDatabaseManager.m
//  timecoco
//
//  Created by Xie Hong on 3/15/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import "TCDatabaseManager.h"

@implementation TCDatabaseManager

static TCDatabaseManager *manager;
dispatch_queue_t queue;

+ (void)initialize {
    manager = [[TCDatabaseManager alloc] initWithPath:[self getDatabasePathWithName:DB_FULL_NAME]];
    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
}

+ (NSString *)getDatabasePathWithName:(NSString *)databaseName {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *datebasePath = [documentPath stringByAppendingPathComponent:databaseName];
    return datebasePath;
}

@end
