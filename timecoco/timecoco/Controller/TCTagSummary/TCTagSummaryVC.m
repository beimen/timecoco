//
//  TCTagSummaryVC.m
//  timecoco
//
//  Created by Xie Hong on 5/20/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import "TCTagSummaryVC.h"
#import "TCDatabaseManager.h"
#import "TCTagItemModel.h"
#import "TCTagSummaryCell.h"
#import "TCSpecifiedDataVC.h"

@interface TCTagSummaryVC ()

@property (nonatomic, strong) NSMutableArray *tagArray;

@end

@implementation TCTagSummaryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = createTitleViewForTitle(@"标签", TC_RED_COLOR, 17);
    [self updateTagCountedSet];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
    self.tableView.backgroundColor = TC_TABLE_BACK_COLOR;
    [self.tableView registerClass:[TCTagSummaryCell class] forCellReuseIdentifier:@"reuseIdentifier"];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    NSLog(@"TCTagSummaryVC is deallocated");
}

#pragma mark - Update TagCountedSet

- (void)updateTagCountedSet {
    NSArray *allDairyArray = [TCDatabaseManager containHashKeyList];
    __block NSMutableArray *allTagArray = [NSMutableArray new];
    [allDairyArray enumerateObjectsUsingBlock:^(NSString *content, NSUInteger idx, BOOL *stop) {
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(#\\w+#)" options:0 error:nil];
        NSArray *matches = [regex matchesInString:content options:0 range:NSMakeRange(0, [content length])];
        [matches enumerateObjectsUsingBlock:^(NSTextCheckingResult *match, NSUInteger idx, BOOL *stop) {
            [allTagArray addObject:[content substringWithRange:match.range]];
        }];
    }];
    NSCountedSet *countedSet = [NSCountedSet setWithArray:allTagArray];
    NSMutableArray *tagArray = [NSMutableArray array];
    [countedSet enumerateObjectsUsingBlock:^(NSString *tagTitle, BOOL *stop) {
        TCTagItemModel *tagItem = [TCTagItemModel new];
        tagItem.title = tagTitle;
        tagItem.count = [countedSet countForObject:tagTitle];
        [tagArray addObject:tagItem];
    }];

    self.tagArray = [[tagArray sortedArrayUsingDescriptors:@[ [NSSortDescriptor sortDescriptorWithKey:@"count" ascending:NO] ]] mutableCopy];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tagArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCTagSummaryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    cell.tagItem = self.tagArray[indexPath.row];
    __weak typeof(TCTagSummaryVC) *weakSelf = self;
    [cell setTapTagBlock:^(NSString *tag) {
        assert(tag.length);
        TCSpecifiedDataVC *vc = [[TCSpecifiedDataVC alloc] init];
        vc.searchedTag = tag;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    return cell;
}

@end
