//
//  TCDairy.m
//  timecoco
//
//  Created by Xie Hong on 3/15/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import "TCDairyModel.h"

@implementation TCDairyModel

- (NSInteger)timeZoneOffsetInterval {
    return self.pointTime + (NSInteger) self.timeZoneInterval;
}

@end
