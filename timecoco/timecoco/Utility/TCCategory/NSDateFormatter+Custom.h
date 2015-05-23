//
//  NSDateFormatter+Custom.h
//  timecoco
//
//  Created by Xie Hong on 5/21/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (Custom)

+ (NSDateFormatter *)customFormatter;
+ (NSDateFormatter *)customNormalFormatter;
+ (NSDateFormatter *)customYearFormatter;

@end
