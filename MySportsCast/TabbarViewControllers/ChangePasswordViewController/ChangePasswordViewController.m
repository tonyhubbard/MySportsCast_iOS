//
//  ChangePasswordViewController.m
//  MySportsCast
//
//  Created by SPARSHMAC08 on 28/10/15.
//  Copyright © 2015 SPARSHMAC08. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "AppDelegate.h"
#import "JsonClass.h"
#import "Constants.h"

@interface ChangePasswordViewController ()<WebServiceProtocol>
{
    AppDelegate * appdelegate;
    JsonClass * jsonobj;
    
    
}
@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    
    appdelegate = [UIApplication sharedApplication].delegate;
    
    jsonobj = [[JsonClass alloc]init];
    
    jsonobj.delegate = self;
    

   
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)backButtonClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)changePassword:(id)sender {
    
    if (self.tfOldPassword.text.length==0) {
      
        [self alertViewShow:@"please enter old password"];
    }
    else if  (self.tfNewPaasoword.text.length==0  ){
        
        [self alertViewShow:@"please enter new password"];
        
    }
    else if (self.tfConformPassword.text.length==0)
    {
        [self alertViewShow:@"please enter conform password"];
    }
    else if ([self.tfNewPaasoword.text isEqualToString:self.tfConformPassword.text])
    {
        
        if ( [appdelegate connectedToInternet]) {
            
            
            [appdelegate startIndicator];
            NSString * userId = [[NSUserDefaults standardUserDefaults]valueForKey:@"loginId"];
            
//            [jsonobj getMethodforServiceRequest:[NSString stringWithFormat:@"http://182.75.34.62/MySportsShare/web_services/update_password.php?user_id=%@&old_pass=%@&new_pass=%@",userId,self.tfOldPassword.text,self.tfNewPaasoword.text]];
            
            [jsonobj getMethodforServiceRequest:[NSString stringWithFormat:@"%@%@user_id=%@&old_pass=%@&new_pass=%@",commonURL,upDatePassword,userId,self.tfOldPassword.text,self.tfNewPaasoword.text]];
        }
        else
        {
            [self alertViewShow:@"No Internet Connection"];
        }
       
    }
    else{
        
        [self alertViewShow:@"password not mach"];
        
    }
    
//   http://182.75.34.62/MySportsShare/web_services/update_password.php?user_id=2&old_pass=123456&new_pass=222222
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -AlertShow

-(void)alertViewShow:(NSString *)alertMessage
{
    UIAlertView *globalAlertView = [[UIAlertView alloc]initWithTitle:@"MySportsCast" message:alertMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [globalAlertView show];
    globalAlertView  = nil;
    [appdelegate stopIndicators];
    
}

-(void)didReceiveResponseFromWebService:(NSDictionary *)responseDictionary{
    
    
    if ([[[responseDictionary valueForKey:@"Response"]valueForKey:@"ResponseInfo"] isEqualToString:@"SUCCESS"])
    {
        
        [self alertViewShow:@"Password Updated"];
      
    }
    else{
        [self alertViewShow:@"Old Password wrong"];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.message isEqualToString:@"Password Updated"]) {
        
      [self.navigationController popViewControllerAnimated:YES];

    }
}
@end
