//
//  CreateNewEntryViewController.m
//  iPartnerTestProject
//
//  Created by Tiran Saroyan on 07/10/2016.
//  Copyright © 2016 Tiran Saroyan. All rights reserved.
//

#import "CreateNewEntryViewController.h"
#import "ServerService.h"
#import "Constant.h"

@interface CreateNewEntryViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *entryTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *entryTextViewBottomConstraint;

@end

@implementation CreateNewEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.entryTextView.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.entryTextView becomeFirstResponder];
}

#pragma mark - Actions

- (IBAction)saveAction:(UIBarButtonItem *)sender {
    NSString *entry = [self.entryTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (entry.length == 0) {
        [self alertActionWithTitle:@"Sorry" andMessage:@"Entry cant be empty."];
    } else {
        [[ServerService sharedInstance] addEntry:entry withCompletion:^(NSString *entryId, NSError *error) {
            if (!error) {
                [self.delegate newEntryCreated];
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            } else {
                [self alertActionWithTitle:@"Something went wrong" andMessage:@"Entry didn't save!"];
            }
        }];
    }
}

- (IBAction)cancelAction:(UIBarButtonItem *)sender {
    [self.entryTextView resignFirstResponder];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *changedText = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger charachtersLeft = maxEntryCharachtersCount - changedText.length;
    if (charachtersLeft > 0) {
        return YES;
    } else {
        return NO;
    }
    
}

#pragma mark - UIKeyboardNotification

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    self.entryTextViewBottomConstraint.constant = 20+keyboardSize.height;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.entryTextViewBottomConstraint.constant = 20;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - Alert

- (void)alertActionWithTitle:(NSString *) title andMessage:(NSString *) message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                         }];
    
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
