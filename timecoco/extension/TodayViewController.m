//
//  TodayViewController.m
//  extension
//
//  Created by Xie Hong on 5/30/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import "TodayViewController.h"
#import "TCColorManager.h"
#import "UIImage+Extensions.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>

@property (nonatomic, weak) IBOutlet UIButton *addButton;

@end

@implementation TodayViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_addButton setTitle:@"添加记录" forState:UIControlStateNormal];
    [_addButton setTitleColor:TC_RED_COLOR forState:UIControlStateNormal];
    [_addButton addTarget:self action:@selector(jumpToAdd:) forControlEvents:UIControlEventTouchUpInside];
    
    [self updateUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateUI {
    self.preferredContentSize = CGSizeMake(self.view.frame.size.width, 50);
}

#pragma mark - Button Action

- (void)jumpToAdd:(UIButton *)sender {
    NSURL *url = [NSURL URLWithString:@"timecoco://add"];
    [self.extensionContext openURL:url completionHandler:nil];
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets {
    return UIEdgeInsetsZero;
}

@end
