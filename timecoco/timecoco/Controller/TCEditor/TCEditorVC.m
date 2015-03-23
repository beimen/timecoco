//
//  TCEditorVC.m
//  timecoco
//
//  Created by Xie Hong on 3/15/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import "TCEditorVC.h"

#define ALERT_TAG_TCEDITOR (12)

@interface TCEditorVC () <UITextViewDelegate, UIAlertViewDelegate>

@property (nonatomic, weak) UIView *lineView;
@property (nonatomic, weak) UITextView *textView;
@property (nonatomic, assign) TCDairyType dairyType;

@end

@implementation TCEditorVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = TC_BACK_COLOR;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem createBarButtonItemWithImage:[UIImage imageNamed:@"button_back"]
                                                                                   Target:self
                                                                                 Selector:@selector(backAction:)];
    self.navigationItem.rightBarButtonItems = @[ [UIBarButtonItem createBarButtonItemWithImages:@[ [UIImage imageNamed:@"button_confirm"],
                                                                                                   [UIImage imageNamed:@"button_confirm_disable"] ]
                                                                                         Target:self
                                                                                       Selector:@selector(confirmAction:)] ];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self setUpUI];
    self.textView.delegate = self;
    self.dairyType = TCDairyTypeNormal;
    [self.textView becomeFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (keyboardRect.size.height) {
        self.textView.height = self.view.height - keyboardRect.size.height - self.navigationController.navigationBar.bottom - 20;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"TCEditor dealloated.");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation action

- (void)backAction:(UIBarButtonItem *)sender {
    if ([self isNotEmpty:self.textView.text]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"当前有内容，是否确定退出。"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确认", nil];
        alertView.tag = ALERT_TAG_TCEDITOR;
        [alertView show];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)confirmAction:(UIBarButtonItem *)sender {
    TCDairy *dairy = [TCDairy new];
    dairy.timeZoneInterval = [[NSTimeZone localTimeZone] secondsFromGMT];
    dairy.type = self.dairyType;
    if (self.dairyType == TCDairyTypeNormal) {
        dairy.pointTime = [[NSDate date] timeIntervalSince1970];
    } else {
        dairy.pointTime = (((NSInteger)[[NSDate date] timeIntervalSince1970] + dairy.timeZoneInterval) / T_DAY) * T_DAY - dairy.timeZoneInterval;
    }
    dairy.content = [self stringDeleteSideWhite:self.textView.text];

    if (dairy.content.length > 1000) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"字数不能超过1000个字。"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确认"
                                                  otherButtonTitles:nil];
        [alertView show];
    } else {
        [TCDatabaseManager addDairy:dairy];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ADD_DAIRY_SUCCESS object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UI

- (void)setUpUI {
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10 + self.navigationController.navigationBar.bottom, self.view.width - 20, 100)];
    textView.backgroundColor = TC_WHITE_COLOR;
    textView.textColor = TC_DARK_GRAY_COLOR;
    textView.font = [UIFont systemFontOfSize:16.0f];
    textView.layer.borderColor = TC_RED_COLOR.CGColor;
    textView.layer.borderWidth = 1.0f;
    [self.view addSubview:textView];
    self.textView = textView;
}

#pragma mark - UITextView Delegate

- (void)textViewDidChange:(UITextView *)textView {
    self.navigationItem.rightBarButtonItem.enabled = [self isNotEmpty:textView.text];
}

#pragma mark - NSString method

- (NSString *)stringDeleteSideWhite:(NSString *)string {
    //去除两端的空格之类的东西
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *stringTrans = [string stringByTrimmingCharactersInSet:whitespace];
    return stringTrans;
}

- (BOOL)isNotEmpty:(NSString *)string {
    //去除中间的空格
    NSString *stringTrans = [self stringDeleteSideWhite:string];
    stringTrans = [stringTrans stringByReplacingOccurrencesOfString:@" " withString:@""];
    return stringTrans.length;
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == ALERT_TAG_TCEDITOR) {
        if (buttonIndex == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            return;
        }
    }
}

@end
