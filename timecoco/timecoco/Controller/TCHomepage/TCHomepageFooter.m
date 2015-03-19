//
//  TCHomepageFooter.m
//  timecoco
//
//  Created by Xie Hong on 3/16/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import "TCHomepageFooter.h"
#import "TCDashLineView.h"

@interface TCHomepageFooter ()

@property (nonatomic, strong) TCDashLineView *dashLine;

@end

@implementation TCHomepageFooter

@synthesize footerType = _footerType;

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
    self.dashLine.lineColor = [TCColorManager changeColorForType:self.footerType];
}

- (void)setFooterType:(TCHomepageFooterType)footerType {
    _footerType = footerType;

    [self setNeedsLayout];
}

- (TCHomepageFooterType)footerType {
    if (_footerType == 0) {
        self.footerType = TCHomepageFooterTypeDefault;
    }
    return _footerType;
}

- (TCDashLineView *)dashLine {
    if (_dashLine == nil) {
        self.dashLine = [[TCDashLineView alloc] initWithFrame:CGRectMake(24, 0, 2, 10)];
        _dashLine.startPoint = CGPointMake(0, 0);
        _dashLine.endPoint = CGPointMake(0, 10);

        [self.contentView addSubview:_dashLine];
    }
    return _dashLine;
}

@end
