//
//  ServerService.h
//  iPartnerTestProject
//
//  Created by Tiran Saroyan on 05/10/2016.
//  Copyright © 2016 Tiran Saroyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerService : NSObject

+ (instancetype)sharedInstance;

- (void)getNewSessionWithCompletion:(void(^)(NSString *session, NSError *error))completion;
- (void)getEntriesWithCompletion:(void(^)(NSArray *entries, NSError *error))completion;
- (void)addEntry:(NSString *)entry withCompletion:(void(^)(NSString *entryId, NSError *error))completion;

@end
