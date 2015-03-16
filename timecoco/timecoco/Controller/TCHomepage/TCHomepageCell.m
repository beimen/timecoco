//
//  TCHomepageCell.m
//  timecoco
//
//  Created by Xie Hong on 3/15/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import "TCHomepageCell.h"
#import "TCDashLineView.h"

@interface TCHomepageCell ()

@property (nonatomic, strong) TCDashLineView *dashLine;

@end

@implementation TCHomepageCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = TC_BACK_COLOR;
        self.cellType = TCHomepageCellTypeWorkday;
        [self dashLine];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.cellType == TCHomepageCellTypeWorkday) {
        //self.contentView.backgroundColor = TC_RED_COLOR;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellType:(TCHomepageCellType)cellType {
    _cellType = cellType;
}

- (TCDashLineView *)dashLine {
    if (_dashLine == nil) {
        self.dashLine = [[TCDashLineView alloc] initWithFrame:CGRectMake(24, 0, 2, 75)];
        _dashLine.startPoint = CGPointMake(0, 0);
        _dashLine.endPoint = CGPointMake(0, 75);
        _dashLine.lineColor = TC_RED_COLOR;
        [self.contentView addSubview:self.dashLine];
    }
    return _dashLine;
}

@end
