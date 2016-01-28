//
//  ForgotPasswordViewController.m
//  MySportsCast
//
//  Created by SPARSHMAC08 on 21/08/15.
//  Copyright (c) 2015 SPARSHMAC08. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "JsonClass.h"
#import "AppDelegate.h"
#import "Constants.h"

@interface ForgotPasswordViewController ()<WebServiceProtocol>

{
    
    AppDelegate * appdelegate;
    JsonClass * jsonObject;
    
    
    
}
@property (weak, nonatomic) IBOutlet UITextField *textFiledEmail;

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    
    self.navigationController.navigationBar.hidden = YES;
    appdelegate =[UIApplication sharedApplication].delegate;
    jsonObject = [[JsonClass alloc]init];
    jsonObject.delegate = self;
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
- (IBAction)buttonRestClicked:(id)sender {
    
    
     [appdelegate startIndicator];
    if (![appdelegate connectedToInternet])
    {
        [appdelegate stopIndicators];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Connection Failed" message:@"No internet connection available." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        alert = nil;
    }
    else
    {
        
//        [jsonObject getMethodforServiceRequest:[NSString stringWithFormat:@"http://182.75.34.62/MySportsShare/web_services/forgot_password.php?email=%@",self.textFiledEmail.text]];
        
        [jsonObject getMethodforServiceRequest:[NSString stringWithFormat:@"%@%@email=%@",commonURL,forgetPassword,self.textFiledEmail.text]];
      
        
        
    }
   
    
}

#pragma WebServiceDelegate

-(void)didReceiveResponseFromWebService:(NSDictionary *)responseDictionary{
    
    NSLog(@"%@",responseDictionary);
    
    if ([[[responseDictionary valueForKey:@"Response"]valueForKey:@"ResponseInfo"] isEqualToString:@"SUCCESS"]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"SUCCESS" message:@"Please Check Your Email" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        alert = nil;
        [appdelegate stopIndicators];
    }
    
}






@end
