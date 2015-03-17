//
//  TCDatabaseManager.m
//  timecoco
//
//  Created by Xie Hong on 3/15/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import "TCDatabaseManager.h"

@implementation TCDatabaseManager

- (NSString *)getDatabasePath {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *datebasePath = [documentPath stringByAppendingPathComponent:@"timecoco.db"];
    return datebasePath;
}

@end
