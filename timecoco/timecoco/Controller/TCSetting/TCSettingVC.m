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

@interface TCSettingVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TCSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];

    [self.view addSubview:self.tableView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    NSLog(@"TCSettingVC is deallocated.");
}

#pragma mark - Setup UI

- (void)setupUI {
    self.navigationItem.titleView = createTitleViewForTitle(@"设置", TC_RED_COLOR, 17);
    [self setupTableView];
}

- (void)setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [_tableView registerClass:[TCSettingCell class] forCellReuseIdentifier:CellIdentifier];
    _tableView.backgroundColor = TC_TABLE_BACK_COLOR;
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"语言";
            cell.detailTextLabel.text = @"中文";
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"数据";
        }
    }
 
    return cell;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
