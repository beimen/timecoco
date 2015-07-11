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
#import "DHSmartScreenshot.h"

@interface TCTagpageDetailVC ()

@property (nonatomic, strong) TCDairyTable *tableView;
@property (nonatomic, strong) NSMutableArray *dairyList;

@end

@implementation TCTagpageDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBarButtons];

    [self.tableView setDairyList:self.dairyList];
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    NSLog(@"TCTagpageDetailVC deallocated.");
}

#pragma mark - NavigationBar Buttons & Methods

- (void)setupNavigationBarButtons {
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem createBarButtonItemWithImage:[UIImage imageNamed:@"button_back"]
                                                                                   target:self
                                                                                 selector:@selector(backAction:)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem createBarButtonItemWithTitle:@"生成图片"
                                                                                    target:self
                                                                                  selector:@selector(screenShotAction:)];
}

- (void)backAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)screenShotAction:(UIBarButtonItem *)sender {
    UIImage *screenShot = [self.tableView screenshot];
    NSData *imageData = UIImagePNGRepresentation(screenShot);
    UIImage *pngScreenShot = [UIImage imageWithData:imageData];
    UIImageWriteToSavedPhotosAlbum(pngScreenShot, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error != NULL) {
    } else {
        NSLog(@"成功");
    }
}

#pragma mark - Setter & Getter

- (void)setDairyList:(NSMutableArray *)dairyList {
    _dairyList = dairyList;
}

- (void)setSearchedTag:(NSString *)searchedTag {
    _searchedTag = searchedTag;
    NSArray *array = [TCDatabaseManager dairyListWithTag:searchedTag];
    [self setDairyList:[array mutableCopy]];
    NSString *subtitle = [NSString stringWithFormat:@"共 %lu 项", (unsigned long) [self.dairyList count]];
    self.navigationItem.titleView = createTitleViewForTitleWithMaxWidth(searchedTag, subtitle, TC_RED_COLOR, 17, SCREEN_WIDTH - 120);
}

- (TCDairyTable *)tableView {
    if (_tableView == nil) {
        _tableView = [[TCDairyTable alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.tableOption = TCDairyTableOptionShowMonth;

        __weak typeof(TCTagpageDetailVC) *weakSelf = self;
        [_tableView setTapTagBlock:^(NSString *tag) {
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
    }
    return _tableView;
}

@end
