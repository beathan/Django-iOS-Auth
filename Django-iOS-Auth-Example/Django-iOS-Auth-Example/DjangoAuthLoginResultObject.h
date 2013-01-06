//
//  DjangoAuthLoginResultObject.h
//  Django-iOS-Auth-Example
//
//  Created by Ben Boyd on 1/3/13.
//  Copyright (c) 2013 Ben Boyd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DjangoAuthLoginResultObject : NSObject

@property (nonatomic, strong) NSString *loginFailureReason;
@property (nonatomic, strong) NSDictionary *responseHeaders;
@property (nonatomic, strong) NSURLResponse *serverResponse;
@property (nonatomic, assign) NSInteger statusCode;

+ (DjangoAuthLoginResultObject *)loginResultObjectFromResponse:(NSURLResponse *)response;

@end
