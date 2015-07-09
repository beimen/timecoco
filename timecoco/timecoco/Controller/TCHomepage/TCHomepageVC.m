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
#import "NSDateFormatter+Custom.h"

#define CellIdentifier (@"TCHomepgeCell")
#define CellHeaderIdentifier (@"TCHomepageHeader")
#define CellFooterIdentifier (@"TCHomepageFooter")

static CGFloat cellHeaderHeight = 30.0f;
static CGFloat cellFooterHeight = 10.0f;

@interface TCHomepageVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dairyList;
@property (nonatomic, copy) NSMutableArray *dairyListDateIndex;
@property (nonatomic, assign) BOOL firstAppear;
@property (nonatomic, assign) NSInteger yearNowValue;
@property (nonatomic, assign) NSUInteger firstDiffIndex;
@property (nonatomic, strong) UILabel *introLabel;
@property (nonatomic, strong) NSString *navigationDateString;
@property (nonatomic, strong) UILabel *dateLabel;

@end

@implementation TCHomepageVC

+ (instancetype)sharedVC {
    static TCHomepageVC *shareVC;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareVC = [[TCHomepageVC alloc] init];
    });
    return shareVC;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.firstAppear = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TC_RED_COLOR;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem createBarButtonItemWithImage:[UIImage imageNamed:@"button_add"]
                                                                                    Target:self
                                                                                  Selector:@selector(addAction:)];

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
    self.tableView.scrollsToTop = NO;
    self.tableView.backgroundColor = TC_BACK_COLOR;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[TCHomepageCell class] forCellReuseIdentifier:CellIdentifier];
    [self.tableView registerClass:[TCHomepageHeader class] forHeaderFooterViewReuseIdentifier:CellHeaderIdentifier];
    [self.tableView registerClass:[TCHomepageFooter class] forHeaderFooterViewReuseIdentifier:CellFooterIdentifier];
    [self.view addSubview:self.tableView];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDairyListWithNotification:) name:NOTIFICATION_ADD_DAIRY_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDairyListWithNotification:) name:NOTIFICATION_REMOVE_DAIRY_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDairyListWithNotification:) name:NOTIFICATION_REPLACE_DAIRY_SUCCESS object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (self.firstAppear) {
        [self initDairyList];
        self.firstAppear = NO;
    }

    if ([self.dairyList count]) {
        [self.dateLabel setHidden:NO];
        if (self.dateLabel.alpha != 1.0f) {
            [self labelFadeIn];
        }
    }

    self.introLabel.hidden = [self.dairyList count];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.dateLabel setHidden:YES];
    [self.dateLabel setAlpha:0.0f];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"TCHomepageVC is deallocated");
}

#pragma mark - NavigationBar

- (void)addAction:(UIBarButtonItem *)sender {
    TCEditorVC *vc = [[TCEditorVC alloc] init];
    vc.type = TCEditorVCTypeAdd;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)updateNavigationBarDateLabel:(NSString *)detectionDateString {
    NSDate *currentDate = [NSDate date];
    NSString *currentDateString = [[NSDateFormatter customNormalFormatter] stringFromDate:currentDate];
    NSArray *detectionDateComponets = [detectionDateString componentsSeparatedByString:@"-"];
    NSArray *currentDateComponets = [currentDateString componentsSeparatedByString:@"-"];

    if ([detectionDateComponets[0] isEqualToString:currentDateComponets[0]]) {
        if ([detectionDateComponets[1] isEqualToString:currentDateComponets[1]]) {
            self.dateLabel.text = @"本月";
            [self labelFadeOut];
        } else {
            self.dateLabel.text = [NSString stringWithFormat:@"%@月", detectionDateComponets[1]];
            if (self.dateLabel.alpha == 0) {
                [self labelFadeIn];
            } else {
                [self.dateLabel setAlpha:1.0f];
            }
        }
    } else {
        self.dateLabel.text = [NSString stringWithFormat:@"%@\n%@月", detectionDateComponets[0], detectionDateComponets[1]];
    }
}

- (void)labelFadeIn {
    [self.dateLabel setAlpha:0.0f];
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        self.dateLabel.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [self labelFadeOut];
    }];
}

- (void)labelFadeOut {
    if ([self.dateLabel.text isEqualToString:@"本月"]) {
        [self.dateLabel setAlpha:1.0f];
        [UIView animateWithDuration:0.5f delay:1.0f options:UIViewAnimationOptionCurveLinear animations:^{
            self.dateLabel.alpha = 0.0f;
        } completion:^(BOOL finished) {
        }];
    }
}

#pragma mark - DairyList and DateIndex

- (NSMutableArray *)getDairyListData {
    return [NSMutableArray arrayWithArray:[TCDatabaseManager storedDairyList]];
}

- (NSMutableArray *)generateDateIndex {
    NSMutableArray *dateIndex = [NSMutableArray new];
    __block NSInteger lastDate = 0;
    __block NSInteger lastTimeZoneInterval = 0;
    [self.dairyList enumerateObjectsUsingBlock:^(TCDairy *dairy, NSUInteger idx, BOOL *stop) {
        NSInteger date = (NSInteger)(dairy.pointTime + dairy.timeZoneInterval) / T_DAY;
        if ([dateIndex lastObject] && (date == lastDate) && (lastTimeZoneInterval == dairy.timeZoneInterval)) {
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

- (NSInteger)getDairySumBeforeSection:(NSUInteger)section {
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

- (UILabel *)dateLabel {
    if (_dateLabel == nil) {
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.navigationController.navigationBar.height, self.navigationController.navigationBar.height)];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        _dateLabel.font = [UIFont systemFontOfSize:12];
        _dateLabel.textColor = TC_DARK_GRAY_COLOR;
        _dateLabel.backgroundColor = TC_CLEAR_COLOR;
        _dateLabel.numberOfLines = 0;
    }
    //这里可能需要修改，可能目前这种处理不是太好
    [self.navigationController.navigationBar addSubview:_dateLabel];
    return _dateLabel;
}

#pragma mark - Getter

- (NSInteger)yearNowValue {
    return [[NSDateFormatter customYearFormatter] stringFromDate:[NSDate date]].integerValue;
}

#pragma mark - Setter

- (void)setNavigationDateString:(NSString *)navigationDateString {
    if (![_navigationDateString isEqualToString:navigationDateString]) {
        _navigationDateString = navigationDateString;
        [self updateNavigationBarDateLabel:navigationDateString];
    }
}

#pragma mark - TableView Delegate & Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dairyListDateIndex.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.dairyListDateIndex objectAtIndex:section] intValue];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCDairy *dairy = [self.dairyList objectAtIndex:([self getDairySumBeforeSection:indexPath.section] + indexPath.row)];

    return [self cellHeightWithContent:dairy.content];
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

    __weak TCHomepageVC *weakSelf = self;
    [cell setLongPressBlock:^(TCDairy *dairy) {
        if ([weakSelf.navigationController.topViewController isKindOfClass:[TCHomepageVC class]]) {
            TCEditorVC *vc = [[TCEditorVC alloc] init];
            vc.type = TCEditorVCTypeEdit;
            vc.editDairy = dairy;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    }];

    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TCHomepageHeader *header = (TCHomepageHeader *) [tableView dequeueReusableHeaderFooterViewWithIdentifier:CellHeaderIdentifier];

    if (section) {
        header.lastDairy = [self.dairyList objectAtIndex:[self getDairySumBeforeSection:section] - 1];
    } else {
        header.lastDairy = nil;
    }

    header.yearNowValue = self.yearNowValue;
    header.dairy = [self.dairyList objectAtIndex:[self getDairySumBeforeSection:section]];

    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    TCHomepageFooter *footer = (TCHomepageFooter *) [tableView dequeueReusableHeaderFooterViewWithIdentifier:CellFooterIdentifier];

    footer.dairy = [self.dairyList objectAtIndex:[self getDairySumBeforeSection:section]];

    return footer;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Cell Height

- (CGFloat)cellHeightWithContent:(NSString *)string {
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    [style setMaximumLineHeight:18.0f];
    NSDictionary *attrs = @{
        NSFontAttributeName : [UIFont fontWithName:@"NotoSansCJKsc-DemiLight" size:15],
        NSParagraphStyleAttributeName : style
    };
    CGRect rect = [string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 65, MAXFLOAT)
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:attrs
                                       context:nil];
    return ((rect.size.height > 63.0f) ? (int) rect.size.height / 5 * 5 + 13 : 63) + 12;
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGRect rectInScreen = CGRectMake(0, self.navigationController.navigationBar.bottom - cellFooterHeight, SCREEN_WIDTH, SCREEN_HEIGHT - self.navigationController.navigationBar.bottom);
    CGRect rectInTableView = [self.view convertRect:rectInScreen toView:self.tableView];
    NSArray *dairyIndexPaths = [self.tableView indexPathsForRowsInRect:rectInTableView];
    NSInteger count = [dairyIndexPaths count];
    if (count) {
        NSIndexPath *dairyIndexPath = dairyIndexPaths[0];
        TCDairy *dairy = [self.dairyList objectAtIndex:([self getDairySumBeforeSection:dairyIndexPath.section] + dairyIndexPath.row)];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:(dairy.timeZoneInterval + dairy.pointTime)];
        self.navigationDateString = [[NSDateFormatter customFormatter] stringFromDate:date];
    }
}

#pragma mark - Other Method

- (void)scrollToLastDairyWithAnimated:(BOOL)animated {
    if ([self.dairyListDateIndex count]) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[[self.dairyListDateIndex lastObject] integerValue] - 1
                                                                  inSection:self.dairyListDateIndex.count - 1]
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:animated];
    }
}

- (void)scrollToDairy:(NSUInteger)sectionIndex {
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[[self.dairyListDateIndex objectAtIndex:sectionIndex] integerValue] - 1
                                                              inSection:sectionIndex]
                          atScrollPosition:UITableViewScrollPositionBottom
                                  animated:NO];
}

- (void)scrollToLastDairy {
    [self scrollToLastDairyWithAnimated:YES];
}

- (void)updateDairyListDataAndIndex {
    self.dairyList = [self getDairyListData];
    self.dairyListDateIndex = [self generateDateIndex];
}

- (void)initDairyList {
    [self updateDairyListDataAndIndex];
    [self.tableView reloadData];
    [self scrollToLastDairyWithAnimated:NO];
}

- (void)updateDairyListWithDictionary:(NSDictionary *)dictionary {
    __weak TCHomepageVC *weakSelf = self;
    __block BOOL animated = [[dictionary objectForKey:@"animated"] boolValue];
    __block BOOL scrollEnabled = [[dictionary objectForKey:@"scrollEnabled"] boolValue];
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf updateDairyListDataAndIndex];
        [weakSelf.tableView reloadData];
        if ([weakSelf.dairyList count]) {
            if (scrollEnabled) {
                if (animated) {
                    [weakSelf performSelector:@selector(scrollToLastDairy) withObject:nil afterDelay:0.5f];
                } else {
                    [weakSelf scrollToLastDairyWithAnimated:NO];
                }
            }
        }
    });
}

- (void)updateDairyListWithNotification:(NSNotification *)notification {
    if (notification == nil) {
        assert(0);
    } else {
        [self updateDairyListWithDictionary:notification.userInfo];
    }
}

@end
