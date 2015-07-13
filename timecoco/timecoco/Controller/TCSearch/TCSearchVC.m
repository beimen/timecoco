//
//  TCSearchVC.m
//  timecoco
//
//  Created by Xie Hong on 7/12/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import "TCSearchVC.h"
#import "TCDairyTable.h"
#import "TCSpecifiedDataVC.h"
#import "SVProgressHUD.h"

@interface TCSearchVC () <UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) TCDairyTable *tableView;

@end

@implementation TCSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TC_BACK_COLOR;
    [self updateTitleWithCount:nil];
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.tableView];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dismissKeyboard)
                                                 name:NOTIFICATION_TABLEVIEW_BEGIN_DRAGGING
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([self.tableView.dairyList count] == 0) {
        [self.searchBar performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.35f];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    NSLog(@"TCSearchVC is deallocated.");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Lazy Loading

- (UISearchBar *)searchBar {
    if (_searchBar == nil) {
        self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 40)];
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchBar.delegate = self;
        _searchBar.tintColor = TC_RED_COLOR;
    }
    return _searchBar;
}

- (TCDairyTable *)tableView {
    if (_tableView == nil) {
        self.tableView = [[TCDairyTable alloc] initWithFrame:CGRectMake(0, self.searchBar.bottom, self.view.width, self.view.height - self.searchBar.bottom) style:UITableViewStyleGrouped];
        _tableView.tableOption = TCDairyTableOptionShowMonth;
        __weak typeof(TCSearchVC) *weakSelf = self;
        [_tableView setTapTagBlock:^(NSString *tag) {
            TCSpecifiedDataVC *vc = [[TCSpecifiedDataVC alloc] init];
            vc.searchedTag = tag;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
        [_tableView setHeaderDateBlock:^(TCDairyModel *dairy) {
            TCSpecifiedDataVC *vc = [[TCSpecifiedDataVC alloc] init];
            vc.searchDairy = dairy;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _tableView;
}

#pragma mark - Actions

- (void)updateTitleWithCount:(NSNumber *)count {
    if (count == nil) {
        self.navigationItem.titleView = createTitleViewForTitleWithMaxWidth(@"搜索", @"请输入关键字", TC_RED_COLOR, 15, MAXFLOAT);
    } else {
        NSString *subTitle = [NSString stringWithFormat:@"共 %@ 项", count];
        self.navigationItem.titleView = createTitleViewForTitleWithMaxWidth(@"搜索", subTitle, TC_RED_COLOR, 15, MAXFLOAT);
    }
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText length]) {
        NSArray *resultArray = [TCDatabaseManager dairyListWithKeyword:searchText];
        if ([resultArray count] == 0) {
            [SVProgressHUD setFont:[UIFont fontWithName:CUSTOM_FONT_NAME size:13]];
            [SVProgressHUD setForegroundColor:TC_RED_COLOR];
            [SVProgressHUD setBackgroundColor:TC_BACK_COLOR];
            [SVProgressHUD showInfoWithStatus:@"无记录" maskType:SVProgressHUDMaskTypeClear];
        }
        self.tableView.dairyList = [resultArray mutableCopy];
        [self updateTitleWithCount:@([resultArray count])];
        [self.tableView reloadData];
    } else {
        self.tableView.dairyList = nil;
        [self updateTitleWithCount:nil];
        [self.tableView reloadData];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {
    [self dismissKeyboard];
}

@end
