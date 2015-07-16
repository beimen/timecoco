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
    [super awakeFromNib];
    [self commonInit];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)commonInit {
    self.textLabel.textColor = TC_RED_COLOR;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

@end
