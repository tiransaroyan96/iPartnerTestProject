//
//  EntryCell.h
//  iPartnerTestProject
//
//  Created by Tiran Saroyan on 06/10/2016.
//  Copyright © 2016 Tiran Saroyan. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *EntryCellIdentifier = @"EntryCell";

@interface EntryCell : UITableViewCell

- (void)configureCellWithEntry:(NSDictionary *)dictionary;

@end
