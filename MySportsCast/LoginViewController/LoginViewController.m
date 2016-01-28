//
//  LoginViewController.m
//  MySportsCast
//
//  Created by SPARSHMAC08 on 19/08/15.
//  Copyright (c) 2015 SPARSHMAC08. All rights reserved.
//

#import "LoginViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <FacebookSDK/FacebookSDK.h>
#import <FacebookSDK/FBSession.h>
#import <FacebookSDK/FBRequest.h>
#import <FacebookSDK/FBAccessTokenData.h>
#import "LoginWithEmailViewController.h"
#import "AppDelegate.h"
#import "RegistraionViewController.h"
#import "HomeViewController.h"
#import "JsonClass.h"
#import "Constants.h"




#define KAUTHURL @"https://api.instagram.com/oauth/authorize/"
#define kAPIURl @"https://api.instagram.com/v1/users/"
#define KCLIENTID @"2003cd493a6b491b8ded9a8f0cd40a3f"
#define KCLIENTSERCRET @"1bca4ad06f7d457e8075b51444076c49"
#define kREDIRECTURI @"http://www.sparshcommunications.com/"
#define kScocpe @"comments+relationships+likes"

//FOR TIWTTER
NSString *client_id = @"ZYj95YLog8RkDGTkmEVvnCRVM";
NSString *secret = @"AI7z8yRmTuUIyUTOgeC4pLVQ45LNMxngvpMkzVC0KXEipTgIfm";
NSString *callback = @"https://dev.twitter.com/";
@interface LoginViewController ()<FBLoginViewDelegate,WebServiceProtocol,UIWebViewDelegate>
{
    
    
    FBLoginView *loginView;
    AppDelegate *appDelegateObj;
    JsonClass * jsonObject;
    UIView * tempView;
    UIWebView *mywebview;
    UIButton * crossButton;
    BOOL fromTwitter;
    BOOL isLoginDetails;
    NSString*firstNamme;
    NSString * profilePicUrl;
    
    
    
}
@end

@implementation LoginViewController
@synthesize twitterWebview, isLogin;
@synthesize accessToken,consumer,requestToken;

- (void)viewDidLoad

{
    
    appDelegateObj = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    
    firstNamme =[[NSString alloc]init];
    profilePicUrl = [[NSString alloc]init];
    jsonObject = [[JsonClass alloc]init];
    
    jsonObject.delegate = self;
    
    self.navigationController.navigationBar.hidden = YES;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewDidDisappear:(BOOL)animated
{
    
    [self removeViewInstgramView];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)backButtonClicked:(id)sender {
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

#pragma mark - twitterButtonAction


- (IBAction)twitterButtonAction:(id)sender
{

    fromTwitter = YES;
    twitterWebview=[[UIWebView alloc] init];
    twitterWebview.frame=CGRectMake(10, 30, self.view.frame.size.width-20, self.view.frame.size.height-60);
    
    
    [self.view addSubview:twitterWebview];
    
    [appDelegateObj startIndicator];
    twitterWebview.delegate=self;
    consumer = [[OAConsumer alloc] initWithKey:client_id secret:secret];
    
    if ([appDelegateObj connectedToInternet]) {
        NSURL* requestTokenUrl = [NSURL URLWithString:@"https://api.twitter.com/oauth/request_token"];
        OAMutableURLRequest* requestTokenRequest = [[OAMutableURLRequest alloc] initWithURL:requestTokenUrl
                                                                                   consumer:consumer
                                                                                      token:nil
                                                                                      realm:nil
                                                                          signatureProvider:nil];
        OARequestParameter* callbackParam = [[OARequestParameter alloc] initWithName:@"oauth_callback" value:callback];
        [requestTokenRequest setHTTPMethod:@"POST"];
        [requestTokenRequest setParameters:[NSArray arrayWithObject:callbackParam]];
        OADataFetcher* dataFetcher = [[OADataFetcher alloc] init];
        [dataFetcher fetchDataWithRequest:requestTokenRequest
                                 delegate:self
                        didFinishSelector:@selector(didReceiveRequestToken:data:)
                          didFailSelector:@selector(didFailOAuth:error:)];
    }
    
    else{
        
        [self alertView:@"No internet Connectiuon"];
        
    }
    
 
 
    
//    [self alertView:@"Yet Be implement"];
    
    
}
#pragma mark - twitter delegate methods

- (void)didReceiveRequestToken:(OAServiceTicket*)ticket data:(NSData*)data
{
    NSString* httpBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    requestToken = [[OAToken alloc] initWithHTTPResponseBody:httpBody];
    
    NSURL* authorizeUrl = [NSURL URLWithString:@"https://api.twitter.com/oauth/authorize"];
    OAMutableURLRequest* authorizeRequest = [[OAMutableURLRequest alloc] initWithURL:authorizeUrl
                                                                            consumer:nil
                                                                               token:nil
                                                                               realm:nil
                                                                   signatureProvider:nil];
    NSString* oauthToken = requestToken.key;
    OARequestParameter* oauthTokenParam = [[OARequestParameter alloc] initWithName:@"oauth_token" value:oauthToken];
    [authorizeRequest setParameters:[NSArray arrayWithObject:oauthTokenParam]];
    
    [twitterWebview loadRequest:authorizeRequest];
    [appDelegateObj stopIndicators];
    
    
}

- (void)didReceiveAccessToken:(OAServiceTicket*)ticket data:(NSData*)data {
    
    NSString* httpBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    accessToken = [[OAToken alloc] initWithHTTPResponseBody:httpBody];
    // WebServiceSocket *connection = [[WebServiceSocket alloc] init];
    //  connection.delegate = self;
    NSString *pdata = [NSString stringWithFormat:@"type=2&token=%@&secret=%@&login=%@", accessToken.key, accessToken.secret, self.isLogin];
    // [connection fetch:1 withPostdata:pdata withGetData:@"" isSilent:NO];
    NSLog(@"accessToken.secret %@",accessToken.secret);
    
    
    if (accessToken)
    {
        NSURL* userdatarequestu = [NSURL URLWithString:@"https://api.twitter.com/1.1/account/verify_credentials.json"];
        OAMutableURLRequest* requestTokenRequest = [[OAMutableURLRequest alloc] initWithURL:userdatarequestu consumer:consumer
                                                                                      token:accessToken realm:nil signatureProvider:nil];
        
        [requestTokenRequest setHTTPMethod:@"GET"];
        OADataFetcher* dataFetcher = [[OADataFetcher alloc] init];
        [dataFetcher fetchDataWithRequest:requestTokenRequest
                                 delegate:self
                        didFinishSelector:@selector(didReceiveuserdata:data:)
                          didFailSelector:@selector(didFailOdatah:error:)];
    } else {
        // ERROR!
    }
    
}
- (void)didReceiveuserdata:(OAServiceTicket*)ticket data:(NSData*)data {
    
    NSError *error;
    NSDictionary *user_data = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSString *name = [user_data objectForKey:@"name"];
//    NSString *followers = [user_data objectForKey:@"followers_count"];
//    NSString *location = [user_data objectForKey:@"location"];
//    NSString *profile_image_url = [user_data objectForKey:@"profile_image_url"];
//    NSString *screen_name = [user_data objectForKey:@"screen_name"];
//    NSString *friends_count = [user_data objectForKey:@"friends_count"];
    NSString * userId =[user_data objectForKey:@"id_str"];
    

    
//    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
//    [tempDict setObject:name forKey:@"userName"];
//    [tempDict setObject:followers forKey:@"followers"];
//    [tempDict setObject:location forKey:@"location"];
//    [tempDict setObject:profile_image_url forKey:@"userImageUrl"];
//    [tempDict setObject:screen_name forKey:@"accountName"];
//    [tempDict setObject:friends_count forKey:@"friendsCount"];
//    [tempDict setObject:userId forKey:@"userid"];
//    NSLog(@"user details:%@",tempDict);
    
    [self webserviceRequestWhileLoginWithRegisterType:@"twitter" authString:userId name:name userEmail:[user_data objectForKey:@"screen_name"]];
    
    

}

- (void)didReceiveuserdata1:(OAServiceTicket*)ticket data:(NSData*)data {
    
    NSError *error;
    NSDictionary *user_data = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSLog(@"user_data %@",user_data);
}
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    if (fromTwitter) {
        NSString *temp = [NSString stringWithFormat:@"%@",request];
        
        NSRange textRange = [[temp lowercaseString] rangeOfString:[@"https://dev.twitter.com/" lowercaseString]];
        
        if(textRange.location != NSNotFound){
            
            // Extract oauth_verifier from URL query
            NSString* verifier = nil;
            NSArray* urlParams = [[[request URL] query] componentsSeparatedByString:@"&"];
            for (NSString* param in urlParams) {
                NSArray* keyValue = [param componentsSeparatedByString:@"="];
                NSString* key = [keyValue objectAtIndex:0];
                if ([key isEqualToString:@"oauth_verifier"]) {
                    verifier = [keyValue objectAtIndex:1];
                    break;
                }
            }
            
            if (verifier)
            {
                NSURL* accessTokenUrl = [NSURL URLWithString:@"https://api.twitter.com/oauth/access_token"];
                OAMutableURLRequest* accessTokenRequest = [[OAMutableURLRequest alloc] initWithURL:accessTokenUrl consumer:consumer token:requestToken realm:nil signatureProvider:nil];
                OARequestParameter* verifierParam = [[OARequestParameter alloc] initWithName:@"oauth_verifier" value:verifier];
                [accessTokenRequest setHTTPMethod:@"POST"];
                [accessTokenRequest setParameters:[NSArray arrayWithObject:verifierParam]];
                OADataFetcher* dataFetcher = [[OADataFetcher alloc] init];
                [dataFetcher fetchDataWithRequest:accessTokenRequest
                                         delegate:self
                                didFinishSelector:@selector(didReceiveAccessToken:data:)
                                  didFailSelector:@selector(didFailOAuth:error:)];
            }
            else
            {
                // ERROR!
            }
            
            [webView removeFromSuperview];
            
            return NO;
        }
        
    }else
    {
        NSString* urlString = [[request URL] absoluteString];
        NSLog(@"URL STRING : %@ ",urlString);
        if ([urlString rangeOfString:@"login"].location != NSNotFound) {
            [appDelegateObj stopIndicators];
        }
        else if ([urlString rangeOfString:@"#access_token"].location != NSNotFound) {
            [appDelegateObj startIndicator];
            NSString *strAccessToken = [[urlString componentsSeparatedByString:@"="] lastObject];
            [webView removeFromSuperview];
            [self getUserDataUsingToken:strAccessToken];
            return NO;
        }
        
    }
    
    return YES;
}

- (IBAction)notYetSignUpBUttonClicked:(id)sender {
    fromTwitter = NO;
    RegistraionViewController * registratioVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RegistraionViewController"];
    
    [self.navigationController pushViewController:registratioVC animated:YES];
    
    
}

#pragma mark - FacebookButton Clicked

- (IBAction)facebookButtonClicked:(id)sender {
    fromTwitter = NO;
    [appDelegateObj startIndicator];
    if (![appDelegateObj connectedToInternet])
    {
        [self alertView:@"Please check your internet connection"];
        [appDelegateObj stopIndicators];
    }
    else {
        NSArray *permissions = [[NSArray alloc] initWithObjects:@"public_profile", @"email", @"user_friends",@"user_birthday", nil];
        
        [FBSession openActiveSessionWithReadPermissions:permissions allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error)
         {
             if(!error) {
                 [self UserInformation];
             }
             else {
                 [self alertView:@"Cancel Facebook"];
                 [appDelegateObj stopIndicators];
             }
         }];
    }
 
}

-(void)UserInformation {
    
    if (![appDelegateObj connectedToInternet])
    {
        [appDelegateObj stopIndicators];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Connection Failed" message:@"No internet connection available." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        alert = nil;
    }
    else {
        
      
        [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *FBuser, NSError *error) {
            if (error)
            {
                // Handle error
                
                
            }
            
            else
            {
                 firstNamme= [FBuser name];
                 profilePicUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [FBuser objectID]];
                
                NSString * userId = [FBuser objectID];
               
                  [self webserviceRequestWhileLoginWithRegisterType:@"facebook" authString:userId name:firstNamme userEmail:[FBuser objectForKey:@"email"]];
            }
        }];
    }
}

#pragma mark -webserviceRequestWhileLoginWithSN


-(void)webserviceRequestWhileLoginWithRegisterType:(NSString *)regType authString:(NSString *)authString name:(NSString *)UserName userEmail:(NSString*)email
{
    [appDelegateObj startIndicator];
    NSString *post = [NSString stringWithFormat:@"reg_type=%@&name=%@&oauth_id=%@&email=%@",regType,UserName,authString,email];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSURL *registerUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",commonURL,socialRegister]];
    
    [jsonObject postMethodForServiceRequestWithPostData:postData andWithPostUrl:registerUrl];
    
    
}


#pragma mark - alertViewCreation 

-(void)alertView:(NSString *)alertDiscripatio
{
    UIAlertView *globalAlertView = [[UIAlertView alloc]initWithTitle:@"MySportsCast" message:alertDiscripatio delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [globalAlertView show];
    globalAlertView  = nil;
}

#pragma mark - instagramButtonClicked

- (IBAction)instagramButtonClicked:(id)sender {
    fromTwitter = NO;
    float height = self.view.frame.size.height;
    float width = self.view.frame.size.width;
    if (![appDelegateObj connectedToInternet])
    {
        [self alertView:@"Please check your internet connection"];
        return;
    }
    
    
    NSString *fullURL = [NSString stringWithFormat:@"https://api.instagram.com/oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=TOKEN",KCLIENTID,kREDIRECTURI];
    
    NSURL *url = [NSURL URLWithString:fullURL];
    
    tempView = [[UIView alloc]initWithFrame:self.view.frame];
    
    mywebview = [[UIWebView alloc] initWithFrame:CGRectMake(10, 64, width-20, height-120)];
    
    crossButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    
    [crossButton addTarget:self action:@selector(removeViewInstgramView) forControlEvents:UIControlEventTouchUpInside];
    
    [crossButton setImage:[UIImage imageNamed:@"crossround.png"] forState:UIControlStateNormal];
    
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [mywebview loadRequest:requestObj];
    mywebview.delegate = self;
    mywebview.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tempView];
    [self.view addSubview:mywebview];
    
    [mywebview addSubview:crossButton];
    
    [appDelegateObj startIndicator];
    
    
}



-(void)removeViewInstgramView
{
    [mywebview removeFromSuperview];
    
    [tempView removeFromSuperview];
    
    [crossButton removeFromSuperview];
    
    mywebview = nil;
    crossButton = nil;
    tempView = nil;
    

}

#pragma mark - InstagramWebDelegateMethods

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
//    [appDelegateObj stopIndicators];
    if (fromTwitter)
    {
        
    }else
    {
        [webView removeFromSuperview];
        [self removeViewInstgramView];
        //[self alertView:@"Sorry!!! Failed to load Instagram please try again after some time"];
    }
}

- (void)getUserDataUsingToken:(NSString *)tokenString
{
    
    
    [appDelegateObj stopIndicators];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/v1/users/self?access_token=%@",tokenString]]];
    NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    NSMutableDictionary *userDictionary = [[NSMutableDictionary alloc] init];
    [userDictionary setObject:[[dictResponse objectForKey:@"data"] objectForKey:@"username"] forKey:@"userName"];
    [userDictionary setObject:[[dictResponse objectForKey:@"data"] objectForKey:@"full_name"] forKey:@"profileName"];
    [userDictionary setObject:[[dictResponse objectForKey:@"data"] objectForKey:@"id"] forKey:@"id"];
    [userDictionary setObject:[[dictResponse objectForKey:@"data"] objectForKey:@"profile_picture"] forKey:@"profile_picture"];

    [self webserviceRequestWhileLoginWithRegisterType:@"instagram" authString:tokenString name:[[dictResponse objectForKey:@"data"] objectForKey:@"full_name"] userEmail:@""];
}


#pragma mark - loginWithEmailclicked

- (IBAction)loginWithEmailButtonClicked:(id)sender {
    
    
    fromTwitter = NO;
    
    LoginWithEmailViewController * logInwithEmailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginWithEmailViewController"];
    
    [self.navigationController pushViewController:logInwithEmailVC animated:YES];
    
}

#pragma mark -Facebook login

- (void)loginView:(FBLoginView *)loginView
      handleError:(NSError *)error
{
    NSLog(@"Failed with error:%@",[error localizedDescription]);
}



#pragma mark - WebServiceDelegateMethod

-(void)didReceiveResponseFromWebService:(NSDictionary *)responseDictionary
{
    
   
    if (isLoginDetails == YES)
    {
        
        isLoginDetails = NO;
        
        if ([[[[responseDictionary objectForKey:@"Response"] objectForKey:@"ProfileInfo"]objectForKey:@"first_name"]isEqual:[NSNull null]])
        {
            firstNamme = @"";
        }
       else if ([[[[responseDictionary objectForKey:@"Response"] objectForKey:@"ProfileInfo"]objectForKey:@"user_profile_pic"]isEqual:[NSNull null]])
       {
           profilePicUrl = @"";
       }
      else
      {
          firstNamme = [[[responseDictionary objectForKey:@"Response"] objectForKey:@"ProfileInfo"]objectForKey:@"first_name"];
          
          profilePicUrl = [[[responseDictionary objectForKey:@"Response"] objectForKey:@"ProfileInfo"]objectForKey:@"user_profile_pic"];
          
          NSMutableDictionary * profileInfoDic = [[NSMutableDictionary alloc]init];
          [profileInfoDic setValue:firstNamme forKey:@"userName"];
          [profileInfoDic setValue:profilePicUrl forKey:@"userPic"];
          
          NSData * data = [NSKeyedArchiver archivedDataWithRootObject:profileInfoDic];
          
        [[NSUserDefaults standardUserDefaults]setObject:data forKey:@"profileInfo"];
          profileInfoDic = nil;
          
          
          UITabBarController * tabbarVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabbarViewController"];
          
          
          [tabbarVC setSelectedIndex:0];
          [self.navigationController pushViewController:tabbarVC animated:YES];
          
          NSLog(@"%@",responseDictionary);

      }
        
    }
    else
    {
        if ([[[responseDictionary valueForKey:@"Response"]valueForKey:@"ResponseInfo"] isEqualToString:@"SUCCESS"])
        {
            
            
            [[NSUserDefaults standardUserDefaults]setObject:[[responseDictionary valueForKey:@"Response"]valueForKey:@"user_id"] forKey:@"loginId"];
            
            
        }
        else if ([[[responseDictionary valueForKey:@"Response"]valueForKey:@"ResponseInfo"] isEqualToString:@"EMAIL ALREADY EXIST"])
        {
            [[NSUserDefaults standardUserDefaults]setObject:[[responseDictionary valueForKey:@"Response"]valueForKey:@"user_id"] forKey:@"loginId"];
        }
        [self requestForUserDetailsFromServer];
    }
    
    [appDelegateObj stopIndicators];
    
   
}


-(void)requestForUserDetailsFromServer
{
    isLoginDetails = YES;
    if ([appDelegateObj connectedToInternet])
    {
        [appDelegateObj startIndicator];
        
//           [jsonObject getMethodforServiceRequest:[NSString stringWithFormat:@"http://182.75.34.62/MySportsShare/web_services/get_profile_info.php?user_id=%@&login_user_id=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"loginId"],[[NSUserDefaults standardUserDefaults] objectForKey:@"loginId"]]];
        
        
        
        [jsonObject getMethodforServiceRequest:[NSString stringWithFormat:@"%@%@user_id=%@&login_user_id=%@",commonURL,getProfileInfo,[[NSUserDefaults standardUserDefaults] objectForKey:@"loginId"],[[NSUserDefaults standardUserDefaults] objectForKey:@"loginId"]]];
    }
    
    else{
        
        [self alertView:@"unabletogetUserDetails"];
    }

    
}

@end
