//
//  NSArray+DairyIndex.m
//  timecoco
//
//  Created by Xie Hong on 3/28/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import "NSArray+DairyIndex.h"

@implementation NSArray (Extensions)

- (NSUInteger)findFirstDiffDairyIndex:(NSArray *)array {
    if ([self count] > [array count]) {
        return [array findFirstDiffDairyIndex:self];
    } else {
        __block NSUInteger result;
        result = [self count] - 1;
        [self enumerateObjectsUsingBlock:^(TCDairy *obj, NSUInteger idx, BOOL *stop) {
            TCDairy *dairy = [array objectAtIndex:idx];
            if ([obj.content isEqualToString:dairy.content]
                && (obj.timeZoneInterval == dairy.timeZoneInterval)
                && (obj.pointTime == dairy.pointTime)
                && (obj.type == dairy.type)
                && (obj.primaryId == dairy.primaryId)) {
            } else {
                result = idx;
                *stop = YES;
            }
        }];
        return result;
    }
}

@end
