//
//  TCDashLineView.h
//  timecoco
//
//  Created by Xie Hong on 3/15/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCDashLineView : UIView

@property(nonatomic, assign) CGPoint startPoint;//虚线起点

@property(nonatomic, assign) CGPoint endPoint;//虚线终点

@property(nonatomic, strong) UIColor* lineColor;//虚线颜色

@end
