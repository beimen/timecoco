//
//  TCTagpageVC.m
//  timecoco
//
//  Created by Xie Hong on 5/20/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import "TCTagpageVC.h"

@interface TCTagpageVC ()

@end

@implementation TCTagpageVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];

    return cell;
}

@end
