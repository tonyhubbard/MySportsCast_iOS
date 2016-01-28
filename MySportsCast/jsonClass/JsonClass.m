//
//  JsonClass.h
//  barberApp
//
//  Created by sparsh Wave01 on 1/5/15.
//  Copyright (c) 2015 sparsh. All rights reserved.
//

#import "JsonClass.h"
#include "AppDelegate.h"
#import "Constants.h"



@implementation JsonClass
@synthesize delegate = _delegate;

- (void) setdelegate:(id<WebServiceProtocol>) delegate1
{
    if (_delegate != delegate1)
    { // Add breakpoint here to see when set is called.
        _delegate = delegate1;
    }
    
}


-(void)getMethodforServiceRequest:(NSString * )serviceUrl
{
    
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    configuration.timeoutIntervalForResource = 30.0;
//    NSURL *url = [NSURL URLWithString:serviceUrl];
    NSURL *url = [NSURL URLWithString:[serviceUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:30.0];
    
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
       

        if (response != nil) {
            
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
            if (!error) {
                if (self.delegate != nil) {
                    
                    [self.delegate didReceiveResponseFromWebService:jsonDict];
                    
                }
                
            }else if (jsonDict != nil) {
                if (self.delegate != nil) {
                    
                    [self.delegate didReceiveResponseFromWebService:jsonDict];
                    
                }
            }else if (jsonDict == nil) {
                
                [self.delegate didReceiveResponseFromWebService:jsonDict];
                
            }
        }else
        {
            [self.delegate didReceiveResponseFromWebService:nil];
            
        }
        
        
    }];
    
    [dataTask resume];
    
    
}


-(void)postMethodForServiceRequestWithPostData:(NSData *)postData andWithPostUrl:(NSURL *)url
{
    @autoreleasepool {
//        [kAppDelegateAccessor startIndicator];
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.timeoutIntervalForResource = 160.0;
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];

        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
        {
            
            if (data!= nil)
            {
                NSError * error;
                
                {
                    
//                  id jsonDict  = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                   
                    if (!error) {
                        if (self.delegate != nil) {
                            [self.delegate didReceiveResponseFromWebService:jsonDict];
                        }
                        
                    }
                    else if (jsonDict != nil)
                    {
                        if (self.delegate != nil)
                        {
                            [self.delegate didReceiveResponseFromWebService:jsonDict];

                        }
                    }
                    else if (jsonDict == nil)
                    {
                        [self.delegate didReceiveResponseFromWebService:jsonDict];

                    }
                }
             
            }
    
        }];
        
        [dataTask resume];
  
    }
}


-(void)postRegisterDetails:(NSDictionary *)dictionary withImageORVideoUrl:(NSURL *)url

{
    
    
    NSString *boundary = [self generateBoundaryString];
    
    // configure the request
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    
    // set content type
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSString * mediaPath = [dictionary valueForKey:@"media_file"];
    
    
    NSData *httpBody = [self createBodyWithBoundary:boundary parameters:dictionary paths:@[mediaPath] fieldName:@"media_file"];
    
    [request setHTTPBody:httpBody];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    

    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        // send the request (submit the form) and get the response
        
        if (error == nil)
            {
            
                NSMutableDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];

                [self.delegate didReceiveResponseFromWebService:jsonDict];
                
                    }
            else
            {
            
        }
    }];
    
    
    

}


- (NSData *)createBodyWithBoundary:(NSString *)boundary
                        parameters:(NSDictionary *)parameters
                             paths:(NSArray *)paths
                         fieldName:(NSString *)fieldName
{
    NSMutableData *httpBody = [NSMutableData data];
    
    // add params (all params are strings)
    
    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *parameterKey, NSString *parameterValue, BOOL *stop)
     {
         [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
         [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", parameterKey] dataUsingEncoding:NSUTF8StringEncoding]];
         [httpBody appendData:[[NSString stringWithFormat:@"%@\r\n", parameterValue] dataUsingEncoding:NSUTF8StringEncoding]];
     }];
    
    // add image data
    
    for (NSString *path in paths)
    {
        NSString *filename  = [path lastPathComponent];
        NSData   *data      = [NSData dataWithContentsOfFile:path];
        //        NSString *mimetype  = [self mimeTypeForPath:path];
        
        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", fieldName, filename] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", @"image/png"] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [httpBody appendData:data];
        [httpBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [httpBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    return httpBody;
   
}




- (NSString *)generateBoundaryString
{
    return [NSString stringWithFormat:@"Boundary-%@", [[NSUUID UUID] UUIDString]];
    
    
}








- (void)postRegisterDetails:(NSString *)postStr withUrlString:(NSString *)urlString{
    
    NSData *postData =  [postStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSURL *registerUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]];
    [request setURL:registerUrl];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//        [kAppDelegateAccessor stopIndicators];

        // send the request (submit the form) and get the response
        
        if (error == nil)
        {
            
            NSMutableDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            
            [self.delegate didReceiveResponseFromWebService:jsonDict];
            
            
        }
        else{
            
           [self.delegate didReceiveResponseFromWebService:nil];
            
        }
    }];
    
}




@end
