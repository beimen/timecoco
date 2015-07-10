//
//  TCDairyManager.h
//  timecoco
//
//  Created by Xie Hong on 7/11/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCDairyManager : NSObject

+ (NSArray *)generateDateIndexFromDairyList:(NSArray *)dairyList;

+ (NSInteger)getDairySumBeforeSection:(NSUInteger)section withDateIndex:(NSArray *)dateIndex;

@end
