//
//  TCTouchLabel.m
//  timecoco
//
//  Created by Xie Hong on 7/17/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import "TCTouchLabel.h"

@implementation TCTouchLabel

@synthesize longPressInterval = _longPressInterval;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = TC_WHITE_COLOR;
        self.clipsToBounds = YES;
        self.multipleTouchEnabled = NO;
       
        self.extendsLinkTouchArea = NO;
        self.lineSpacing = 0.0f;
        
        NSMutableDictionary *linkAttributes = [NSMutableDictionary dictionaryWithDictionary:self.linkAttributes];
        [linkAttributes setObject:[NSNumber numberWithBool:NO] forKey:(NSString *) kCTUnderlineStyleAttributeName];
        [linkAttributes setObject:(__bridge id) TC_RED_COLOR.CGColor forKey:(NSString *) kCTForegroundColorAttributeName];
        self.linkAttributes = linkAttributes;
        NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:self.activeLinkAttributes];
        [attributes setObject:(__bridge id) TC_LIGHT_GRAY_COLOR.CGColor forKey:(NSString *) kTTTBackgroundFillColorAttributeName];
        [attributes setObject:(__bridge id) TC_RED_COLOR.CGColor forKey:(NSString *) kCTForegroundColorAttributeName];
        [attributes setObject:[NSNumber numberWithDouble:2.0f] forKey:(NSString *) kTTTBackgroundCornerRadiusAttributeName];
        self.activeLinkAttributes = attributes;
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if (self.allowLongPress) {
        NSSet *allTouches = [event allTouches];
        UITouch *touch = [allTouches anyObject];
        CGPoint point = [touch locationInView:self];
        if (![self containslinkAtPoint:point]) {
            [self performSelector:@selector(setBackgroundColorForTouch) withObject:nil afterDelay:0.1f];
            self.isTouchingInCorrectRect = YES;
            [self performSelector:@selector(resetBackgroundColorFroTouch) withObject:nil afterDelay:self.longPressInterval];
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    if (self.allowLongPress) {
        [self setBackgroundColor:TC_WHITE_COLOR];
        self.isTouchingInCorrectRect = NO;
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    if (self.allowLongPress) {
        [self setBackgroundColor:TC_WHITE_COLOR];
        self.isTouchingInCorrectRect = NO;
    }
}

- (void)setBackgroundColorForTouch {
    if (self.isTouchingInCorrectRect) {
        [self setBackgroundColor:TC_GRAY_BACK_COLOR];
    }
}

- (void)resetBackgroundColorFroTouch {
    [self setBackgroundColor:TC_WHITE_COLOR];
}

#pragma mark - Setter

- (void)setLongPressInterval:(NSTimeInterval)longpressInterval {
    _longPressInterval = longpressInterval;
}

- (NSTimeInterval)longPressInterval {
    if (_longPressInterval == 0) {
        self.longPressInterval = 0.5f;
    }
    return _longPressInterval;
}

@end
