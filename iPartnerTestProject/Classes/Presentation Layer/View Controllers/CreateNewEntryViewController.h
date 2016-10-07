//
//  CreateNewEntryViewController.h
//  iPartnerTestProject
//
//  Created by Tiran Saroyan on 07/10/2016.
//  Copyright © 2016 Tiran Saroyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CreateNewEntryViewControllerDelegate

- (void)newEntryCreated;

@end

@interface CreateNewEntryViewController : UIViewController

@property (weak, nonatomic) id<CreateNewEntryViewControllerDelegate> delegate;

@end
