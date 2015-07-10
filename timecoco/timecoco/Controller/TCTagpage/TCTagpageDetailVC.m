//
//  TCTagpageDetailVC.m
//  timecoco
//
//  Created by Xie Hong on 7/10/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import "TCTagpageDetailVC.h"
#import "TCHomepageCell.h"
#import "TCHomepageHeader.h"
#import "TCHomepageFooter.h"
#import "NSDateFormatter+Custom.h"

#define CellIdentifier (@"TCTagpageDetailCell")
#define CellHeaderIdentifier (@"TCTagpageDetailHeader")
#define CellFooterIdentifier (@"TCTagpageDetailFooter")

static CGFloat cellHeaderHeight = 30.0f;
static CGFloat cellFooterHeight = 10.0f;

@interface TCTagpageDetailVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TCTagpageDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark 

@end
