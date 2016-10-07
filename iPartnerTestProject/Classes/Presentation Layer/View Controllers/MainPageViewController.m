//
//  MainPageViewController.m
//  iPartnerTestProject
//
//  Created by Tiran Saroyan on 05/10/2016.
//  Copyright © 2016 Tiran Saroyan. All rights reserved.
//

#import "MainPageViewController.h"
#import "EntryPreviewViewController.h"
#import "CreateNewEntryViewController.h"
#import "ServerService.h"
#import "EntryCell.h"
#import <SAMKeychain.h>
#import "Constant.h"

@interface MainPageViewController() <UITableViewDataSource, UITableViewDelegate, CreateNewEntryViewControllerDelegate>

@property (strong, nonatomic) NSArray *entries;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@end

@implementation MainPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.entries = [NSArray array];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self reloadData];
}

- (void)reloadData {
    [self.activityIndicatorView startAnimating];
    if ([SAMKeychain passwordForService:keychainService account:keychainAccount]) {
        [[ServerService sharedInstance] getEntriesWithCompletion:^(NSArray *entries, NSError *error) {
            [self.activityIndicatorView stopAnimating];
            if (!error) {
                self.entries = [entries firstObject];
                [self.tableView reloadData];
            } else {
                [self alertActionWithTitle:@"Something went wrong" andMessage:@"Please, check your internet connection."];
            }
        }];
    } else {
        [[ServerService sharedInstance] getNewSessionWithCompletion:^(NSString *session, NSError *error) {
            [SAMKeychain setPassword:session forService:keychainService account:keychainAccount];
            [[ServerService sharedInstance] getEntriesWithCompletion:^(NSArray *entries, NSError *error) {
                [self.activityIndicatorView stopAnimating];
                if (!error) {
                    self.entries = [entries firstObject];
                    [self.tableView reloadData];
                } else {
                    [self alertActionWithTitle:@"Something went wrong" andMessage:@"Please, check your internet connection."];
                }
            }];
        }];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"MainPageEntryPreview"]) {
        EntryPreviewViewController *entryPreviewVC = (EntryPreviewViewController *)segue.destinationViewController;
        [entryPreviewVC configureEntry:sender];
    } else if ([segue.identifier isEqualToString:@"MainPageCreateNewEntry"]) {
        CreateNewEntryViewController *createNewEntryVC = (CreateNewEntryViewController *)[((UINavigationController *)segue.destinationViewController).viewControllers firstObject];
        createNewEntryVC.delegate = self;
    }
}

#pragma mark - CreateNewEntryViewControllerDelegate

- (void)newEntryCreated {
    [self reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.entries.count ? : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EntryCell *entryCell = [self.tableView dequeueReusableCellWithIdentifier:EntryCellIdentifier];
    if (!entryCell) {
        entryCell = [[EntryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:EntryCellIdentifier];
    }
    
    NSDictionary *entry = [self.entries objectAtIndex:indexPath.row];
    [entryCell configureCellWithEntry:entry];
    
    return entryCell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"MainPageEntryPreview" sender:[self.entries objectAtIndex:indexPath.row]];
}

#pragma mark - Alert

- (void)alertActionWithTitle:(NSString *) title andMessage:(NSString *) message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Reload Data" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
        [self reloadData];
    }];
    
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
