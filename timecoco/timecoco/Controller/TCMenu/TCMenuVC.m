//
//  TCMenuVC.m
//  timecoco
//
//  Created by Xie Hong on 3/22/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import "TCMenuVC.h"
#import "TCHomepageVC.h"
#import "TCTagSummaryVC.h"
#import "TCSearchVC.h"
#import "TCSettingVC.h"
#import "REFrostedViewController.h"
#import "UIViewController+REFrostedViewController.h"
#import "TCSlideNavigationController.h"

@interface TCMenuVC ()

@end

#define CellIdentifier (@"reuseIdentifier")

@implementation TCMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.backgroundColor = TC_CLEAR_COLOR;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    self.tableView.contentInset = UIEdgeInsetsMake(SCREEN_HEIGHT - 120, 0, 0, 0);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"TCMenuVC is dealocated");
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows;
    if (section == 0) {
        numberOfRows = 1;
    } else if (section == 1) {
        numberOfRows = 2;
    } else if (section == 2) {
        numberOfRows = 1;
    }
    return numberOfRows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"日常";
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"标签";
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"搜索";
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"设置";
        }
    }
    cell.textLabel.textColor = [self cellTextColorWithIndexPath:indexPath];
    return cell;
}

- (UIColor *)cellTextColorWithIndexPath:(NSIndexPath *)indexPatch {
    NSArray *array = @[ @[@"TCHomepageVC"], @[@"TCTagSummaryVC", @"TCSearchVC"], @[@"TCSettingVC"] ];
    UIViewController *topVC = [(UINavigationController *) self.frostedViewController.contentViewController topViewController];
    NSString *classString = (NSString *)[(NSArray *)array[indexPatch.section] objectAtIndex:indexPatch.row];
    if ([topVC isKindOfClass:NSClassFromString(classString)]) {
        return TC_RED_COLOR;
    } else {
        return TC_GRAY_COLOR;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
#ifdef HOMEPAGE_SINGLETON
            TCHomepageVC *vc = [TCHomepageVC sharedVC];
#else
            TCHomepageVC *vc = [[TCHomepageVC alloc] init];
#endif
            TCSlideNavigationController *navigationController = [[TCSlideNavigationController alloc] initWithRootViewController:vc];
            self.frostedViewController.contentViewController = navigationController;
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            TCTagSummaryVC *vc = [[TCTagSummaryVC alloc] init];
            TCSlideNavigationController *navigationController = [[TCSlideNavigationController alloc] initWithRootViewController:vc];
            self.frostedViewController.contentViewController = navigationController;
        } else if (indexPath.row == 1) {
            TCSearchVC *vc = [[TCSearchVC alloc] init];
            TCSlideNavigationController *navigationController = [[TCSlideNavigationController alloc] initWithRootViewController:vc];
            self.frostedViewController.contentViewController = navigationController;
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            TCSettingVC *vc = [[TCSettingVC alloc] init];
            TCSlideNavigationController *navigationController = [[TCSlideNavigationController alloc] initWithRootViewController:vc];
            self.frostedViewController.contentViewController = navigationController;
        }
    }
    [self.frostedViewController hideMenuViewController];
}

@end
