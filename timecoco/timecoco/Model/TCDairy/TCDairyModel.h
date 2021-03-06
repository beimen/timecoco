//
//  TCDairy.h
//  timecoco
//
//  Created by Xie Hong on 3/15/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, TCDairyType) {
    TCDairyTypeNormal = 0,
    TCDairyTypeAllDay,

    TCDairyTypeDefault = TCDairyTypeNormal,
};

@interface TCDairyModel : NSObject

@property (nonatomic, assign) NSInteger primaryId;
@property (nonatomic, assign) NSInteger timeZoneInterval;
@property (nonatomic, assign) TCDairyType type;
@property (nonatomic, assign) CGFloat pointTime;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, readonly) NSInteger timeZoneOffsetInterval;

@end
