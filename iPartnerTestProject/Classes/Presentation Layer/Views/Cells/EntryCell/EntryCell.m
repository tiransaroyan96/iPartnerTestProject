//
//  EntryCell.m
//  iPartnerTestProject
//
//  Created by Tiran Saroyan on 06/10/2016.
//  Copyright © 2016 Tiran Saroyan. All rights reserved.
//

#import "EntryCell.h"

@interface EntryCell()

@property (weak, nonatomic) IBOutlet UILabel *entryLabel;
@property (weak, nonatomic) IBOutlet UILabel *modifiedLabel;
@property (weak, nonatomic) IBOutlet UILabel *modifiedDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdDateLabel;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSString *entryId;

@end

@implementation EntryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"H:mm, d MMM";
}

- (void)configureCellWithEntry:(NSDictionary *)dictionary {
    NSString *entry = [dictionary objectForKey:@"body"];
    NSNumber *modifiedDate = [dictionary objectForKey:@"dm"];
    NSNumber *createdDate = [dictionary objectForKey:@"da"];
    NSString *entryId = [dictionary objectForKey:@"id"];
    
    self.entryLabel.text = entry;
    self.modifiedDateLabel.text = [self.dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[modifiedDate floatValue]]];
    self.createdDateLabel.text = [self.dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[createdDate floatValue]]];
    self.entryId = entryId;
    
    if ([modifiedDate floatValue] == [createdDate floatValue]) {
        self.modifiedLabel.hidden = YES;
        self.modifiedDateLabel.hidden = YES;
    } else {
        self.modifiedLabel.hidden = NO;
        self.modifiedDateLabel.hidden = NO;
    }
}

@end
