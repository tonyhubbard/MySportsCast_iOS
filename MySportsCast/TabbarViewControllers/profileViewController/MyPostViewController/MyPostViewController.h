//
//  MyPostViewController.h
//  MySportsCast
//
//  Created by SPARSHMAC08 on 30/09/15.
//  Copyright © 2015 SPARSHMAC08. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import "PhotoTweaksViewController.h"

@interface MyPostViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,PhotoTweaksViewControllerDelegate,UIDocumentInteractionControllerDelegate>
{
    SLComposeViewController * Composercontroller;
}
@property (weak, nonatomic) IBOutlet UITableView *tableViewMyPost;
@property (nonatomic, retain) UIDocumentInteractionController *dicInteractionVC;
@property BOOL isMediaFromNotification;
@property (strong,nonatomic) NSString * notificationMediaType;
@property (strong,nonatomic) NSString * mediaIdFormNotifcationScreen;
- (IBAction)backButtonClicked:(id)sender;
@property(strong,nonatomic)NSString * eventCastType;
@property(strong,nonatomic)NSString * eventResponceKey;
@property (strong,nonatomic)UIImage * editImage;

@end
