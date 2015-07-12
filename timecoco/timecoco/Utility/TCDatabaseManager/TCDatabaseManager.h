//
//  TCDatabaseManager.h
//  timecoco
//
//  Created by Xie Hong on 3/15/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import "FMDatabaseQueue.h"

@class TCDairyModel;

@interface TCDatabaseManager : FMDatabaseQueue

+ (NSArray *)storedDairyList;

/*!
 *  仅仅抓取含有#存储的文字
 */
+ (NSArray *)containHashKeyList;

+ (NSArray *)dairyListWithTag:(NSString *)tag;

+ (NSArray *)sameDayDairyListWithDairy:(TCDairyModel *)dairy;

+ (NSArray *)storedDairyListFromTime:(NSTimeInterval)startTime toTime:(NSTimeInterval)endTime;

+ (BOOL)addDairy:(TCDairyModel *)dairy;

+ (BOOL)replaceDairy:(TCDairyModel *)dairy;

+ (BOOL)removeDairy:(TCDairyModel *)dairy;

@end
