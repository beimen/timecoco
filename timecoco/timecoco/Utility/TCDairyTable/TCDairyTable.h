//
//  TCDairyTable.h
//  timecoco
//
//  Created by Xie Hong on 7/11/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TCDairyTableDateType) {
    TCDairyTableDateTypeSimplest,
    TCDairyTableDateTypeAtLeastShowMonth,
};

@interface TCDairyTable : UITableView

@property (nonatomic, strong) NSMutableArray *dairyList;
@property (nonatomic, assign) TCDairyTableDateType dateType;
@property (nonatomic, copy) void (^tapTagBlock)(NSString *tag);

@end
