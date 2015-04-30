//
//  LayerHelpers.h
//  conduit
//
//  Created by Nathan Eidelson on 4/5/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LayerKit/LayerKit.h>

@interface LayerHelpers : NSObject

+ (NSDateFormatter *)LQSDateFormatter;

+ (void)authenticateLayerWithEmailAddress:(NSString *)emailAddress
                                   client:(LYRClient *)client
                               completion:(void (^)(BOOL success, NSError * error))completion;


+ (void)authenticationTokenWithEmailAddress:(NSString *)emailAddress
                                     client:(LYRClient *)client
                                 completion:(void (^)(BOOL success, NSError* error))completion;
  
+ (void)requestIdentityTokenForEmailAddress:(NSString *)emailAddress
                                      nonce:(NSString *)nonce
                                 completion:(void(^)(NSString *identityToken, NSError *error))completion;

+ (LYRQuery *)createQueryWithClass:(Class)class_type;

+ (LYRPredicate *)createPredicateWithProperty:(NSString *)property
                                    _operator:(LYRPredicateOperator)_operator
                                        value:(id)value;

+ (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
             client:(LYRClient *)client fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;

+ (LYRMessage *)messageFromRemoteNotification:(NSDictionary *)remoteNotification client:(LYRClient *)client;


@end
