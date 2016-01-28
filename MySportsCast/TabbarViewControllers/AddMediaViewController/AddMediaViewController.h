//
//  AddMediaViewController.h
//  MySportsCast
//
//  Created by SPARSHMAC08 on 24/08/15.
//  Copyright (c) 2015 SPARSHMAC08. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface AddMediaViewController : UIViewController<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIScrollView * scrollViewBottom;
    UIImagePickerController * imagepicker;
    SLComposeViewController * slController;

}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewTop;
@property (nonatomic, retain) UIDocumentInteractionController *dicInteractionVC;
@end
