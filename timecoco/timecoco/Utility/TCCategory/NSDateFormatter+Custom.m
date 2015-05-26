//
//  NSDateFormatter+Custom.m
//  timecoco
//
//  Created by Xie Hong on 5/21/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import "NSDateFormatter+Custom.h"

@implementation NSDateFormatter (Custom)

+ (NSDateFormatter *)customFormatter {
    static NSDateFormatter *customFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        customFormatter = [[NSDateFormatter alloc] init];
        customFormatter.dateFormat = @"yyyy-MM";
        NSTimeZone *timezone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        [customFormatter setTimeZone:timezone];
    });
    return customFormatter;
}

+ (NSDateFormatter *)customNormalFormatter {
    static NSDateFormatter *customNormalFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        customNormalFormatter = [[NSDateFormatter alloc] init];
        customNormalFormatter.dateFormat = @"yyyy-MM";
    });
    return customNormalFormatter;
}

+ (NSDateFormatter *)customYearFormatter {
    static NSDateFormatter *customYearFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        customYearFormatter = [[NSDateFormatter alloc] init];
        customYearFormatter.dateFormat = @"yyyy";
    });
    return customYearFormatter;
}

@end
