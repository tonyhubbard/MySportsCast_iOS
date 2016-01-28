//
//  CalendarEventsViewController.m
//  MySportsCast
//
//  Created by SPARSHMAC08 on 27/10/15.
//  Copyright © 2015 SPARSHMAC08. All rights reserved.
//

#import "CalendarEventsViewController.h"
#import "EventDestialsViewController.h"
#import "FilterViewController.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "JsonClass.h"
#import "EventCell.h"
@interface CalendarEventsViewController ()<WebServiceProtocol>
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
}
@end

@implementation CalendarEventsViewController

- (void)viewDidLoad {
    
    
    appDelegate =[UIApplication sharedApplication].delegate;
    
    jsonObj = [[JsonClass alloc]init];
    
    jsonObj.delegate = self;
    self.labelSelectedDate.text = self.selectedDate;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    [imageCache clearMemory];
    [imageCache clearDisk];
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    
    //gettinguser location
    
    [appDelegate userCurrentLocation];
    
    
    if (appDelegate.profileViewNavAccount == 3 || (appDelegate.isfromNotificationScreen == YES))
    {
        
        if (appDelegate.isUserCheckin == YES) {
            self.buttonFilter.hidden = YES;
            self.labelSelectedDate.text = [NSString stringWithFormat:@"%@ CHECK-IN",appDelegate.profileSelectedUSeName];
            self.labelSelectedDate.text = [self.labelSelectedDate.text uppercaseString];
        }
        else{
            self.buttonFilter.hidden = NO;
             self.labelSelectedDate.text = self.selectedDate;
        }
        
    }
    else{
        
        if (appDelegate.isUserCheckin == YES)
        {
            self.labelSelectedDate.text = @"MY CHECK-IN";
            self.buttonFilter.hidden = YES;
            
        }
        else{
            self.buttonFilter.hidden = NO;
             self.labelSelectedDate.text = self.selectedDate;
        
      }
    }
 
}

-(void)viewDidAppear:(BOOL)animated
{
    
    resultArray = [[NSMutableArray alloc]init];
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
    
    if (self.isAllEvetnCalendar == YES) {
        
        [self loadService:pageId baseUrlstring:commonURL eventTypeUrlString:calendarEvent];
    }
    else
    {
        [self loadService:pageId baseUrlstring:commonURL eventTypeUrlString:UserSingleDayEvent];
    }
    
  
}


#pragma mark - ServiceCall

-(void)loadService:(int)pageIndex baseUrlstring:(NSString *)commonUrlString eventTypeUrlString:(NSString *)eventTypeString

{
    if (appDelegate.isUserCheckin == YES) {
        
        if ([appDelegate connectedToInternet]) {
            
            [appDelegate startIndicator];
            
            [jsonObj getMethodforServiceRequest:[NSString stringWithFormat:@"%@get_user_checkin_events.php?user_id=%@&user_lat=%f&user_lng=%f&page_id=%d&filter=%@&search=%@",commonUrlString,appDelegate.profileSelectedUserId,latitude,longitude,pageId,@"none",@""]];
            
        }
        
    }
    else
    {
        
        
        stringSportsId = [[NSString alloc]init];
        NSTimeZone *timeZone = [NSTimeZone localTimeZone];
        NSString *tzName = [timeZone name];
      
        NSString *dateString = self.selectedDate;
        
        
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"MM/dd/YYYY"];
//        NSDate *date = [dateFormatter dateFromString:dateString];
//        
//        // Convert date object into desired format
//        [dateFormatter setDateFormat:@"MM/dd/YYYY"];
//        NSString *newDateString = [dateFormatter stringFromDate:date];
        
        
        NSString * convertedDate = [NSString stringWithFormat:@"%@",dateString];
        
        NSArray * selecteddateComponets = [convertedDate componentsSeparatedByString:@"/"];
        NSInteger month = [[selecteddateComponets objectAtIndex:0]integerValue];
        NSInteger day = [[selecteddateComponets objectAtIndex:1]integerValue];
        NSInteger year = [[selecteddateComponets objectAtIndex:2]integerValue];
        
        if ([appDelegate connectedToInternet])
        {
            
            [appDelegate startIndicator];
            NSData * data = [[NSUserDefaults standardUserDefaults]valueForKey:@"filterValues"];
            if (data)
            {
                
                NSDictionary * filterDic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                NSArray * lanAndLngArray = [filterDic valueForKey:@"location"];
                
                NSString * lan = [[lanAndLngArray objectAtIndex:0]valueForKey:@"lat"];
                NSString * lng = [[lanAndLngArray objectAtIndex:0]valueForKey:@"lng"];
                NSString * range = [filterDic valueForKey:@"selectedRange"];
                NSArray * temArray =[filterDic valueForKey:@"sportsId"];
                
                if (temArray)
                {
                    for (int a=0; a<[temArray count]; a++)
                    {
                        
                        NSString * tempString = [temArray objectAtIndex:a];
                        
                        stringSportsId = [stringSportsId stringByAppendingString:[NSString stringWithFormat:@"%@,",tempString]];
                    }
                    if (stringSportsId.length !=0)
                    {
                        stringSportsId = [stringSportsId substringToIndex:[stringSportsId length]-1];
                    }
                    
                    [jsonObj getMethodforServiceRequest:[NSString stringWithFormat:@"%@%@user_id=%@&user_lat=%@&user_lng=%@&year=%ld&month=%ld&day=%ld&time_zone=%@&page_id=%d&sport_id=%@&radious=%@",commonUrlString,eventTypeString,appDelegate.profileSelectedUserId,lan,lng,(long)year,(long)month,(long)day,tzName,pageId,stringSportsId,range]];
                }
                
                
            }
            else{
                [jsonObj getMethodforServiceRequest:[NSString stringWithFormat:@"%@%@user_id=%@&user_lat=%f&user_lng=%f&year=%ld&month=%ld&day=%ld&time_zone=%@&page_id=%d&sport_id=%@&radious=all",commonUrlString,eventTypeString,appDelegate.profileSelectedUserId,latitude,longitude,(long)year,(long)month,(long)day,tzName,pageId,@"0"]];
            }
            stringSportsId = nil;
            
            
            
        }

    }
    
}

#pragma mark - ServiceResponceDelegate


-(void)didReceiveResponseFromWebService:(NSDictionary *)responseDictionary
{
    
    if ([[[responseDictionary valueForKey:@"Response"]valueForKey:@"ResponseInfo"] isEqualToString:@"SUCCESS"])
    {
        
        if ([[[responseDictionary valueForKey:@"Response"]valueForKey:@"events_list"] isKindOfClass:[NSArray class]]) {
            
             self.tableviewForEvents.hidden = NO;
            NSArray * tempArray = [[responseDictionary valueForKey:@"Response"]valueForKey:@"events_list"];
            
            for (int i =0; i<[tempArray count]; i++)
                
            {
                [resultArray addObject:[tempArray objectAtIndex:i]];
            }
            
            [self.tableviewForEvents reloadData];
        }
        else{
            if (resultArray.count>0) {
                
                
                
            }
            else{
                
                self.tableviewForEvents.hidden = YES;
            }
            
            
        }
    }
    else{
        
        if (resultArray.count>0) {
            
          
            
        }
        else{
           
           self.tableviewForEvents.hidden = YES;
        }
    
    }
    
    
    
    [appDelegate stopIndicators];
}


- (IBAction)backButtonClicked:(id)sender {
    
    appDelegate.isUserCheckin = NO;
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)filterButtonClicked:(id)sender {
    
    FilterViewController * filterVC  =[self.storyboard instantiateViewControllerWithIdentifier:@"FilterViewController"];
    
    filterVC.isFromCalendarEvent = YES;
    
    
    [self.navigationController pushViewController:filterVC animated:YES];
    
    
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
        
            
            cell.labelDistance.text = [[resultArray objectAtIndex:indexPath.row]valueForKey:@"distance_from_user_location"];
            
       
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
    
//    eventDetailsVC.selectedEventType=self.labelEvent.text;
    eventDetailsVC.eventId = [[resultArray objectAtIndex:indexPath.row]valueForKey:@"event_id"];
    
    eventDetailsVC.eventCreatedId = [[resultArray objectAtIndex:indexPath.row]valueForKey:@"event_creator_id"];
    [self.navigationController pushViewController:eventDetailsVC animated:YES];
    
    resultArray  = nil;
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



#pragma mark - imageCroping

-(void)cropimageView:(UIImageView*)imageView
{
    imageView.layer.contents = (__bridge id)(imageView.image.CGImage);
    imageView.layer.contentsGravity = kCAGravityResizeAspectFill;
    imageView.layer.contentsScale = imageView.image.scale;
    imageView.layer.masksToBounds = YES;
    
    
}


@end
