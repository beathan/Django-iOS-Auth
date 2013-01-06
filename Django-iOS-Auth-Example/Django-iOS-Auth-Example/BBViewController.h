//
//  BBViewController.h
//  Django-iOS-Auth-Example
//
//  Created by Ben Boyd on 1/6/13.
//  Copyright (c) 2013 Ben Boyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DjangoAuthClient.h"

@interface BBViewController : UIViewController <DjangoAuthClientDelegate>

@property (nonatomic, strong) IBOutlet UITextField *username;
@property (nonatomic, strong) IBOutlet UITextField *password;
@property (nonatomic, strong) IBOutlet UILabel *loginMessage;

@property (nonatomic, strong) DjangoAuthClient *authClient;

- (IBAction)logIn:(id)sender;

@end
