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
@property (nonatomic, strong) UILabel *minuteLabel;

@end

@implementation TCHomepageCell

//@synthesize cellType = _cellType;

- (void)awakeFromNib {
    self.contentView.backgroundColor = TC_TABLE_BACK_COLOR;
    self.backgroundColor = TC_TABLE_BACK_COLOR;
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

    self.contentLabel.height = self.contentView.height - 12;
    self.contentButton.height = self.contentLabel.height;

    self.hourLabel.height = self.contentView.height;
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
//
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
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 6, SCREEN_WIDTH - 65, self.contentView.height - 12)];
        _contentLabel.textColor = TC_TEXT_COLOR;
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.numberOfLines = 0;
        _contentLabel.backgroundColor = TC_WHITE_COLOR;
        _contentLabel.clipsToBounds = YES;

        [self.frameBorder addSubview:_contentLabel];
    }
    return _contentLabel;
}

- (UILabel *)hourLabel {
    if (_hourLabel == nil) {
        self.hourLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, self.contentView.height)];
        _hourLabel.textColor = TC_TEXT_COLOR;
        _hourLabel.textAlignment = NSTextAlignmentRight;
        _hourLabel.font = [UIFont systemFontOfSize:10];
        _hourLabel.userInteractionEnabled = YES;
        _hourLabel.backgroundColor = TC_TABLE_BACK_COLOR;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMinuteLabel)];
        [_hourLabel addGestureRecognizer:singleTap];

        [self.contentView addSubview:_hourLabel];
    }
    return _hourLabel;
}

- (UILabel *)minuteLabel {
    if (_minuteLabel == nil) {
        self.minuteLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 10, self.contentView.height)];
        _minuteLabel.textColor = TC_TEXT_COLOR;
        _minuteLabel.textAlignment = NSTextAlignmentLeft;
        _minuteLabel.font = [UIFont systemFontOfSize:7];
        _minuteLabel.alpha = 0.0f;
        _minuteLabel.backgroundColor = TC_TABLE_BACK_COLOR;

        [self.contentView addSubview:_minuteLabel];
    }
    return _minuteLabel;
}

- (UIButton *)contentButton {
    if (_contentButton == nil) {
        self.contentButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 6, SCREEN_WIDTH - 54, self.contentView.height - 12)];

        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressTap:)];
        longPress.cancelsTouchesInView = NO;
        longPress.minimumPressDuration = 0.7f;
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
        self.hourLabel.text = [NSString stringWithFormat:@"%ld", (long) [dairy getHourValue]];
    } else {
        self.hourLabel.text = @"";
    }

    self.cellType = [dairy estimateWeekend] ? TCHomepageCellTypeWeekend : TCHomepageCellTypeWorkday;
}

- (void)longPressTap:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.longPressBlock(self.dairy);
    }
}

- (void)showMinuteLabel {
    if (self.dairy.type == TCDairyTypeNormal) {
        NSString *minuteLabelText = [NSString stringWithFormat:@"%ld", (long) [self.dairy getMinuteValue]];
        self.minuteLabel.text = (minuteLabelText.length == 1) ? [NSString stringWithFormat:@"0%@", minuteLabelText] : minuteLabelText;
        self.minuteLabel.textColor = [TCColorManager changeTextColorForType:self.cellType];
        [UIView animateWithDuration:1.0f animations:^{
            self.minuteLabel.alpha = 1.0f;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:1.0f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
                self.minuteLabel.alpha = 0.0f;
            } completion:^(BOOL finished) {
            }];
        }];
    }
}

@end
