//
//  TCHomepageVC.m
//  timecoco
//
//  Created by Hong Xie on 9/3/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import "TCHomepageVC.h"
#import "TCHomepageCell.h"
#import "TCHomepageHeader.h"
#import "TCHomepageFooter.h"
#import "TCEditorVC.h"

#define CellIdentifier (@"TCHomepgeCell")
#define CellHeaderIdentifier (@"TCHomepageHeader")
#define CellFooterIdentifier (@"TCHomepageFooter")

@interface TCHomepageVC ()

@property (nonatomic, strong) NSMutableArray *dairyList;
@property (nonatomic, copy) NSMutableArray *dairyListDateIndex;
@property (nonatomic, assign) BOOL firstAppear;
@property (nonatomic, assign) NSInteger yearNowValue;
@property (nonatomic, assign) NSUInteger firstDiffIndex;
@property (nonatomic, strong) UILabel *introLabel;
@property (nonatomic, assign) BOOL didAppear;

@end

@implementation TCHomepageVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.firstAppear = YES;
        self.didAppear = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TC_RED_COLOR;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem createBarButtonItemWithImage:[UIImage imageNamed:@"button_add"]
                                                                                    Target:self
                                                                                  Selector:@selector(addAction:)];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
    self.tableView.scrollsToTop = NO;
    //    self.tableView.delaysContentTouches = NO;
    self.tableView.backgroundColor = TC_BACK_COLOR;
    [self.tableView registerClass:[TCHomepageCell class] forCellReuseIdentifier:CellIdentifier];
    [self.tableView registerClass:[TCHomepageHeader class] forHeaderFooterViewReuseIdentifier:CellHeaderIdentifier];
    [self.tableView registerClass:[TCHomepageFooter class] forHeaderFooterViewReuseIdentifier:CellFooterIdentifier];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self refreshYearNowValue];

    NSArray *lastDairyList = [NSArray arrayWithArray:self.dairyList];

    NSUInteger diffListIndex = [[self getDairyListData] findFirstDiffDairyIndex:lastDairyList];

    self.dairyList = [self getDairyListData];
    self.dairyListDateIndex = [self generateDateIndex];
    NSIndexPath *diffDairyIndexPath = [self getDiffDairyIndexPathWithListIndex:diffListIndex];

    NSLog(@"action section is %ld, row is %ld", (long) diffDairyIndexPath.section, (long) diffDairyIndexPath.row);
    if ([self.dairyList count] == [lastDairyList count]) {
        //编辑
        [self.tableView scrollToRowAtIndexPath:diffDairyIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        [self.tableView reloadData];
    } else if ([self.dairyList count] > [lastDairyList count]) {
        //添加
        [self.tableView reloadData];
        [self.tableView scrollToRowAtIndexPath:diffDairyIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    } else if ([self.dairyList count] < [lastDairyList count]) {
        //删除
        [self.tableView scrollToRowAtIndexPath:diffDairyIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        [self.tableView reloadData];
    }

    if (self.firstAppear && self.dairyList.count) {
        self.firstAppear = NO;
        [self scrollToLastDairy];
    }
    
    self.didAppear = YES;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (self.didAppear) {
        if ([self.dairyList count] == 0) {
            self.introLabel.hidden = NO;
        } else {
            self.introLabel.hidden = YES;
        }
    }
}

- (NSIndexPath *)getDiffDairyIndexPathWithListIndex:(NSUInteger)listIndex {
    __block NSIndexPath *indexPath;
    __block NSUInteger sum = 0;
    __block NSUInteger lastRowCount = 0;
    [self.dairyListDateIndex enumerateObjectsUsingBlock:^(NSNumber *rowCount, NSUInteger section, BOOL *stop) {
        sum += rowCount.integerValue;
        lastRowCount = rowCount.unsignedIntegerValue;
        if ((listIndex + 1) <= sum) {
            indexPath = [NSIndexPath indexPathForRow:(listIndex + lastRowCount - sum) inSection:section];
            *stop = YES;
        }
    }];
    return indexPath;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    NSLog(@"TCHomepageVC is deallocated");
}

#pragma mark - Navigationbar action

- (void)addAction:(UIBarButtonItem *)sender {
    TCEditorVC *vc = [[TCEditorVC alloc] init];
    vc.type = TCEditorVCTypeAdd;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - DairyList and DateIndex

- (NSMutableArray *)getDairyListData {
    //    return [TCDatabaseManager storedDairyListFromTime:[[NSDate date] timeIntervalSince1970]-T_WEEK toTime:[[NSDate date] timeIntervalSince1970]];
    return [NSMutableArray arrayWithArray:[TCDatabaseManager storedDairyList]];
}

- (NSMutableArray *)generateDateIndex {
    NSMutableArray *dateIndex = [NSMutableArray new];
    __block NSInteger lastDate = 0;
    __block NSInteger lastTimeZoneInterval = 0;
    [self.dairyList enumerateObjectsUsingBlock:^(TCDairy *dairy, NSUInteger idx, BOOL *stop) {
        NSInteger date = (NSInteger)(dairy.pointTime + dairy.timeZoneInterval) / T_DAY;
        if ([dateIndex lastObject] && (date == lastDate) && (lastTimeZoneInterval = dairy.timeZoneInterval)) {
            int lastDateCount = [[dateIndex lastObject] intValue];
            [dateIndex replaceObjectAtIndex:(dateIndex.count - 1) withObject:[NSNumber numberWithInteger:(lastDateCount + 1)]];
        } else {
            [dateIndex addObject:[NSNumber numberWithInteger:1]];
            lastDate = date;
            lastTimeZoneInterval = dairy.timeZoneInterval;
        }
    }];
    return dateIndex;
}

- (NSInteger)getDairyCountBeforeSection:(NSUInteger)section {
    __block NSInteger count = 0;
    [self.dairyListDateIndex enumerateObjectsUsingBlock:^(NSNumber *num, NSUInteger idx, BOOL *stop) {
        if (idx < section) {
            count += [num integerValue];
        } else {
            *stop = YES;
        }
    }];
    return count;
}

#pragma mark - Lazy Loading

- (UILabel *)introLabel {
    if (_introLabel == nil && ![self.dairyList count]) {
        self.introLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
        _introLabel.textColor = TC_RED_COLOR;
        _introLabel.font = [UIFont systemFontOfSize:15];
        _introLabel.text = @"还没有内容哦，\n请点击右上角添加记录。";
        _introLabel.textAlignment = NSTextAlignmentCenter;
        _introLabel.numberOfLines = 0;
        [self.tableView addSubview:_introLabel];
    }
    return _introLabel;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dairyListDateIndex.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.dairyListDateIndex objectAtIndex:section] intValue];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCDairy *dairy = [self.dairyList objectAtIndex:([self getDairyCountBeforeSection:indexPath.section] + indexPath.row)];

    return [self cellHeightWithContent:dairy.content];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCHomepageCell *cell = (TCHomepageCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    cell.dairy = [self.dairyList objectAtIndex:([self getDairyCountBeforeSection:indexPath.section] + indexPath.row)];

    __weak TCHomepageVC *weakSelf = self;
    [cell setLongPressBlock:^(TCDairy *dairy) {
        TCEditorVC *vc = [[TCEditorVC alloc] init];
        vc.type = TCEditorVCTypeEdit;
        vc.editDairy = dairy;
        if ([weakSelf.navigationController.topViewController isKindOfClass:[TCHomepageVC class]]) {
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    }];

    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TCHomepageHeader *header = (TCHomepageHeader *) [tableView dequeueReusableHeaderFooterViewWithIdentifier:CellHeaderIdentifier];

    if (section) {
        header.lastDairy = [self.dairyList objectAtIndex:[self getDairyCountBeforeSection:section] - 1];
    } else {
        header.lastDairy = nil;
    }

    header.yearNowValue = self.yearNowValue;
    header.dairy = [self.dairyList objectAtIndex:[self getDairyCountBeforeSection:section]];

    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    TCHomepageFooter *footer = (TCHomepageFooter *) [tableView dequeueReusableHeaderFooterViewWithIdentifier:CellFooterIdentifier];

    footer.dairy = [self.dairyList objectAtIndex:[self getDairyCountBeforeSection:section]];

    return footer;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)cellHeightWithContent:(NSString *)string {
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    NSDictionary *attrs = @{
        NSFontAttributeName : [UIFont systemFontOfSize:15],
        NSParagraphStyleAttributeName : style
    };
    CGRect rect = [string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 65, MAXFLOAT)
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:attrs
                                       context:nil];
    return ((rect.size.height > 65.0f) ? (int) rect.size.height / 5 * 5 + 15 : 65) + 10;
}

- (void)scrollToLastDairy {
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[[self.dairyListDateIndex lastObject] integerValue] - 1
                                                              inSection:self.dairyListDateIndex.count - 1]
                          atScrollPosition:UITableViewScrollPositionBottom
                                  animated:NO];
}

- (void)scrollToDairy:(NSUInteger)sectionIndex {
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[[self.dairyListDateIndex objectAtIndex:sectionIndex] integerValue] - 1
                                                              inSection:sectionIndex]
                          atScrollPosition:UITableViewScrollPositionBottom
                                  animated:NO];
}

- (void)refreshYearNowValue {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY"];
    self.yearNowValue = [formatter stringFromDate:[NSDate date]].integerValue;
}

@end
