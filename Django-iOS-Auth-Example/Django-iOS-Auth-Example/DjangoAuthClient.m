//
//  DjangoAuthClient.m
//  Django-iOS-Auth-Example
//
//  Created by Ben Boyd on 1/3/13.
//  Copyright (c) 2013 Ben Boyd. All rights reserved.
//

#import "DjangoAuthClient.h"
#import "DjangoAuthLoginResultObject.h"

NSString * const DjangoAuthClientDidLoginSuccessfully = @"DjangoAuthClientDidLoginSuccessfully";
NSString * const DjangoAuthClientDidFailToLogin = @"DjangoAuthClientDidFailToLogin";
NSString * const DjangoAuthClientDidFailToCreateConnectionToAuthURL = @"DjangoAuthClientDidFailToCreateConnectionToAuthURL";

NSString *const kDjangoAuthClientLoginFailureInvalidCredentials = @"kDjangoAuthClientLoginFailureInvalidCredentials";
NSString *const kDjangoAuthClientLoginFailureInactiveAccount = @"kDjangoAuthClientLoginFailureInactiveAccount";

@interface DjangoAuthClient()

// Private properties
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;

@end

@implementation DjangoAuthClient

- (id)initWithURL:(NSString *)loginURL forUsername:(NSString *)username andPassword:(NSString *)password {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _username = username;
    _password = password;
    _requestURL = [NSURL URLWithString:loginURL];
    _responseData = [[NSMutableData alloc] initWithCapacity:512];
    
    return self;
}

- (void)login {
    [self makeLoginRequest:nil];
}

- (void)makeLoginRequest:(NSMutableURLRequest *)request {
    if (request == nil) {
        request = [NSMutableURLRequest requestWithURL:_requestURL];
    }
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (!connection) {
        [[NSNotificationCenter defaultCenter] postNotificationName:DjangoAuthClientDidFailToCreateConnectionToAuthURL object:self];
    }
}

#pragma mark - NSURLConnectionDelegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    DjangoAuthLoginResultObject *resultObject = [DjangoAuthLoginResultObject loginResultObjectFromResponse:response];
    
    if (resultObject.statusCode == 200) {
        // We're logged in and good to go
        [connection cancel];
        if ([_delegate respondsToSelector:@selector(loginSuccessful:)]) {
            [_delegate loginSuccessful:resultObject];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:DjangoAuthClientDidLoginSuccessfully object:resultObject];
    }
    else if (resultObject.statusCode == 401) {
        // We're not authorized, so cancel the connection since we need to send the login POST request
        [connection cancel];
        
        // Check to see if we've already made an attempt to log in and failed
        if ([[resultObject.responseHeaders objectForKey:@"Auth-Response"] isEqualToString:@"Login failed"]) {
            resultObject.loginFailureReason = kDjangoAuthClientLoginFailureInvalidCredentials;
            if ([_delegate respondsToSelector:@selector(loginFailed:)]) {
                [_delegate loginFailed:resultObject];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:DjangoAuthClientDidFailToLogin object:resultObject];
        }
        else {
            // Initial login attempt
            NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:resultObject.responseHeaders forURL:self.requestURL];
            
            // Django defaults to CSRF protection, so we need to get the token to send back in the request
            NSHTTPCookie *csrfCookie;
            for (NSHTTPCookie *cookie in cookies) {
                if ([cookie.name isEqualToString:@"csrftoken"]) {
                    csrfCookie = cookie;
                }
            }
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:self.requestURL];
            [request setHTTPMethod:@"POST"];
            
            NSString *authString = [NSString stringWithFormat:@"username=%@;password=%@;csrfmiddlewaretoken=%@;", _username, _password, csrfCookie.value, nil];
            [request setHTTPBody:[authString dataUsingEncoding:NSUTF8StringEncoding]];

            [self makeLoginRequest:request];
        }
    }
    else if (resultObject.statusCode == 403) {
        // Login failed because the user's account is inactive
        resultObject.loginFailureReason = kDjangoAuthClientLoginFailureInactiveAccount;
        if ([_delegate respondsToSelector:@selector(loginFailed:)]) {
            [_delegate loginFailed:resultObject];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:DjangoAuthClientDidFailToLogin object:resultObject];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"%@", [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding]);
    [self.responseData setLength:0];
}


@end
