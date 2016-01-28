//
//  CastTextViewController.h
//  MySportsCast
//
//  Created by SPARSHMAC08 on 09/09/15.
//  Copyright (c) 2015 SPARSHMAC08. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>

@interface CastTextViewController : UIViewController<UITextViewDelegate,UIDocumentInteractionControllerDelegate>

{
    SLComposeViewController * controller;
}
- (IBAction)backButton:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *textViewCast;
@property (weak, nonatomic) IBOutlet UITextField *textFiledCast;
@property (nonatomic, retain) UIDocumentInteractionController *dicInteractionVC;


- (IBAction)buttonSearch:(id)sender;
- (IBAction)buttonInstagram:(id)sender;

- (IBAction)buttonTwitter:(id)sender;
- (IBAction)buttonFaceBook:(id)sender;

- (IBAction)buttonBroadCast:(id)sender;
@end
