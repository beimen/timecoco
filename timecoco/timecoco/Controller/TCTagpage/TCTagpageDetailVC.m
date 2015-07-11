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
#import "SVProgressHUD.h"

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
        } else {
            NSString *status = [NSString stringWithFormat:@"你点击的是当前页的标签"];
            [SVProgressHUD setFont:[UIFont fontWithName:CUSTOM_FONT_NAME size:13]];
            [SVProgressHUD setForegroundColor:TC_RED_COLOR];
            [SVProgressHUD setBackgroundColor:TC_BACK_COLOR];
            [SVProgressHUD showInfoWithStatus:status maskType:SVProgressHUDMaskTypeNone];
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
    self.navigationItem.titleView = createTitleViewForTitleWithMaxWidth(searchedTag, TC_RED_COLOR, 17, SCREEN_WIDTH - 120);
    NSArray *array = [TCDatabaseManager dairyListWithTag:searchedTag];
    [self setDairyList:[array mutableCopy]];
}

@end
