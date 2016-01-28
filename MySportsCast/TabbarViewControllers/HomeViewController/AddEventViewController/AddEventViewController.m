//
//  AddEventViewController.m
//  MySportsCast
//
//  Created by SPARSHMAC08 on 24/08/15.
//  Copyright (c) 2015 SPARSHMAC08. All rights reserved.
//

#import "AddEventViewController.h"
#import "PhotoTweaksViewController.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "SportsListModel.h"
#import "NIDropDown.h"
#import "TagViewController.h"
#import "Base64.h"

#define tabBarDefaultHeight 49
#define label_padding 15
#define textfield_padding 10
#define labelHeight 21
#define textfield_Height 30
#define textfield_border_width 0.3f
#define buttion_Height 30
#define padding_between_textfields 15
#define except_radio_button_height 40
#define button_font 13.0f
#define title_font 14.0f
#define dropdown_width_height 15
#define dropdown_y 7
#define dropDownPadding 20
#define radioButton_width_height 20
#define tabbar_default_height 49

@interface AddEventViewController ()<TagsCustomDelegate,PhotoTweaksViewControllerDelegate>
{
    NSMutableArray *sportsListArray;
    NSMutableArray *spoertsIdArray;
    NSMutableArray *eventTypeArray;
    UIImagePickerController *imagePickController;
    NSString * stringTagId;
    UITapGestureRecognizer * tapgesture;
    AppDelegate * appdelegate;
   
    BOOL isTime;
    BOOL isstartDateClicked;
    BOOL isStartTimeClicked;
    BOOL isPostEvent;
    
    UIView * viewAddresTableViewBackGround;
    UITableView * tableViewAddress;
    NSArray * arrayPlaceResult;
    NSString * gameType1;
    NSString * gameType2;
    NSMutableArray * invitePeopleArray;
    NSMutableArray * invitePeopelIdArray;
    NSString * sportsId;
    NSString * lat;
    NSString * lng;
    NSString * startdateAndTime;
    NSString * endDateAndTime;
    NSString* placeId;
    NSString * stringBase64Image;
    NSString * mediaFile;
    BOOL isSportType;
    NSDate * startDate;
    NSDate * endDate;
   
}
@end

@implementation AddEventViewController

-(void)viewDidLayoutSubviews
{
    _scrollViewWidthConstraint.constant = self.view.frame.size.width;
    if ([_eventTypeButtonObj.titleLabel.text isEqualToString:@"Game"]) {
        [self setConstraintValues];
    }else{
        [self resetConstraintValues];
    }
    [self.view layoutSubviews];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    startDate = [[NSDate alloc]init];
    endDate =[[NSDate alloc]init];
    arrayPlaceResult = [[NSArray alloc]init];
    stringTagId = [[NSString alloc]init];
    appdelegate  = [UIApplication sharedApplication].delegate;
    self.navigationController.navigationBar.hidden = YES;
    jsonObject = [[JsonClass alloc] init];
     sportsListArray = [[NSMutableArray alloc] init];
     spoertsIdArray = [[NSMutableArray alloc] init];
    jsonObject.delegate = self;
   gameType1 = [[NSString alloc]init];
   gameType2 = [[NSString alloc]init];
   invitePeopleArray =[[NSMutableArray alloc]init];
   invitePeopelIdArray = [[NSMutableArray alloc]init];
    
    if ([appdelegate connectedToInternet])
    {
        [appdelegate startIndicator];
        [jsonObject getMethodforServiceRequest:[NSString stringWithFormat:@"%@%@",commonURL,kSportsListUrl]];
    }
    else{
        
        [appdelegate stopIndicators];
    }
  eventTypeArray = [[NSMutableArray alloc] initWithObjects:@"Challenge",@"Event",@"Game",@"Meet Up",@"Other",@"Practice", nil];
    _descriptionText.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _descriptionText.layer.borderWidth = 1.0f;
//    _descriptionText.layer.cornerRadius = 5.0f;
    _uploadImgBtnView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _uploadImgBtnView.layer.borderWidth = 1.0f;
//    _uploadImgBtnView.layer.cornerRadius = 5.0f;
    self.invitePeopleView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.invitePeopleView.layer.borderWidth = 1.0f;
//    _inviteUsersBtnObj.layer.cornerRadius = 5.0f;
    imagePickController = [[UIImagePickerController alloc]init];
    imagePickController.delegate = self;
    _evenImgTopSpace.constant = 0;
    _addEventImgHeight.constant = 0;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM/dd/yyyy";
    NSString *string = [formatter stringFromDate:[NSDate date]];
    
    [self.buttonStartDate setTitle:string forState:UIControlStateNormal];
    [self.buttonEndDate setTitle:string forState:UIControlStateNormal];
    formatter.dateFormat = @"hh:mm a";
    NSString *resultString = [formatter stringFromDate:[NSDate date]];
    [self.buttonEndTime setTitle:resultString forState:UIControlStateNormal];
    [self.buttonStartTime setTitle:resultString forState:UIControlStateNormal];
}

-(void)viewDidAppear:(BOOL)animated
{
    
    tapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(inviteUsersBtnAction:)];
    
    [self.invitePeopleView addGestureRecognizer:tapgesture];
    
    
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    tapgesture = nil;
    gameType1 = nil;
    gameType2 = nil;
    invitePeopleArray = nil;
    invitePeopelIdArray = nil;
    
}
    
    

- (IBAction)backButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)didReceiveResponseFromWebService:(NSDictionary *)responseDictionary
{
    [appdelegate stopIndicators];
    dispatch_queue_t getDbSize = dispatch_queue_create("getDbSize", NULL);
    dispatch_queue_t main = dispatch_get_main_queue();
    if (isPostEvent == YES)
    {
        isPostEvent = NO;
        
      if ([[[responseDictionary objectForKey:@"Response"] objectForKey:@"ResponseInfo"]isEqualToString:@"SUCCESS"]) {
          
          
          dispatch_async(getDbSize, ^(void)
                         {
                             dispatch_async(main, ^{
                                 [self alertViewShow:@"Posted Successfully"];
                             });
                         });
          
      }
        else
            
        {
            dispatch_async(getDbSize, ^(void)
                          
                           {
                               dispatch_async(main, ^{
                                   
                                    [self alertViewShow:@"Unable to Post Event"];
                                   
                               });
                           });

          
        }
        
        
    }
    else{
        if ([[[responseDictionary objectForKey:@"Response"] objectForKey:@"ResponseInfo"]isEqualToString:@"SUCCESS"]) {
            
            NSArray *sportsList = [[responseDictionary objectForKey:@"Response"] objectForKey:@"sprots_list"];
            NSMutableArray *sportsArray = [[NSMutableArray alloc] init];
            for (NSDictionary *responseDict in sportsList) {
                SportsListModel *sportsModel = [SportsListModel new];
                sportsModel.max_players_on_field = [responseDict objectForKey:@"max_players_on_field"];
                sportsModel.rounds = [responseDict objectForKey:@"rounds"];
                sportsModel.sport_id = [responseDict objectForKey:@"sport_id"];
                sportsModel.sport_image = [responseDict objectForKey:@"sport_image"];
                sportsModel.sport_name = [responseDict objectForKey:@"sport_name"];
                [sportsArray addObject:sportsModel];
                
                
            }
            for (SportsListModel *sportsModel in sportsArray) {
                [sportsListArray addObject:sportsModel.sport_name];
                
            }
            for (SportsListModel *sportsModel in sportsArray)
            {
                [spoertsIdArray addObject:sportsModel.sport_id];
                
            }
            
        }

    }
    
    
    
    
    
}
- (IBAction)selectSportButtonAction:(id)sender {
    
    isSportType = YES;
    if(dropDown == nil)
    {
        CGFloat f;
        if ([sportsListArray count] >= 5) {
            f = 5 * 40;
        }
        else{
            f = [sportsListArray count] * 40;
        }
        NSArray *arrImage = [[NSArray alloc]init];
        dropDown = [[NIDropDown alloc]showDropDown:_selectSportsBtnObj :&f :sportsListArray :arrImage :@"down"];
        dropDown.delegate = self;
    }
    else {
        
        [dropDown hideDropDown:_selectSportsBtnObj];
        
        [self rel];
    }
}
-(void)rel{
    
    dropDown = nil;
}

- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    [self rel];
}

- (IBAction)eventTypeButtonAction:(id)sender {
     isSportType = NO;
    if(dropDown == nil) {
        CGFloat f;
        if ([eventTypeArray count] >= 5) {
            f = 5 * 40;
        }
        else{
            f = [eventTypeArray count] * 40;
        }
        NSArray *arrImage = [[NSArray alloc]init];
        dropDown = [[NIDropDown alloc]showDropDown:_eventTypeButtonObj :&f :eventTypeArray :arrImage :@"down"];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:_eventTypeButtonObj];
        [self rel];
    }

}
- (void)selectedDropDownValue:(NSString *)selectedStr andSelectedIndex:(NSString *)indexStr{
    
    if (isSportType == YES) {
        
        NSInteger index = [indexStr intValue];
        
        sportsId = [spoertsIdArray objectAtIndex:index];
        
        if ([selectedStr isEqualToString:@"Game"])
        {
            
        }
        else
        {
            [self resetConstraintValues];
        }
    }
    else{
        
    }
    
}
- (void)resetConstraintValues{
    _selectTeamHeightConstraint.constant = 0;
    _selectTeamTopSpaceConstraint.constant = 0;
    _selectTeam1HeightConstraint.constant = 0;
    _homeRadioBtnTopSpaceConstraint.constant = 0;
    _homeRadioBtnHeightConstraint.constant = 0;
    _selectTeam2TopSpaceConstraint.constant = 0;
    _selectTeam2HeightConstraint.constant = 0;
    _selectTeam2HomeBtnConstraint.constant = 0;
    _selectTeam2HomeBtnHeightConstraint.constant = 0;
    _selectTeam1HomeLblTopConstraint.constant = 0;
    _selectTeam1HomeLblHeightConstaint.constant = 0;
    _selectTeam1AwayBtnTopConstarint.constant = 0;
    _selectTeam1AwayBtnHeightConstarint.constant = 0;
    _selectTeam1AwayLblTopSpaceConstaint.constant = 0;
    _selectTeam1AwayTopSpaceHeightConstaint.constant = 0;
    _selectTeam2HomeLblTopSpaceConstaint.constant = 0;
    _selectTeam2HeightLblConstraint.constant = 0;
    _selectTeam2AwayBtnTopSpace.constant = 0;
    _selectTeam2BtnHeightConstraint.constant = 0;
    _selectTeam2AwayLblTopSpaceConstraint.constant = 0;
    _selectTeam2AwayLblHeightConstraint.constant = 0;
    _selectTeam2SeperatorGapConstraint.constant = 0;
    _selectTeam2SeperatorGapHeightConstraint.constant = 0;
    _selectTeam1SeperatorTopSpaceConstraint.constant = 0;
    _selectTeam1SeperatorHeightConstraint.constant = 0;
}
- (void)setConstraintValues{
    _selectTeamHeightConstraint.constant = 185;
    _selectTeamTopSpaceConstraint.constant = 17;
    _selectTeam1HeightConstraint.constant = 30;
    _homeRadioBtnTopSpaceConstraint.constant = 17;
    _homeRadioBtnHeightConstraint.constant = 31;
    _selectTeam2TopSpaceConstraint.constant = 12;
    _selectTeam2HeightConstraint.constant = 30;
    _selectTeam2HomeBtnConstraint.constant = 17;
    _selectTeam2HomeBtnHeightConstraint.constant = 31;
    _selectTeam1HomeLblTopConstraint.constant = 22;
    _selectTeam1HomeLblHeightConstaint.constant = 21;
    _selectTeam1AwayBtnTopConstarint.constant = 17;
    _selectTeam1AwayBtnHeightConstarint.constant = 31;
    _selectTeam1AwayLblTopSpaceConstaint.constant = 22;
    _selectTeam1AwayTopSpaceHeightConstaint.constant = 21;
    _selectTeam2HomeLblTopSpaceConstaint.constant = 22;
    _selectTeam2HeightLblConstraint.constant = 21;
    _selectTeam2AwayBtnTopSpace.constant = 17;
    _selectTeam2BtnHeightConstraint.constant = 31;
    _selectTeam2AwayLblTopSpaceConstraint.constant = 22;
    _selectTeam2AwayLblHeightConstraint.constant = 21;
    _selectTeam2SeperatorGapConstraint.constant = 8;
    _selectTeam2SeperatorGapHeightConstraint.constant = 1;
    _selectTeam1SeperatorTopSpaceConstraint.constant = 8;
    _selectTeam1SeperatorHeightConstraint.constant = 1;
}


#pragma mark - ButtonActions

- (IBAction)selectTeamRadioBtnAction:(id)sender
{
    UIImage * buttonImage  = self.buttonHomeTeam1.currentBackgroundImage;
    if ([buttonImage isEqual:[UIImage imageNamed:@"edit_profile_radio_selected.png"]])
    {
        [self.buttonHomeTeam1 setBackgroundImage:[UIImage imageNamed:@"edit_profile_radiobutton.png"] forState:UIControlStateNormal];
        [self.buttonAwayTema1 setBackgroundImage:[UIImage imageNamed:@"edit_profile_radio_selected.png"] forState:UIControlStateNormal];
        
        gameType1 = @"away";
        
        
        

    }
    else
    {
        
        [self.buttonAwayTema1 setBackgroundImage:[UIImage imageNamed:@"edit_profile_radiobutton.png"] forState:UIControlStateNormal];
        [self.buttonHomeTeam1 setBackgroundImage:[UIImage imageNamed:@"edit_profile_radio_selected.png"] forState:UIControlStateNormal];
        gameType1 = @"home";

    }
    
}

- (IBAction)selectTeam2BtnAction:(id)sender
{
    UIImage * buttonImage  = self.buttonHomeTeam2.currentBackgroundImage;
    if ([buttonImage isEqual:[UIImage imageNamed:@"edit_profile_radio_selected.png"]])
    {
        [self.buttonHomeTeam2 setBackgroundImage:[UIImage imageNamed:@"edit_profile_radiobutton.png"] forState:UIControlStateNormal];
        [self.buttonAwayTeam2 setBackgroundImage:[UIImage imageNamed:@"edit_profile_radio_selected.png"] forState:UIControlStateNormal];
        
        gameType2 = @"away";
        
    }
    else
    {
        
        [self.buttonAwayTeam2 setBackgroundImage:[UIImage imageNamed:@"edit_profile_radiobutton.png"] forState:UIControlStateNormal];
        [self.buttonHomeTeam2 setBackgroundImage:[UIImage imageNamed:@"edit_profile_radio_selected.png"] forState:UIControlStateNormal];
        gameType2 = @"home";
        
    }
}

- (IBAction)startDateButtonAction:(id)sender
{
    
    
    
    isTime = NO;
    isstartDateClicked = YES;
    [self datePickerCreation:@"StartDate"];
}

- (IBAction)startTimeButtonAction:(id)sender {
    
    isTime = YES;
    isStartTimeClicked = YES;
    [self datePickerCreation:@"StartTime"];
}

- (IBAction)endDateButtonAction:(id)sender {
    
    isTime = NO;
    isstartDateClicked = NO;
     [self datePickerCreation:@"EndDate"];
}

- (IBAction)endTimeBtnAction:(id)sender {
    
    isTime = YES;
    isStartTimeClicked = NO;

     [self datePickerCreation:@"EndTime"];
}

- (IBAction)addEventBtnAction:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"My SportsCast"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet]; //
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Take A Picture"
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                              NSLog(@"You pressed button one");
                                                              [self addCameraAction];
                                                          }]; // 2
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"Select From Gallery"
                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                               NSLog(@"You pressed button two");
                                                               [self addPhotoAction];
                                                           }]; // 3
    
    UIAlertAction *thirdAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                              [alert dismissViewControllerAnimated:YES completion:nil];
                                                          }];
    
    [alert addAction:firstAction];
    [alert addAction:secondAction]; // 5
    [alert addAction:thirdAction];
    
    if (isipad()) {
        UIPopoverPresentationController *popPC = alert.popoverPresentationController;
        popPC.permittedArrowDirections = UIPopoverArrowDirectionAny;
        popPC.sourceView =self.addPhotoButton;
        popPC.sourceRect = self.addPhotoButton.bounds;
        [self presentViewController:alert animated:YES completion:nil];
    }else
    {
        [self presentViewController:alert animated:YES completion:nil]; //
    }
    
}
-(void)addCameraAction{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        imagePickController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePickController animated:YES completion:nil];
    }
}
-(void)addPhotoAction{
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        imagePickController.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickController animated:YES completion:nil];
    }
    
    
    
}
- (IBAction)inviteUsersBtnAction:(id)sender
{
    
    TagViewController * tagVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TagViewController"];
    tagVC.delegate = self;
    
    tagVC.headerName = @"INVITE PEOPLE";
    tagVC.selectedValues = invitePeopleArray;
    tagVC.selecteTagIds = invitePeopelIdArray;
    
    [self.navigationController pushViewController:tagVC animated:YES];
    
    
}

#pragma mark - TagCustomDelegate

-(void)TagsSelectedId:(NSMutableArray *)selectedTagIds
{
    invitePeopelIdArray = selectedTagIds;
    
    if (selectedTagIds)
    {
        for (int a=0; a<[selectedTagIds count]; a++)
        {
            
            NSString * tempString = [selectedTagIds objectAtIndex:a];
            
            stringTagId = [stringTagId stringByAppendingString:[NSString stringWithFormat:@"%@,",tempString]];
        }
        if (stringTagId.length !=0)
        {
            stringTagId = [stringTagId substringToIndex:[stringTagId length]-1];
        }
        
    }
    
}
-(void)TagsSelectedValues:(NSMutableArray *)selectedValues
{
    invitePeopleArray = selectedValues;
    
    
    for (UIScrollView * scrollview in self.invitePeopleView.subviews)
    {
        if ([scrollview isKindOfClass:[UIScrollView class]])
        {
            [scrollview removeFromSuperview];
        }
    }
    
    UIScrollView * scrollViewTag = [[UIScrollView alloc]init];
    
    scrollViewTag.frame = CGRectMake(0, 0, self.invitePeopleView.frame.size.width, self.invitePeopleView.frame.size.height) ;
    
    
    NSLog(@"ScrolViewFrame%@",NSStringFromCGRect(scrollViewTag.frame));
    
    
    float xvalue= 5;
    float yvalue = 5;
    UILabel * labelPeople;
    
    
    
    for (int i = 0; i<[selectedValues count]; i++)
    {
        
        NSString *peopleTag = [selectedValues objectAtIndex:i];
        
        CGFloat width = [peopleTag sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17]}].width;
        
        if (xvalue+width+5<=scrollViewTag.frame.size.width)
        {
            
            labelPeople = [[UILabel alloc]initWithFrame:CGRectMake(xvalue, yvalue, width, 25)];
            xvalue = xvalue+width+5;
        }
        else
        {
            
            yvalue = yvalue+30;
            xvalue = 5;
            labelPeople = [[UILabel alloc]initWithFrame:CGRectMake(xvalue, yvalue, width, 25)];
            xvalue = xvalue+ceilf(width)+10;
            
            
        }
        labelPeople.text = [selectedValues objectAtIndex:i];
        
        labelPeople.textAlignment = NSTextAlignmentCenter;
        
        labelPeople.textColor = [UIColor blackColor];
        
        labelPeople.font = [UIFont systemFontOfSize:15];
        
        labelPeople.layer.cornerRadius = 5;
        labelPeople.layer.borderWidth = 1.0f;
        
        labelPeople.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        [scrollViewTag addSubview:labelPeople];
        
        
        
    }
    
    scrollViewTag.contentSize = CGSizeMake(scrollViewTag.frame.size.width, yvalue+50);
    
    [self.invitePeopleView addSubview:scrollViewTag];
    
   
}
#pragma mark - ActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex)
    {
        // Enable Camera to take a Snap.
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            imagePickController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePickController animated:YES completion:nil];
        }
    }
    else if (1 == buttonIndex)
    {
        // Open photo gallery to choose a picture.
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        {
            imagePickController.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePickController animated:YES completion:nil];
        }
    }
}

#pragma mark - UIPickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (image!= nil)
    {
        
        
        PhotoTweaksViewController *photoTweaksViewController = [[PhotoTweaksViewController alloc] initWithImage:image];
        photoTweaksViewController.delegate = self;
        photoTweaksViewController.autoSaveToLibray = NO;
        
        [picker presentViewController:photoTweaksViewController animated:YES completion:nil];
    }
    else
    {
        UIImage *eventPic = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        _evenImgTopSpace.constant = 15;
        _addEventImgHeight.constant = 300;
        _addEventImg.image = eventPic;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:@"savedImage.png"];
        // imageView is my image from camera
        NSData *imageData = UIImageJPEGRepresentation(_addEventImg.image, 0.9f);
        
        [imageData writeToFile:savedImagePath atomically:NO];
        
        
        
        
        [picker dismissViewControllerAnimated:YES completion:nil];
    }

    
    
}
#pragma mark - imageCropViewDelegateMethods

- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)photoTweaksController:(PhotoTweaksViewController *)controller didFinishWithCroppedImage:(UIImage *)croppedImage
{
    
    [controller dismissViewControllerAnimated:YES completion:^{
        
        [imagePickController dismissViewControllerAnimated:YES completion:^{
     
      
            _evenImgTopSpace.constant = 15;
            
            _addEventImgHeight.constant = 300;
            
            _addEventImg.image = croppedImage;
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            
            NSString *documentsDirectory = [paths objectAtIndex:0];
            
            NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:@"savedImage.png"];
            
            // imageView is my image from camera
            NSData *imageData = UIImageJPEGRepresentation(_addEventImg.image, 0.9f);
            NSLog(@"Size of Image(bytes):%lu",(unsigned long)[imageData length]);
            [imageData writeToFile:savedImagePath atomically:NO];
          
            
        }];
    
    }];
    
    
    
}
- (void)photoTweaksControllerDidCancel:(PhotoTweaksViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - DatePickerCreation

-(void)datePickerCreation:(NSString *)alertDiscriation
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ADD EVENT" message:alertDiscriation delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    
    Datepicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(10, alert.bounds.size.height, 200, 216)];
    
    
    if (isstartDateClicked == NO)
    {
        Datepicker.minimumDate = startDate;
        [Datepicker setDate:startDate];
    }
    else{
        
        [Datepicker setDate:startDate];
    }
    Datepicker.datePickerMode = UIDatePickerModeDateAndTime;
    if (isTime == YES)
    {
        Datepicker.datePickerMode = UIDatePickerModeTime;

    }
    else
    {
        Datepicker.datePickerMode = UIDatePickerModeDate;

    }
    [alert addSubview:Datepicker];
    
    
    
    alert.bounds = CGRectMake(10, 0, self.view.frame.size.width-20, alert.bounds.size.height + 216 + 20);
    [Datepicker addTarget:self
               action:@selector(LabelChange:)
     forControlEvents:UIControlEventValueChanged];
    
    
    [alert setValue:Datepicker forKey:@"accessoryView"];
    [alert show];
    alert = nil;
}


- (void)LabelChange:(UIButton*)sender
{
    
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
   
    
    if (isTime == YES)
    {
        [df setDateFormat:@"hh:mm a"];
        
         NSString * selectedDate = [NSString stringWithFormat:@"%@",[df stringFromDate:Datepicker.date]];
       
        
        if (isStartTimeClicked == YES)
        {
            
            [self.buttonStartTime setTitle:selectedDate forState:UIControlStateNormal];
        }
        else
        {
            [self.buttonEndTime setTitle:selectedDate forState:UIControlStateNormal];
            
        }
    }
    else
    {
        [df setDateFormat:@"MM/dd/yyyy"];
        
         NSString * selectedDate = [NSString stringWithFormat:@"%@",[df stringFromDate:Datepicker.date]];
        
        if (isstartDateClicked == YES)
        {
             startDate = Datepicker.date;
            if ([Datepicker.date compare: endDate] == NSOrderedDescending) {
                
               
                endDate = Datepicker.date;
                [self.buttonStartDate setTitle:selectedDate forState:UIControlStateNormal];
                [self.buttonEndDate setTitle:selectedDate forState:UIControlStateNormal];
                
            }
            else{
                
                startDate = Datepicker.date;
                
                [self.buttonStartDate setTitle:selectedDate forState:UIControlStateNormal];
            }
            
        }
        else{
            
            endDate = Datepicker.date;
            
            [self.buttonEndDate setTitle:selectedDate forState:UIControlStateNormal];

        }
      
    }

}

#pragma mark - TextFiledDelegateMethods

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.addLocationTF)
    {
        
    }
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.addLocationTF)
    {
        
        float width = self.view.frame.size.width;
        if (tableViewAddress==nil)
        {
            viewAddresTableViewBackGround = [[UIView alloc]initWithFrame:CGRectMake(20, 65, width-40, 250)];
            
            tableViewAddress = [[UITableView alloc]initWithFrame:CGRectMake(5, 25, CGRectGetWidth(viewAddresTableViewBackGround.frame)-10, CGRectGetHeight(viewAddresTableViewBackGround.frame)-30)];
            
            viewAddresTableViewBackGround.backgroundColor =[ UIColor whiteColor];
            
            UIButton * ButtonCross = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
            
            [ButtonCross setImage:[UIImage imageNamed:@"crossround.png"] forState:UIControlStateNormal];
            
            [ButtonCross addTarget:self action:@selector(closeButtonClicekd) forControlEvents:UIControlEventTouchUpInside];
            
            [viewAddresTableViewBackGround addSubview:ButtonCross];
            
            viewAddresTableViewBackGround.layer.cornerRadius = 10;
            viewAddresTableViewBackGround.layer.borderColor = [UIColor lightGrayColor].CGColor;
            viewAddresTableViewBackGround.layer.borderWidth =1.0f;
            
            [viewAddresTableViewBackGround addSubview:tableViewAddress];
            tableViewAddress.delegate = self;
            tableViewAddress.dataSource =self;
            
            
            [self.view addSubview:viewAddresTableViewBackGround];
            
            ButtonCross = nil;
            
            
            
        }
        
        
        NSString * stringToRange = [textField.text substringWithRange:NSMakeRange(0,range.location)];
        
        // Appending the currently typed charactor
        stringToRange = [stringToRange stringByAppendingString:string];
        
        // Processing the last typed word
        NSArray *wordArray       = [stringToRange componentsSeparatedByString:@" "];
        NSString * wordTyped     = [wordArray lastObject];
        if ([appdelegate connectedToInternet])
        {
            [appdelegate startIndicator];
           
         
            
            NSString * placeSearchResultString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&sensor=nil&key=AIzaSyAZ-Z1DQ9LlqdlzHgyJpiqlLLRqb8I72_8",wordTyped];
            
            placeSearchResultString = [placeSearchResultString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSURL*Url=[NSURL URLWithString:placeSearchResultString];
            
            NSData *jsonData = [[NSData alloc]initWithContentsOfURL:Url];
            
            if(jsonData!= nil)
                
            {
                NSError *error = nil;
                
                id result = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
                NSLog(@"%@",result);
                
                arrayPlaceResult = [result valueForKey:@"predictions"];
                
                [tableViewAddress reloadData];
                
            }
            else
            {
                [self alertViewShow:@"unable To get Data"];
            }
        }
        else
        {
            
        }
    }
    else
    {
        
    }
    
    [appdelegate stopIndicators];
    
    return YES;
}

-(void)closeButtonClicekd
{
    [viewAddresTableViewBackGround removeFromSuperview];
    
    tableViewAddress = nil;
    arrayPlaceResult = nil;
    
    
    
}

#pragma mark - AlertView
-(void)alertViewShow:(NSString *)alertMessage
{
    UIAlertView *globalAlertView = [[UIAlertView alloc]initWithTitle:@"MySportsCast" message:alertMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [globalAlertView show];
    globalAlertView  = nil;
    [appdelegate stopIndicators];
    

}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.message isEqualToString:@"Posted Successfully"])
        
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - TableViewdelegate



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayPlaceResult count];

}





-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        
        cell.textLabel.text = [[arrayPlaceResult objectAtIndex:indexPath.row]valueForKey:@"description"];
        cell.textLabel.numberOfLines = 2;
        cell.textLabel.textColor = [UIColor blackColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
  


}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString * placeName;
    if (arrayPlaceResult.count == 0)
    {
        
    }else
    {
        placeName = [[arrayPlaceResult objectAtIndex:indexPath.row]valueForKey:@"description"];
    }
    
    if (placeName.length == 0)
    {
        
    }
    self.addLocationTF.text = placeName;
    [viewAddresTableViewBackGround removeFromSuperview];
    tableViewAddress = nil;
    viewAddresTableViewBackGround = nil;
    
    placeId = [[arrayPlaceResult objectAtIndex:indexPath.row]valueForKey:@"place_id"];
    
    NSString * placeIdurl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?placeid=%@&sensor=nil&key=AIzaSyAZ-Z1DQ9LlqdlzHgyJpiqlLLRqb8I72_8",placeId];
    
    placeIdurl = [placeIdurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL*Url=[NSURL URLWithString:placeIdurl];
    NSData *jsonData = [[NSData alloc]initWithContentsOfURL:Url];
    
    [appdelegate startIndicator];
    
    if(jsonData!= nil)
        
    {
        NSError *error = nil;
        
        id result = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        NSLog(@"%@",result);
        NSDictionary * tempDic = [result valueForKey:@"result"];
         lat =[[[tempDic valueForKey:@"geometry"]valueForKey:@"location"]valueForKeyPath:@"lat"];
         lng = [[[tempDic valueForKeyPath:@"geometry"]valueForKey:@"location"]valueForKeyPath:@"lng"];
        NSLog(@"lat%@",lng);
        NSLog(@"lag%@",lat);
        
        
        
        
        
    }
    [appdelegate stopIndicators];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}



- (void)textViewDidBeginEditing:(UITextView *)textView

{
    if ([textView.text isEqualToString:@"Write a description of the event."])
    {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""])
    {
        textView.text = @"Write a description of the event.";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}




- (IBAction)postButtonClicked:(id)sender {
    
    isPostEvent = YES;
    [appdelegate startIndicator];
    
    NSString *myDateAsAStringValue = [NSString stringWithFormat:@"%@ %@",self.buttonEndDate.currentTitle,self.buttonEndTime.currentTitle];
    
    //create the formatter for parsing
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    [df setTimeZone:[NSTimeZone localTimeZone]];
    
    [df setDateFormat:@"MM/dd/yyyy hh:mm a"];
    
    //parsing the string and converting it to NSDate
    NSDate *myDate = [df dateFromString: myDateAsAStringValue];
    
    //create the formatter for the output
    NSDateFormatter *out_df = [[NSDateFormatter alloc] init];
    [out_df setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    
    [out_df setDateFormat:@"MM/dd/yyyy hh:mma"];
    
    //output the date
    NSString * endTimeUtc = [out_df stringFromDate:myDate];
    
    myDateAsAStringValue = [NSString stringWithFormat:@"%@ %@",self.buttonStartDate.currentTitle,self.buttonStartTime.currentTitle];
    
    myDate = [df dateFromString:myDateAsAStringValue];
    
    [out_df setDateFormat:@"MM/dd/yyyy hh:mma"];
    

    
    //output the date
    NSString * startTimeUtc = [out_df stringFromDate:myDate];
    
    out_df = nil;
    df = nil;
    myDate = nil;
    
    endDateAndTime = endTimeUtc;
    startdateAndTime = startTimeUtc;
    
    endTimeUtc = nil;
    startTimeUtc = nil;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    mediaFile = [documentsDirectory stringByAppendingPathComponent:@"savedImage.png"];
    
    if (sportsId.length == 0)
    {
        [self alertViewShow:@"Please select sport name"];
    }
    else if (self.eventTypeButtonObj.currentTitle.length == 0)
    {
        [self alertViewShow:@"Please select event type"];
    }
    else if (self.eventTypeTF.text.length == 0)
    {
        [self alertViewShow:@"Please enter event name"];
    }
    else if (startdateAndTime.length == 0)
    {
        [self alertViewShow:@"Please enter start time and date"];
    }
    else if (endDateAndTime.length == 0)
    {
        [self alertViewShow:@"Please enter end time and date"];
    }
    else if ([self.descriptionText.text isEqualToString:@"Write a description of the event."])
    {
        [self alertViewShow:@"Please enter  event description"];
    }
    else if (self.addLocationTF.text.length == 0)
    {
        [self alertViewShow:@"Please enter location"];
    }
   
    else{
        
//        NSString * postString = [NSString stringWithFormat:@"user_id=%@&sports_id=%@&event_name=%@&team1_id=1&team2_id=1&team1_type=Home&team2_type=Home&formatted_address=%@&sub_location=%@&description=%@&lat=%@&lang=%@&date=%@&start_time=%@&end_time=%@&route=%@&city=%@&street_number=%@&state=%@&country=%@&postal_code=%@&event_type=%@&unique_id=%@&invite_user_ids=%@&event_image=%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"loginId"],sportsId,self.eventTypeTF.text,self.addLocationTF.text,self.subLocationTF.text,self.descriptionText.text,lat,lng,startdateAndTime,startdateAndTime,endDateAndTime,@"",self.addLocationTF.text,@"",@"",@"",@"",self.eventTypeButtonObj.currentTitle,placeId,stringTagId,encodedString];
//            stringBase64Image = nil;
        
        if (mediaFile.length == 0)
        {
            mediaFile = @"";
        }
        NSMutableDictionary * postDict = [[NSMutableDictionary alloc]init];
        
        [postDict setObject:[[NSUserDefaults standardUserDefaults]valueForKey:@"loginId"] forKey:@"user_id"];
        [postDict setObject:sportsId forKey:@"sports_id"];
        [postDict setObject:self.eventTypeTF.text forKey:@"event_name"];
        [postDict setObject:@"1" forKey:@"team1_id"];
        [postDict setObject:@"1" forKey:@"team2_id"];
        [postDict setObject:@"Home" forKey:@"team1_type"];
        [postDict setObject:@"Home" forKey:@"team2_type"];
        [postDict setObject:self.addLocationTF.text forKey:@"formatted_address"];
        [postDict setObject:self.subLocationTF.text forKey:@"sub_location"];
        [postDict setObject:self.descriptionText.text forKey:@"description"];
        [postDict setObject:lat forKey:@"lat"];
        [postDict setObject:lng forKey:@"lang"];
        [postDict setObject:startdateAndTime forKey:@"date"];
        [postDict setObject:startdateAndTime forKey:@"start_time"];
        [postDict setObject:endDateAndTime forKey:@"end_time"];
        [postDict setObject:@" " forKey:@"route"];
        [postDict setObject:self.addLocationTF.text forKey:@"city"];
        [postDict setObject:@" " forKey:@"street_number"];
        [postDict setObject:@" "forKey:@"state"];
        [postDict setObject:@" " forKey:@"country"];
        [postDict setObject:@" " forKey:@"postal_code"];
        [postDict setObject:self.eventTypeButtonObj.currentTitle forKey:@"event_type"];
        [postDict setObject:placeId forKey:@"unique_id"];
        [postDict setObject:stringTagId forKey:@"invite_user_ids"];
        [postDict setObject: mediaFile forKey:@"media_file"];
        
        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@add_event.php?",commonURL]];
        if ([appdelegate connectedToInternet])
        {
            [appdelegate startIndicator];
            [jsonObject postRegisterDetails:postDict withImageORVideoUrl:url];
        }
        else
        {
            [self alertViewShow:@"No internet connection"];
            
        }

    }
 
  
}


@end
