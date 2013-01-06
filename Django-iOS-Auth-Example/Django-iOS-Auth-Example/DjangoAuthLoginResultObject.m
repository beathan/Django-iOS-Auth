//
//  DjangoAuthLoginResultObject.m
//  Django-iOS-Auth-Example
//
//  Created by Ben Boyd on 1/3/13.
//  Copyright (c) 2013 Ben Boyd. All rights reserved.
//

#import "DjangoAuthLoginResultObject.h"

@implementation DjangoAuthLoginResultObject

+ (DjangoAuthLoginResultObject *)loginResultObjectFromResponse:(NSURLResponse *)response {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    
    DjangoAuthLoginResultObject *resultObject = [[DjangoAuthLoginResultObject alloc] init];
    resultObject.responseHeaders = [httpResponse allHeaderFields];
    resultObject.serverResponse = response;
    resultObject.statusCode = [httpResponse statusCode];
    
    return resultObject;
}

@end
