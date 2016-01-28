//
//  ChangePasswordViewController.h
//  MySportsCast
//
//  Created by SPARSHMAC08 on 28/10/15.
//  Copyright © 2015 SPARSHMAC08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePasswordViewController : UIViewController<UITextFieldDelegate>
- (IBAction)backButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *tfOldPassword;
@property (weak, nonatomic) IBOutlet UITextField *tfNewPaasoword;
@property (weak, nonatomic) IBOutlet UITextField *tfConformPassword;
- (IBAction)changePassword:(id)sender;

@end
