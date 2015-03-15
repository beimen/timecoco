//
//  TCDairy.h
//  timecoco
//
//  Created by Xie Hong on 3/15/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    TCDairyTypeNormal = 0,
    TCDairyTypeAllDay,
} TCDairyType;

@interface TCDairy : NSObject

@property (nonatomic, assign) TCDairyType type;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSDate *creatTime;

@end
