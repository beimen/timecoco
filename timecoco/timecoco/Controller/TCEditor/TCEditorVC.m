//
//  TCEditorVC.m
//  timecoco
//
//  Created by Xie Hong on 3/15/15.
//  Copyright (c) 2015 timecoco. All rights reserved.
//

#import "TCEditorVC.h"

@interface TCEditorVC () <UITextViewDelegate>

@property (nonatomic, weak) UITextView *textView;
@property (nonatomic, assign) TCDairyType dairyType;

@end

@implementation TCEditorVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = TC_BACK_COLOR;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem createBarButtonItemWithImage:[UIImage imageNamed:@"button_back"]
                                                                                   target:self
                                                                                 selector:@selector(backAction:)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem createBarButtonItemWithImages:@[ [UIImage imageNamed:@"button_confirm"],
                                                                                               [UIImage imageNamed:@"button_confirm_disable"] ]
                                                                                     target:self
                                                                                   selector:@selector(confirmAction:)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self setupUI];
    self.textView.delegate = self;
    self.dairyType = TCDairyTypeNormal;
    if (self.type == TCEditorVCTypeEdit) {
        self.textView.text = self.editDairy.content;
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.view endEditing:YES];
    [self.textView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
    NSLog(@"TCEditorVC deallocated.");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation action

- (void)backAction:(UIBarButtonItem *)sender {
    if ([self isNotEmpty:self.textView.text] && self.type == TCEditorVCTypeAdd) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                       message:@"当前有内容，是否确定退出？"
                                                                preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction *action){
                                                             }];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确认"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction *action) {
                                                                  [self.navigationController popToRootViewControllerAnimated:YES];
                                                              }];

        [alert addAction:cancelAction];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)confirmAction:(UIBarButtonItem *)sender {
    [self.view endEditing:YES];
    if (self.type == TCEditorVCTypeAdd) {
        [self addDairy];
    } else if (self.type == TCEditorVCTypeEdit) {
        if (![self isNotEmpty:self.textView.text]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                           message:@"当前没有任何有效内容，是要删除该记录吗？"
                                                                    preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                                   style:UIAlertActionStyleCancel
                                                                 handler:^(UIAlertAction *action){
                                                                 }];
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确认"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction *action) {
                                                                      [self removeDairy];
                                                                  }];

            [alert addAction:cancelAction];
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                           message:@"确定要这么编辑吗？"
                                                                    preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                                   style:UIAlertActionStyleCancel
                                                                 handler:^(UIAlertAction *action){
                                                                 }];
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确认"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction *action) {
                                                                      [self replaceDairy];
                                                                  }];

            [alert addAction:cancelAction];
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

#pragma mark - Dairy Actions

- (void)addDairy {
    TCDairyModel *dairy = [TCDairyModel new];
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
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)removeDairy {
    [TCDatabaseManager removeDairy:self.editDairy];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)replaceDairy {
    TCDairyModel *dairy = self.editDairy;
    dairy.content = [self stringDeleteSideWhite:self.textView.text];

    if (dairy.content.length > 1000) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                       message:@"字数不能超过1000个字。"
                                                                preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确认"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction *action){
                                                              }];

        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        [TCDatabaseManager replaceDairy:dairy];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - UI

- (void)setupUI {
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10 + self.navigationController.navigationBar.bottom, self.view.width - 20, self.view.height - 20 - self.navigationController.navigationBar.bottom)];
    textView.backgroundColor = TC_WHITE_COLOR;
    textView.textColor = TC_DARK_GRAY_COLOR;
    textView.font = [UIFont fontWithName:CUSTOM_FONT_NAME size:16.0f];
    textView.layer.borderColor = TC_RED_COLOR.CGColor;
    textView.layer.borderWidth = 1.0f;
    textView.layoutManager.allowsNonContiguousLayout = NO;
    textView.tintColor = TC_RED_COLOR;
    [self.view addSubview:textView];
    self.textView = textView;
}

#pragma mark - UITextView Delegate

- (void)textViewDidChange:(UITextView *)textView {
    if (self.type == TCEditorVCTypeAdd) {
        self.navigationItem.rightBarButtonItem.enabled = [self isNotEmpty:textView.text];
    } else if (self.type == TCEditorVCTypeEdit) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    CGPoint cursorPosition = [textView caretRectForPosition:textView.selectedTextRange.start].origin;

    [textView scrollRectToVisible:CGRectMake(cursorPosition.x, cursorPosition.y, 1, 16.0f + 10.0f) animated:YES];
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

@end
