//
//  TCEditorVC.m
//  timecoco
//
//  Created by Xie Hong on 3/15/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import "TCEditorVC.h"

@interface TCEditorVC ()

@end

@implementation TCEditorVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem createBarButtonItemWithImage:[UIImage imageNamed:@"button_back"] Target:self Selector:@selector(backAction:)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem createBarButtonItemWithImages:@[[UIImage imageNamed:@"button_confirm"], [UIImage imageNamed:@"button_confirm_disable"]] Target:self Selector:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation action

- (void)backAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
