//
//  TCDashLineView.m
//  timecoco
//
//  Created by Xie Hong on 3/15/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import "TCDashLineView.h"

@implementation TCDashLineView

- (id)initWithFrame:(CGRect)frame {
    
    self= [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = TC_CLEAR_COLOR;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, MIN(self.frame.size.height, self.frame.size.width) * 2);
    CGContextSetStrokeColorWithColor(context,self.lineColor.CGColor);
    CGFloat lengths[] = {2,3};
    CGContextSetLineDash(context, 0, lengths, 2);
    CGContextMoveToPoint(context,self.startPoint.x,self.startPoint.y);
    CGContextAddLineToPoint(context,self.endPoint.x,self.endPoint.y);
    CGContextStrokePath(context);
}

@end
