//
//  TCTouchLabel.h
//  timecoco
//
//  Created by Xie Hong on 7/17/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import "TTTAttributedLabel.h"

@interface TCTouchLabel : TTTAttributedLabel

@property (nonatomic, assign) BOOL isTouchingInCorrectRect;
@property (nonatomic, assign) BOOL allowLongPress;
@property (nonatomic, assign) NSTimeInterval longPressInterval;

@end