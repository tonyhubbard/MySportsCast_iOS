 //
//  HomeViewController.m
//  MySportsCast
//
//  Created by SPARSHMAC08 on 21/08/15.
//  Copyright (c) 2015 SPARSHMAC08. All rights reserved.
//

#import "HomeViewController.h"
#import "EventCell.h"
#import "EventDestialsViewController.h"
#import "CalendarViewController.h"
#import "FilterViewController.h"
#import "AddEventViewController.h"
#import "AppDelegate.h"
#import "JsonClass.h"
#import "Constants.h"
#import "UIImageView+WebCache.h"
#import "profileViewController.h"
#import "ChangePasswordViewController.h"
#import "LoginViewController.h"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
@interface HomeViewController ()<WebServiceProtocol,UIActionSheetDelegate>

{
    JsonClass * jsonObj;
    AppDelegate * appDelegate;
    NSMutableArray * resultArray;
    NSString * userId;
    EventCell * cell;
    NSString * stringSportsId;
    NSInteger eventType;
    int pageId;
    BOOL isMenuButtonClicked;
    
    float longitude;
    float latitude;
    NSString * userProfileFilter;
    
    UIButton * createEventButton;
    UILabel * infoLabel;
}
@end

@implementation HomeViewController

#pragma mark - ViewControllerLifeCycle

- (void)viewDidLoad
{
    
    jsonObj =[[JsonClass alloc]init];
    jsonObj.delegate =self;
    
    infoLabel = [[UILabel alloc]init];
    createEventButton = [[UIButton alloc]init];
 
    appDelegate =[UIApplication  sharedApplication].delegate;
    userId = [[NSString alloc]init];
    userId = [[NSUserDefaults standardUserDefaults]valueForKey:@"loginId"];
   userProfileFilter = @"Today";
    

    /*http://182.75.34.62/MySportsShare/web_services/update_device_token.php?user_id=296&device_type=ANDROID&device_token=APA91bFGx2thegQxzHfHkoQQBBroXYc7A9VQQgc3qa0GdTWiLC9AHFxTjIvOyTy-otwKB8vJ_tJTinqjU_WECrZR4aE4bqfCVgGGGzDCt029x0CFM4TnPsK6d9GZ8FalCGKGIT1gNfP*/
    
    
    
    // device token sending to server 
    if ([appDelegate connectedToInternet]) {
        
        
        [jsonObj getMethodforServiceRequest:[NSString stringWithFormat:@"%@update_device_token.php?user_id=%@&device_type=%@&device_token=%@",commonURL,userId,@"IOS",[[NSUserDefaults standardUserDefaults]  valueForKey:@"deviceToken"]]];
      
        
    }
    else{
        
        [self alertViewShow:@"No internet connection"];
         [appDelegate stopIndicators];
    }
   
    [super viewDidLoad];
    self.googleAdMob.adUnitID = @"ca-app-pub-1589399713821641/6728748219";
    self.googleAdMob.rootViewController = self;
    [self.googleAdMob loadRequest:[GADRequest request]];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    [imageCache clearMemory];
    [imageCache clearDisk];
    
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated
{
    [appDelegate startIndicator];
    //gettinguser location
    [resultArray removeAllObjects];
    if (resultArray == nil) {
        resultArray = [[NSMutableArray alloc]init];
    }
    else{
        
    }
    [appDelegate userCurrentLocation];
    pageId = 0;
    
    latitude= [[[NSUserDefaults standardUserDefaults] valueForKey:@"latitude"]floatValue];
    longitude =  [[[NSUserDefaults standardUserDefaults]valueForKey:@"longitude"]floatValue];
    
    NSString * lat = [NSString stringWithFormat:@"%f", latitude];
    NSString * lng = [NSString stringWithFormat:@"%f", longitude];
    
    NSMutableDictionary * locationDetails = [[NSMutableDictionary alloc]init];
    
    [locationDetails setObject:lat forKey:@"lat"];
    [locationDetails setObject:lng forKey:@"lng"];
    
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:locationDetails];
    [[NSUserDefaults standardUserDefaults]setObject:data forKey:@"userLocation"];
    
  
}




-(void)viewDidAppear:(BOOL)animated
{
    
    [self loadService:pageId baseUrlstring:commonURL eventTypeUrlString:calendarEvent];
 
    
    
 
}
#pragma mark - ServiceResponceDelegate


-(void)didReceiveResponseFromWebService:(NSDictionary *)responseDictionary
{
    
    
    if ([[[responseDictionary valueForKey:@"Response"]valueForKey:@"ResponseInfo"] isEqualToString:@"SUCCESS"])
    {
        
        if ([[[responseDictionary valueForKey:@"Response"]valueForKey:@"events_list"] isKindOfClass:[NSArray class]]) {
            self.tableViewEvents.hidden = NO;
            [createEventButton removeFromSuperview];
            [infoLabel removeFromSuperview];

            
            NSArray * tempArray = [[responseDictionary valueForKey:@"Response"]valueForKey:@"events_list"];
            for (int i =0; i<[tempArray count]; i++)
            {
                [resultArray addObject:[tempArray objectAtIndex:i]];
            }
             self.tableViewEvents.delegate = self;
            self.tableViewEvents.dataSource = self;
          [self.tableViewEvents reloadData];
            
            
        }
        else{
            
        }
    }
    else{
        
        if (resultArray.count>0) {
            
           
            
        }
        else{
            
            
            infoLabel.frame = CGRectMake(5, (self.view.frame.size.height/2)-30, self.view.frame.size.width, 60);
            infoLabel.numberOfLines = 2;
            infoLabel.text  = @"No events found in your location. Please use the filters to broaden your search";
            infoLabel.textAlignment = NSTextAlignmentCenter;
            infoLabel.textColor =[UIColor blackColor];
            
            [self.view addSubview:infoLabel];
            
            createEventButton.frame = CGRectMake((self.view.frame.size.width)/2-100, CGRectGetMaxY(infoLabel.frame), 200, 40);
            
            [self.view addSubview:createEventButton];
            
            [createEventButton setTitle:@"CREATE YOUR EVENT" forState:UIControlStateNormal];
            
            [createEventButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            
            [createEventButton addTarget:self action:@selector(addEventAction) forControlEvents:UIControlEventTouchUpInside];
            
            self.tableViewEvents.hidden = YES;
           
        }
     
    }
    
    [appDelegate stopIndicators];
}


#pragma mark -AlertShow

-(void)alertViewShow:(NSString *)alertMessage
{
    UIAlertView *globalAlertView = [[UIAlertView alloc]initWithTitle:@"MySportsCast" message:alertMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [globalAlertView show];
    globalAlertView  = nil;
    [appDelegate stopIndicators];
    
}

#pragma mark - viewControlerButtionAction



- (IBAction)buttonSearchClicked:(id)sender
{
    
}
- (IBAction)buttonFilterClicked:(id)sender
{
    [resultArray removeAllObjects];
    
    resultArray = nil;
    
    FilterViewController * filterVC  =[self.storyboard instantiateViewControllerWithIdentifier:@"FilterViewController"];
    
    filterVC.isFromCalendarEvent = NO;
    
    [self.navigationController pushViewController:filterVC animated:YES];
    
}

- (IBAction)buttonAddEvent:(id)sender

{
  
    if (self.isFromProfileScreen == YES)
    {
        [self.navigationController popViewControllerAnimated:YES];
        appDelegate.isUserCheckin = NO;
    }
    else{
        
        
        CalendarViewController * calendarVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CalendarViewController"];
        calendarVC.calendarScreenFromHome = YES;
        appDelegate.profileSelectedUserId = [[NSUserDefaults standardUserDefaults]valueForKey:@"loginId"];
        [self.navigationController pushViewController:calendarVC animated:YES];    }
 
    
}


- (IBAction)buttonSettingClicked:(id)sender
{
    
    isMenuButtonClicked = NO;
    NSArray * array = @[@"Profile Setting",@"Change Password",@"Logout"];
    [self actionSheetCreation:array];
    
    
}

- (IBAction)menuButtonClicked:(id)sender {
    
    isMenuButtonClicked = YES;
    NSArray * array ;
   /* if (isMenuButtonClicked ==YES)
    {
        array = @[@"Upcoming Events",@"in-progress Events",@"Fineshed Events",@"Calendar Events"];
    }
    else{
        
         array = @[@"Upcoming Events",@"in-progress Events",@"Fineshed Events",@"Calendar Events",@"Add Event"];
    }
   */
    
    
    array = @[@"Today Events",@"All Calendar Events",@"Add Event"];
    [self actionSheetCreation:array];
    
}

#pragma mark - tableViewDelegateMethods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [resultArray count];

    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell  =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EventCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSString * cast = [[resultArray objectAtIndex:indexPath.row]valueForKey:@"latest_cast"];
    
    
    if (self.view.frame.size.width == 768)
    {
        cell.labelAddress.font = [UIFont systemFontOfSize:17];
        cell.labelDistance.font = [UIFont systemFontOfSize:17];
        cell.labelLocation.font = [UIFont systemFontOfSize:17];
        cell.labelCastUserName.font = [UIFont systemFontOfSize:17];
        cell.textViewuserCast.font = [UIFont systemFontOfSize:16];
    }
    else{
        cell.labelAddress.font = [UIFont systemFontOfSize:10];
        cell.labelDistance.font = [UIFont systemFontOfSize:10];
        cell.labelLocation.font = [UIFont systemFontOfSize:10];
        cell.labelCastUserName.font = [UIFont systemFontOfSize:12];
        cell.textViewuserCast.font = [UIFont systemFontOfSize:11];
    }

    if (![cast isKindOfClass:[NSDictionary class]])
    {
            cell.singleLineView.hidden = YES;
            cell.castView.hidden = YES;
        
    }
    else
    {
       
            cell.singleLineView.hidden = NO;
            cell.castView.hidden = NO;
        
        NSDictionary * tempDic = [[resultArray objectAtIndex:indexPath.row]valueForKey:@"latest_cast"];
       
        

        
        [cell.imageViewCastUser sd_setImageWithURL:[NSURL URLWithString:[tempDic valueForKey:@"profile_image"]] placeholderImage:[UIImage imageNamed:@""]];
        
        
        
        if ([[tempDic valueForKey:@"name"]isKindOfClass:[NSNull class]])
        {
            cell.labelCastUserName.text = @"";
        }
        else{
            cell.labelCastUserName.text = [tempDic valueForKey:@"name"];
        }
        if ([[tempDic valueForKey:@"cast_text"]isKindOfClass:[NSNull class]]) {
            cell.textViewuserCast.text = @"";
        }
        else{
            cell.textViewuserCast.text = [tempDic valueForKey:@"cast_text"];
        }
        
        
     
    }
    if (self.view.frame.size.width==768)
    {
        if ([cast isKindOfClass:[NSDictionary class]])
        {
            cell.castaViewHeightConstrain.constant = 74;
            
            
        }
        else
        {
            cell.castaViewHeightConstrain.constant = 0;
           
        }
    }
    else
    {
        if ([cast isKindOfClass:[NSDictionary class]])
        {
            cell.castaViewHeightConstrain.constant = 74;
            
            
        }
        else
        {
            cell.castaViewHeightConstrain.constant = 0;
            
        }
    }
    
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    if ([[[resultArray objectAtIndex:indexPath.row]valueForKey:@"event_start_date"] isKindOfClass:[NSNull class]])
    {
      cell.labelAddress.text = @"--";
    }
    else{
        
      cell.labelAddress.text = [[resultArray objectAtIndex:indexPath.row]valueForKey:@"event_start_date"];
    }
    if ([[[resultArray objectAtIndex:indexPath.row]valueForKey:@"event_type"] isKindOfClass:[NSNull class]]) {
        cell.labelEventType.text = @"--";
    }
    else{
        
   
        cell.labelEventType.text = [[resultArray objectAtIndex:indexPath.row]valueForKey:@"event_type"];
        cell.labelEventType.text = [cell.labelEventType.text uppercaseString];
    
        NSString *datestr = [[resultArray objectAtIndex:indexPath.row]valueForKey:@"event_start_date"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //[dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        NSDate *date = [dateFormatter dateFromString:datestr]; // create date from string
        
        // change to a readable time format and change to local time zone
        [dateFormatter setDateFormat:@"MM/dd/yyyy-h:mm a"];
        [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
        NSString *timestamp = [dateFormatter stringFromDate:date];
        cell.labelAddress.text = timestamp;
        
    }
    if ([[[resultArray objectAtIndex:indexPath.row]valueForKey:@"event_title"]isKindOfClass:[NSNull class]]) {
        cell.labelEventName.text = @"--";
    }
    else{
        cell.labelEventName.text = [[resultArray objectAtIndex:indexPath.row]valueForKey:@"event_title"];
        
        cell.labelEventName.text = [cell.labelEventName.text uppercaseString];
    }
    
    if ([cell.labelEventType.text isEqualToString:@""])
    {
        cell.labelEventType.text = @"--";
    }
    if ([[[resultArray objectAtIndex:indexPath.row]valueForKey:@"sport_name"]isKindOfClass:[NSNull class]]) {
        cell.labelEventGameName.text = @"--";
    }
    else
    {
        cell.labelEventGameName.text = [[resultArray objectAtIndex:indexPath.row]valueForKey:@"sport_name"];
        cell.labelEventGameName.text = [cell.labelEventGameName.text uppercaseString];
        
    }
    
    if ([[[resultArray objectAtIndex:indexPath.row]valueForKey:@"distance_from_user_location"] isKindOfClass:[NSNull class]])
    {
        cell.labelDistance.text = @"--";
    }
    
    else{
        if (self.isFromProfileScreen == YES)
        {
            
            if (appDelegate.isUserCheckin == YES) {
                
                
                cell.labelDistance.text = [[resultArray objectAtIndex:indexPath.row]valueForKey:@"distance_from_user_location"];
                
            }
            else{
               
            
                    cell.labelDistance.text = [[[resultArray objectAtIndex:indexPath.row]valueForKey:@"distance_from_user_location"]stringValue];
            }
            
        }
        else
        {
          
          
                cell.labelDistance.text = [[resultArray objectAtIndex:indexPath.row]valueForKey:@"distance_from_user_location"];
         
        }
    }
    

    if ([[[resultArray objectAtIndex:indexPath.row]valueForKey:@"formatted_address"]isKindOfClass:[NSNull class]]) {
        
        
        cell.labelLocation.text = @"--";
    }
    else{
        cell.labelLocation.text = [[resultArray objectAtIndex:indexPath.row]valueForKey:@"formatted_address"];
    }
    
    
    
    cell.labelCherss.text = [NSString stringWithFormat:@"%@ cheers",[[resultArray objectAtIndex:indexPath.row]valueForKey:@"event_likes"]];
    
    cell.labelAttending.text = [NSString stringWithFormat:@"%@ Attending",[[resultArray objectAtIndex:indexPath.row]valueForKey:@"attending_count"]];
    
   
    [cell.imaeViewEventCoverPic sd_setImageWithURL:[NSURL URLWithString:[[resultArray objectAtIndex:indexPath.row]valueForKey:@"event_image"]] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
    
    [self cropimageView:cell.imaeViewEventCoverPic];
    return cell;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cast = [[resultArray objectAtIndex:indexPath.row]valueForKey:@"latest_cast"];
    if (self.view.frame.size.width==768)
    {
        if ([cast isKindOfClass:[NSDictionary class]])
        {
            cell.castaViewHeightConstrain.constant = 74;
            return 700;
            
        }
        else
        {
            cell.castaViewHeightConstrain.constant = 0;
            return 640;
        }
    }
    else
    {
        if ([cast isKindOfClass:[NSDictionary class]])
        {
            cell.castaViewHeightConstrain.constant = 74;
            return 500;
            
        }
        else
        {
            cell.castaViewHeightConstrain.constant = 0;
            return 430;
        }
    }
   
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   
    
    EventDestialsViewController * eventDetailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EventDestialsViewController"];
    
    eventDetailsVC.selectedEventType=self.labelEvent.text;
    
    eventDetailsVC.eventId = [[resultArray objectAtIndex:indexPath.row]valueForKey:@"event_id"];
    
    eventDetailsVC.eventCreatedId = [[resultArray objectAtIndex:indexPath.row]valueForKey:@"event_creator_id"];
    
    appDelegate.profileSelectedUserId = [[NSUserDefaults standardUserDefaults]valueForKey:@"loginId"];
   
    [self.navigationController pushViewController:eventDetailsVC animated:YES];
    
    resultArray  = nil;
}

#pragma mark - imageCroping

-(void)cropimageView:(UIImageView*)imageView
{
    imageView.layer.contents = (__bridge id)(imageView.image.CGImage);
    imageView.layer.contentsGravity = kCAGravityResizeAspectFill;
    imageView.layer.contentsScale = imageView.image.scale;
    imageView.layer.masksToBounds = YES;
    
    
}

#pragma mark - scrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView

{

    
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    
    CGFloat maxcontentOffSet = scrollView.contentSize.height - scrollView.frame.size.height;
    
    if ((maxcontentOffSet-contentOffsetY)<=50)
        
    {
       pageId = pageId+1;
       [self loadService:pageId baseUrlstring:commonURL eventTypeUrlString:calendarEvent];
     
    }
    
}



#pragma mark - ServiceCall

-(void)loadService:(int)pageIndex baseUrlstring:(NSString *)baseUrlString eventTypeUrlString:(NSString *)eventTypeString

{
   
    
        stringSportsId = [[NSString alloc]init];
        NSTimeZone *timeZone = [NSTimeZone localTimeZone];
        NSString *tzName = [timeZone name];
        NSString *monthChangeDate = [NSString stringWithFormat:@"%@",[NSDate date]];
        
        NSArray * dateComponets = [monthChangeDate componentsSeparatedByString:@"-"];
        
        NSInteger currentYear = [[dateComponets objectAtIndex:0]integerValue];
        NSInteger currentMonth = [[dateComponets objectAtIndex:1]integerValue];
        NSString * tepmDaystring = [dateComponets objectAtIndex:2];
        NSArray * dayArray =[tepmDaystring componentsSeparatedByString:@" "];
        NSInteger currentDay = [[dayArray objectAtIndex:0]integerValue];
        
        if ([appDelegate connectedToInternet])
        {
            
            [appDelegate startIndicator];
            NSData * data = [[NSUserDefaults standardUserDefaults]valueForKey:@"filterValues"];
            if (data)
            {
                
                NSDictionary * filterDic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                NSArray * lanAndLngArray = [filterDic valueForKey:@"location"];
                
                NSString * lan = [[lanAndLngArray objectAtIndex:0]valueForKey:@"lan"];
                NSString * lng = [[lanAndLngArray objectAtIndex:0]valueForKey:@"lng"];
                NSString * range = [filterDic valueForKey:@"selectedRange"];
                NSArray * temArray =[filterDic valueForKey:@"sportsId"];
                
                if (temArray)
                {
                    for (int a=0; a<[temArray count]; a++)
                    {
                        
                        NSString * tempString = [temArray objectAtIndex:a];
                        if ([tempString isEqualToString:@"0"]) {
                           
                        }
                        else{
                          stringSportsId = [stringSportsId stringByAppendingString:[NSString stringWithFormat:@"%@,",tempString]];
                        }
                        
                    }
                    if (stringSportsId.length !=0)
                    {
                        stringSportsId = [stringSportsId substringToIndex:[stringSportsId length]-1];
                    }
                    
                    if ([[filterDic valueForKey:@"dateSelection"] isEqualToString:@"NO"]) {
                     
                        self.labelEvent.text = [NSString stringWithFormat:@"%@-%@",[filterDic valueForKey:@"fromDate"],[filterDic valueForKey:@"toDate"]];
                        
                        // particular date to end date service
                        [jsonObj getMethodforServiceRequest:[NSString stringWithFormat:@"%@get_date_range_events.php?user_id=%@&user_lat=%@&user_lng=%@&from_date=%@&to_date=%@&time_zone=%@&page_id=%d&sport_id=%@&radious=%@",baseUrlString,userId,lan,lng,[filterDic valueForKey:@"fromDate"],[filterDic valueForKey:@"toDate"],tzName,pageId,stringSportsId,range]];
                     
                    }
                    else{
                         self.labelEvent.text = @"Today Events";
                        // with out  date
                        [jsonObj getMethodforServiceRequest:[NSString stringWithFormat:@"%@%@user_id=%@&user_lat=%@&user_lng=%@&year=%ld&month=%ld&day=%ld&time_zone=%@&page_id=%d&sport_id=%@&radious=%@",baseUrlString,eventTypeString,userId,lan,lng,(long)currentYear,(long)currentMonth,(long)currentDay,tzName,pageId,stringSportsId,range]];
                    }
                    
                    
                }
                stringSportsId = nil;
                
            }
            else{
                 self.labelEvent.text = @"Today Events";
                
                [jsonObj getMethodforServiceRequest:[NSString stringWithFormat:@"%@%@user_id=%@&user_lat=%f&user_lng=%f&year=%ld&month=%ld&day=%ld&time_zone=%@&page_id=%d&sport_id=%@&radious=all",baseUrlString,eventTypeString,userId,latitude,longitude,(long)currentYear,(long)currentMonth,(long)currentDay,tzName,pageId,@"0"]];
            }
            
            
            
            
        }
        else{
            [appDelegate stopIndicators];
        }
}



#pragma mark - ActionSheetCreation
-(void)actionSheetCreation:(NSArray *)SheetButton

{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"My SportsCast"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet]; // 1
    
    if (isMenuButtonClicked==NO) {
        
        
        UIAlertAction *Menufrist = [UIAlertAction actionWithTitle:@"Profile Setting"
                                                            style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                NSLog(@"You pressed button one");
                                                                [self.tabBarController setSelectedIndex:4];
                                                            }]; // 2
        UIAlertAction *MenuSecond = [UIAlertAction actionWithTitle:@"Change Password"
                                                             style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                 
                                                                 [self changePaswordAction];
                                                             }]; // 3
        
        UIAlertAction *Menuthird = [UIAlertAction actionWithTitle:@"Logout"
                                                            style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                [self logoutAction];
                                                            }];
        UIAlertAction *fourthAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                               style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                   [alert removeFromParentViewController];
                                                               }];
        [alert addAction:Menufrist];
        [alert addAction:MenuSecond];
        [alert addAction:Menuthird];
        [alert addAction:fourthAction];
        
        if (isipad()) {
            
            UIPopoverPresentationController *popPC = alert.popoverPresentationController;
            popPC.permittedArrowDirections = UIPopoverArrowDirectionAny;
            popPC.sourceView =self.settingsButton;
            popPC.sourceRect = self.settingsButton.bounds;
            [self presentViewController:alert animated:YES completion:nil];
        }else
        {
            [self presentViewController:alert animated:YES completion:nil]; //
        }
        
       
        
        
    }else // Alertview Controller for For Setings Button
    {
        
        UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Today Events"
                                                              style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                  NSLog(@"You pressed button one");
                                                                  [self todayAction];
                                                              }]; // 2
        UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"All Calendar Events"
                                                               style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                   NSLog(@"You pressed button two");
                                                                   [self allCalendarAction];
                                                               }]; // 3
        
        UIAlertAction *thirdAction = [UIAlertAction actionWithTitle:@"Add Event"
                                                              style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                  NSLog(@"You pressed button two");
                                                                  [self addEventAction];
                                                              }];
        UIAlertAction *fourthAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                               style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                   [alert removeFromParentViewController];
                                                               }];
        [alert addAction:firstAction];
        [alert addAction:secondAction]; // 5
        [alert addAction:thirdAction];
        [alert addAction:fourthAction];
        
        if (isipad()) {
            UIPopoverPresentationController *popPC = alert.popoverPresentationController;
            popPC.permittedArrowDirections = UIPopoverArrowDirectionAny;
            popPC.sourceView =self.menuButton;
            popPC.sourceRect = self.menuButton.bounds;
            [self presentViewController:alert animated:YES completion:nil];
        }else
        {
            [self presentViewController:alert animated:YES completion:nil]; //
        }
    }
}

-(void)todayAction
{
    [resultArray removeAllObjects];
    pageId = 0;
    
    [self loadService:pageId baseUrlstring:commonURL eventTypeUrlString:calendarEvent];
}
-(void)allCalendarAction
{
    
    
    CalendarViewController * calendarVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CalendarViewController"];
    appDelegate.profileSelectedUserId = [[NSUserDefaults standardUserDefaults]valueForKey:@"loginId"];
    
    calendarVC.calendarScreenFromHome = YES;
    calendarVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:calendarVC animated:YES];
    
}
-(void)addEventAction{
    
    resultArray = nil;
    AddEventViewController * addeventVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddEventViewController"];
    [self.navigationController pushViewController:addeventVC animated:YES];
}
-(void)changePaswordAction{
    
    
    ChangePasswordViewController * changePasswordVc = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangePasswordViewController"];
    changePasswordVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:changePasswordVc animated:YES];
}
-(void)logoutAction{
    UIAlertView *globalAlertView = [[UIAlertView alloc]initWithTitle:@"MySportsCast" message:@"Are you sure want to logout" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok",nil];
    [globalAlertView show];
    globalAlertView  = nil;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.message isEqualToString:@"Are you sure want to logout"]) {
        if (buttonIndex == 0) {
            
        }
        else{
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"filterValues"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"loginId"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"profileInfo"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"screenCount"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"deviceToken"];

            
            [[NSUserDefaults standardUserDefaults]valueForKey:@"previousSecValu"];
            
            LoginViewController * loginVC =[self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            loginVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:loginVC animated:NO];
        }
        
    }
}


@end
