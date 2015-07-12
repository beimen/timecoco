//
//  TCSpecifiedDataVC.m
//  timecoco
//
//  Created by Xie Hong on 7/10/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import "TCSpecifiedDataVC.h"
#import "TCDairyTable.h"
#import "NSDateFormatter+Custom.h"
#import "SVProgressHUD.h"
#import "DHSmartScreenshot.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface TCSpecifiedDataVC ()

@property (nonatomic, strong) TCDairyTable *tableView;
@property (nonatomic, strong) NSMutableArray *dairyList;

@end

@implementation TCSpecifiedDataVC

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
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];

    if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied) {
        [self showNeedsAlbumAuthorizationAlert];
    } else {
        [self showSaveScreenShotAlert];
    }
}

- (void)showNeedsAlbumAuthorizationAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"保存图片需要相册的授权"
                                                                   message:@"请进入“设置”->“隐私”->“相册”中开启授权。"
                                                            preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确认"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action){
                                                          }];

    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showSaveScreenShotAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"这个步骤可能需要一些时间"
                                                                   message:@"确定要生成图片，并保存到相册吗？"
                                                            preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *action){
                                                         }];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确认"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {
                                                              [self saveScreenShot];
                                                          }];

    [alert addAction:cancelAction];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)saveScreenShot {
    [SVProgressHUD setFont:[UIFont fontWithName:CUSTOM_FONT_NAME size:13]];
    [SVProgressHUD setForegroundColor:TC_RED_COLOR];
    [SVProgressHUD setBackgroundColor:TC_BACK_COLOR];
    [SVProgressHUD showWithStatus:@"保存中" maskType:SVProgressHUDMaskTypeClear];
    //保存图片需要大量的计算资源，会影响到SVProgressHUD的显示，因此将其放在后台线程中处理
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *screenShot = [self.tableView screenshot];
        NSData *imageData = UIImagePNGRepresentation(screenShot);
        UIImage *pngScreenShot = [UIImage imageWithData:imageData];
        UIImageWriteToSavedPhotosAlbum(pngScreenShot, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error != NULL) {
        [SVProgressHUD showErrorWithStatus:@"出错了！"];
    } else {
        [SVProgressHUD showSuccessWithStatus:@"保存成功！"];
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
    self.navigationItem.titleView = createTitleViewForTitleWithMaxWidth(searchedTag, subtitle, TC_RED_COLOR, 15, SCREEN_WIDTH - 120);
}

- (void)setSearchDairy:(TCDairyModel *)searchDairy {
    _searchDairy = searchDairy;
    NSArray *dairyList = [TCDatabaseManager sameDayDairyListWithDairy:searchDairy];
    [self setDairyList:[dairyList mutableCopy]];

    NSDate *date = [NSDate dateWithTimeIntervalSince1970:searchDairy.pointTime];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    [formatter setDateFormat:@"YYYY年MM月dd日"];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:searchDairy.timeZoneInterval]];

    NSString *subtitle = [NSString stringWithFormat:@"共 %lu 项", (unsigned long) [self.dairyList count]];
    self.navigationItem.titleView = createTitleViewForTitleWithMaxWidth([formatter stringFromDate:date], subtitle, TC_RED_COLOR, 15, SCREEN_WIDTH - 120);
}

- (TCDairyTable *)tableView {
    if (_tableView == nil) {
        _tableView = [[TCDairyTable alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.tableOption = TCDairyTableOptionShowMonth;

        __weak typeof(TCSpecifiedDataVC) *weakSelf = self;
        [_tableView setTapTagBlock:^(NSString *tag) {
            assert(tag.length);
            if (![weakSelf.searchedTag isEqualToString:tag]) {
                TCSpecifiedDataVC *vc = [[TCSpecifiedDataVC alloc] init];
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

        [_tableView setHeaderDateBlock:^(TCDairyModel *dairy) {
            __strong typeof(TCSpecifiedDataVC) *strongSelf = weakSelf;
            if ([strongSelf.searchedTag length]) {
                TCSpecifiedDataVC *vc = [[TCSpecifiedDataVC alloc] init];
                vc.searchDairy = dairy;
                [strongSelf.navigationController pushViewController:vc animated:YES];
            }
        }];
    }
    return _tableView;
}

@end
