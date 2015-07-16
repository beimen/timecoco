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

@property (nonatomic, assign) TCHomepageFooterType footerType;
@property (nonatomic, strong) TCDashLineView *dashLine;

@end

@implementation TCHomepageFooter

- (void)awakeFromNib {
    [super awakeFromNib];
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

- (TCDashLineView *)dashLine {
    if (_dashLine == nil) {
        self.dashLine = [[TCDashLineView alloc] initWithFrame:CGRectMake(24, 0, 2, 10)];
        _dashLine.startPoint = CGPointMake(0, 0);
        _dashLine.endPoint = CGPointMake(0, 10);

        [self.contentView addSubview:_dashLine];
    }
    return _dashLine;
}

- (void)setDairy:(TCDairyModel *)dairy {
    _dairy = dairy;
    
    self.footerType = [dairy estimateWeekend] ? TCHomepageFooterTypeWeekend : TCHomepageFooterTypeWorkday;
}

@end
