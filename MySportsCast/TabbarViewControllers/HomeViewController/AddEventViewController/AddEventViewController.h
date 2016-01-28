//
//  AddEventViewController.h
//  MySportsCast
//
//  Created by SPARSHMAC08 on 24/08/15.
//  Copyright (c) 2015 SPARSHMAC08. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"
#import "UIScrollView+TPKeyboardAvoidingAdditions.h"
#import "PhotoTweaksViewController.h"
#import "NIDropDown.h"
#import "JsonClass.h"

@interface AddEventViewController : UIViewController<WebServiceProtocol,NIDropDownDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UIAlertViewDelegate>
{
    JsonClass *jsonObject;
    NIDropDown *dropDown;
    UIDatePicker *Datepicker;
//    NIDropDown *eventTypeDropDown;
    
}

@property (weak, nonatomic) IBOutlet UIButton *addPhotoButton;

- (IBAction)postButtonClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *buttonAwayTeam2;
@property (weak, nonatomic) IBOutlet UIButton *buttonAwayTema1;
@property (weak, nonatomic) IBOutlet UIButton *buttonHomeTeam2;

@property (weak, nonatomic) IBOutlet UIButton *buttonHomeTeam1;

@property (weak, nonatomic) IBOutlet UIView *invitePeopleView;
@property (weak, nonatomic) IBOutlet UIButton *buttonStartDate;
@property (weak, nonatomic) IBOutlet UIButton *buttonStartTime;
@property (weak, nonatomic) IBOutlet UIButton *buttonEndDate;
@property (weak, nonatomic) IBOutlet UIButton *buttonEndTime;

@property (weak, nonatomic) IBOutlet UIButton *selectSportsBtnObj;
@property (weak, nonatomic) IBOutlet UITextField *eventTypeTF;
@property (weak, nonatomic) IBOutlet UITextField *selectTeam1TF;
@property (weak, nonatomic) IBOutlet UITextField *selectTeam2TF;
@property (weak, nonatomic) IBOutlet UITextView *descriptionText;
@property (weak, nonatomic) IBOutlet UITextField *addLocationTF;
@property (weak, nonatomic) IBOutlet UITextField *subLocationTF;
@property (weak, nonatomic) IBOutlet UIButton *eventTypeButtonObj;
@property (weak, nonatomic) IBOutlet UIImageView *addEventImg;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectTeamTopSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectTeamHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectTeam1HeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *homeRadioBtnTopSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *homeRadioBtnHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectTeam2TopSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectTeam2HeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectTeam2HomeBtnConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectTeam2HomeBtnHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectTeam1HomeLblTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectTeam1HomeLblHeightConstaint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectTeam1AwayBtnTopConstarint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectTeam1AwayBtnHeightConstarint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectTeam1AwayLblTopSpaceConstaint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectTeam1AwayTopSpaceHeightConstaint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectTeam2HomeLblTopSpaceConstaint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectTeam2HeightLblConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectTeam2AwayBtnTopSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectTeam2BtnHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectTeam2AwayLblTopSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectTeam2AwayLblHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectTeam2SeperatorGapConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectTeam2SeperatorGapHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectTeam1SeperatorTopSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectTeam1SeperatorHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *evenImgTopSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addEventImgHeight;
@property (weak, nonatomic) IBOutlet UIView *uploadImgBtnView;
@property (weak, nonatomic) IBOutlet UIScrollView *inviteUsersScrollView;

- (IBAction)backButtonClicked:(id)sender;
- (IBAction)selectSportButtonAction:(id)sender;
- (IBAction)eventTypeButtonAction:(id)sender;
- (IBAction)selectTeamRadioBtnAction:(id)sender;
- (IBAction)selectTeam2BtnAction:(id)sender;
- (IBAction)startDateButtonAction:(id)sender;
- (IBAction)startTimeButtonAction:(id)sender;
- (IBAction)endDateButtonAction:(id)sender;
- (IBAction)endTimeBtnAction:(id)sender;
- (IBAction)addEventBtnAction:(id)sender;
- (IBAction)inviteUsersBtnAction:(id)sender;

@end
