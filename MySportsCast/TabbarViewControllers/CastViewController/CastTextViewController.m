//
//  CastTextViewController.m
//  MySportsCast
//
//  Created by SPARSHMAC08 on 09/09/15.
//  Copyright (c) 2015 SPARSHMAC08. All rights reserved.
//
#import "EventDestialsViewController.h"
#import "CastTextViewController.h"
#import "AppDelegate.h"
#import "JsonClass.h"
#import "Constants.h"
@interface CastTextViewController ()<WebServiceProtocol>
{
    JsonClass * jsonObj;
    AppDelegate * appdelegate;
}
@end

@implementation CastTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    appdelegate = [UIApplication sharedApplication].delegate;
    
    self.textViewCast.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.textViewCast.layer.borderWidth = 1.0f;
    
    jsonObj = [[JsonClass alloc]init];
    
    jsonObj.delegate = self;
  
    NSData * data = [[NSUserDefaults standardUserDefaults]valueForKey:@"eventDeatils"];
    
    NSDictionary * eventsdic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    self.textFiledCast.text  =[NSString stringWithFormat:@" %@",[eventsdic valueForKey:@"EventName"]];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)backButton:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)buttonSearch:(id)sender
{
    
}

- (IBAction)buttonInstagram:(id)sender
{
    UIImageView * imageview = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 350, 350)];
    
    imageview.image = [UIImage imageNamed:@"splash_screen_inner.jpg"];
    
    CGFloat cropVal = (imageview.image.size.height > imageview.image.size.width ? imageview.image.size.width : imageview.image.size.height);
    
    
    cropVal *= [imageview.image scale];
    
    CGRect cropRect = (CGRect){.size.height = cropVal, .size.width = cropVal};
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([imageview.image CGImage], cropRect);
    
    NSData *imageData = UIImageJPEGRepresentation([UIImage imageWithCGImage:imageRef], 1.0);
    CGImageRelease(imageRef);
    
    NSString *writePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"instagram.igo"];
    
    if (![imageData writeToFile:writePath atomically:YES]) {
        // failure
        NSLog(@"image save failed to path %@", writePath);
        return;
    } else {
        // success.
    }
    
    // send it to instagram.
    NSURL *fileURL = [NSURL fileURLWithPath:writePath];
    self.dicInteractionVC = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
    self.dicInteractionVC.delegate = self;
    [self.dicInteractionVC setUTI:@"com.instagram.MySportsCast"];
    
    // [self.dic setAnnotation:@{@"InstagramCaption" : @"https://play.google.com/store/apps/details?id=idreammedia.ramcharanstar&hl=en"}];
    
    self.dicInteractionVC.annotation = [NSDictionary dictionaryWithObject:@"MySportsCast" forKey:@"InstagramCaption"];
    
    
    [self.dicInteractionVC presentOpenInMenuFromRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) inView:self.view animated:YES];
}

- (UIDocumentInteractionController *) setupControllerWithURL: (NSURL*) fileURL usingDelegate: (id <UIDocumentInteractionControllerDelegate>) interactionDelegate {
    NSLog(@"file url %@",fileURL);
    UIDocumentInteractionController *interactionController = [UIDocumentInteractionController interactionControllerWithURL: fileURL];
    interactionController.delegate = interactionDelegate;
    
    return interactionController;
}



- (IBAction)buttonTwitter:(id)sender {
    
    controller=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    [controller setInitialText:@"MySportsCast"];
    
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)buttonFaceBook:(id)sender {
    
    controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    
    [controller setInitialText:@"MySportsCast"];
    
    [self presentViewController:controller animated:YES completion:Nil];
    
}

- (IBAction)buttonBroadCast:(id)sender {
    
    
    if ([self.textViewCast.text isEqualToString:@""])
    {
        
        [self alertViewShow:@"Please Enter Comment Cast"];
    }
    else{
        
        if ([appdelegate connectedToInternet])
        {
            [appdelegate startIndicator];
            
//            [appdelegate.indicator setLabelText:@"commenting..."];
            
            NSString * userId = [[NSUserDefaults standardUserDefaults]valueForKey:@"loginId"];
            
            NSData * data = [[NSUserDefaults standardUserDefaults]valueForKey:@"eventDeatils"];
            
            NSDictionary * eventsdic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            
            NSString * eventId = [eventsdic valueForKey:@"EventId"];
            
            NSString * castText = self.textViewCast.text;
            
            [jsonObj getMethodforServiceRequest:[NSString stringWithFormat:@"%@add_cast_to_event.php?user_id=%@&event_id=%@&cast_info=%@",commonURL,userId,eventId,castText]];
            
        }
       
    }
   
}

#pragma mark - WebServiceDelegate

-(void)didReceiveResponseFromWebService:(NSDictionary *)responseDictionary
{
    [appdelegate stopIndicators];
    
    NSLog(@"%@",responseDictionary);
    
    NSString * responceString = [[responseDictionary valueForKey:@"Response"]valueForKey:@"ResponseInfo"];
    
    if ([responceString isEqualToString:@"SUCCESS"])
    {
        NSArray * arrayViewController = self.navigationController.viewControllers;
        
        for (int i = 0; i<[arrayViewController count]; i++)
        {
            UIViewController * particularView = [arrayViewController objectAtIndex:i];
            
            if ([particularView isKindOfClass:[EventDestialsViewController class]])
            {
                [self.navigationController popToViewController:particularView animated:YES];
                
                i = (int)arrayViewController.count;
                
            }
            else
            {
                
            }
        }
    }
    
    
}

#pragma mark - textViewDelegate

#define MAX_LENGTH 140


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }

    if (textView.text.length >= MAX_LENGTH && range.length == 0)
    {
        return NO; // return NO to not change text
    }
    else
    {
        return YES;
    }
 
}

-(void)alertViewShow:(NSString *)alertMessage
{
    
    UIAlertView *globalAlertView = [[UIAlertView alloc]initWithTitle:@"MySportsCast" message:alertMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [globalAlertView show];
    globalAlertView  = nil;
    
    
}


@end
