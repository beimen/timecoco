//
//  TCSearchVC.m
//  timecoco
//
//  Created by Xie Hong on 7/12/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import "TCSearchVC.h"

@interface TCSearchVC ()

@end

@implementation TCSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TC_BACK_COLOR;
    self.navigationItem.titleView = createTitleViewForTitle(@"搜索", TC_RED_COLOR, 17);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
