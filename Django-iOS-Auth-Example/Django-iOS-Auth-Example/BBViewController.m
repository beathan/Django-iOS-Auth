//
//  BBViewController.m
//  Django-iOS-Auth-Example
//
//  Created by Ben Boyd on 1/6/13.
//  Copyright (c) 2013 Ben Boyd. All rights reserved.
//

#import "BBViewController.h"
#import "DjangoAuthLoginResultObject.h"

@implementation BBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)validateInputs {
    if (![_username.text isEqualToString:@""] && ![_password.text isEqualToString:@""]) {
        return YES;
    }
    
    return NO;
}

- (IBAction)logIn:(id)sender {
    if ([self validateInputs]) {
        _authClient = [[DjangoAuthClient alloc] initWithURL:@"http://127.0.0.1:8000/accounts/login/"
                                                forUsername:_username.text
                                                andPassword:_password.text];
        _authClient.delegate = self;
        [_authClient login];
    }
    else {
        _loginMessage.text = @"Username and Password are required to log in.";
    }
}

- (void)loginSuccessful:(DjangoAuthLoginResultObject *)result {
    _loginMessage.text = @"Login successful";
}

- (void)loginFailed:(DjangoAuthLoginResultObject *)result {
    if (result.loginFailureReason == kDjangoAuthClientLoginFailureInactiveAccount) {
        _loginMessage.text = @"Login failed: Your account is inactive.";
    }
    else if (result.loginFailureReason == kDjangoAuthClientLoginFailureInvalidCredentials) {
        _loginMessage.text = @"Login failed: Please check your username and password.";
    }
}

@end
