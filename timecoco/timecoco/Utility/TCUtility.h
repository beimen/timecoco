//
//  TCUtility.h
//  timecoco
//
//  Created by Hong Xie on 16/3/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SCREEN_WIDTH        (getScreenSize().width)
#define SCREEN_HEIGHT       (getScreenSize().height)

@interface TCUtility : NSObject

CGSize getScreenSize();

@end
