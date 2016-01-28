//
//  CastVideoViewController.h
//  MySportsCast
//
//  Created by SPARSHMAC08 on 09/09/15.
//  Copyright (c) 2015 SPARSHMAC08. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
@interface CastVideoViewController : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate>

- (IBAction)backButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *videoButtonClicked;
- (IBAction)videoButtonClickedAction:(id)sender;
@property (strong,nonatomic)UIImagePickerController * imagepicker;
@end
