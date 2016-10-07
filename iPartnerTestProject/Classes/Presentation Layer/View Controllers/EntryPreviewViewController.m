//
//  EntryPreviewViewController.m
//  iPartnerTestProject
//
//  Created by Tiran Saroyan on 07/10/2016.
//  Copyright © 2016 Tiran Saroyan. All rights reserved.
//

#import "EntryPreviewViewController.h"

@interface EntryPreviewViewController ()

@property (weak, nonatomic) IBOutlet UILabel *entryLabel;

@property (strong, nonatomic) NSDictionary *entry;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation EntryPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"H:mm, d MMM";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.entryLabel.text = [self.entry objectForKey:@"body"];
    self.title = [self.dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[self.entry objectForKey:@"da"] floatValue]]];
}

- (void)configureEntry:(NSDictionary *)dictionary {
    self.entry = dictionary;
}

@end
