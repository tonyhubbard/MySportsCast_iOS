//
//  LoginWithEmailViewController.m
//  MySportsCast
//
//  Created by Vardhan on 20/08/15.
//  Copyright (c) 2015 SPARSHMAC08. All rights reserved.
//

#import "LoginWithEmailViewController.h"
#import "AppDelegate.h"
#import "JsonClass.h"
#import "ForgotPasswordViewController.h"
#import "HomeViewController.h"
#import "Constants.h"




@interface LoginWithEmailViewController ()<WebServiceProtocol,UIAlertViewDelegate>
{
    AppDelegate *appDelegateObj;
    JsonClass * jsonObject;
    UIAlertView *SuccessAlert;
    BOOL isLoginDetails;
}
@end

@implementation LoginWithEmailViewController

- (void)viewDidLoad {
    
    appDelegateObj = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    jsonObject = [[JsonClass alloc]init];
    
    jsonObject.delegate = self;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backButtonAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}
#pragma mark EmailValidation
- (BOOL)emailValidation
{
    
    BOOL isValidEmail = FALSE;
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    if ([emailTest evaluateWithObject:self.textFieldEmailId.text] == NO) {
        isValidEmail = FALSE;
        
    }
    else{
        isValidEmail = TRUE;
    }
    return isValidEmail;
}
#pragma mark ButtonAction


- (IBAction)loginButtonClicked:(id)sender {
    
    if (![appDelegateObj connectedToInternet])
    {
        [self showAlert:@"Please check your internet connection"];
        
        return;
    }
    
    if ([self.textFieldEmailId.text length] == 0 || [self.textfiledPassword.text length] == 0)
    {
        [self showAlert:@"Please fill all fields"];
    }
    else if(![self emailValidation])
    {
        
        [self showAlert:@"Enter valid email id"];
    }
    else
    {
        [appDelegateObj startIndicator];
        [self.textfiledPassword resignFirstResponder];
        [self.textFieldEmailId resignFirstResponder];
        [self loginThoroughEmail:self.textFieldEmailId.text andPassword:self.textfiledPassword.text];
       
    }
    
    [self.textfiledPassword resignFirstResponder];
  
    
}


- (IBAction)forGetPasswordClicked:(id)sender

{
    
    ForgotPasswordViewController * forgotVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ForgotPasswordViewController"];
    
    [self.navigationController pushViewController:forgotVC animated:YES];
    
}






#pragma mark - alertViewCreation

- (void)showAlert :(NSString *)alertDescription{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:alertDescription delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma  mark - TextfieldDelegateMethods

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



#pragma mark - WebServices

-(void)loginThoroughEmail:(NSString *)email andPassword:(NSString *)password
{
    
    [appDelegateObj startIndicator];
    if (![appDelegateObj connectedToInternet])
    {
        [appDelegateObj stopIndicators];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Connection Failed" message:@"No internet connection available." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        alert = nil;
    }
    else
    {
        
        NSString *post = [NSString stringWithFormat:@"email=%@&pass=%@",email,password];
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSURL *registerUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",commonURL,loginURL]];
        
        [jsonObject postMethodForServiceRequestWithPostData:postData andWithPostUrl:registerUrl];
    
    }

}

-(void)didReceiveResponseFromWebService:(NSDictionary *)responseDictionary
{
    
    if (isLoginDetails == YES)
    {
        NSString*firstNamme;
        NSString * profilePicUrl;
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
        }
        

    }
    else
    {
        if ([[[responseDictionary valueForKey:@"Response"]valueForKey:@"ResponseInfo"] isEqualToString:@"SUCCESS"])
        {
            [[NSUserDefaults standardUserDefaults]setObject:[[responseDictionary valueForKey:@"Response"]valueForKey:@"user_id"] forKey:@"loginId"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [self alertView:@"SUCCESS"];
        }
        
        else
        {
            
            [self alertView:@"FAIL"];
        }
        

        
    }
       [appDelegateObj stopIndicators];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    
    if ([alertView.message isEqualToString:@"SUCCESS"])
    {
        
        [self requestForUserDetailsFromServer];
        
        
    }
}


-(void)requestForUserDetailsFromServer
{
    isLoginDetails = YES;
    if ([appDelegateObj connectedToInternet])
    {
        [appDelegateObj startIndicator];
//        [jsonObject getMethodforServiceRequest:[NSString stringWithFormat:@"http://182.75.34.62/MySportsShare/web_services/get_profile_info.php?user_id=%@&login_user_id=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"loginId"],[[NSUserDefaults standardUserDefaults] objectForKey:@"loginId"]]];
        
        [jsonObject getMethodforServiceRequest:[NSString stringWithFormat:@"%@%@user_id=%@&login_user_id=%@",commonURL,getProfileInfo,[[NSUserDefaults standardUserDefaults] objectForKey:@"loginId"],[[NSUserDefaults standardUserDefaults] objectForKey:@"loginId"]]];
        
    }
    
    else{
        
        [self alertView:@"unabletogetUserDetails"];
    }
    
    
}

-(void)alertView:(NSString *)discripation
{
    SuccessAlert = [[UIAlertView alloc]initWithTitle:@"Login" message:discripation delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [SuccessAlert show];
    SuccessAlert = nil;
}
@end
