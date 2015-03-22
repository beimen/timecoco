//
//  TCFrameBorderView.m
//  timecoco
//
//  Created by Hong Xie on 16/3/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import "TCFrameBorderView.h"

@implementation TCFrameBorderView

@synthesize lineColor = _lineColor;

- (void)awakeFromNib {
    self.backgroundColor = TC_CLEAR_COLOR;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    CGRect rectangle = CGRectMake(15, 6, self.width - 4 - 15, self.height - 12);
    CGContextAddRect(context, rectangle);
    CGContextStrokePath(context);
    CGContextSetFillColorWithColor(context, TC_WHITE_COLOR.CGColor);
    CGContextFillRect(context, rectangle);
}

- (UIColor *)lineColor {
    if (_lineColor == nil) {
        self.lineColor = TC_RED_COLOR;
    }
    return _lineColor;
}

- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;

    [self setNeedsDisplay];
}

@end
