//
//  JsonClass.h
//  barberApp
//
//  Created by sparsh Wave01 on 1/5/15.
//  Copyright (c) 2015 sparsh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>





@protocol WebServiceProtocol <NSObject>
@optional

-(void)didReceiveResponseFromWebService:(NSDictionary *)responseDictionary;


@end


@interface JsonClass : NSObject
{
    NSMutableData *downloadJsonData;
}
@property(nonatomic, retain)id<WebServiceProtocol> delegate;



-(void)getMethodforServiceRequest:(NSString * )serviceUrl;

-(void)postMethodForServiceRequestWithPostData:(NSData *)postData andWithPostUrl:(NSURL *)url;

- (void)postRegisterDetails:(NSString *)postStr withUrlString:(NSString *)urlString;

-(void)postRegisterDetails:(NSDictionary *)dictionary withImageORVideoUrl:(NSURL *)url;



@end
