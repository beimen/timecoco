//
//  TCDairyTable.m
//  timecoco
//
//  Created by Xie Hong on 7/11/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import "TCDairyTable.h"
#import "TCHomepageCell.h"
#import "TCHomepageHeader.h"
#import "TCHomepageFooter.h"
#import "NSDateFormatter+Custom.h"
#import "TCDairyManager.h"

#define CellIdentifier (@"TCHomepgeCell")
#define CellHeaderIdentifier (@"TCHomepageHeader")
#define CellFooterIdentifier (@"TCHomepageFooter")

static CGFloat cellHeaderHeight = 30.0f;
static CGFloat cellFooterHeight = 10.0f;

@interface TCDairyTable () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *dairyListDateIndex;

@end

@implementation TCDairyTable

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.allowsSelection = NO;
    self.scrollsToTop = NO;
    self.backgroundColor = TC_BACK_COLOR;
    self.delaysContentTouches = YES;
    self.canCancelContentTouches = YES;
    self.delegate = self;
    self.dataSource = self;
    [self registerClass:[TCHomepageCell class] forCellReuseIdentifier:CellIdentifier];
    [self registerClass:[TCHomepageHeader class] forHeaderFooterViewReuseIdentifier:CellHeaderIdentifier];
    [self registerClass:[TCHomepageFooter class] forHeaderFooterViewReuseIdentifier:CellFooterIdentifier];
}

#pragma mark - Setter & Getter

- (void)setDairyList:(NSMutableArray *)dairyList {
    _dairyList = dairyList;
    [self updateTableView];
}

- (void)updateTableView {
    self.dairyListDateIndex = [TCDairyManager generateDateIndexFromDairyList:_dairyList];
    [self reloadData];
}

- (NSInteger)getDairySumBeforeSection:(NSUInteger)section {
    return [TCDairyManager getDairySumBeforeSection:section withDateIndex:self.dairyListDateIndex];
}

#pragma mark - UITableViewDelegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dairyListDateIndex.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.dairyListDateIndex objectAtIndex:section] intValue];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCDairyModel *dairy = [self.dairyList objectAtIndex:([self getDairySumBeforeSection:indexPath.section] + indexPath.row)];

    return [TCHomepageCell cellHeightWithDairy:dairy];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return cellHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return cellFooterHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCHomepageCell *cell = (TCHomepageCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    cell.dairy = [self.dairyList objectAtIndex:([self getDairySumBeforeSection:indexPath.section] + indexPath.row)];

    __weak typeof(TCDairyTable) *weakSelf = self;
    if (self.tapTagBlock) {
        [cell setTapTagBlock:weakSelf.tapTagBlock];
    }
    if (self.longPressBlock) {
        [cell setLongPressBlock:weakSelf.longPressBlock];
    }

    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TCHomepageHeader *header = (TCHomepageHeader *) [tableView dequeueReusableHeaderFooterViewWithIdentifier:CellHeaderIdentifier];

    if (section) {
        header.lastDairy = [self.dairyList objectAtIndex:[self getDairySumBeforeSection:section] - 1];
    } else {
        header.lastDairy = nil;
    }

    if (self.tableOption | TCDairyTableOptionShowMonth) {
        header.showMonth = YES;
    }

    header.yearNowValue = [[NSDateFormatter customYearFormatter] stringFromDate:[NSDate date]].integerValue;
    header.dairy = [self.dairyList objectAtIndex:[self getDairySumBeforeSection:section]];

    __weak typeof(TCDairyTable) *weakSelf = self;
    [header setDoubleTapBlock:weakSelf.headerDateBlock];

    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    TCHomepageFooter *footer = (TCHomepageFooter *) [tableView dequeueReusableHeaderFooterViewWithIdentifier:CellFooterIdentifier];

    footer.dairy = [self.dairyList objectAtIndex:[self getDairySumBeforeSection:section]];

    return footer;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TABLEVIEW_BEGIN_DRAGGING object:nil];
}

#pragma mark - UITableViewDataSource Methods

@end
