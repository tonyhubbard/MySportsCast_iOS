//
//  LoginWithEmailViewController.h
//  MySportsCast
//
//  Created by Vardhan on 20/08/15.
//  Copyright (c) 2015 SPARSHMAC08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginWithEmailViewController : UIViewController


@property (weak, nonatomic) IBOutlet UITextField *textFieldEmailId;

@property (weak, nonatomic) IBOutlet UITextField *textfiledPassword;
- (IBAction)loginButtonClicked:(id)sender;

- (IBAction)forGetPasswordClicked:(id)sender;

@end
