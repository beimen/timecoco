//
//  TCBackupVC.m
//  timecoco
//
//  Created by Xie Hong on 4/2/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import "TCBackupVC.h"

@interface TCBackupVC ()

@end

@implementation TCBackupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TC_BACK_COLOR;
    self.navigationItem.titleView = createTitleViewForTitle(@"备份", TC_RED_COLOR, 17);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
