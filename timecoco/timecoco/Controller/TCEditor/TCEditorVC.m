//
//  TCEditorVC.m
//  timecoco
//
//  Created by Xie Hong on 3/15/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import "TCEditorVC.h"

@interface TCEditorVC () <UITextViewDelegate>

@property (nonatomic, weak) UIView *lineView;
@property (nonatomic, weak) UITextView *textView;

@end

@implementation TCEditorVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TC_BACK_COLOR;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem createBarButtonItemWithImage:[UIImage imageNamed:@"button_back"] Target:self Selector:@selector(backAction:)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem createBarButtonItemWithImages:@[ [UIImage imageNamed:@"button_confirm"], [UIImage imageNamed:@"button_confirm_disable"] ] Target:self Selector:@selector(confirmAction:)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self setUpUI];
    self.textView.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.textView becomeFirstResponder];
}

- (void)dealloc {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation action

- (void)backAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)confirmAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UI

- (void)setUpUI {
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.navigationController.navigationBar.frame) + 10, self.view.frame.size.width - 20, self.view.bounds.size.height / 3)];
    lineView.backgroundColor = TC_WHITE_COLOR;
    lineView.layer.borderColor = TC_RED_COLOR.CGColor;
    lineView.layer.borderWidth = 1.0f;
    [self.view addSubview:lineView];
    self.lineView = lineView;
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(5 + 10, 5 + CGRectGetMaxY(self.navigationController.navigationBar.frame) + 10, self.lineView.frame.size.width - 10, self.lineView.frame.size.height - 10)];
    textView.backgroundColor = TC_WHITE_COLOR;
    textView.textColor = TC_DARK_GRAY_COLOR;
    textView.font = [UIFont systemFontOfSize:16.0f];
    [self.view addSubview:textView];
    self.textView = textView;
}

#pragma mark - UITextView Delegate

- (void)textViewDidChange:(UITextView *)textView {
    self.navigationItem.rightBarButtonItem.enabled = [self isNotEmpty:textView.text];
}

- (BOOL)isNotEmpty:(NSString *)string {
    //去除两端的空格之类的东西
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *stringTrans = [string stringByTrimmingCharactersInSet:whitespace];
    //去除中间的空格
    stringTrans = [stringTrans stringByReplacingOccurrencesOfString:@" " withString:@""];
    return stringTrans.length;
}

@end
