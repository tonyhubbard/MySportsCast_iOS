//
//  EditProfileViewController.m
//  MySportsCast
//
//  Created by SPARSHMAC03 on 31/08/15.
//  Copyright (c) 2015 SPARSHMAC08. All rights reserved.
//

#import "EditProfileViewController.h"
#import "UIImageView+Network.h"
#import "JsonClass.h"
#import "Constants.h"
#import "AppDelegate.h"

@interface EditProfileViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,WebServiceProtocol>{
     UIImagePickerController *imagePickController;
    UIImage *checkImage;
    UIImage *unCheckImage;
    UIButton *previouslySelectedButton;
    JsonClass *jsonObject;
    BOOL submitEditProfile;
    AppDelegate * appdelegate;
    NSString *privacyType;
}

@end

@implementation EditProfileViewController
@synthesize firstName;
@synthesize userName;
@synthesize lastName;
@synthesize privateConfidential;
- (void)viewDidLayoutSubviews
{
 _scrollViewWidthConstraint.constant = self.view.frame.size.width;
    [self.view layoutSubviews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    imagePickController = [[UIImagePickerController alloc]init];
    appdelegate = [UIApplication sharedApplication].delegate;
    imagePickController.delegate = self;
    checkImage = [UIImage imageNamed:@"edit_profile_radio_selected.png"];
    
    unCheckImage = [UIImage imageNamed:@"edit_profile_radiobutton.png"];
    
//    previouslySelectedButton = _everyOneButtonObj;
    
    jsonObject = [[JsonClass alloc] init];
    
    jsonObject.delegate = self;
    
//   [jsonObject getMethodforServiceRequest:[NSString stringWithFormat:@"http://182.75.34.62/MySportsShare/web_services/get_user_details.php?user_id=%@&login_user_id=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"loginId"],[[NSUserDefaults standardUserDefaults] objectForKey:@"loginId"]]];
    
    [jsonObject getMethodforServiceRequest:[NSString stringWithFormat:@"%@%@user_id=%@&login_user_id=%@",commonURL,getUserDetails,[[NSUserDefaults standardUserDefaults] objectForKey:@"loginId"],[[NSUserDefaults standardUserDefaults] objectForKey:@"loginId"]]];
    
    
    
    _profileImg.layer.cornerRadius = _profileImg.frame.size.width/2;
    
    _profileImg.clipsToBounds = YES;
    
    submitEditProfile = NO;
    
//        privacyType = @"public";
}
- (void)viewWillAppear:(BOOL)animated{

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)submitButtonAction:(id)sender {
    
    [self dismissKeyboardIfPresent];
    BOOL validate = [self validateProfileDetails];
    if (validate == FALSE)
        return;
    else
    {
        submitEditProfile = YES;
        [appdelegate startIndicator];
        [self callSubmitService];
    }
    
}
- (void)callSubmitService{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"loginId"] forKey:@"user_id"];
    [dict setObject:self.firstName.text forKey:@"first_name"];
    [dict setObject:self.lastName.text forKey:@"last_name"];
    [dict setObject:privacyType forKey:@"privacy_type"];
    [dict setObject:self.userName.text forKey:@"username"];
  
    NSData *imageData = UIImagePNGRepresentation(_profileImg.image);
    NSString *base64String = [imageData base64EncodedStringWithOptions:0];
    
    NSString* encodedString = [base64String stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];

    [dict setObject:encodedString forKey:@"profile_image"];
    
    NSString *postStr = [NSString stringWithFormat:@"user_id=%@&first_name=%@&last_name=%@&privacy_type=%@&username=%@&profile_image=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"loginId"],self.firstName.text,self.lastName.text,privacyType,self.userName.text,encodedString];
    
    [jsonObject postRegisterDetails:postStr withUrlString:[NSString stringWithFormat:@"%@%@",commonURL,updateProfileUrl]];
}

- (BOOL)validateProfileDetails
{
    BOOL anyTextFieldIsEmpty =  (self.firstName.text.length == 0) ||
    (self.lastName.text.length == 0) ||
    (self.userName.text.length == 0) ||
    (_profileImg.image == nil);
    
    if (anyTextFieldIsEmpty) {
        [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please fill the complete details." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        return FALSE;
    }
    return TRUE;
    
}
- (void)dismissKeyboardIfPresent
{
    // If a textField is first responder then resign it.
    if ([self.firstName isFirstResponder])
        [self textFieldShouldReturn:self.firstName];
    else if ([self.lastName isFirstResponder])
        [self textFieldShouldReturn:self.lastName];
    else if ([self.userName isFirstResponder])
        [self textFieldShouldReturn:self.userName];
    else if ([self.privateConfidential isFirstResponder])
        [self textFieldShouldReturn:self.privateConfidential];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)editPhotoButtonAction:(id)sender {
    
    // Display action sheet to the user with options.
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"My SportsCast"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet]; //
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Take A Picture"
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                              NSLog(@"You pressed button one");
                                                              [self addCameraActioninEditProfile];
                                                          }]; // 2
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"Select From Gallery"
                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                               NSLog(@"You pressed button two");
                                                               [self addPhotoActioninEditProfile];
                                                           }]; // 3
    
    UIAlertAction *thirdAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                              [alert dismissViewControllerAnimated:YES completion:nil];
                                                          }];
    
    [alert addAction:firstAction];
    [alert addAction:secondAction]; // 5
    [alert addAction:thirdAction];
    
    if (isipad()) {
        UIPopoverPresentationController *popPC = alert.popoverPresentationController;
        popPC.permittedArrowDirections = UIPopoverArrowDirectionAny;
        popPC.sourceView =self.editPhotoButton;
        popPC.sourceRect = self.editPhotoButton.bounds;
        [self presentViewController:alert animated:YES completion:nil];
    }else
    {
        [self presentViewController:alert animated:YES completion:nil]; //
    }
}

-(void)addCameraActioninEditProfile{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        imagePickController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePickController animated:YES completion:nil];
    }
}
-(void)addPhotoActioninEditProfile{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        imagePickController.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickController animated:YES completion:nil];
    }
    
}
- (IBAction)radioButtonAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 111) {
        
        privacyType = @"friends";
        [self.followersOnlyBtnObj setImage:checkImage forState:UIControlStateNormal];
        [self.everyOneButtonObj setImage:unCheckImage forState:UIControlStateNormal];
        
    }else{
        
        
        privacyType = @"public";
        [self.followersOnlyBtnObj setImage:unCheckImage forState:UIControlStateNormal];
        [self.everyOneButtonObj setImage:checkImage forState:UIControlStateNormal];
        
    }
    
  /*
   
    [previouslySelectedButton setBackgroundImage:unCheckImage forState:UIControlStateNormal];
    
    if([btn.currentBackgroundImage isEqual:checkImage]){
        
     [btn setBackgroundImage:unCheckImage forState:UIControlStateNormal];
    }
    else{
        if (btn.tag == 111) {
            privacyType = @"friends";
        }else{
            privacyType = @"public";
        }
        [btn setBackgroundImage:checkImage forState:UIControlStateNormal];
    }
    previouslySelectedButton =  btn;
   */

}
#pragma mark - ActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex)
    {
        // Enable Camera to take a Snap.
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            imagePickController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePickController animated:YES completion:nil];
        }
    }
    else if (1 == buttonIndex)
    {
        // Open photo gallery to choose a picture.
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        {
            imagePickController.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePickController animated:YES completion:nil];
        }
    }
}

#pragma mark - UIPickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIGraphicsBeginImageContext(CGSizeMake(60,60));
    [[info objectForKey:UIImagePickerControllerOriginalImage] drawInRect: CGRectMake(0, 0, 60, 60)];
    UIImage *profilePic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    _profileImg.layer.cornerRadius = _profileImg.frame.size.width/2;
    _profileImg.clipsToBounds = YES;
    _profileImg.image = profilePic;
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
#pragma mark - WebServiceDelegateMethod

- (void)didReceiveResponseFromWebService:(NSDictionary *)responseDictionary
{
    
    if ([[[responseDictionary objectForKey:@"Response"] objectForKey:@"ResponseInfo"]isEqualToString:@"SUCCESS"]) {
        if (submitEditProfile) {
            
            [[NSUserDefaults standardUserDefaults] setObject:[[responseDictionary objectForKey:@"Response"] objectForKey:@"OLD_ID"] forKey:@"old_userid"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            dispatch_queue_t getDbSize = dispatch_queue_create("getDbSize", NULL);
            dispatch_queue_t main = dispatch_get_main_queue();
            
            dispatch_async(getDbSize, ^(void)
                           {
                               dispatch_async(main, ^{
                                   
                                   [appdelegate stopIndicators];
                                   [self.navigationController popViewControllerAnimated:YES];
                               });
                           });
           
            
        }else{
            self.firstName.text = [NSString stringWithFormat:@"%@",[[[responseDictionary objectForKey:@"Response"] objectForKey:@"user_details"] objectForKey:@"first_name"]];
            self.lastName.text = [[[responseDictionary objectForKey:@"Response"] objectForKey:@"user_details"] objectForKey:@"last_name"];
            self.userName.text = [[[responseDictionary objectForKey:@"Response"] objectForKey:@"user_details"] objectForKey:@"username"];
            self.privateConfidential.text = [[[responseDictionary objectForKey:@"Response"] objectForKey:@"user_details"] objectForKey:@"email"];
            [_profileImg loagImageFromURL:[[[responseDictionary objectForKey:@"Response"] objectForKey:@"user_details"] objectForKey:@"profile_image"]];
            
            privacyType = [[[responseDictionary valueForKey:@"Response"]valueForKey:@"user_details"]valueForKey:@"privacy_type"];
            
            
            if ([privacyType isEqualToString:@"friends"]) {
                
                [self.followersOnlyBtnObj setImage:checkImage forState:UIControlStateNormal];
                [self.everyOneButtonObj setImage:unCheckImage forState:UIControlStateNormal];
//                previouslySelectedButton = _followersOnlyBtnObj;
            }
            else{
                
                [self.followersOnlyBtnObj setImage:unCheckImage forState:UIControlStateNormal];
                [self.everyOneButtonObj setImage:checkImage forState:UIControlStateNormal];
//                previouslySelectedButton = _everyOneButtonObj;
                
            }
        }
    }
}
@end
