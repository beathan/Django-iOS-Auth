//
//  DjangoAuthClient.h
//  Django-iOS-Auth-Example
//
//  Created by Ben Boyd on 1/3/13.
//  Copyright (c) 2013 Ben Boyd. All rights reserved.
//

#import <Foundation/Foundation.h>


// Notifications
extern NSString * const DjangoAuthClientDidLoginSuccessfully;
extern NSString * const DjangoAuthClientDidFailToLogin;
extern NSString * const DjangoAuthClientDidFailToCreateConnectionToAuthURL;

// Login failure reasons
extern NSString *const kDjangoAuthClientLoginFailureInvalidCredentials;
extern NSString *const kDjangoAuthClientLoginFailureInactiveAccount;

@class DjangoAuthLoginResultObject;

// Delegate definition
@protocol DjangoAuthClientDelegate <NSObject>

@optional
- (void)loginSuccessful:(DjangoAuthLoginResultObject *)result;
- (void)loginFailed:(DjangoAuthLoginResultObject *)result;

@end

// Client class definition
@interface DjangoAuthClient : NSObject <NSURLConnectionDelegate>

@property (unsafe_unretained) id <DjangoAuthClientDelegate> delegate;

@property (nonatomic, copy) NSData *requestBodyData;
@property (nonatomic, retain) NSURL *requestURL;
@property (nonatomic, strong) NSMutableData *responseData;

- (id)initWithURL:(NSString *)loginURL forUsername:(NSString *)username andPassword:(NSString *)password;
- (void)login;

@end
