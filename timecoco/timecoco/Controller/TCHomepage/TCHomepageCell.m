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
#import "TCTouchLabel.h"

@interface TCHomepageCell () <TTTAttributedLabelDelegate>

@property (nonatomic, assign) TCHomepageCellType cellType;
@property (nonatomic, strong) TCDashLineView *dashLine;
@property (nonatomic, strong) TCFrameBorderView *frameBorder;
@property (nonatomic, strong) UILabel *hourLabel;
@property (nonatomic, strong) TCTouchLabel *contentLabel;
@property (nonatomic, strong) UILabel *minuteLabel;

@end

@implementation TCHomepageCell

//@synthesize cellType = _cellType;

- (void)awakeFromNib {
    [super awakeFromNib];
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

    self.frameBorder.height = self.contentView.height - 10;
    self.frameBorder.lineColor = _dashLine.lineColor;

    self.contentLabel.height = self.contentView.height - 12;
    if (self.longPressBlock) {
        self.contentLabel.allowLongPress = YES;
    }
    [self.frameBorder bringSubviewToFront:self.contentLabel];

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
        self.frameBorder = [[TCFrameBorderView alloc] initWithFrame:CGRectMake(40, 5, SCREEN_WIDTH - 48, self.contentView.height - 10)];

        [self.contentView addSubview:self.frameBorder];
    }
    return _frameBorder;
}

- (TCTouchLabel *)contentLabel {
    if (_contentLabel == nil) {
        self.contentLabel = [[TCTouchLabel alloc] initWithFrame:CGRectMake(1, 1, SCREEN_WIDTH - 50, self.contentView.height - 12)];
        self.contentLabel.textColor = TC_TEXT_COLOR;
        self.contentLabel.font = [UIFont fontWithName:CUSTOM_FONT_NAME size:15];
        self.contentLabel.numberOfLines = 0;
        
        self.contentLabel.maximumLineHeight = 19.0f;
        self.contentLabel.minimumLineHeight = 19.0f;
        self.contentLabel.textInsets = UIEdgeInsetsMake(0, 7, 0, 7);
        
        _contentLabel.delegate = self;

        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressTap:)];
        longPress.cancelsTouchesInView = NO;
        longPress.minimumPressDuration = self.contentLabel.longpressInterval;
        [_contentLabel addGestureRecognizer:longPress];

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

- (void)setDairy:(TCDairyModel *)dairy {
    _dairy = dairy;

    [self setupContentText:dairy.content];

    if (dairy.type == TCDairyTypeNormal) {
        self.hourLabel.text = [NSString stringWithFormat:@"%ld", (long) [dairy getHourValue]];
    } else {
        self.hourLabel.text = @"";
    }

    self.cellType = [dairy estimateWeekend] ? TCHomepageCellTypeWeekend : TCHomepageCellTypeWorkday;
}

- (void)setupContentText:(NSString *)text {
    if ([text containsString:@"#"]) {
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(#\\w+#)" options:0 error:nil];
        NSArray *matches = [regex matchesInString:text options:0 range:NSMakeRange(0, [text length])];
        if ([matches count]) {
            [self.contentLabel setText:text afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
                [matches enumerateObjectsUsingBlock:^(NSTextCheckingResult *match, NSUInteger idx, BOOL *stop) {
                    //设定可点击文字的的大小
                    UIFont *targetFont = [UIFont fontWithName:CUSTOM_FONT_NAME size:15];
                    CTFontRef font = CTFontCreateWithName((__bridge CFStringRef) targetFont.fontName, targetFont.pointSize, NULL);
                    if (font) {
                        //设置可点击文本的大小
                        [mutableAttributedString addAttribute:(NSString *) kCTFontAttributeName value:(__bridge id) font range:match.range];
                        //设置可点击文本的颜色
                        [mutableAttributedString addAttribute:(NSString *) kCTForegroundColorAttributeName value:(id)[[UIColor blueColor] CGColor] range:match.range];
                        
                        CFRelease(font);
                    }
                }];
                return mutableAttributedString;
            }];
            [matches enumerateObjectsUsingBlock:^(NSTextCheckingResult *match, NSUInteger idx, BOOL *stop) {
                [self.contentLabel addLinkWithTextCheckingResult:match];
            }];
        } else {
            [self.contentLabel setText:text];
        }
    } else {
        [self.contentLabel setText:text];
    }
}

- (void)longPressTap:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan && (self.contentLabel.isTouchingInCorrectRect)) {
        if (self.longPressBlock) {
            self.longPressBlock(self.dairy);
            [self.contentLabel setBackgroundColor:TC_WHITE_COLOR];
        }
    }
}

- (void)showMinuteLabel {
    if (self.dairy.type == TCDairyTypeNormal) {
        NSString *minuteLabelText = [NSString stringWithFormat:@"%ld", (long) [self.dairy getMinuteValue]];
        self.minuteLabel.text = (minuteLabelText.length == 1) ? [NSString stringWithFormat:@"0%@", minuteLabelText] : minuteLabelText;
        self.minuteLabel.textColor = [TCColorManager changeTextColorForType:self.cellType];
        [UIView animateWithDuration:1.0f
                         animations:^{
                             self.minuteLabel.alpha = 1.0f;
                         }
                         completion:^(BOOL finished) {
                             [UIView animateWithDuration:1.0f
                                                   delay:0.0f
                                                 options:UIViewAnimationOptionCurveLinear
                                              animations:^{
                                                  self.minuteLabel.alpha = 0.0f;
                                              }
                                              completion:^(BOOL finished){
                                              }];
                         }];
    }
}

#pragma mark - TTTAttributedLabelDelegate Methods

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithTextCheckingResult:(NSTextCheckingResult *)result {
    NSString *tag = [self.dairy.content substringWithRange:result.range];
    if (self.tapTagBlock) {
        self.tapTagBlock(tag);
    }
}

- (void)attributedLabel:(TTTAttributedLabel *)label didLongPressLinkWithTextCheckingResult:(NSTextCheckingResult *)result atPoint:(CGPoint)point {
}

#pragma mark - Class Method

+ (CGFloat)cellHeightWithDairy:(TCDairyModel *)dairy {
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    [style setMaximumLineHeight:19.0f];
    NSDictionary *attrs = @{
        NSFontAttributeName : [UIFont fontWithName:CUSTOM_FONT_NAME size:15],
        NSParagraphStyleAttributeName : style
    };
    CGRect rect = [dairy.content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 64, MAXFLOAT)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:attrs
                                              context:nil];
    return ((rect.size.height > 63.0f) ? (int) rect.size.height / 5 * 5 + 13 : 63) + 12;
}

@end
