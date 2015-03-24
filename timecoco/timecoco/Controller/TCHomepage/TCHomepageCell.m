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

@property (nonatomic, assign) TCHomepageCellType cellType;
@property (nonatomic, strong) TCDashLineView *dashLine;
@property (nonatomic, strong) TCFrameBorderView *frameBorder;
@property (nonatomic, strong) UILabel *hourLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *contentButton;

@end

@implementation TCHomepageCell

//@synthesize cellType = _cellType;

- (void)awakeFromNib {
    self.contentView.backgroundColor = TC_CLEAR_COLOR;
    self.backgroundColor = TC_CLEAR_COLOR;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.dashLine.height = self.contentView.height;
    self.dashLine.endPoint = CGPointMake(0, self.contentView.frame.size.height);
    self.dashLine.lineColor = [TCColorManager changeColorForType:self.cellType];

    self.frameBorder.height = self.contentView.height;
    self.frameBorder.lineColor = _dashLine.lineColor;

    self.contentLabel.height = self.contentView.height - 10;
    self.contentButton.height = self.contentLabel.height - 2;

    self.hourLabel.y = self.contentView.height / 2 - 10;
    self.hourLabel.textColor = [TCColorManager changeTextColorForType:self.cellType];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
}

//- (void)setCellType:(TCHomepageCellType)cellType {
//    _cellType = cellType;
//
//    [self setNeedsLayout];
//}

//- (TCHomepageCellType)cellType {
//    if (_cellType == 0) {
//        self.cellType = TCHomepageCellTypeDefault;
//    }
//    return _cellType;
//}

- (TCDashLineView *)dashLine {
    if (_dashLine == nil) {
        self.dashLine = [[TCDashLineView alloc] initWithFrame:CGRectMake(24, 0, 2, self.contentView.height)];
        _dashLine.startPoint = CGPointMake(0, 0);
        _dashLine.endPoint = CGPointMake(0, self.contentView.height);

        [self.contentView addSubview:self.dashLine];
    }
    return _dashLine;
}

- (TCFrameBorderView *)frameBorder {
    if (_frameBorder == nil) {
        self.frameBorder = [[TCFrameBorderView alloc] initWithFrame:CGRectMake(30, 0, SCREEN_WIDTH - 35, self.contentView.height)];

        [self.contentView addSubview:self.frameBorder];
    }
    return _frameBorder;
}

- (UILabel *)contentLabel {
    if (_contentLabel == nil) {
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, SCREEN_WIDTH - 65, self.contentView.height - 10)];
        _contentLabel.textColor = TC_TEXT_COLOR;
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.numberOfLines = 0;

        [self.frameBorder addSubview:_contentLabel];
    }
    return _contentLabel;
}

- (UILabel *)hourLabel {
    if (_hourLabel == nil) {
        self.hourLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.contentView.height / 2 - 10, 20, 20)];
        _hourLabel.textColor = TC_TEXT_COLOR;
        _hourLabel.textAlignment = NSTextAlignmentRight;
        _hourLabel.font = [UIFont systemFontOfSize:10];

        [self.contentView addSubview:_hourLabel];
    }
    return _hourLabel;
}

- (UIButton *)contentButton {
    if (_contentButton == nil) {
        self.contentButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 6, SCREEN_WIDTH - 54, self.contentView.height - 12)];

        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressTap:)];
        longPress.cancelsTouchesInView = NO;
        longPress.minimumPressDuration = 2.0f;
        [_contentButton addGestureRecognizer:longPress];

        _contentButton.alpha = 0.15f;
        [_contentButton setBackgroundImage:[UIImage imageFromColor:TC_GRAY_COLOR] forState:UIControlStateHighlighted];

        [self.frameBorder addSubview:_contentButton];
    }
    return _contentButton;
}

- (void)setDairy:(TCDairy *)dairy {
    _dairy = dairy;

    self.contentLabel.text = dairy.content;
    if (dairy.type == TCDairyTypeNormal) {
        self.hourLabel.text = [NSString stringWithFormat:@"%li", (long) [TCTimeManager getHourValue:dairy]];
    } else {
        self.hourLabel.text = @"";
    }

    self.cellType = [TCTimeManager estimateWeekend:dairy] ? TCHomepageCellTypeWeekend : TCHomepageCellTypeWorkday;
}

- (void)longPressTap:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.longPressBlock(self.dairy);
    }
}

@end
