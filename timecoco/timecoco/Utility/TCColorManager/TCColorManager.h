//
//  TCColorManager.h
//  timecoco
//
//  Created by Xie Hong on 3/14/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// 全局颜色
#define TC_GRAY_COLOR       UIColorFromRGB(0x808080)
#define TC_RED_COLOR        UIColorFromRGB(0xc13630)
#define TC_DARK_RED_COLOR   UIColorFromRGB(0x701815)
#define TC_BACK_COLOR       UIColorFromRGB(0xf9f6f3)
#define TC_TABLE_BACK_COLOR TC_BACK_COLOR
#define TC_WHITE_COLOR      UIColorFromRGB(0xffffff)
#define TC_DARK_GRAY_COLOR  UIColorFromRGB(0x404040)
#define TC_LIGHT_GRAY_COLOR UIColorFromRGB(0xc0c0c0)
#define TC_TEXT_COLOR       TC_DARK_GRAY_COLOR
#define TC_CLEAR_COLOR      [UIColor clearColor]

@interface TCColorManager : NSObject

+ (UIColor *)changeColorForType:(NSUInteger)type;

+ (UIColor *)changeTextColorForType:(NSUInteger)type;

@end
