//
//  TCFrameBorderView.m
//  timecoco
//
//  Created by Hong Xie on 16/3/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import "TCFrameBorderView.h"

@implementation TCFrameBorderView

- (void)awakeFromNib {
    self.backgroundColor = TC_CLEAR_COLOR;
}

- (id)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, TC_RED_COLOR.CGColor);
    CGRect rectangle = CGRectMake(15, 5, self.frame.size.width - 4 - 15, 65);
    CGContextAddRect(context, rectangle);
    CGContextStrokePath(context);
    CGContextSetFillColorWithColor(context, TC_WHITE_COLOR.CGColor);
    CGContextFillRect(context, rectangle);
}

@end