//
//  EventDestialsViewController.h
//  MySportsCast
//
//  Created by Vardhan on 22/08/15.
//  Copyright (c) 2015 SPARSHMAC08. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
@interface EventDestialsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UITextFieldDelegate,UIAlertViewDelegate,UIDocumentInteractionControllerDelegate>

- (IBAction)backButtonClicked:(id)sender;
- (IBAction)shareButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *labelSelectedEventName;
@property (weak, nonatomic) IBOutlet UILabel *labelSlectedEventType;
@property (weak, nonatomic) IBOutlet UITableView *tableViewEventDeatil;
@property (nonatomic, retain) UIDocumentInteractionController *dicInteractionVC;

@property(strong,nonatomic) NSString * eventId;
@property(strong,nonatomic) NSString * eventCreatedId;
@property(strong,nonatomic)NSString * selectedEventType;
@end
