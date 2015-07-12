//
//  TCTagpageCell.h
//  timecoco
//
//  Created by Xie Hong on 7/12/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCTagItemModel.h"

@interface TCTagSummaryCell : UITableViewCell

@property (nonatomic, strong) TCTagItemModel *tagItem;
@property (nonatomic, copy) void (^tapTagBlock)(NSString *tag);

@end
