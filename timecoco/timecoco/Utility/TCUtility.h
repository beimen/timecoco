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
#define CUSTOM_FONT_NAME    (@"NotoSansCJKsc-DemiLight")

@interface TCUtility : NSObject

CGSize getScreenSize();

UIView *createTitleViewForTitle(NSString *title, UIColor *titleColor, CGFloat fontSize);

UIView *createTitleViewForTitleWithMaxWidth(NSString *title, UIColor *titleColor, CGFloat fontSize, CGFloat maxWidth);

@end
