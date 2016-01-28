//
//  CalendarViewController.m
//  MySportsCast
//
//  Created by SPARSHMAC08 on 13/10/15.
//  Copyright © 2015 SPARSHMAC08. All rights reserved.
//

#import "CalendarViewController.h"
#import "AddEventViewController.h"
#import "JsonClass.h"
#import <CoreGraphics/CoreGraphics.h>
#import "HomeViewController.h"
#import "CKCalendarView.h"
#import "Constants.h"
#import "AppDelegate.h"

@interface CalendarViewController ()<CKCalendarDelegate,WebServiceProtocol>
{
    NSMutableArray *arrayMinutes;
    NSInteger nextYear;
    NSInteger currentYear;
    NSInteger  previousMonth;
    JsonClass * jsonobj;
    AppDelegate * appdelegate;
    UIView * calendarBackGroundView;
    UIView * singleView;
    BOOL isAllEventButtonClicked;
    NSString * userId;
}

@property(nonatomic, weak) CKCalendarView *calendar;

@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSDate *minimumDate;
@property(nonatomic, strong) NSDate *maximumDate;

@property(nonatomic, strong) NSArray *disabledDates;
@end

@implementation CalendarViewController

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    appdelegate = [UIApplication sharedApplication].delegate;
    jsonobj = [[JsonClass alloc]init];
    jsonobj.delegate = self;
    
    
   //hidding button user from homescreen
    
    
    if (self.calendarScreenFromHome == YES) {
        
        self.allEventButton.hidden = YES;
        self.myEventButton.hidden = YES;
        
        
        if (self.view.frame.size.width == 768) {
            
            calendarBackGroundView = [[UIView alloc]initWithFrame:CGRectMake(9, 73, self.view.frame.size.width-18, 780)];
            
        }
        else{
            
            calendarBackGroundView = [[UIView alloc]initWithFrame:CGRectMake(9, 73, self.view.frame.size.width-18, 380)];
            
        }
        calendarBackGroundView.backgroundColor = [UIColor colorWithRed:191.0f/255.0f green:191.0f/255.0f blue:191.0f/255.0f alpha:1.0f];
        
        [self.view addSubview:calendarBackGroundView];
    }
    else{
        
        
        singleView = [[UIView alloc]initWithFrame:CGRectMake(9, CGRectGetMaxY(self.allEventButton.frame), (self.view.frame.size.width)/2-18, 2)];
        
        singleView.backgroundColor = [UIColor blackColor];
        
        [self.view addSubview:singleView];
        if (self.view.frame.size.width == 768) {
            
           calendarBackGroundView = [[UIView alloc]initWithFrame:CGRectMake(9, CGRectGetMaxY(singleView.frame)+2, self.view.frame.size.width-18, 780)];
            
        }
        else{
            
         calendarBackGroundView = [[UIView alloc]initWithFrame:CGRectMake(9, CGRectGetMaxY(singleView.frame)+2, self.view.frame.size.width-18, 380)];
            
        }
        
        
        calendarBackGroundView.backgroundColor = [UIColor colorWithRed:191.0f/255.0f green:191.0f/255.0f blue:191.0f/255.0f alpha:1.0f];
        
        [self.view addSubview:calendarBackGroundView];
        
    }
    [appdelegate startIndicator];
    
    
    NSString *monthChangeDate = [NSString stringWithFormat:@"%@",[NSDate date]];
    
    NSArray * dateComponets = [monthChangeDate componentsSeparatedByString:@"-"];
    
    currentYear = [[dateComponets objectAtIndex:0]integerValue];
    previousMonth = [[dateComponets objectAtIndex:1]integerValue];
    nextYear = currentYear;
    
    CKCalendarView *calendar = [[CKCalendarView alloc] initWithStartDay:startMonday];
    self.calendar = calendar;
    calendar.delegate = self;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"MM/dd/yyyy"];
    
    
    NSDate *date;
    date=[NSDate date];
    self.minimumDate=date;
    
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:-1];
    self.minimumDate=[gregorian dateByAddingComponents:comps toDate:self.minimumDate options:0];
    [comps setDay:91];
    self.maximumDate = [gregorian dateByAddingComponents:comps toDate:self.minimumDate  options:0];
    
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    NSString *tzName = [timeZone name];
    //    my system current year
    NSString * currentDate = [NSString stringWithFormat:@"%@",[NSDate date]];
    NSArray * currentComments = [currentDate componentsSeparatedByString:@"-"];
    currentYear = [[currentComments objectAtIndex:0]integerValue];
    
    // passing  other user id for event dates
    

    
    if (appdelegate.profileSelectedUserId) {
        
        
        if (appdelegate.profileViewNavAccount == 3 || appdelegate.isfromNotificationScreen == YES) {
          
            [self.myEventButton setTitle:@"User Events" forState:UIControlStateNormal];
          
        }
        userId = appdelegate.profileSelectedUserId;
        
    }
    else{
        if (appdelegate.notificationSelectedId) {
           
            userId = appdelegate.notificationSelectedId;
            [self.myEventButton setTitle:@"User Events" forState:UIControlStateNormal];
            
        }
        else{
            userId = [[NSUserDefaults standardUserDefaults]valueForKey:@"loginId"];
            [self.myEventButton setTitle:@"My Events" forState:UIControlStateNormal];
 
        }
       

    }
    
    
    if ([appdelegate connectedToInternet]) {
        
        [self servicecallForCalendarEvent:tzName];
        
    }
    else{
        
        [self alertViewShow:@"No internet connection"];
    }
    
    
    
    calendar.onlyShowCurrentMonth = NO;
    
    calendar.adaptHeightToNumberOfWeeksInMonth = YES;
    
    calendar.frame = CGRectMake(5, 5, self.view.frame.size.width-28, 320);
    
    [calendarBackGroundView addSubview:calendar];

    
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    
    
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)localeDidChange {
    
    [self.calendar reloadData];
    [appdelegate stopIndicators];
}

- (BOOL)dateIsDisabled:(NSDate *)date {
    for (NSDate *disabledDate in self.disabledDates) {
        if ([disabledDate isEqualToDate:date]) {
            return YES;
        }
    }
    return NO;
}
#pragma mark - CKCalendarDelegate

- (void)calendar:(CKCalendarView *)calendar configureDateItem:(CKDateItem *)dateItem forDate:(NSDate *)date {
    // TODO: play with the coloring if we want to...
    if ([self dateIsDisabled:date]) {
        
        
        if ([date laterDate:self.minimumDate] == self.minimumDate) {
            
            dateItem.blueColorImage = [UIImage imageNamed:@"dot.png"];
            
        }
        else{
            
            dateItem.blueColorImage = [UIImage imageNamed:@"green.png"];
        }
        
    }
    
    else if ([date laterDate:self.minimumDate] == self.minimumDate) {
        
        
        dateItem.blueColorImage = [UIImage imageNamed:@""];
        
    }
    
    else
    {
        
        dateItem.blueColorImage = [UIImage imageNamed:@""];
    }
}


- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {

    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
  
    NSString *newDateString = [dateFormatter stringFromDate:date];
    
    CalendarEventsViewController * calendarEventVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CalendarEventsViewController"];
    
    if (isAllEventButtonClicked == YES || self.calendarScreenFromHome == YES) {
        
        calendarEventVC.isAllEvetnCalendar = YES;
    }
    else{
        
       calendarEventVC.isAllEvetnCalendar = NO;
        
    }
    
    calendarEventVC.selectedDate = newDateString;
    [self.navigationController pushViewController:calendarEventVC animated:YES];
    
}

- (void)calendar:(CKCalendarView *)calendar didLayoutInRect:(CGRect)frame {
    
}
- (BOOL)calendar:(CKCalendarView *)calendar willSelectDate:(NSDate *)date {
    
    return [calendar dateIsInCurrentMonth:date];
}

- (void)calendar:(CKCalendarView *)calendar didChangeToMonth:(NSDate *)date {
    
   
    
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    NSString *tzName = [timeZone name];
    
    NSString *monthChangeDate = [NSString stringWithFormat:@"%@",date];
    
    NSArray * dateComponets = [monthChangeDate componentsSeparatedByString:@"-"];
    
    nextYear = [[dateComponets objectAtIndex:0]integerValue];
    
    previousMonth = [[dateComponets objectAtIndex:1]integerValue];
    
    //my system current year
    NSString * currentDate = [NSString stringWithFormat:@"%@",[NSDate date]];
    
    NSArray * currentComments = [currentDate componentsSeparatedByString:@"-"];
    currentYear = [[currentComments objectAtIndex:0]integerValue];
    
    
    
    if (currentYear > nextYear)
    {
        
        if (previousMonth == 11)
        {
       
            [self servicecallForCalendarEvent:tzName];
            
            //send next year
        }
        
        if (previousMonth == 12)
        {
            nextYear = nextYear+1;
         
           [self servicecallForCalendarEvent:tzName];
         
        }
    
    }
    else{
        
        if (previousMonth == 12) {
            
            nextYear = nextYear+1;
     
            [self servicecallForCalendarEvent:tzName];
            
            //send next year
        }
        else if (previousMonth == 11)
        {
         
           [self servicecallForCalendarEvent:tzName];
            
        }
        
    }
    
}
-(void)didReceiveResponseFromWebService:(NSDictionary *)responseDictionary{
    
    if ([[[responseDictionary valueForKey:@"Response"]valueForKey:@"ResponseInfo"] isEqualToString:@"SUCCESS"]) {
     
        
        NSArray * listOfDate;
        if (self.calendarScreenFromHome == YES) {
            listOfDate = [[responseDictionary valueForKey:@"Response"]valueForKey:@"event_dates_list"];
        }
        else{
            if (isAllEventButtonClicked == NO) {
                listOfDate = [[responseDictionary valueForKey:@"Response"]valueForKey:@"user_post_event_dates_list"];
                
            }
            else{
                listOfDate = [[responseDictionary valueForKey:@"Response"]valueForKey:@"event_dates_list"];
            }
        }
        
       
        NSMutableArray * datesArray = [[[NSMutableArray alloc]init]mutableCopy];
        
        NSDate * date = [[NSDate alloc]init];
        
        for ( int i=0; i<[listOfDate count]; i++)
        {
            
            NSArray * dateComponets = [[[listOfDate objectAtIndex:i]valueForKey:@"event_date"] componentsSeparatedByString:@" "];
            
            date = [self.dateFormatter dateFromString:[dateComponets objectAtIndex:0]];
            
            [datesArray addObject:date];
            
        }
        
        self.disabledDates = datesArray;
        
    }
    else{
        
//        [self alertViewShow:@"No events found"];
        
    }
      [self localeDidChange];
}

-(void)alertViewShow:(NSString *)alertMessage
{
    
    UIAlertView *globalAlertView;
   
    globalAlertView = [[UIAlertView alloc]initWithTitle:@"MySportsCast" message:alertMessage delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: @"Ok", nil];
    [globalAlertView show];
    [self.view addSubview:globalAlertView];
    globalAlertView = nil;
        
}
- (IBAction)backButton:(id)sender {
    
    self.calendarScreenFromHome = NO;
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)myEventButtonClicked:(id)sender {
    
    
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    NSString *tzName = [timeZone name];
    
     isAllEventButtonClicked = NO;
    
    [UIView animateWithDuration:0.2 animations:^{
        
    
        singleView.frame = CGRectMake(9, CGRectGetMaxY(self.allEventButton.frame), (self.view.frame.size.width)/2-18, 2);
        [self servicecallForCalendarEvent:tzName];
        
        
    }];
    
    
    
}

- (IBAction)allEventButtonClicked:(id)sender {
    
    isAllEventButtonClicked = YES;
    
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    NSString *tzName = [timeZone name];
    [UIView animateWithDuration:0.2 animations:^{
                                                 
        singleView.frame = CGRectMake((self.view.frame.size.width)/2+(5), CGRectGetMaxY(self.allEventButton.frame), (self.view.frame.size.width)/2-18, 2);
        
        [self servicecallForCalendarEvent:tzName];
        
    }];
    
    
}

- (IBAction)buttonAddEvent:(id)sender {
    
    AddEventViewController * addeventVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddEventViewController"];
    [self.navigationController pushViewController:addeventVC animated:YES];
}

-(void)servicecallForCalendarEvent:(NSString * )tzName
{
    
    if (self.calendarScreenFromHome == YES) {
        
        //DISPLAYING ALL EVENT BCZ SCREEN FROM HOMEVC
        
        [jsonobj getMethodforServiceRequest:[NSString stringWithFormat:@"%@get_event_dates_list.php?time_zone=%@&year=%ld",commonURL,tzName,(long)nextYear]];
    }
    else{
        if(isAllEventButtonClicked == NO)
        {
            
            [jsonobj getMethodforServiceRequest:[NSString stringWithFormat:@"%@get_user_post_event_dates_list.php?user_id=%@&user_check_in=%@&time_zone=%@&year=%ld",commonURL,userId,@"0",tzName,(long)nextYear]];
            
        }
        else{
            
            [jsonobj getMethodforServiceRequest:[NSString stringWithFormat:@"%@get_event_dates_list.php?time_zone=%@&year=%ld",commonURL,tzName,(long)nextYear]];
        }
    }

}
@end
