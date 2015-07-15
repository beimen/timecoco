//
//  TCSettingCell.m
//  timecoco
//
//  Created by Xie Hong on 7/15/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import "TCSettingCell.h"

@implementation TCSettingCell

- (void)awakeFromNib {
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
