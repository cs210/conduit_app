//
//  LayerHelpers.m
//  conduit
//
//  Created by Nathan Eidelson on 4/5/15.
//  Copyright (c) 2015 Conduit. All rights reserved.
//

#import "LayerHelpers.h"

@implementation LayerHelpers

//- (void)init {
//  
//  NSUUID *appID = [[NSUUID alloc] initWithUUIDString:@"7b2aed30-db1b-11e4-a21a-52bb02000413"];
//  self.layerClient = [LYRClient clientWithAppID:appID];
//  [self.layerClient connectWithCompletion:^(BOOL success, NSError *error) {
//    if (!success) {
//      NSLog(@"Failed to connect to Layer: %@", error);
//    } else {
//      // For the purposes of this Quick Start project, let's authenticate as a user named 'Device'.  Alternatively, you can authenticate as a user named 'Simulator' if you're running on a Simulator.
//      NSString *userIDString = @"Device";
//      // Once connected, authenticate user.
//      // Check Authenticate step for authenticateLayerWithUserID source
//      [self authenticateLayerWithUserID:userIDString completion:^(BOOL success, NSError *error) {
//        if (!success) {
//          NSLog(@"Failed Authenticating Layer Client with error:%@", error);
//        }
//      }];
//    }
//  }];
//  
//}

+ (void)authenticateLayerWithUserID:(NSString *)userID client:(LYRClient *)client completion:(void (^)(BOOL success, NSError * error))completion
{
  // Check to see if the layerClient is already authenticated.
  if (client.authenticatedUserID) {
    // If the layerClient is authenticated with the requested userID, complete the authentication process.
    if ([client.authenticatedUserID isEqualToString:userID]){
      NSLog(@"Layer Authenticated as User %@", client.authenticatedUserID);
      if (completion) completion(YES, nil);
      return;
    } else {
      //If the authenticated userID is different, then deauthenticate the current client and re-authenticate with the new userID.
      [client deauthenticateWithCompletion:^(BOOL success, NSError *error) {
        if (!error){
          [self authenticationTokenWithUserId:userID client:client completion:^(BOOL success, NSError *error) {
            if (completion){
              completion(success, error);
            }
          }];
        } else {
          if (completion){
            completion(NO, error);
          }
        }
      }];
    }
  } else {
    // If the layerClient isn't already authenticated, then authenticate.
    [self authenticationTokenWithUserId:userID client:client completion:^(BOOL success, NSError *error) {
      if (completion){
        completion(success, error);
      }
    }];
  }
}

+ (void)authenticationTokenWithUserId:(NSString *)userID client:(LYRClient *)client completion:(void (^)(BOOL success, NSError* error))completion{
  
  /*
   * 1. Request an authentication Nonce from Layer
   */
  [client requestAuthenticationNonceWithCompletion:^(NSString *nonce, NSError *error) {
    if (!nonce) {
      if (completion) {
        completion(NO, error);
      }
      return;
    }
    
    /*
     * 2. Acquire identity Token from Layer Identity Service
     */
    [self requestIdentityTokenForUserID:userID appID:[client.appID UUIDString] nonce:nonce completion:^(NSString *identityToken, NSError *error) {
      if (!identityToken) {
        if (completion) {
          completion(NO, error);
        }
        return;
      }
      
      /*
       * 3. Submit identity token to Layer for validation
       */
      [client authenticateWithIdentityToken:identityToken completion:^(NSString *authenticatedUserID, NSError *error) {
        if (authenticatedUserID) {
          if (completion) {
            completion(YES, nil);
          }
          NSLog(@"Layer Authenticated as User: %@", authenticatedUserID);
        } else {
          completion(NO, error);
        }
      }];
    }];
  }];
}

+ (void)requestIdentityTokenForUserID:(NSString *)userID appID:(NSString *)appID nonce:(NSString *)nonce completion:(void(^)(NSString *identityToken, NSError *error))completion
{
  NSParameterAssert(userID);
  NSParameterAssert(appID);
  NSParameterAssert(nonce);
  NSParameterAssert(completion);
  
  NSURL *identityTokenURL = [NSURL URLWithString:@"https://layer-identity-provider.herokuapp.com/identity_tokens"];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:identityTokenURL];
  request.HTTPMethod = @"POST";
  [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
  [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
  
  NSDictionary *parameters = @{ @"app_id": appID, @"user_id": userID, @"nonce": nonce };
  NSData *requestBody = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
  request.HTTPBody = requestBody;
  
  NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
  NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
  [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    if (error) {
      completion(nil, error);
      return;
    }
    
    // Deserialize the response
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    if(![responseObject valueForKey:@"error"])
    {
      NSString *identityToken = responseObject[@"identity_token"];
      completion(identityToken, nil);
    }
    else
    {
      NSString *domain = @"layer-identity-provider.herokuapp.com";
      NSInteger code = [responseObject[@"status"] integerValue];
      NSDictionary *userInfo =
      @{
        NSLocalizedDescriptionKey: @"Layer Identity Provider Returned an Error.",
        NSLocalizedRecoverySuggestionErrorKey: @"There may be a problem with your APPID."
        };
      
      NSError *error = [[NSError alloc] initWithDomain:domain code:code userInfo:userInfo];
      completion(nil, error);
    }
    
  }] resume];
}



@end
