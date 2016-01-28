//
//  EditProfileViewController.h
//  MySportsCast
//
//  Created by SPARSHMAC03 on 31/08/15.
//  Copyright (c) 2015 SPARSHMAC08. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"

@interface EditProfileViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *profileImg;
@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *lastName;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *privateConfidential;
@property (weak, nonatomic) IBOutlet UIButton *everyOneButtonObj;
@property (weak, nonatomic) IBOutlet UIButton *editPhotoButton;


@property (weak, nonatomic) IBOutlet UIButton *followersOnlyBtnObj;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewWidthConstraint;
- (IBAction)editPhotoButtonAction:(id)sender;
- (IBAction)radioButtonAction:(id)sender;
- (IBAction)backButtonClicked:(id)sender;

- (IBAction)submitButtonAction:(id)sender;

@end
