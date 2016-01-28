//
//  LoginViewController.h
//  MySportsCast
//
//  Created by SPARSHMAC08 on 19/08/15.
//  Copyright (c) 2015 SPARSHMAC08. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAuthConsumer.h"

@interface LoginViewController : UIViewController
- (IBAction)backButtonClicked:(id)sender;
- (IBAction)facebookButtonClicked:(id)sender;
- (IBAction)instagramButtonClicked:(id)sender;
- (IBAction)twitterButtonAction:(id)sender;
- (IBAction)loginWithEmailButtonClicked:(id)sender;
//FOR TWITTER
@property (nonatomic,strong) OAConsumer *consumer;
@property (nonatomic,strong) OAToken* accessToken;
@property (nonatomic,strong) OAToken* requestToken;
@property (nonatomic, retain) UIWebView *twitterWebview;
@property (nonatomic, retain) NSString *isLogin;
@end
