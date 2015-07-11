//
//  TCTagpageDetailVC.m
//  timecoco
//
//  Created by Xie Hong on 7/10/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import "TCTagpageDetailVC.h"
#import "TCDairyTable.h"
#import "NSDateFormatter+Custom.h"

@interface TCTagpageDetailVC ()

@property (nonatomic, strong) TCDairyTable *tableView;
@property (nonatomic, strong) NSMutableArray *dairyList;

@end

@implementation TCTagpageDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem createBarButtonItemWithImage:[UIImage imageNamed:@"button_back"]
                                                                                   Target:self
                                                                                 Selector:@selector(backAction:)];
    self.tableView = [[TCDairyTable alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.tableOption = TCDairyTableOptionShowMonth;

    __weak typeof(TCTagpageDetailVC) *weakSelf = self;
    [self.tableView setTapTagBlock:^(NSString *tag) {
        assert(tag.length);
        if (![weakSelf.searchedTag isEqualToString:tag]) {
            TCTagpageDetailVC *vc = [[TCTagpageDetailVC alloc] init];
            vc.searchedTag = tag;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    }];

    [self.tableView setDairyList:self.dairyList];
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    NSLog(@"TCTagpageDetailVC deallocated.");
}

- (void)backAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Setter & Getter

- (void)setDairyList:(NSMutableArray *)dairyList {
    _dairyList = dairyList;
}

- (void)setSearchedTag:(NSString *)searchedTag {
    _searchedTag = searchedTag;
    self.navigationItem.titleView = createTitleViewForTitle(searchedTag, TC_RED_COLOR, 17);
    NSArray *array = [TCDatabaseManager dairyListWithTag:searchedTag];
    [self setDairyList:[array mutableCopy]];
}

@end
