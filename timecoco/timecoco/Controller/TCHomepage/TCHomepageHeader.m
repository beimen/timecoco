//
//  TCHomepageHeader.m
//  timecoco
//
//  Created by Xie Hong on 3/16/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import "TCHomepageHeader.h"
#import "TCDashLineView.h"

@interface TCHomepageHeader ()

@property (nonatomic, assign) TCHomepageHeaderType headerType;
@property (nonatomic, strong) TCDashLineView *verticalDashLine;
@property (nonatomic, strong) TCDashLineView *horizontalDashLine;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation TCHomepageHeader

- (void)awakeFromNib {
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.verticalDashLine.lineColor = [TCColorManager changeColorForType:self.headerType];
    self.horizontalDashLine.lineColor = _verticalDashLine.lineColor;
    self.timeLabel.textColor = [TCColorManager changeTextColorForType:self.headerType];
}

- (TCDashLineView *)verticalDashLine {
    if (_verticalDashLine == nil) {
        self.verticalDashLine = [[TCDashLineView alloc] initWithFrame:CGRectMake(24, 0, 2, 30)];
        _verticalDashLine.startPoint = CGPointMake(0, 0);
        _verticalDashLine.endPoint = CGPointMake(0, 30);

        [self.contentView addSubview:_verticalDashLine];
    }
    return _verticalDashLine;
}

- (TCDashLineView *)horizontalDashLine {
    if (_horizontalDashLine == nil) {
        NSUInteger lineWidth = (SCREEN_WIDTH / 2 + 10) / 10;
        lineWidth = 10 * lineWidth + 4;
        self.horizontalDashLine = [[TCDashLineView alloc] initWithFrame:CGRectMake(0, 0, lineWidth, 2)];
        _horizontalDashLine.startPoint = CGPointMake(4, 0);
        _horizontalDashLine.endPoint = CGPointMake(lineWidth, 0);

        [self.contentView addSubview:_horizontalDashLine];
    }
    return _horizontalDashLine;
}

- (void)setDairy:(TCDairy *)dairy {
    _dairy = dairy;

    self.headerType = [TCTimeManager estimateWeekend:dairy] ? TCHomepageHeaderTypeWeekend : TCHomepageHeaderTypeWorkday;

    [self setUpTimeText:dairy];
}

- (UILabel *)timeLabel {
    if (_timeLabel == nil) {
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 12, SCREEN_WIDTH - 50, 12)];
        _timeLabel.font = [UIFont boldSystemFontOfSize:12];

        [self.contentView addSubview:_timeLabel];
    }
    return _timeLabel;
}

- (void)setUpTimeText:(TCDairy *)dairy {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:dairy.pointTime];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    [formatter setDateFormat:@"YYYY"];
    BOOL showYear = (self.yearNowValue != [formatter stringFromDate:[NSDate date]].integerValue);
    BOOL showMonth;
    
    if (self.lastDairy) {
        showMonth = ([TCTimeManager weekOrderSince1970:self.lastDairy] != [TCTimeManager weekOrderSince1970:dairy]);
    } else {
        showMonth = YES;
    }
    if (showMonth) {
        [formatter setDateFormat:@"MM月dd日"];
        if (showYear) {
            [formatter setDateFormat:@"YYYY年MM月dd日"];
        }
    } else {
        [formatter setDateFormat:@"dd日"];
    }
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:dairy.timeZoneInterval]];
    
    NSArray *array = @[ @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", @"周日" ];
    NSInteger order = [TCTimeManager dayOrderInWeek:dairy];
    self.timeLabel.text = [NSString stringWithFormat:@"%@ %@", [formatter stringFromDate:date], [array objectAtIndex:order]];
    
    BOOL showTimeZone = ([[NSTimeZone localTimeZone] secondsFromGMT] != dairy.timeZoneInterval);
    if (showTimeZone) {
        self.timeLabel.text = [self.timeLabel.text stringByAppendingFormat:@"   %@",[NSTimeZone timeZoneForSecondsFromGMT:dairy.timeZoneInterval].name];
    }
}

@end
