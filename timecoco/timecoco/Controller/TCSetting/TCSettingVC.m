//
//  TCSettingVC.m
//  timecoco
//
//  Created by Xie Hong on 4/8/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import "TCSettingVC.h"
#import "TCSettingCell.h"

#define CellIdentifier (@"TCSettingCell")

@interface TCSettingVC ()

@end

@implementation TCSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = createTitleViewForTitle(@"设置", TC_RED_COLOR, 17);
    [self.tableView registerClass:[TCSettingCell class] forCellReuseIdentifier:@"TCSettingCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    NSLog(@"TCSettingVC is deallocated.");
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
 
    return cell;
}

@end
