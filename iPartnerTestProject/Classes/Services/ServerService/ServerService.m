//
//  ServerService.m
//  iPartnerTestProject
//
//  Created by Tiran Saroyan on 05/10/2016.
//  Copyright © 2016 Tiran Saroyan. All rights reserved.
//

#import "ServerService.h"
#import <AFNetworking.h>
#import <SAMKeychain.h>
#import "Constant.h"

@implementation ServerService

+ (instancetype)sharedInstance {
    
    static ServerService *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ServerService alloc] init];
    });
    return sharedInstance;
}

- (void)getNewSessionWithCompletion:(void(^)(NSString *session, NSError *error))completion {
    NSString *post = [NSString stringWithFormat:@"a=new_session"];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURL *URL = [NSURL URLWithString:@"https://bnet.i-partner.ru/testAPI/"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"xUlvMvW-Mv-SadYWz2" forHTTPHeaderField:@"token"];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            completion(nil,error);
        } else {
            completion([[responseObject objectForKey:@"data"] objectForKey:@"session"], nil);
        }
    }];
    [dataTask resume];
}

- (void)getEntriesWithCompletion:(void(^)(NSArray *entries, NSError *error))completion {
    NSString *session = [SAMKeychain passwordForService:keychainService account:keychainAccount];
    [self getEntriesForSession:session withCompletion:^(NSArray *entries, NSError *error) {
        completion(entries, error);
    }];
}

- (void)getEntriesForSession:(NSString *)session withCompletion:(void(^)(NSArray *entries, NSError *error))completion {
    NSString *post = [NSString stringWithFormat:@"a=get_entries&session=%@", session];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURL *URL = [NSURL URLWithString:@"https://bnet.i-partner.ru/testAPI/"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"xUlvMvW-Mv-SadYWz2" forHTTPHeaderField:@"token"];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            completion(nil,error);
        } else {
            completion([responseObject objectForKey:@"data"], nil);
        }
    }];
    [dataTask resume];
}

- (void)addEntry:(NSString *)entry withCompletion:(void(^)(NSString *entryId, NSError *error))completion {
    NSString *session = [SAMKeychain passwordForService:keychainService account:keychainAccount];
    [self addEntry:entry forSession:session withCompletion:^(NSString *entryId, NSError *error) {
        completion(entryId, error);
    }];
}

- (void)addEntry:(NSString *)entry forSession:(NSString *)session withCompletion:(void(^)(NSString *entryId, NSError *error))completion {
    NSString *post = [NSString stringWithFormat:@"a=add_entry&session=%@&body=%@", session, entry];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURL *URL = [NSURL URLWithString:@"https://bnet.i-partner.ru/testAPI/"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"xUlvMvW-Mv-SadYWz2" forHTTPHeaderField:@"token"];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            completion(nil,error);
        } else {
            completion([[responseObject objectForKey:@"data"] objectForKey:@"id"], nil);
        }
    }];
    [dataTask resume];
}

@end
