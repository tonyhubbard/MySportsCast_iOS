//
//  RegistraionViewController.m
//  MySportsCast
//
//  Created by SPARSHMAC08 on 19/08/15.
//  Copyright (c) 2015 SPARSHMAC08. All rights reserved.
//

#import "RegistraionViewController.h"
#define kKeyboardOffsetY 50.0f
#import "JsonClass.h"
#import "AppDelegate.h"
#import "PhotoTweaksViewController.h"
#import "HomeViewController.h"
#import "LoginWithEmailViewController.h"
#import "Base64.h"
#import "WebViewController.h"
#import "Constants.h"


@interface RegistraionViewController ()<WebServiceProtocol,UIActionSheetDelegate,PhotoTweaksViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>

{
    NSArray * arrayRegisterItems;
    NSString * firstName;
    NSString * lastName;
    NSString * email;
    NSString * password;
    NSString * reenterPassword;
    AppDelegate *appDelegateObj;
    JsonClass * jsonObject;
    UIImagePickerController * imagePickerController;
    UIImageView * imageViewProfile;
    NSString * mediaFile;
    BOOL isChecked;
    UIButton * checkButton;
    
    
    
}
@end

@implementation RegistraionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arrayRegisterItems = @[@"First Name",@"Last Name",@"Email id",@"Password",@"Conform Password",@"Terms and conditions"];
    appDelegateObj = (AppDelegate *)[UIApplication sharedApplication].delegate;
    jsonObject = [[JsonClass alloc]init];
    jsonObject.delegate = self;
    firstName = [[NSString alloc]init];
    lastName = [[NSString alloc]init];
    email = [[NSString alloc]init];
    password = [[NSString alloc]init];
    reenterPassword = [[NSString alloc]init];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)checkButtonClicked
{
    if (isChecked == YES) {
        
        [checkButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        isChecked =  NO;
       
    }
    else{
        
        isChecked =  YES;
        [checkButton setImage:[UIImage imageNamed:@"tick.png"] forState:UIControlStateNormal];

    }
    

}

#pragma mark - TabelViewDelegateMethods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayRegisterItems count];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    for (UITextField * tf in cell.contentView.subviews)
    {
        if ([tf isKindOfClass:[UITextField class]])
        {
            [tf removeFromSuperview];
        }
    }
    for (UIButton * tf in cell.contentView.subviews)
    {
        if ([tf isKindOfClass:[UIButton class]])
        {
            [tf removeFromSuperview];
        }
    }
    
    UITextField * textFiled = [[UITextField alloc]init];
   
    if (indexPath.row == 5) {
        
        checkButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 5, 30, 30)];
        checkButton.backgroundColor = [UIColor whiteColor];
        checkButton.layer.borderColor = [UIColor blackColor].CGColor;
        checkButton.layer.borderWidth = 1.0f;
        
        [checkButton addTarget:self action:@selector(checkButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
//        if (isChecked == NO) {
//            
//            [checkButton setImage:[UIImage imageNamed:@"tick.png"] forState:UIControlStateNormal];
//        }
//        else{
//            
//            [checkButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//        }
        
        
        textFiled = [[UITextField alloc]initWithFrame:CGRectMake(50, 0, self.tableviewRegistrtion.frame.size.width-20, 44)];
        
        textFiled.userInteractionEnabled = NO;
    }
    else{
      textFiled = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, self.tableviewRegistrtion.frame.size.width-20, 44)];
        textFiled.userInteractionEnabled = YES;
    }
    
    
    textFiled.placeholder = [arrayRegisterItems objectAtIndex:indexPath.row];
    
    if ([textFiled.placeholder isEqualToString:@"Password"]||[textFiled.placeholder isEqualToString:@"Conform Password"])
    {
        [textFiled setSecureTextEntry:YES];
    }
    
    [textFiled setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    textFiled.delegate = self;
    
    [cell.contentView addSubview:textFiled];
    [cell.contentView addSubview:checkButton];
    textFiled = nil;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 90;
    //check ipad header Size
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 50;
    
    
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    @autoreleasepool {
        
        UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableviewRegistrtion.frame.size.width, 90)];
        
        
        headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"profile_pic_bg.jpg"]];
        
        imageViewProfile = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 70, 70)];
       
        
        imageViewProfile.image = [UIImage imageNamed:@"ProfilePic.png"];
        
        imageViewProfile.layer.cornerRadius = 70/2;
        
        imageViewProfile.layer.masksToBounds = YES;
        
        
        imageViewProfile.userInteractionEnabled = YES;
        
        
        UILabel * labelAddphoto = [[UILabel alloc]initWithFrame:CGRectMake(imageViewProfile.frame.size.width+10+5, 25, 100, 40)];
        labelAddphoto.text = @"Add Photo";
        labelAddphoto.textColor = [UIColor whiteColor];
        
        labelAddphoto.font = [UIFont systemFontOfSize:19];
        
        [headerView addSubview:imageViewProfile];
        [headerView addSubview:labelAddphoto];
        
        UITapGestureRecognizer * tapGeture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture)];
        [headerView addGestureRecognizer:tapGeture];
        return headerView;
    }
    
    
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    @autoreleasepool {
        
        UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableviewRegistrtion.frame.size.width, 50)];
        
        
        footerView.backgroundColor = [UIColor whiteColor];
        
        UIButton * submitButton =[[UIButton alloc]initWithFrame:CGRectMake(10, 10, footerView.frame.size.width-20, 40)];
        [submitButton setBackgroundImage:[UIImage imageNamed:@"submit_btn.png"] forState:UIControlStateNormal];
        [submitButton addTarget:self action:@selector(submitBUttonClicked) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:submitButton];
        
        return footerView;
    }
    
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row ==  5) {
        
        WebViewController * webVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
        [self.navigationController pushViewController:webVC animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    }
}


-(void)submitBUttonClicked
{
   
    NSLog(@"submitClicked");
    [UIView animateWithDuration:0.3 animations:^{
        self.tableviewRegistrtion.frame = CGRectMake(0.0f, self.view.frame.origin.y+64, self.tableviewRegistrtion.frame.size.width, self.tableviewRegistrtion.frame.size.height);
    }];

    [self registerUserWithUserFirstName:firstName withLastName:lastName withpassword:password withReenterPassword:reenterPassword withEmail:email uploadUserImage:imageViewProfile.image];
}

-(void)tapGesture
{
    
    NSLog(@"tapGesture");
    
    UIActionSheet * pickPhotoActionSheet = [[UIActionSheet alloc]initWithTitle:@"Profile Pick" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Pick from gallery",@"Pick from camera", nil];
    pickPhotoActionSheet.delegate = self;
    [pickPhotoActionSheet showInView:self.view];

}

#pragma mark - actionSheetDelegate

- (void)actionSheet:(UIActionSheet *)myActionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex {
    imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    if (buttonIndex == 0) {
        
        imagePickerController.sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        //[self presentViewController:imagePickerController animated:YES completion:nil];
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
    else if (buttonIndex == 1)
    {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
        else{
           
            [self alertView:@"There is no camera avilable"];
        }
        
    }
    
}


#pragma mark - textFiledDelegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSString * stringToRange = [textField.text substringWithRange:NSMakeRange(0,range.location)];
    
    // Appending the currently typed charactor
    stringToRange = [stringToRange stringByAppendingString:string];
    
    // Processing the last typed word
    NSArray *wordArray       = [stringToRange componentsSeparatedByString:@" "];
    NSString * wordTyped     = [wordArray lastObject];
    
    // wordTyped will give you the last typed object
    

    if ([textField.placeholder isEqualToString:@"First Name"]) {
        
        NSLog(@"firstName String:%@",wordTyped);
        firstName = wordTyped;
        
    }
    else if ([textField.placeholder isEqualToString:@"Last Name"])
    {
        NSLog(@"lastName String:%@",wordTyped);
        lastName = wordTyped;
    }
  
    else if ([textField.placeholder isEqualToString:@"Email id"])
    {
        NSLog(@"Email id String:%@",wordTyped);
        email = wordTyped;
    }
    else if ([textField.placeholder isEqualToString:@"Password"])
    {
        NSLog(@"Password String:%@",wordTyped);
        password = wordTyped;
    }
    else if ([textField.placeholder isEqualToString:@"Conform Password"])
    {
        NSLog(@"Conform Password String:%@",wordTyped);
        reenterPassword = wordTyped;
        
        
        
    }
    
   
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    // get a reference to the view you want to move when editing begins
    // which can be done by setting the tag of the container view to VIEW_TAG
    
    [UIView animateWithDuration:0.3 animations:^{
        self.tableviewRegistrtion.frame = CGRectMake(0.0f, -kKeyboardOffsetY, self.tableviewRegistrtion.frame.size.width, self.tableviewRegistrtion.frame.size.height);
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
   
    [UIView animateWithDuration:0.3 animations:^{
        self.tableviewRegistrtion.frame = CGRectMake(0.0f, self.view.frame.origin.y+64, self.tableviewRegistrtion.frame.size.width, self.tableviewRegistrtion.frame.size.height);
    }];
}
#pragma mark - serviceRequestForUserRegistration


-(void)registerUserWithUserFirstName:(NSString *)firstNames withLastName:(NSString *)lastNames withpassword:(NSString * )EnterPassword withReenterPassword:(NSString *)reEnterPasswords withEmail:(NSString *)emailStrings uploadUserImage:(UIImage *)userUploaImages{
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    mediaFile = [documentsDirectory stringByAppendingPathComponent:@"savedImage.png"];
    
    if (![appDelegateObj connectedToInternet])
    {
        [self alertView:@"Please check your internet connection"];
        return;
    }
    
    if ([firstNames length] == 0) {
        [self alertView:@"Please enter first name"];
    }
    else if ([lastNames length] == 0){
        [self alertView:@"Please enter last name"];
    }
    else if ([emailStrings length] == 0){
        [self alertView:@"Please enter email"];
    }
    else if ([EnterPassword length] == 0){
        [self alertView:@"Please enter password"];
    }
    else if ([reEnterPasswords length] == 0){
        [self alertView:@"Please enter confirm password"];
    }
    else if (![self emailValidation]){
        [self alertView:@"Enter valid email id"];
    }
    
    else if (![reenterPassword isEqualToString:EnterPassword])
    {
       [self alertView:@"password Not Mach"];

    }
    else if (isChecked == NO)
    {
        [self alertView:@"Please accept terms and conditions"];
    }
    else
    
    
    {
        if (mediaFile.length == 0)
        {
            mediaFile = @"";
        }
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        [dict setObject:firstNames forKey:@"first_name"];
        [dict setObject:lastNames forKey:@"last_name"];
        [dict setObject:emailStrings forKey:@"email"];
        [dict setObject:@"" forKey:@"birth_date"];
        [dict setObject:EnterPassword forKey:@"pass"];
        [dict setObject:mediaFile forKey:@"media_file"];
        
        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",commonURL,registrationURL]];
        if ([appDelegateObj connectedToInternet])
        {
            [appDelegateObj startIndicator];
            [jsonObject postRegisterDetails:dict withImageORVideoUrl:url];
        }
        else
        {
            [self alertView:@"No internet connection"];
            
        }

//        NSData *imageData = UIImagePNGRepresentation(imageViewProfile.image);
//        
//        NSString *encodedString = [Base64 encode:imageData];
//        encodedString = [encodedString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
//        
//        NSString *postStr = [NSString stringWithFormat:@"first_name=%@&last_name=%@&email=%@&birth_date=%@&pass=%@&profile_image=%@",firstNames,lastNames,emailStrings,@"",EnterPassword,encodedString];
//        
//        [appDelegateObj startIndicator];
//        
//        [jsonObject postRegisterDetails:postStr withUrlString:[NSString stringWithFormat:@"%@%@",commonURL,registrationURL]];

    }

}

- (BOOL)emailValidation
{
    BOOL isValidEmail = FALSE;
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    if ([emailTest evaluateWithObject:email] == NO)
    {
        isValidEmail = FALSE;
        
    }
    else{
        isValidEmail = TRUE;
    }
    return isValidEmail;
}


-(void)didReceiveResponseFromWebService:(NSDictionary *)responseDictionary
{
    NSLog(@"responseDictionary:%@",responseDictionary);
    
    
    if ([[[responseDictionary valueForKey:@"Response"]valueForKey:@"ResponseInfo"] isEqualToString:@"EMAIL ALREADY EXIST"] )
    {
        // screen stay here.
        [self alertView:@"EMAIL ALREADY EXIST"];
        
        
    }
    else if ([[[responseDictionary valueForKey:@"Response"]valueForKey:@"ResponseInfo"] isEqualToString:@"SUCCESS"])
    {
        //navigate to next Screen
   
        [appDelegateObj stopIndicators];
       
        [self alertView:@"SUCCESS"];
        
    }
    else
    {
        //unableto login
    }
    
}

#pragma mark - alertViewCreation

-(void)alertView:(NSString *)alertDiscripatio
{
    UIAlertView *globalAlertView = [[UIAlertView alloc]initWithTitle:@"MySportsCast" message:alertDiscripatio delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [globalAlertView show];
    globalAlertView  = nil;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.message isEqualToString:@"SUCCESS"])
    {
        LoginWithEmailViewController * loginWithEmail = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginWithEmailViewController"];
        
        [self.navigationController pushViewController:loginWithEmail animated:YES];
        
    }
    
    
}


#pragma mark - pickerViewControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (image!= nil)
    {
        PhotoTweaksViewController *photoTweaksViewController = [[PhotoTweaksViewController alloc] initWithImage:image];
        photoTweaksViewController.delegate = self;
        photoTweaksViewController.autoSaveToLibray = NO;
        [picker pushViewController:photoTweaksViewController animated:YES];
    }
    else
    {
        
    }
    
    
}

#pragma mark - imageCropViewDelegateMethods

- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)photoTweaksController:(PhotoTweaksViewController *)controller didFinishWithCroppedImage:(UIImage *)croppedImage
{
     imageViewProfile.image =  croppedImage;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:@"savedImage.png"];
    // imageView is my image from camera
    NSData *imageData = UIImageJPEGRepresentation(imageViewProfile.image, 0.9f);
    
    [imageData writeToFile:savedImagePath atomically:NO];

    [controller.navigationController popViewControllerAnimated:YES];
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
    
    
}

- (void)photoTweaksControllerDidCancel:(PhotoTweaksViewController *)controller
{
    [controller.navigationController popViewControllerAnimated:YES];
}


@end
