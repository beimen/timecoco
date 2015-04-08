//
//  TCBackUpVC.m
//  timecoco
//
//  Created by Xie Hong on 4/2/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import "TCBackUpVC.h"

@interface TCBackUpVC ()

@end

@implementation TCBackUpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TC_BACK_COLOR;
    self.navigationItem.titleView = createTitleViewForTitle(@"备份", TC_RED_COLOR, 17);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
