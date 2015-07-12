//
//  TCTagpageCell.m
//  timecoco
//
//  Created by Xie Hong on 7/12/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import "TCTagpageCell.h"
#import "TCTagItemModel.h"
#import "TCFrameBorderView.h"
#import "TTTAttributedLabel.h"

@interface TCTagpageCell () <TTTAttributedLabelDelegate>

@property (nonatomic, strong) TCFrameBorderView *frameBorder;
@property (nonatomic, strong) TTTAttributedLabel *tagTitleLabel;
@property (nonatomic, strong) UILabel *tagCountLabel;

@end

@implementation TCTagpageCell

- (void)awakeFromNib {
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
    self.frameBorder.height = self.contentView.height - 10;
    self.tagTitleLabel.height = self.contentView.height - 40;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma makr - Lazy Loading

- (TCFrameBorderView *)frameBorder {
    if (_frameBorder == nil) {
        self.frameBorder = [[TCFrameBorderView alloc] initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH - 10, self.contentView.height - 10)];

        [self.contentView addSubview:self.frameBorder];
    }
    return _frameBorder;
}

- (TTTAttributedLabel *)tagTitleLabel {
    if (_tagTitleLabel == nil) {
        self.tagTitleLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(1, 1, SCREEN_WIDTH - 12, self.contentView.height - 12)];
        _tagTitleLabel.textColor = TC_TEXT_COLOR;
        _tagTitleLabel.font = [UIFont fontWithName:CUSTOM_FONT_NAME size:15];
        _tagTitleLabel.numberOfLines = 1;
        _tagTitleLabel.textAlignment = NSTextAlignmentCenter;
        _tagTitleLabel.backgroundColor = TC_WHITE_COLOR;
        _tagTitleLabel.clipsToBounds = YES;
        _tagTitleLabel.minimumScaleFactor = 0.5f;
        _tagTitleLabel.adjustsFontSizeToFitWidth = YES;
        
        _tagTitleLabel.extendsLinkTouchArea = NO;
        _tagTitleLabel.maximumLineHeight = 19.0f;
        _tagTitleLabel.minimumLineHeight = 19.0f;
        _tagTitleLabel.lineSpacing = 0.0f;
        _tagTitleLabel.delegate = self;
        
        NSMutableDictionary *linkAttributes = [NSMutableDictionary dictionaryWithDictionary:_tagTitleLabel.linkAttributes];
        [linkAttributes setObject:[NSNumber numberWithBool:NO] forKey:(NSString *) kCTUnderlineStyleAttributeName];
        [linkAttributes setObject:(__bridge id) TC_RED_COLOR.CGColor forKey:(NSString *) kCTForegroundColorAttributeName];
        _tagTitleLabel.linkAttributes = linkAttributes;
        NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:_tagTitleLabel.activeLinkAttributes];
        [attributes setObject:(__bridge id) TC_LIGHT_GRAY_COLOR.CGColor forKey:(NSString *) kTTTBackgroundFillColorAttributeName];
        [attributes setObject:(__bridge id) TC_RED_COLOR.CGColor forKey:(NSString *) kCTForegroundColorAttributeName];
        [attributes setObject:[NSNumber numberWithDouble:2.0f] forKey:(NSString *) kTTTBackgroundCornerRadiusAttributeName];
        _tagTitleLabel.activeLinkAttributes = attributes;
        
        [self.frameBorder addSubview:self.tagTitleLabel];
    }
    return _tagTitleLabel;
}

- (UILabel *)tagCountLabel {
    if (_tagCountLabel == nil) {
        self.tagCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(1, 31, SCREEN_WIDTH - 12, self.contentView.height - 42)];
        _tagCountLabel.font = [UIFont fontWithName:CUSTOM_FONT_NAME size:12.0f];
        _tagCountLabel.textAlignment = NSTextAlignmentCenter;
        _tagCountLabel.textColor = TC_LIGHT_GRAY_COLOR;
        _tagCountLabel.backgroundColor = TC_WHITE_COLOR;
        
        [self.frameBorder addSubview:self.tagCountLabel];
    }
    return _tagCountLabel;
}

#pragma mark - Setter & Getter

- (void)setTagItem:(TCTagItemModel *)tagItem {
    _tagItem = tagItem;

    [self.tagTitleLabel setText:tagItem.title];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(#\\w+#)" options:0 error:nil];
    NSArray *matches = [regex matchesInString:tagItem.title options:0 range:NSMakeRange(0, [tagItem.title length])];
    if ([matches count]) {
        [self.tagTitleLabel setText:tagItem.title afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
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
            [self.tagTitleLabel addLinkWithTextCheckingResult:match];
        }];
    }
    [self.tagCountLabel setText:[NSString stringWithFormat:@"共 %ld 项", (long) tagItem.count]];

    [self setNeedsLayout];
}


#pragma mark - TTTAttributedLabelDelegate Methods

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithTextCheckingResult:(NSTextCheckingResult *)result {
    NSString *tag = self.tagTitleLabel.text;
    if (self.tapTagBlock) {
        self.tapTagBlock(tag);
    }
}

- (void)attributedLabel:(TTTAttributedLabel *)label didLongPressLinkWithTextCheckingResult:(NSTextCheckingResult *)result atPoint:(CGPoint)point {
}

@end
