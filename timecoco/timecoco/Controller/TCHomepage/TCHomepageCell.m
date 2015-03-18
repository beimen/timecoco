//
//  TCHomepageCell.m
//  timecoco
//
//  Created by Xie Hong on 3/15/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import "TCHomepageCell.h"
#import "TCDashLineView.h"
#import "TCFrameBorderView.h"

@interface TCHomepageCell ()

@property (nonatomic, strong) TCDashLineView *dashLine;
@property (nonatomic, strong) TCFrameBorderView *frameBorder;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation TCHomepageCell

@synthesize cellType = _cellType;

- (void)awakeFromNib {
    self.contentView.backgroundColor = TC_BACK_COLOR;
    [self dashLine];
    [self frameBorder];
    [self contentLabel];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _dashLine.lineColor = [TCColorManager changeColorForType:self.cellType];
    _frameBorder.lineColor = _dashLine.lineColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setCellType:(TCHomepageCellType)cellType {
    _cellType = cellType;

    [self setNeedsLayout];
}

- (TCHomepageCellType)cellType {
    if (_cellType == 0) {
        self.cellType = TCHomepageCellTypeDefault;
    }
    return _cellType;
}

- (TCDashLineView *)dashLine {
    if (_dashLine == nil) {
        self.dashLine = [[TCDashLineView alloc] initWithFrame:CGRectMake(24, 0, 2, 75)];
        _dashLine.startPoint = CGPointMake(0, 0);
        _dashLine.endPoint = CGPointMake(0, 75);

        [self.contentView addSubview:self.dashLine];
    }
    return _dashLine;
}

- (TCFrameBorderView *)frameBorder {
    if (_frameBorder == nil) {
        self.frameBorder = [[TCFrameBorderView alloc] initWithFrame:CGRectMake(30, 0, SCREEN_WIDTH - 35, 75)];
        [self.contentView addSubview:self.frameBorder];
    }
    return _frameBorder;
}

- (UILabel *)contentLabel {
    if (_contentLabel == nil) {
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, SCREEN_WIDTH - 65, 65)];
        _contentLabel.textColor = TC_TEXT_COLOR;
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.numberOfLines = 0;
        _contentLabel.text = @"这仅仅是用于测试的一段话。现在的代码还都是伪数据，接下来要用上真实的数据。";
        [self.frameBorder addSubview:_contentLabel];
    }
    return _contentLabel;
}

- (void)setDairy:(TCDairy *)dairy {
    _dairy = dairy;
    
    _contentLabel.text = dairy.content;
}

@end
