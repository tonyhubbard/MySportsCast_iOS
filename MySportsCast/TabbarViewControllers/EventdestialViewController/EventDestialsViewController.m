//
//  EventDestialsViewController.m
//  MySportsCast
//
//  Created by Vardhan on 22/08/15.
//  Copyright (c) 2015 SPARSHMAC08. All rights reserved.
//
@import GoogleMobileAds;
#define kKeyboardOffsetY 80.0f
#import "EventDestialsViewController.h"
#import "EventDeatilPhotoCell.h"
#import "EventDeatilSectionCell.h"
#import "EventDetailsTextCell.h"
#import "EventDetailVideoCell.h"
#import <AVFoundation/AVFoundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"
#import "JsonClass.h"
#import "CastTextViewController.h"
#import "CastPhotoViewController.h"
#import "CastVideoViewController.h"
#import "UIImageView+WebCache.h"
#import "PlayerViewController.h"
#import "OpenInGoogleMapsController.h"

#import "Constants.h"
@interface EventDestialsViewController ()<WebServiceProtocol,GADInterstitialDelegate>

{
    CGRect screenFrame;
    NSString * userId;
    JsonClass * jsonObj;
    AppDelegate * appDelegate;
    NSMutableDictionary * resultDic;
    UITableView * locationSearchTable;
    UIButton * buttonCheers;
    UIButton * buttonAttending;
    UIButton * buttonIamAtending;
    UIButton * buttonAddMedia;
    UILabel  * labelCheers
    ;
    UILabel * labelAttending;
    UILabel * labelIamAttending;
    UILabel * labelAddMedia;
    BOOL isCheers;
    BOOL isIamAttending;
    BOOL isComment;
    BOOL isSendButtonClicked;
    BOOL isCommnetDelete;
    BOOL isMenuclicked;
    BOOL iscastShare;
    NSString * stringEventMedia;
    NSMutableDictionary * dicEventMedia;
    BOOL iseventMedia;
    NSMutableArray * arrayPohotCast;
    NSMutableArray * arrayTextCast;
    NSMutableArray * arrayVideoCast;
    NSMutableArray * arrayAllCast;
    UIView * commentView;
    UIButton * buttonClose;
    UIView * viewBlackLayer;
    NSMutableArray * arrayComment;
    UITableView * tableCommnet;
    NSString * commentMediaId;
    NSString * commentMediaType;
    NSMutableArray * filterCastArray;
    NSString * commentStringTF;
    NSString * categorytype;
    NSString * userProfileUrl;
    NSString * userProfileName;
    NSInteger deletedIndex;
    CGRect keyboardFrameBeginRect;
    CGFloat cellImageHeight;
    UIButton * menuButton;
    NSString * filterByString;
    UIButton * buttonClickHereToaddMedia;
    BOOL isaddMediaButton;
    UIView * viewBack;
    UIView * layerView;
    BOOL isAttendingView;
    NSArray * attendingListArray;
    UITableView * attendingTableView;
    NSInteger screenCount;
   
    
}
@property(nonatomic, strong) GADInterstitial *interstitial;
@property(nonatomic, strong) NSTimer *timer;

@end

@implementation EventDestialsViewController

- (void)viewDidLoad
{
    
    self.navigationController.navigationBar.hidden = YES;
    [super viewDidLoad];
    
    
    userId = [[NSString alloc]init];
    
    userProfileName = [[NSString alloc]init];
    
    userProfileUrl = [[NSString alloc]init];
    
    commentStringTF = [[NSString alloc]init];
    
    attendingListArray = [[NSArray alloc]init];
    
    userId = [[NSUserDefaults standardUserDefaults]valueForKey:@"loginId"];
    
    NSData * data = [[NSUserDefaults standardUserDefaults]valueForKey:@"profileInfo"];
    
    NSDictionary * userInfoDic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    userProfileUrl = [userInfoDic valueForKey:@"userPic"];
    
    userProfileName = [userInfoDic valueForKey:@"userName"];
    
    screenFrame = [[UIScreen mainScreen] bounds];
    
    jsonObj =[[JsonClass alloc]init];
    jsonObj.delegate =self;
    resultDic = [[NSMutableDictionary alloc]init];
    
    arrayComment = [[NSMutableArray alloc]init];
    
    appDelegate =[UIApplication  sharedApplication].delegate;
    
    
    screenCount = [[[NSUserDefaults standardUserDefaults]valueForKey:@"screenCount"]integerValue];
    appDelegate.previousTimerSec = [[[NSUserDefaults standardUserDefaults]valueForKey:@"previousSecValu"]integerValue];

    [self createAndLoadInterstitial];
 
    
    if (screenCount >= 5) {
        
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSCalendarUnitDay|NSCalendarUnitWeekOfMonth|NSCalendarUnitMonth|NSCalendarUnitYear|NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:[NSDate date]];
        
        NSInteger newHur = components.hour*(60*60);
        NSInteger newMin = components.minute*60;
        
        NSInteger completeTotalSec = newMin+newHur;
        NSInteger difSec = (completeTotalSec-appDelegate.previousTimerSec);
        
        if (difSec>=180) {
            
            appDelegate.previousTimerSec = completeTotalSec;
            
             [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%ld",(long)appDelegate.previousTimerSec] forKey:@"previousSecValu"];
            
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                          target:self
                                                        selector:@selector(presentAdFromGoogle:)
                                                        userInfo:nil
                                                         repeats:YES];

            
           
        }
        else{
            
            if (appDelegate.previousTimerSec == 0) {
                self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                              target:self
                                                            selector:@selector(presentAdFromGoogle:)
                                                            userInfo:nil
                                                             repeats:YES];
            }
            
        }
        
    }
    
    else{
        
        screenCount = screenCount+1;
        NSString * screenCountValue = [NSString stringWithFormat:@"%ld",(long)screenCount];
        
        [[NSUserDefaults standardUserDefaults]setObject:screenCountValue forKey:@"screenCount"];
        appDelegate.previousTimerSec = 0;
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%ld",(long)appDelegate.previousTimerSec] forKey:@"previousSecValu"];
        
    }
    

    
    
    
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    [imageCache clearMemory];
    [imageCache clearDisk];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChange:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    arrayAllCast = [[NSMutableArray alloc]init];
    arrayPohotCast = [[NSMutableArray alloc]init];
    arrayTextCast = [[NSMutableArray alloc]init];
    arrayVideoCast = [[NSMutableArray alloc]init];
    filterCastArray = [[NSMutableArray alloc]init];
    filterByString = @"all";
    [self webServiceRequest];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    arrayAllCast = nil;
    arrayPohotCast = nil;
    arrayTextCast = nil;
    arrayVideoCast = nil;
    filterCastArray = nil;
    commentStringTF = nil;
    
    
}
#pragma mark - FullScreenGoogleLaunch

-(void)presentAdFromGoogle:(NSTimer*)timer{
    
    if (self.interstitial.isReady) {
        
    
       
        [timer invalidate];
        
        [self.interstitial presentFromRootViewController:self];
    } else {
        
    }
    
}


- (void)createAndLoadInterstitial {
    self.interstitial =
    [[GADInterstitial alloc] initWithAdUnitID:@"ca-app-pub-1589399713821641/5252015016"];
    self.interstitial.delegate = self;
    
    GADRequest *request = [GADRequest request];
    // Request test ads on devices you specify. Your test device ID is printed to the console when
    // an ad request is made. GADInterstitial automatically returns test ads when running on a
    // simulator.
    request.testDevices = @[
                            @"2077ef9a63d2b398840261c8221a0c9a"  // Eric's iPod Touch
                            ];
    [self.interstitial loadRequest:request];
    
   
}
- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial {
    
    NSLog(@"interstitialDidDismissScreen");
    
}


#pragma mark -AlertShow

-(void)alertViewShow:(NSString *)alertMessage
{
    UIAlertView *globalAlertView = [[UIAlertView alloc]initWithTitle:@"MySportsCast" message:alertMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [globalAlertView show];
    globalAlertView  = nil;
    [appDelegate stopIndicators];
    
}


#pragma mark -  buttonAction

- (IBAction)backButtonClicked:(id)sender
{
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

- (IBAction)shareButtonClicked:(id)sender {
    
    UIAlertView *AlertView = [[UIAlertView alloc]initWithTitle:@"MySportsCast" message:@"Share With" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"TWITTER",@"FACEBOOK",@"INSTAGRAM",nil];
    [AlertView show];
    
    iscastShare = NO;
    AlertView  = nil;
    
  
    
}


#pragma mark - ServiceResponceDelegate

-(void)didReceiveResponseFromWebService:(NSDictionary *)responseDictionary
{
    

    
    if (isCheers == YES)
    {
        isCheers = NO;
        if ([[[responseDictionary valueForKey:@"Response"]valueForKey:@"ResponseInfo"] isEqualToString:@"SUCCESS"]) {
            
            
            [self removingObjectsFromCastArrays];

            [self webServiceRequest];
            
        }
        else
        {
            [self alertViewShow:@"Check Internetconnectio"];
        }
    }
    else if (isAttendingView == YES)
    {
        
            
            [self attendingListResponceHandlar:responseDictionary];
        
        
    }
    else if(isIamAttending == YES)
    {
        isIamAttending = NO;
        
        if ([[[responseDictionary valueForKey:@"Response"]valueForKey:@"ResponseInfo"] isEqualToString:@"SUCCESS"]) {
            
            [self removingObjectsFromCastArrays];
            [self webServiceRequest];
           
        }
        else
        {
            [self alertViewShow:@"Check Internetconnectio"];
        }
        
        
    }
    else if (isSendButtonClicked == YES)
    {
        isSendButtonClicked = NO;
        [self sendButtonRespoceHandler:responseDictionary];
        
        
    }
    
    else if (isComment == YES)
    {
        isCheers = NO;
        isIamAttending = NO;
        [self commentServiceResponceHandler:responseDictionary];
    
    }
    else if (isCommnetDelete == YES)
    {
        isCommnetDelete = NO;
        [self commnetDeleteRespoceHandeler:responseDictionary];
    }
    
    else
    
    {
        NSString * responceString = [[responseDictionary valueForKey:@"Response"]valueForKey:@"ResponseInfo"];
        
        if ([responceString isEqualToString:@"SUCCESS"])
        {
            resultDic = [[responseDictionary valueForKey:@"Response"]valueForKey:@"event_details"];
            
            if ([[[responseDictionary valueForKey:@"Response"]valueForKey:@"event_media"] isKindOfClass:[NSDictionary class]])
            {
                NSDictionary * eventMediaDic = [[responseDictionary valueForKey:@"Response"]valueForKey:@"event_media"];
                
                iseventMedia = YES;
                if ([[eventMediaDic valueForKey:@"all_data"] isKindOfClass:[NSArray class]])
                {
                
                     filterCastArray = [[eventMediaDic valueForKey:@"all_data"]mutableCopy];
                    
                }
               else if ([[eventMediaDic valueForKey:@"photo_data"] isKindOfClass:[NSArray class]])
                {
                    
                    filterCastArray = [[eventMediaDic valueForKey:@"photo_data"]mutableCopy];
                    
                }
               else if ([[eventMediaDic valueForKey:@"cast_data"] isKindOfClass:[NSArray class]])
               {
                   
                   filterCastArray = [[eventMediaDic valueForKey:@"cast_data"]mutableCopy];
                   
               }
               else if ([[eventMediaDic valueForKey:@"video_data"] isKindOfClass:[NSArray class]])
               {
                   
                   filterCastArray = [[eventMediaDic valueForKey:@"video_data"]mutableCopy];
                   
               }
                
               
                
            }
                else
                    {
                [filterCastArray addObject:@[]];
                iseventMedia = NO;
                //No media Data;
            }
            
            [self.tableViewEventDeatil reloadData];
            [appDelegate stopIndicators];

            
        }
        else
        {
            [self alertViewShow:@"No Data"];
        }

    }
    
   
    
 }
#pragma mark - commentServiceResponceHandler

-(void)commentServiceResponceHandler:(NSDictionary *)responceDic

{
    NSString * responceString =[[responceDic valueForKey:@"Response"]valueForKey:@"ResponseInfo"];
    if ([responceString isEqualToString:@"SUCCESS"])
    {
        arrayComment = [[[responceDic valueForKey:@"Response"]valueForKey:@"search_list"] mutableCopy];
        arrayComment = [[[arrayComment reverseObjectEnumerator] allObjects]mutableCopy];
      
    }
    else
    {

        [arrayComment removeAllObjects];

    }
    
    tableCommnet.delegate = self;
    tableCommnet.dataSource = self;
 
    [tableCommnet reloadData];
    
   
    
}

#pragma mark - sendButtonRespoceHandler

-(void)sendButtonRespoceHandler:(NSDictionary *)respoceDic
{
    
    NSString * responceString =[[respoceDic valueForKey:@"Response"]valueForKey:@"ResponseInfo"];
    if ([responceString isEqualToString:@"SUCCESS"])
    {
        
        NSString * commnetId = [[respoceDic valueForKey:@"Response"]valueForKey:@"comment_id"];
        NSMutableDictionary * recentCommentDic = [[NSMutableDictionary alloc]init];
        
        
        [recentCommentDic setObject:userProfileName forKey:@"first_name"];
        [recentCommentDic setObject:userProfileUrl forKey:@"image"];
        [recentCommentDic setObject:userId forKey:@"user_id"];
        [recentCommentDic setObject:commentStringTF forKey:@"comment_content"];
        [recentCommentDic setObject:commnetId forKey:@"comment_id"];
        
        [arrayComment addObject:recentCommentDic];
        arrayComment = [[[arrayComment reverseObjectEnumerator] allObjects]mutableCopy];
        
        [tableCommnet reloadData];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [tableCommnet scrollToRowAtIndexPath:indexPath
                             atScrollPosition:UITableViewScrollPositionBottom
                                     animated:YES];
        
    }
    
}


#pragma commnetDeleteRespoceHandeler

-(void)commnetDeleteRespoceHandeler:(NSDictionary *)responceDic
{
    NSString * responceString =[[responceDic valueForKey:@"Response"]valueForKey:@"ResponseInfo"];
    if ([responceString isEqualToString:@"SUCCESS"])
        
    {
         NSIndexPath *indexpath  = [NSIndexPath indexPathForRow:deletedIndex inSection:0];
        
        [tableCommnet scrollToRowAtIndexPath:indexpath
                            atScrollPosition:UITableViewScrollPositionTop
                                    animated:YES];
        
        [arrayComment removeObjectAtIndex:deletedIndex];
        
        [tableCommnet reloadData];
        
    }
    else
    {
        [self alertViewShow:@"UnableToDelete"];
    }
}

#pragma mark- tableViewDelegateMethods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == tableCommnet || tableView == attendingTableView)
    {
        return 1;
    }
    else
    {
        return 2;
    }
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (tableView == tableCommnet || tableView == attendingTableView)
    {
        return 0;
    }
    else
    {
        if (section == 0)
        {
            return 0;
        }
        else{
            return 44;
        }
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
   
    
    if (tableView == tableCommnet)
    {
        return [arrayComment count];
    }
    else if (tableView == attendingTableView)
    {
        return [attendingListArray count];
    }
    else
    {
        
        if (section ==0)
        {
            return 1;
        }
        else
        {
           if (iseventMedia == NO)
                
            {
                
                return 1;
            }
            else
            {
                // check condition for particular cast (video or photo or  text)
                return [filterCastArray count];
            }
            
       }

}
    
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == tableCommnet)
    {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell"];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"commentCell"];
        }
        for (UIImageView * imageView in cell.contentView.subviews)
        {
            if ([imageView isKindOfClass:[UIImageView class]])
            {
                [imageView removeFromSuperview];
            }
        }
        for (UILabel * label in cell.contentView.subviews)
        {
            if ([label isKindOfClass:[UILabel class]])
            {
                [label removeFromSuperview];
            }
        }
        for (UITextView * textview in cell.contentView.subviews)
        {
            if ([textview isKindOfClass:[UITextView class]])
            {
                [textview removeFromSuperview];
            }
        }
        for (UIButton * button in cell.contentView.subviews)
        {
            if ([button isKindOfClass:[UIButton class]])
            {
                [button removeFromSuperview];
            }
        }
        for (UIView * view in cell.contentView.subviews)
        {
            if ([view isKindOfClass:[UIView class]])
            {
                [view removeFromSuperview];
            }
        }
        
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 50, 50)];
        

        [imageView sd_setImageWithURL:[[arrayComment objectAtIndex:indexPath.row]valueForKey:@"image"] placeholderImage:[UIImage imageNamed:@""]];
        
        
        imageView.layer.cornerRadius = imageView.frame.size.width/2;
        imageView.layer.masksToBounds = YES;
        
        
        if ([userId isEqualToString:[[arrayComment objectAtIndex:indexPath.row]valueForKey:@"user_id"]])
        {
            UIButton * commentDeleteButton = [[UIButton alloc]initWithFrame:CGRectMake(tableCommnet.frame.size.width-25, 10, 25, 25)];
            [commentDeleteButton setImage:[UIImage imageNamed:@"trash.png"] forState:UIControlStateNormal];
            
            [commentDeleteButton addTarget:self action:@selector(commentDeleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            commentDeleteButton.tag = indexPath.row;
            [cell.contentView addSubview:commentDeleteButton];
            commentDeleteButton = nil;
            
        }
        
        UILabel * labelUserName = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(imageView.frame)+5+50, 5, 200, 40)];
        
        labelUserName.text = [[arrayComment objectAtIndex:indexPath.row]valueForKey:@"first_name"];
        
        labelUserName.textAlignment =NSTextAlignmentLeft;
        
        labelUserName.textColor =[UIColor blackColor];
        
        UITextView * commentTextLabel = [[UITextView alloc]init];
        
        commentTextLabel.text = [[arrayComment objectAtIndex:indexPath.row]valueForKey:@"comment_content"];
        
        
        
        CGSize boundingSize = CGSizeMake(260, 10000000);
        
        CGRect itemTextSize = [commentTextLabel.text boundingRectWithSize:boundingSize
                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                     attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}
                                                        context:nil];
        
        CGSize size = itemTextSize.size;
        float textHeight = size.height+10;
        
        commentTextLabel.frame = CGRectMake(5, CGRectGetMaxY(labelUserName.frame)+15,commentView.frame.size.width-10, textHeight);
       
        
        commentTextLabel.textAlignment =NSTextAlignmentLeft;
        commentTextLabel.textColor =[UIColor blackColor];
        commentTextLabel.font = [UIFont systemFontOfSize:14];
        commentTextLabel.scrollEnabled = NO;
        commentTextLabel.editable = NO;
        
        
        UIView * singleLineView =[[UIView alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(commentTextLabel.frame)+3, commentView.frame.size.width-10, 1)];
        
        singleLineView.backgroundColor = [UIColor lightGrayColor];
        
        
        
        
        [cell.contentView addSubview:imageView];
        [cell.contentView addSubview:labelUserName];
        [cell.contentView addSubview:commentTextLabel];
        [cell.contentView addSubview:singleLineView];
        
        imageView = nil;
        labelUserName = nil;
        commentTextLabel = nil;
        singleLineView = nil;
        return cell;
    }
    
    else if (tableView == attendingTableView)
    {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AttendingCell"];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AttendingCell"];
        }
        for (UIImageView * imageView in cell.contentView.subviews)
        {
            if ([imageView isKindOfClass:[UIImageView class]])
            {
                [imageView removeFromSuperview];
            }
        }
        for (UILabel * label in cell.contentView.subviews)
        {
            if ([label isKindOfClass:[UILabel class]])
            {
                [label removeFromSuperview];
            }
        }
        
        
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 50, 50)];
        
        
        [imageView sd_setImageWithURL:[[attendingListArray objectAtIndex:indexPath.row]valueForKey:@"profile_image"] placeholderImage:[UIImage imageNamed:@""]];
        
        imageView.layer.cornerRadius = imageView.frame.size.width/2;
        
        imageView.layer.masksToBounds = YES;
        
        UILabel * labelUserName = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(imageView.frame)+5+50, 5, 200, 40)];
        
        labelUserName.text = [[attendingListArray objectAtIndex:indexPath.row]valueForKey:@"first_name"];
        
        labelUserName.textAlignment =NSTextAlignmentLeft;
        
        labelUserName.textColor =[UIColor blackColor];
        
        [cell.contentView addSubview:imageView];
        [cell.contentView addSubview:labelUserName];
        
        imageView = nil;
        labelUserName = nil;
        return cell;
    }
    
    
    else
    {
        
        if (indexPath.section==0)
        {
            EventDeatilSectionCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellSection"];
            if (cell == nil)
            {
                NSArray * nib = [[NSBundle mainBundle]loadNibNamed:@"EventDeatilSectionCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
                
            }
            
            UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapheGestureMethod:)];
            
            UITapGestureRecognizer * tapgesture1  = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapheGestureMethod:)];
            
            [cell.imageViewRightDist addGestureRecognizer:tapgesture1];
            [cell.imageViewLeftDist addGestureRecognizer:tapGesture];
            
            
            
            cell.selectionStyle = UITableViewCellEditingStyleNone;
            
            cell.labelSportType.text = [NSString stringWithFormat:@" %@",[resultDic valueForKey:@"sport_name"]];
            
            cell.labelSportType.text = [cell.labelSportType.text uppercaseString];
            
            self.labelSelectedEventName.text = [NSString stringWithFormat:@" %@",[resultDic         valueForKey:@"event_title"]];
            
            self.labelSelectedEventName.text = [self.labelSelectedEventName.text uppercaseString];
            
            cell.labelEventType.text = [NSString stringWithFormat:@"%@   ",[resultDic valueForKey:@"event_type"]];
            
            cell.labelEventType.text = [cell.labelEventType.text uppercaseString];
            
            if ([cell.labelEventType.text isEqual:@""])
            {
                cell.labelEventType.text = @"--";
            }
            
            NSString * startDateString = [resultDic valueForKey:@"event_start_date"];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            
            [dateFormat setDateFormat:@"MM/dd/yyyy"];
            
            NSDate *startDate = [dateFormat dateFromString:startDateString];
            NSString * todayDatestring = [NSString stringWithFormat:@"%@",[NSDate date]];
            NSDate * todayDate = [dateFormat dateFromString:todayDatestring];
            
            
            if ([[resultDic valueForKey:@"is_stubhub_event"] isEqualToString:@"YES"] && [startDate compare:todayDate ] == NSOrderedAscending)
                
            {
           
                cell.buttonBooTicket.hidden = NO;
                cell.bookButtonHeightConstrain.constant = 47;
                cell.bookButtonVerticalSpace.constant = 11;
                cell.ViewYellowHeightConstrain.constant = 189;
                [cell.buttonBooTicket addTarget:self action:@selector(bookButtonClicked) forControlEvents:UIControlEventTouchUpInside];
                
                
            }
            else
            {
                cell.buttonBooTicket.hidden = YES;
                cell.bookButtonHeightConstrain.constant = 0;
                cell.bookButtonVerticalSpace.constant = 0;
                cell.ViewYellowHeightConstrain.constant = 189-(47+11);
            }
            
            cell.labelStartAndEndTime.frame = CGRectMake(0, 0, self.view.frame.size.width, 30);
            cell.labelStartAndEndTime.textColor = [UIColor whiteColor];
            [self labelFontBasedOnDevice:cell.labelStartAndEndTime];
            
            [cell.viewForStartTime addSubview:cell.labelStartAndEndTime];
            if (self.view.frame.size.width == 768)
            {
             cell.imageViewForCalendar.frame = CGRectMake(self.view.frame.size.width/2-190, 0, 30, 30);
            }
            else{
                cell.imageViewForCalendar.frame = CGRectMake(self.view.frame.size.width/2-150, 5, 20, 20);
            }
            [cell.imageViewForCalendar setImage:[UIImage imageNamed:@"event_details_calender120X120.png"]];
            
            [cell.viewForStartTime addSubview:cell.imageViewForCalendar];
            
           
          
            
            NSString *eventStartdatestr = [resultDic valueForKey:@"event_start_time" ];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            
            [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm"];
            [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
            NSDate *date = [dateFormatter dateFromString:eventStartdatestr]; // create date from string
            
            // change to a readable time format and change to local time zone
            [dateFormatter setDateFormat:@"MM/dd/yyyy-h:mm a"];
            [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
            NSString *startTimestamp = [dateFormatter stringFromDate:date];
            
            NSString *eventEnddatestr = [resultDic valueForKey:@"event_end_time"];
            NSDateFormatter *endDateFormatter = [[NSDateFormatter alloc] init];
            //[dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
            [endDateFormatter setDateFormat:@"MM/dd/yyyy HH:mm"];
            [endDateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
            NSDate *enddate = [endDateFormatter dateFromString:eventEnddatestr]; // create date from string
            
            // change to a readable time format and change to local time zone
            [endDateFormatter setDateFormat:@"MM/dd/yyyy-h:mm a"];
            [endDateFormatter setTimeZone:[NSTimeZone localTimeZone]];
            NSString *endTimestamp = [endDateFormatter stringFromDate:enddate];
            
            
            cell.labelStartAndEndTime.text = [NSString stringWithFormat:@"%@ to %@",startTimestamp,endTimestamp];
            cell.labelSelectedEventName.text = [resultDic valueForKey:@"event_title"];
            
            cell.labelSelectedEventName.text = [cell.labelSelectedEventName.text uppercaseString];
            
            cell.labelLocationName.text = [resultDic valueForKey:@"formatted_address"];
            
            
            NSInteger distance  = [[resultDic valueForKey:@"distance_from_user_location"]integerValue];
            
            cell.labelDistance.text = [NSString stringWithFormat:@"%ldm",(long)distance];
            
            for (UIButton * button in cell.buttonBackGroundView.subviews) {
                if ([button isKindOfClass:[UIButton class]])
                {
                    [button removeFromSuperview];
                }
            }
            for (UILabel * label in cell.buttonBackGroundView.subviews) {
                if ([label isKindOfClass:[UILabel class]])
                {
                    [label removeFromSuperview];
                }
            }
            
            
            CGSize screenSize = self.view.frame.size;
            float xvalu = (screenSize.width/5)/3;
            float withd = (screenSize.width/8);
            float labelWidth = (screenSize.width/4);
            
            buttonCheers = [[UIButton alloc]initWithFrame:CGRectMake(xvalu, 10, withd, withd)];
            buttonAttending = [[UIButton alloc]initWithFrame:CGRectMake(xvalu+withd*2, 10, withd, withd)];
            buttonIamAtending = [[UIButton alloc]initWithFrame:CGRectMake(xvalu+withd*4, 10, withd, withd)];
            buttonAddMedia = [[UIButton alloc]initWithFrame:CGRectMake(xvalu+withd*6, 10, withd, withd)];
            
            labelCheers = [[UILabel alloc]initWithFrame:CGRectMake(0, 10+withd, labelWidth, 40)];
            labelAttending = [[UILabel alloc]initWithFrame:CGRectMake(labelWidth, 10+withd, labelWidth, 40)];
            labelIamAttending = [[UILabel alloc]initWithFrame:CGRectMake(labelWidth*2, 10+withd, labelWidth, 40)];
            labelAddMedia = [[UILabel alloc]initWithFrame:CGRectMake(labelWidth*3, 10+withd, labelWidth, 40)];
            
            
            NSInteger attendting  = [[resultDic valueForKey:@"attending_count"]integerValue];
            labelAttending.text =[NSString stringWithFormat:@"%ld Attending",(long)attendting];
            
            labelIamAttending.text = @"Check In";
            labelAddMedia.text = @"Add Media";
            NSInteger chress  = [[resultDic valueForKey:@"event_likes"]integerValue];
            labelCheers.text = [NSString stringWithFormat:@"%ld cheers",(long)chress];
            
            labelCheers.textColor = [UIColor lightGrayColor];
            labelIamAttending.textColor = [UIColor lightGrayColor];
            labelAddMedia.textColor = [UIColor lightGrayColor];
            labelAttending.textColor = [UIColor lightGrayColor];
            
            NSString *likeString =[resultDic valueForKey:@"is_user_liked"];
            
            if ([likeString isEqualToString:@"0"])
            {
                [buttonCheers setImage:[UIImage imageNamed:@"event_details_cheers120X120.png"] forState:UIControlStateNormal];
            }
            else{
                
                [buttonCheers setImage:[UIImage imageNamed:@"event_details_cheered120X120.png"] forState:UIControlStateNormal];
            }
            NSString *attendingString =[resultDic valueForKey:@"attending_count"];
            
            if ([attendingString isEqualToString:@"0"])
            {
                [buttonAttending setImage:[UIImage imageNamed:@"event_details_no_attending120X120.png"] forState:UIControlStateNormal];
            }
            else{
                
                [buttonAttending setImage:[UIImage imageNamed:@"event_details_attending120X120.png"] forState:UIControlStateNormal];
            }
            
            NSString *iAmAttendingString =[[resultDic valueForKey:@"is_attending"]stringValue];
            if ([iAmAttendingString isEqualToString:@"0"])
            {
                [buttonIamAtending setImage:[UIImage imageNamed:@"event_details_iamattending_empty120X120.png"] forState:UIControlStateNormal];
                [buttonAddMedia setImage:[UIImage imageNamed:@"event_details_addmedia120X120.png"] forState:UIControlStateNormal];

                
                
            }
            else{
                
                [buttonIamAtending setImage:[UIImage imageNamed:@"event_details_iamattending120X120.png"] forState:UIControlStateNormal];
                [buttonAddMedia setImage:[UIImage imageNamed:@"event_details_addmedia_enable120X120.png"] forState:UIControlStateNormal];
                labelIamAttending.text = @"Attending";
            }
            
            
            [self labelFontBasedOnDevice:labelCheers];
            [self labelFontBasedOnDevice:labelAttending];
            [self labelFontBasedOnDevice:labelIamAttending];
            [self labelFontBasedOnDevice:labelAddMedia];
            
            [buttonAddMedia addTarget:self action:@selector(addMediaButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            
            [buttonAttending addTarget:self action:@selector(attendingButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            
            [buttonCheers addTarget:self action:@selector(cheersButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            
            [buttonIamAtending addTarget:self action:@selector(IamAttendingButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            
            
            [cell.buttonBackGroundView addSubview:buttonCheers];
            [cell.buttonBackGroundView addSubview:buttonAttending];
            [cell.buttonBackGroundView addSubview:buttonIamAtending];
            [cell.buttonBackGroundView addSubview:buttonAddMedia];
            
            [cell.buttonBackGroundView addSubview:labelCheers];
            [cell.buttonBackGroundView addSubview:labelAttending];
            [cell.buttonBackGroundView addSubview:labelIamAttending];
            [cell.buttonBackGroundView addSubview:labelAddMedia];
            
            return cell;
            
        }
        
        else
        {
            
#pragma mark - castCellsLoading
          
            if (iseventMedia == NO)
            {
                
                UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
                }
                
                for (UILabel * label in cell.subviews) {
                    if ([label isKindOfClass:[UILabel class]])
                    {
                        [label removeFromSuperview];
                    }
                }
                for (UIButton * button in cell.subviews)
                {
                    if ([button isKindOfClass:[UIButton class]])
                    {
                        [button removeFromSuperview];
                    }
                }
                UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, self.view.frame.size.width-20, 40)];
                label.text = @"No media exist!....";
                label.textAlignment = NSTextAlignmentCenter;
                label.textColor = [UIColor blackColor];
                
                buttonClickHereToaddMedia = [[UIButton alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(label.frame)+10, self.view.frame.size.width-60, 35)];
                
                [buttonClickHereToaddMedia setTitle:@"click here to add new media" forState:UIControlStateNormal];
                [buttonClickHereToaddMedia setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                buttonClickHereToaddMedia.layer.cornerRadius = 5;
                buttonClickHereToaddMedia.layer.borderColor =[UIColor colorWithRed:60.0f/255.0f green:142.0f/255.0f blue:249 alpha:1].CGColor;
                [buttonClickHereToaddMedia addTarget:self action:@selector(clickHereToaddMedia) forControlEvents:UIControlEventTouchUpInside];
                buttonClickHereToaddMedia.layer.borderWidth = 1.0f;
                [buttonClickHereToaddMedia setBackgroundColor:[UIColor whiteColor]];
                [cell addSubview:label];
                [cell addSubview:buttonClickHereToaddMedia];
                label = nil;
//                buttonClickHereToaddMedia = nil;
                menuButton.hidden = YES;
                return cell;
                
                
            }
            else
            {
                NSString * mediaData = [[filterCastArray objectAtIndex:indexPath.row]valueForKey:@"media_data"];
                NSString * photoString = [[filterCastArray objectAtIndex:indexPath.row]valueForKey:@"photo_url"];
                NSString * videoString = [[filterCastArray objectAtIndex:indexPath.row]valueForKey:@"video_url"];
                menuButton.hidden = NO;
                
#pragma mark - TextCell
                if (mediaData)
                {
                    
                    
                    EventDetailsTextCell * cell1 = [tableView dequeueReusableCellWithIdentifier:@"EventDetailsTextCell"];
                    
                    if (cell1 == nil)
                    {
                        NSArray * nib = [[NSBundle mainBundle]loadNibNamed:@"EventDetailsTextCell" owner:self options:nil];
                        cell1 = [nib objectAtIndex:0];
                        
                    }
                   
                    [cell1.imageViewDpText sd_setImageWithURL:[NSURL URLWithString:[[filterCastArray objectAtIndex:indexPath.row]valueForKey:@"profile_image"]] placeholderImage:[UIImage imageNamed:@""]];
                    
               
                    cell1.buttonCheers.tag = indexPath.row;
                    cell1.buttoncomment.tag = indexPath.row;
                    cell1.buttonShare.tag = indexPath.row;
                    
                    cell1.textViewText.text = [[filterCastArray objectAtIndex:indexPath.row]valueForKey:@"media_data"];
                    
                    CGSize boundingSize = CGSizeMake(260, 10000000);
                    
                    CGRect itemTextSize = [cell1.textViewText.text boundingRectWithSize:boundingSize
                                                                              options:NSStringDrawingUsesLineFragmentOrigin
                                                                           attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]}
                                                                            context:nil];
                    
                    
                    CGSize size = itemTextSize.size;
                    
                    float textHeight = size.height;
                    
                    cell1.textViewText.frame = CGRectMake(10, CGRectGetMaxY(cell1.imageViewDpText.frame)+7,self.view.frame.size.width-16, textHeight+10);
                    
                    
                    cell1.textViewText.backgroundColor = [UIColor clearColor];
                    cell1.labelUserNameText.text = [[filterCastArray objectAtIndex:indexPath.row]valueForKey:@"first_name"];
                    
                    cell1.selectionStyle = UITableViewCellEditingStyleNone;
                    cell1.textViewText.editable = NO;
                    cell1.textViewText.scrollEnabled = NO;
                    
                    NSString *likeString =[[filterCastArray objectAtIndex:indexPath.row]valueForKey:@"is_user_liked"];
                    if ([likeString isEqualToString:@"0"])
                    {
                        [cell1.buttonCheers setImage:[UIImage imageNamed:@"mega_phone120X120.png"] forState:UIControlStateNormal];
                    }
                    else{
                        [cell1.buttonCheers setImage:[UIImage imageNamed:@"mega_phone_cheer120X120.png"] forState:UIControlStateNormal];
                    }
                    
                    cell1.labelCheers.text = [NSString stringWithFormat:@"%@ cheers",[[filterCastArray objectAtIndex:indexPath.row]valueForKey:@"likes_count"]];
                    
                    cell1.labelComment.text = [NSString stringWithFormat:@"%@ comment",[[filterCastArray objectAtIndex:indexPath.row]valueForKey:@"comments_count"]];
                    
                    [cell1.buttonCheers addTarget:self action:@selector(castCheersButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                    
                    [cell1.buttoncomment addTarget:self action:@selector(castCommentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                    
                    [cell1.buttonShare addTarget:self action:@selector(castShareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                    
                    return cell1;
                    
                }
                
#pragma mark - photoCell
                else if (photoString)
                {
                    
                
                    EventDeatilPhotoCell * cell2 = [tableView dequeueReusableCellWithIdentifier:@"EventDeatilPhotoCell"];
                    if (cell2 == nil)
                    {
                        NSArray * nib = [[NSBundle mainBundle]loadNibNamed:@"EventDeatilPhotoCell" owner:self options:nil];
                        cell2 = [nib objectAtIndex:0];
                        
                    }
                    
                    for (UITextView * textView in cell2.viewLayer.subviews) {
                        if ([textView isKindOfClass:[UITextView class]]) {
                           
                            [textView removeFromSuperview];
                            
                        }
                    }
                    cell2.buttonCheers.tag = indexPath.row;
                    cell2.buttonComment.tag = indexPath.row;
                    cell2.buttonShare.tag = indexPath.row;
                    

                    //there any comment displaying comment
                    
                    if ([[[filterCastArray objectAtIndex:indexPath.row]valueForKey:@"comment_data"] isKindOfClass:[NSDictionary class]]) {
                      
                        cell2.LabelcommentLast = [[UITextView alloc]init];
                       
                        NSString * tepmString = [NSString stringWithFormat:@"%@:%@",[[[filterCastArray objectAtIndex:indexPath.row]valueForKey:@"comment_data"]valueForKey:@"latest_commented_by"], [[[filterCastArray objectAtIndex:indexPath.row]valueForKey:@"comment_data"]valueForKey:@"latest_comment"]];
                       
                        CGSize boundingSize = CGSizeMake(260, 10000000);
                        
                        CGRect itemTextSize = [tepmString boundingRectWithSize:boundingSize
                                                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                                                 attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]}
                                                                                    context:nil];
                        
                        
                        CGSize size = itemTextSize.size;
                        
                        float textHeight = size.height;
                        
                        if (self.view.frame.size.width == 768) {
                            
                         
                            cell2.imageViewCast.frame = CGRectMake(3, CGRectGetMaxY(cell2.imageViewDp.frame)+7, self.view.frame.size.width-16,504);
                         
                        }
                        else{
                            
                            
                           cell2.imageViewCast.frame = CGRectMake(3, CGRectGetMaxY(cell2.imageViewDp.frame)+7, self.view.frame.size.width-16,304);
                        }
                        
                        cell2.LabelcommentLast.frame = CGRectMake(3, CGRectGetMaxY(cell2.imageViewCast.frame)+1, self.view.frame.size.width-16, textHeight+15);
                     
                      cell2.LabelcommentLast.text = tepmString;
                        
                      cell2.LabelcommentLast.backgroundColor =[UIColor clearColor];
                      
                      cell2.LabelcommentLast.font = [UIFont systemFontOfSize:12];
                        
                      cell2.LabelcommentLast.scrollEnabled = NO;
                        
                      cell2.LabelcommentLast.editable = NO;
                        
                     [cell2.viewLayer addSubview:cell2.LabelcommentLast];
                    }
                    
                    //no comments for photo displaying only photo
                    else{
                        
                        if (self.view.frame.size.width == 768) {
                            
                            
                            cell2.imageViewCast.frame = CGRectMake(3, CGRectGetMaxY(cell2.imageViewDp.frame)+7, self.view.frame.size.width-16,504);
                            
                        }
                        else{
                            
                            
                            cell2.imageViewCast.frame = CGRectMake(3, CGRectGetMaxY(cell2.imageViewDp.frame)+7, self.view.frame.size.width-16,304);
                        }
                    }
                    [cell2.viewLayer addSubview:cell2.imageViewCast];
                    
                    
                    cell2.LabelcommentLast.textColor = [UIColor blackColor];
                    
                    
                    cellImageHeight = cell2.imageViewCast.frame.size.height;
                    
                    
                    [cell2.imageViewDp sd_setImageWithURL:[NSURL URLWithString:[[filterCastArray objectAtIndex:indexPath.row]valueForKey:@"profile_image"]] placeholderImage:[UIImage imageNamed:@""]];
                    
                    
                    [cell2.imageViewCast sd_setImageWithURL:[NSURL URLWithString:[[filterCastArray objectAtIndex:indexPath.row]valueForKey:@"photo_url"]] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
                    
                    [self cropimageView:cell2.imageViewCast];
                    
                    NSString *likeString =[[filterCastArray objectAtIndex:indexPath.row]valueForKey:@"is_user_liked"];
                    
                    if ([likeString isEqualToString:@"0"])
                    {
                        [cell2.buttonCheers setImage:[UIImage imageNamed:@"mega_phone120X120.png"] forState:UIControlStateNormal];
                    }
                    else{
                        [cell2.buttonCheers setImage:[UIImage imageNamed:@"mega_phone_cheer120X120.png"] forState:UIControlStateNormal];
                    }
                    
                    cell2.labelCheers.text = [NSString stringWithFormat:@"%@ cheers",[[filterCastArray objectAtIndex:indexPath.row]valueForKey:@"likes_count"]];
                    
                    cell2.labelComment.text = [NSString stringWithFormat:@"%@ comment",[[filterCastArray objectAtIndex:indexPath.row]valueForKey:@"comments_count"]];
                    
                    cell2.labelUserName.text = [[filterCastArray objectAtIndex:indexPath.row]valueForKey:@"first_name"];
                    cell2.selectionStyle = UITableViewCellEditingStyleNone;
                    
                    [cell2.buttonCheers addTarget:self action:@selector(castCheersButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                    
                    [cell2.buttonComment addTarget:self action:@selector(castCommentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                    
                    [cell2.buttonShare addTarget:self action:@selector(castShareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                   
                    
                    return cell2;
                }
#pragma mark - VideoCell
                
                else if (videoString)
                {
                    EventDetailVideoCell * cell3 = [tableView dequeueReusableCellWithIdentifier:@"EventDetailVideoCell"];
                    if (cell3 == nil)
                    {
                        
                        NSArray * nib = [[NSBundle mainBundle]loadNibNamed:@"EventDetailVideoCell" owner:self options:nil];
                        cell3 = [nib objectAtIndex:0];
                        
                    }
                    cell3.buttonCheers.tag = indexPath.row;
                    cell3.buttonComment.tag = indexPath.row;
                    cell3.buttonShare.tag = indexPath.row;
                    cell3.playButtonClicked.tag = indexPath.row;
                    [cell3.playButtonClicked addTarget:self action:@selector(playButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                    
                    NSString *likeString =[[filterCastArray objectAtIndex:indexPath.row]valueForKey:@"is_user_liked"];
                    
                    if ([likeString isEqualToString:@"0"])
                    {
                        [cell3.buttonCheers setImage:[UIImage imageNamed:@"mega_phone120X120.png"] forState:UIControlStateNormal];
                    }
                    else{
                        [cell3.buttonCheers setImage:[UIImage imageNamed:@"mega_phone_cheer120X120.png"] forState:UIControlStateNormal];
                    }
                    cell3.labelChrees.text = [NSString stringWithFormat:@"%@ cheers",[[filterCastArray objectAtIndex:indexPath.row]valueForKey:@"likes_count"]];
                    
                    cell3.labelComment.text = [NSString stringWithFormat:@"%@ comment",[[filterCastArray objectAtIndex:indexPath.row]valueForKey:@"comments_count"]];
                    
                    
                    [cell3.buttonCheers addTarget:self action:@selector(castCheersButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                    
                    [cell3.buttonComment addTarget:self action:@selector(castCommentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                    
                    [cell3.buttonShare addTarget:self action:@selector(castShareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                    
                    
                    
                    [cell3.imageViewCastVideo sd_setImageWithURL:[NSURL URLWithString:[[filterCastArray objectAtIndex:indexPath.row]valueForKey:@"video_thumb_url"]] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
                
                    
                    cell3.labelUserNameVideo.text = [[filterCastArray objectAtIndex:indexPath.row]valueForKey:@"first_name"];
                    
                    
                    [cell3.imageViewDpVideo sd_setImageWithURL:[NSURL URLWithString:[[filterCastArray objectAtIndex:indexPath.row]valueForKey:@"profile_image"]] placeholderImage:[UIImage imageNamed:@""]];
                    
                  
                    cell3.selectionStyle = UITableViewCellEditingStyleNone;
                    
                    return cell3;
                    
                }
                else
                {
                    return nil;
                }
            }
            
            
        }
    }


    
    
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == tableCommnet)
    {
        
        NSString *messageText = [[arrayComment objectAtIndex:indexPath.row]valueForKey:@"comment_content"];
        
        CGSize boundingSize = CGSizeMake(260, 10000000);
        
        CGRect itemTextSize = [messageText boundingRectWithSize:boundingSize
                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                     attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}
                                                        context:nil];
        
        CGSize size = itemTextSize.size;
        
        float textHeight = size.height+1+50+5+20;
        
        return textHeight;
      
    }
    else if (tableView == attendingTableView){
        
        return 60;
    }
    else
    {
        if (indexPath.section == 0)
        {
            
            NSString * startDateString = [resultDic valueForKey:@"event_start_date"];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            
            [dateFormat setDateFormat:@"MM/dd/yyyy"];
            
            NSDate *startDate = [dateFormat dateFromString:startDateString];
            NSString * todayDatestring = [NSString stringWithFormat:@"%@",[NSDate date]];
            NSDate * todayDate = [dateFormat dateFromString:todayDatestring];
            //stubhub events  for ipad
            if (self.view.frame.size.width == 768) {
                if ([[resultDic valueForKey:@"is_stubhub_event"] isEqualToString:@"YES"] && [startDate compare:todayDate ] == NSOrderedAscending) {
                    
                    
                    return 380;
                }
                else
                {
                    
                    
                    return 300;
                    
                }
            }
            else{
                if ([[resultDic valueForKey:@"is_stubhub_event"] isEqualToString:@"YES"] && [startDate compare:todayDate ] == NSOrderedAscending) {
                    
                    
                    return 280;
                }
                else
                {
                    
                    
                    return 233;
                    
                }
            }
            
            
            
            
        }
        else
        {
            
            NSString * mediaData = [[filterCastArray objectAtIndex:indexPath.row]valueForKey:@"media_data"];
            NSString * photoString = [[filterCastArray objectAtIndex:indexPath.row]valueForKey:@"photo_url"];
            NSString * videoString = [[filterCastArray objectAtIndex:indexPath.row]valueForKey:@"video_url"];
            //for ipad
            if (self.view.frame.size.width == 768)
            {
                
                
                if (iseventMedia ==NO)
                {
                    return 200;
                }
                else
                {
                    
                    if (mediaData)
                    {
                        NSString *messageText = [[filterCastArray objectAtIndex:indexPath.row]valueForKey:@"media_data"];
                        
                        CGSize boundingSize = CGSizeMake(260, 10000000);
                        
                        CGRect itemTextSize = [messageText boundingRectWithSize:boundingSize
                                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                                     attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}
                                                                        context:nil];
                        
                        CGSize size = itemTextSize.size;
                        
                        float textHeight = size.height+90+10;
                        
                        return textHeight;
                        
                        
                        
                       
                    }
                    else if (photoString)
                    {
                        float textHeight;
                        
                        if ([[[filterCastArray objectAtIndex:indexPath.row]valueForKey:@"comment_data"] isKindOfClass:[NSDictionary class]]) {
                            
                            
                            
                            NSString * tepmString = [NSString stringWithFormat:@"%@:%@",[[[filterCastArray objectAtIndex:indexPath.row]valueForKey:@"comment_data"]valueForKey:@"latest_commented_by"], [[[filterCastArray objectAtIndex:indexPath.row]valueForKey:@"comment_data"]valueForKey:@"latest_comment"]];
                            
                            CGSize boundingSize = CGSizeMake(260, 10000000);
                            
                            CGRect itemTextSize = [tepmString boundingRectWithSize:boundingSize
                                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                                        attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]}
                                                                           context:nil];
                            
                            
                            CGSize size = itemTextSize.size;
                            
                            textHeight = size.height+15;
                            if (self.view.frame.size.width == 768)
                            {
                               return textHeight+504+90+10;
                            }
                            else{
                                return textHeight+304+90+10;
                            }
                            
                        }
                        else{
                            if (self.view.frame.size.width == 768)
                            {
                                return 504+90+10;
                            }
                            else{
                                return 304+90+10;
                            }
                            
                           
                        }
                        
                    }
                    else if (videoString)
                    {
                        return 515;
                    }
                    else{
                        return 0;
                    }
                }
                
            }
            else
            {
               //for iphones
                
                if (iseventMedia ==NO)
                {
                    return 200;
                }
                else
                {
                   
                    if (mediaData)
                    {
                        NSString *messageText = [[filterCastArray objectAtIndex:indexPath.row]valueForKey:@"media_data"];
                        
                        CGSize boundingSize = CGSizeMake(260, 10000000);
                        
                        CGRect itemTextSize = [messageText boundingRectWithSize:boundingSize
                                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                                     attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}
                                                                        context:nil];
                        
                        CGSize size = itemTextSize.size;
                        
                        float textHeight = size.height+90+10;
                        
                        return textHeight;
                    
                        
                    }
                    else if (photoString)
                    {
                        
                        float textHeight;
                        
                        if ([[[filterCastArray objectAtIndex:indexPath.row]valueForKey:@"comment_data"] isKindOfClass:[NSDictionary class]]) {
                            
                            
                            
                            NSString * tepmString = [NSString stringWithFormat:@"%@:%@",[[[filterCastArray objectAtIndex:indexPath.row]valueForKey:@"comment_data"]valueForKey:@"latest_commented_by"], [[[filterCastArray objectAtIndex:indexPath.row]valueForKey:@"comment_data"]valueForKey:@"latest_comment"]];
                            
                            CGSize boundingSize = CGSizeMake(260, 10000000);
                            
                            CGRect itemTextSize = [tepmString boundingRectWithSize:boundingSize
                                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                                        attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]}
                                                                           context:nil];
                            
                            
                            CGSize size = itemTextSize.size;
                            
                            textHeight = size.height+15;
                            
                            return textHeight+304+90;
                        }
                        else{
                            return 304+60+40;
                        }
                   
                    }
                    else if (videoString)
                    {
                        return 315;
                    }
                    else{
                        return 0;
                    }
                }
                
                
            }
        }
    }
    
    
   
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    float width = self.tableViewEventDeatil.frame.size.width;

    if (section ==0)
    {
         return nil;
    }
    else{
        UIView * headerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0,width , 44)];
        
        headerView.backgroundColor = [UIColor colorWithRed:60.0f/255.0f green:142.0f/255.0f blue:249 alpha:1];
        
        UILabel * labelBroadCast = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, 44)];
        
        labelBroadCast.text = @"ALL BROADCASTS";
        labelBroadCast.textAlignment = NSTextAlignmentCenter;
        labelBroadCast.textColor = [UIColor whiteColor];
        menuButton = [[UIButton alloc]init];
        
        menuButton.frame = CGRectMake(5, 3, 40, 40);
        [menuButton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        
        [menuButton setImage:[UIImage imageNamed:@"filter_icon120X120.png"] forState:UIControlStateNormal];
        
        [menuButton addTarget:self action:@selector(menuButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        [headerView addSubview:labelBroadCast];
        
        [headerView addSubview:menuButton];
        
        return headerView;

    }
   
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableCommnet == tableView)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        NSLog(@"selectedComment");
    }
   
}

#pragma mark - EventDetailsbuttonAction


-(void)tapheGestureMethod:(UITapGestureRecognizer *)tapgesture
{
    [appDelegate userCurrentLocation];
    float userlatitude;
    float userlongitude;
    
    float eventLat = [[resultDic valueForKey:@"lat"]floatValue];
    
    float eventLng = [[resultDic valueForKey:@"lng"]floatValue];
    
    userlatitude= [[[NSUserDefaults standardUserDefaults] valueForKey:@"latitude"]floatValue];
    userlongitude =  [[[NSUserDefaults standardUserDefaults]valueForKey:@"longitude"]floatValue];
    
  
    NSString* url = [NSString stringWithFormat: @"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f",userlatitude, userlongitude,eventLat, eventLng];
    
    
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
    
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url]];
}

-(void)playButtonClicked:(UIButton *)Button

{
    
    PlayerViewController * playerVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PlayerViewController"];
    
    NSString * url = [[filterCastArray objectAtIndex:Button.tag]valueForKey:@"video_url"];
    
    playerVC.videoUrl = [NSURL URLWithString:url];
    
    self.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:playerVC animated:YES];
    
    
}



-(void)cheersButtonClicked
{

    
    NSString *likeString =[resultDic valueForKey:@"is_user_liked"];
    self.eventCreatedId = [resultDic valueForKey:@"event_creator_id"];
    
    isCheers =YES;
    isIamAttending =NO;
        
//      http://182.75.34.62/MySportsShare/web_services/update_event_like.php?user_id=298&pn_user_id=296&event_id=340&like_status=true
        
        if ([appDelegate connectedToInternet])
        {
            
            if ([likeString isEqualToString:@"0"])
            {
                
            [jsonObj getMethodforServiceRequest:[NSString stringWithFormat:@"%@update_event_like.php?user_id=%@&pn_user_id=%@&event_id=%@&like_status=true",commonURL,userId,self.eventCreatedId,self.eventId]];
                
            }
            
            else
            {
                
            [jsonObj getMethodforServiceRequest:[NSString stringWithFormat:@"%@update_event_like.php?user_id=%@&pn_user_id=%@&event_id=%@&like_status=false",commonURL,userId,self.eventCreatedId,self.eventId]];
                
            }
            
       }
        else{
            
            //no internet
        }

    
}
-(void)attendingButtonClicked
{
    
    isAttendingView = YES;
    
    layerView = [[UIView alloc]initWithFrame:self.view.frame];
    
    layerView.backgroundColor = [UIColor blackColor];
    
    layerView.alpha = 0.8;
    
    [self.view addSubview:layerView];
    
    [self.view addSubview: [self tableViewContentDispaly:CGRectMake(10, 66, self.view.frame.size.width-20, self.view.frame.size.height-120)]];
    
   
}

-(UIView *)tableViewContentDispaly:(CGRect)rect{
    
    
    
    viewBack = [[UIView alloc]initWithFrame:rect];
    
    viewBack.backgroundColor = [UIColor whiteColor];
    
    viewBack.layer.cornerRadius = 15;
    
    
    UIButton * backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 5, 30, 30)];
    
    [backButton addTarget:self action:@selector(removeObjectFromSuperView) forControlEvents:UIControlEventTouchUpInside];
    
    [backButton setImage:[UIImage imageNamed:@"crossround.png"] forState:UIControlStateNormal];
    
    attendingTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, viewBack.frame.size.width, viewBack.frame.size.height-50)];
    
    [viewBack addSubview:backButton];

    [viewBack addSubview:attendingTableView];
    
    [self attendingPeopleServiceCall];
    
    return viewBack;
    
    
}
-(void)attendingListResponceHandlar:(NSDictionary*)respoceDict
{
  
    if ([[[respoceDict valueForKey:@"Response"]valueForKey:@"ResponseInfo"] isEqualToString:@"SUCCESS"]) {
        
        attendingListArray = [[respoceDict valueForKey:@"Response"]valueForKey:@"attendees_list"];
        
        attendingTableView.delegate = self;
        
        attendingTableView.dataSource = self;
        
        [attendingTableView reloadData];
        
        
    }
    else{
        
    }
    [appDelegate stopIndicators];
    
}

-(void)attendingPeopleServiceCall{
    
    
    
//    http://192.10.250.62/MySportsShare/web_services/get_event_attendees.php?event_id=4088
    
    if ([appDelegate connectedToInternet]) {
        
        [appDelegate startIndicator];
        [jsonObj getMethodforServiceRequest:[NSString stringWithFormat:@"http://192.10.250.62/MySportsShare/web_services/get_event_attendees.php?event_id=%@",self.eventId]];
      
    }
    else
    {
        
        [self alertViewShow:@"No Internet Connection"];
        
    }
    
}

-(void)removeObjectFromSuperView{
    
    isAttendingView = NO;
    [viewBack removeFromSuperview];
    [layerView removeFromSuperview];
    
}

-(void)IamAttendingButtonClicked
{
    isCheers =NO;
    isIamAttending =YES;
    NSString *likeString =[[resultDic valueForKey:@"is_attending"]stringValue];

    //http://182.75.34.62/MySportsShare/web_services/update_event_attending.php?event_id=82&user_id=298&event_creator_id=13&status=0
    
    if ([appDelegate connectedToInternet])
    {
        [appDelegate startIndicator];
        if ([likeString isEqualToString:@"0"])
        {
            [jsonObj getMethodforServiceRequest:[NSString stringWithFormat:@"%@update_event_attending.php?event_id=%@&user_id=%@&event_creator_id=%@&status=1",commonURL,self.eventId,userId,self.eventCreatedId]];
            
        }
        
        else
        {
            [jsonObj getMethodforServiceRequest:[NSString stringWithFormat:@"%@update_event_attending.php?event_id=%@&user_id=%@&event_creator_id=%@&status=0",commonURL,self.eventId,userId,self.eventCreatedId]];
        }
        
    }
    else{
        
        //no internet
    }
    
}
-(void)addMediaButtonClicked
{
    isaddMediaButton = YES;
    
    [self addmedia];
}

-(void)clickHereToaddMedia
{
    isaddMediaButton = NO;
    
    [self addmedia];
}

#pragma mark - labelFontBasedOnDevice

-(void)labelFontBasedOnDevice:(UILabel * )label
{
    if (self.view.frame.size.width ==768)
    {
        label.font = [UIFont systemFontOfSize:17];
    }
    else{
        label.font = [UIFont systemFontOfSize:12];
    }
    
    label.textAlignment = NSTextAlignmentCenter;
}

#pragma mark - WebServiceRequest

-(void)webServiceRequest
{
   
    
    
    if ([appDelegate connectedToInternet])
    {
        [appDelegate startIndicator];
        
        //        http://182.75.34.62/MySportsShare/web_services/get_event_details.php?user_id=2&event_id=82&user_lat=43.59685959999999&user_lng=3.8502617000000328&login_user_id=2
        
        [jsonObj getMethodforServiceRequest:[NSString stringWithFormat:@"%@get_event_details.php?user_id=%@&event_id=%@&user_lat=17.3700&user_lng=78.4700&login_user_id=%@&filter_by=%@",commonURL,userId,self.eventId,userId,filterByString]];
        
        [self.tableViewEventDeatil setDelegate:self];
        [self.tableViewEventDeatil setDataSource:self];
        
    }
    else{
        
        [self alertViewShow:@"Please check internet Connection"];
    }
    
    self.labelSlectedEventType.text = self.selectedEventType;
    
}

#pragma mark -castButtonAction 


-(void)castCommentButtonClicked:(UIButton * )button
{

    
    commentMediaId = [[filterCastArray objectAtIndex:button.tag]valueForKey:@"media_id"];
    NSString * mediaType = [[filterCastArray objectAtIndex:button.tag]valueForKey:@"media_type"];
    self.eventCreatedId = [[filterCastArray objectAtIndex:button.tag]valueForKey:@"user_id"];
    
    if ([mediaType isEqualToString:@"cast"])
    {
        commentMediaType = @"cast";
        categorytype = @"cast";
    }
    else{
        if ([mediaType isEqualToString:@"photo"])
        {
           categorytype = @"photo";
            
        }
        else
        {
            categorytype = @"video";

        }
        commentMediaType = @"event_post";
    }
    isComment = YES;
    viewBlackLayer = [[UIView alloc]init];
    viewBlackLayer.frame = self.view.frame;
    [self.view addSubview:viewBlackLayer];
    viewBlackLayer.backgroundColor = [UIColor blackColor];
    viewBlackLayer.alpha = 0.5;
    
     commentView = [[UIView alloc]initWithFrame:CGRectMake(10, 62, self.view.frame.size.width-20, self.view.frame.size.height-124)];
    commentView.layer.cornerRadius = 15;
    commentView.backgroundColor = [UIColor whiteColor];
    
    buttonClose = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    
    [buttonClose setImage:[UIImage imageNamed:@"crossround.png"] forState:UIControlStateNormal];
    [buttonClose setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonClose addTarget:self action:@selector(closeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    UITextField * textFiledComment = [[UITextField alloc]initWithFrame:CGRectMake(10, CGRectGetHeight(commentView.frame)-40, CGRectGetWidth(commentView.frame)-60, 30)];
    textFiledComment.placeholder = @"Enter comment";
    textFiledComment.borderStyle = UITextBorderStyleBezel;
    UIButton * buttonSend = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(textFiledComment.frame)+10, CGRectGetHeight(commentView.frame)-50, 50, 50)];
    
    textFiledComment.delegate = self;
    
    [buttonSend setImage:[UIImage imageNamed:@"send.png"] forState:UIControlStateNormal];
    [buttonSend addTarget:self action:@selector(sendButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [commentView addSubview:buttonSend];
    [commentView addSubview:textFiledComment];
    [commentView addSubview:buttonClose];
    [self.view addSubview:commentView];
    
    //   http://182.75.34.62/MySportsShare/web_services/get_event_media_comments.php?media_id=376&media_type=cast
    if (tableCommnet == nil)
    {
        tableCommnet = [[UITableView alloc]initWithFrame:CGRectMake(5, 30, commentView.frame.size.width-10, commentView.frame.size.height-75)];
        
        tableCommnet.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    else
    {
        
    }
    
    if ([appDelegate connectedToInternet])
    {
        [jsonObj getMethodforServiceRequest:[NSString stringWithFormat:@"%@get_event_media_comments.php?media_id=%@&media_type=%@",commonURL,commentMediaId,commentMediaType]];
    }
    else
    {
        [self alertViewShow:@"No internet Connection"];
    }

    [commentView addSubview:tableCommnet];
    buttonSend = nil;
    textFiledComment = nil;
 
    
   
}

-(void)sendButtonClicked
{
   
    isComment = NO;
    isSendButtonClicked =YES;
   

   // http://182.75.34.62/MySportsShare/web_services/add_event_media_comment.php
    
   
    NSString * parameterString = [NSString stringWithFormat:@"user_id=%@&pn_user_id=%@&media_type=%@&media_id=%@&comment_content=%@&category=event&category_type=%@",userId,self.eventCreatedId,commentMediaType,commentMediaId,commentStringTF,categorytype];
    
    parameterString = [parameterString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSData* data = [parameterString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@add_event_media_comment.php",commonURL]];
    
    [jsonObj postMethodForServiceRequestWithPostData:data andWithPostUrl:url];
    
}


-(void)closeButtonAction
{
    [commentView removeFromSuperview];
    [viewBlackLayer removeFromSuperview];
    viewBlackLayer = nil;
    commentView = nil;
    buttonClose = nil;
    isCheers = NO;
    isIamAttending = NO;
    isSendButtonClicked = NO;
    isComment = NO;
    
    
    [self removingObjectsFromCastArrays];
    
    [self webServiceRequest];
    
}

-(void)removingObjectsFromCastArrays
{
    [arrayAllCast removeAllObjects];
    [arrayPohotCast removeAllObjects];
    [arrayTextCast removeAllObjects];
    [arrayVideoCast removeAllObjects];
}
-(void)castCheersButtonClicked:(UIButton * )button

{
   
 
    NSIndexPath *selectedIndex = [NSIndexPath indexPathForRow:button.tag inSection:1];//[NSIndexPath indexPathWithIndex:button.tag];
    UITableViewCell *selectedCell=[self.tableViewEventDeatil cellForRowAtIndexPath:selectedIndex];
    NSString * castType ;
    NSString * mediaType;
    if ([selectedCell.reuseIdentifier isEqualToString:@"EventDetailsTextCell"])
    {
        castType = @"cast";
        mediaType = @"cast";
    }
    else if ([selectedCell.reuseIdentifier isEqualToString:@"EventDeatilPhotoCell"])
    {
        castType = @"photo";
        mediaType = @"event_post";
        

    }
    else if ([selectedCell.reuseIdentifier isEqualToString:@"EventDetailVideoCell"])
    {
        castType = @"video";
        mediaType = @"event_post";
    }
    
//    http://182.75.34.62/MySportsShare/web_services/update_event_media_cheer.php?user_id=330&pn_user_id=357&media_id=85&media_type=cast&cheer_status=true&category=event&category_type=cast
    
    NSString *likeString =[[filterCastArray objectAtIndex:button.tag]valueForKey:@"is_user_liked"];
    NSString * mediaId = [[filterCastArray objectAtIndex:button.tag]valueForKey:@"media_id"];
    isCheers = YES;
    isIamAttending = NO;
    NSString * pnUserId = [[filterCastArray objectAtIndex:button.tag]valueForKey:@"user_id"];
    
    
    if ([appDelegate connectedToInternet])
    {
        
        if ([likeString isEqualToString:@"0"])
        {
            [jsonObj getMethodforServiceRequest:[NSString stringWithFormat:@"%@update_event_media_cheer.php?user_id=%@&pn_user_id=%@&media_id=%@&media_type=%@&cheer_status=true&category=event&category_type=%@",commonURL,userId,pnUserId,mediaId,mediaType,castType]];
            
        }
        
        else
        {
           [jsonObj getMethodforServiceRequest:[NSString stringWithFormat:@"%@update_event_media_cheer.php?user_id=%@&pn_user_id=%@#&media_id=%@&media_type=%@&cheer_status=false&category=event&category_type=%@",commonURL,userId,pnUserId,mediaId,mediaType,castType]];
        }
        
    }
    else{
        
        [self alertViewShow:@"please check internet connection"];
        
        //no internet
    }

    
}
-(void)castShareButtonClicked:(UIButton * )button
{
  
    
    iscastShare = YES;
    deletedIndex = button.tag;
    
    UIAlertView *AlertView = [[UIAlertView alloc]initWithTitle:@"MySportsCast" message:@"Share With" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"TWITTER",@"FACEBOOK",@"INSTAGRAM",nil];
    [AlertView show];
    AlertView  = nil;
    
    
}

-(void)menuButtonAction
{
  
    if (iseventMedia == NO) {
        [self alertViewShow:@"Add media to see"];
    }
    else{
        NSArray * array = @[@"All BroadCasts",@"Photos",@"Videos",@"Cast"];
        
        isMenuclicked = YES;
        
        [self actionSheetCreation:array];
    }
   
    
}


-(void)bookButtonClicked{
    
    
    NSURL *url = [NSURL URLWithString:[resultDic valueForKey:@"event_url"]];
    
    if (![[UIApplication sharedApplication] openURL:url]) {
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
    }
    
}


-(void)addmedia
{
     NSString *likeString =[[resultDic valueForKey:@"is_attending"]stringValue];
    
    if ([likeString isEqualToString:@"0"])
    {
        
       [self alertViewShow:@"Unable to add event media.  Please check I am attending for this event to add media."];
        
    }
    
    else
    {
        isMenuclicked = NO;
        NSArray * array = @[@"Add Cast",@"Add Photo",@"Add Video"];
        [self actionSheetCreation:array];
    }
}


-(void)commentDeleteButtonClicked:(UIButton *)button
{
    
    
//    http://182.75.34.62/MySportsShare/web_services/delete_comment.php?media_id=66&media_type=event_post
   
    deletedIndex =button.tag;
    
    isCommnetDelete = YES;
    isCheers = NO;
    isIamAttending = NO;
    isSendButtonClicked = NO;
    isComment = NO;
    
    
    commentMediaId = [[arrayComment objectAtIndex:button.tag]valueForKey:@"comment_id"];
    
    
    if ([appDelegate connectedToInternet])
    {
        [jsonObj getMethodforServiceRequest:[NSString stringWithFormat:@"%@delete_comment.php?media_id=%@&media_type=%@",commonURL,commentMediaId,commentMediaType]];
    }
    else
    {
        [self alertViewShow:@"UnableToDelete"];
    }
    
}




#pragma mark - ActionSheetCreation

-(void)actionSheetCreation:(NSArray *)SheetButton

{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"My SportsCast"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet]; // All BroadCasts
    if (isMenuclicked == YES){
        
        UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"All BroadCasts"
                                                              style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                  NSLog(@"You pressed button one");
                                                                  [self callAllBroadcast];
                                                              }]; // 2
        UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"Photos"
                                                               style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                   NSLog(@"You pressed button two");
                                                                   [self callPhotos];
                                                               }]; // 3
        
        UIAlertAction *thirdAction = [UIAlertAction actionWithTitle:@"Videos"
                                                              style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                  [self callVedios];
                                                              }];
        UIAlertAction *fourthAction = [UIAlertAction actionWithTitle:@"Cast"
                                                               style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                   [self callCast];
                                                               }];
        
        [alert addAction:firstAction];
        [alert addAction:secondAction]; // 5
        [alert addAction:thirdAction];
        [alert addAction:fourthAction];
        
    }
    else // when add media Clicked
    {
        
        NSMutableDictionary * eventDetailDic = [[NSMutableDictionary alloc]init];
        
        [eventDetailDic setObject:self.labelSelectedEventName.text forKey:@"EventName"];
        
        [eventDetailDic setObject:self.eventId forKey:@"EventId"];
        
        NSData * eventDetailData = [NSKeyedArchiver archivedDataWithRootObject:eventDetailDic];
        
        [[NSUserDefaults standardUserDefaults]setObject:eventDetailData forKey:@"eventDeatils"];
        
        UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Add Cast"
                                                              style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                  NSLog(@"You pressed button one");
                                                                  [self callAddCast];
                                                              }]; // 2
        UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"Add Photo"
                                                               style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                   NSLog(@"You pressed button two");
                                                                   [self callAddPhoto];
                                                               }]; // 3
        
        UIAlertAction *thirdAction = [UIAlertAction actionWithTitle:@"Add Video"
                                                              style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                  [self callAddVedio];
                                                              }];
        
        [alert addAction:firstAction];
        [alert addAction:secondAction]; // 5
        [alert addAction:thirdAction];
        
    }
    UIAlertAction *fourthAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                               [alert dismissViewControllerAnimated:YES completion:nil];
                                                           }];
    [alert addAction:fourthAction];
    
    if (isipad()) {
        
        UIPopoverPresentationController *popPC = alert.popoverPresentationController;
        popPC.permittedArrowDirections = UIPopoverArrowDirectionAny;
        if (isMenuclicked == YES) {
            
            popPC.sourceView =menuButton;
            popPC.sourceRect = menuButton.bounds;
        }
        else if (isaddMediaButton == YES)
        {
            popPC.sourceView =buttonAddMedia;
            popPC.sourceRect = buttonAddMedia.bounds;
        }
        else{
            
            popPC.sourceView =buttonClickHereToaddMedia;
            popPC.sourceRect = buttonClickHereToaddMedia.bounds;
           
            
        }
      
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    else
    {
        [self presentViewController:alert animated:YES completion:nil]; //
    }
}
-(void)callAllBroadcast{
//    filterCastArray = arrayAllCast;
    filterByString = @"all";
    [filterCastArray removeAllObjects];
    [self webServiceRequest];
//    [self.tableViewEventDeatil reloadData];
}
-(void)callPhotos{
    filterByString = @"photo";
    [filterCastArray removeAllObjects];
    [self webServiceRequest];
//    filterCastArray = arrayPohotCast;
//    [self.tableViewEventDeatil reloadData];
}
-(void)callVedios{
    filterByString = @"video";
    [filterCastArray removeAllObjects];
    [self webServiceRequest];
    
//    filterCastArray = arrayVideoCast;
//    [self.tableViewEventDeatil reloadData];
}
-(void)callCast{
    
    filterByString = @"cast";
    [filterCastArray removeAllObjects];
    [self webServiceRequest];
    
//    [self.tableViewEventDeatil reloadData];
//    filterCastArray = arrayTextCast;
}
-(void)callAddCast{
    
    
    CastTextViewController * castTextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CastTextViewController"];
    
    [self.navigationController pushViewController:castTextVC animated:YES];
    
}
-(void)callAddVedio{
    CastVideoViewController * castTextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CastVideoViewController"];
    
    [self.navigationController pushViewController:castTextVC animated:YES];
    
    
}
-(void)callAddPhoto{
    CastPhotoViewController * castTextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CastPhotoViewController"];
    
    [self.navigationController pushViewController:castTextVC animated:YES];
    
}

#pragma mark - actionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if (isMenuclicked == YES)
    {
        isMenuclicked = NO;
        
        
        
        if ([title isEqualToString:@"All BroadCasts"])
        {
            
            filterCastArray = arrayAllCast;
            
        }
        
        else if ([title isEqualToString:@"Photos"])
        {
            
            
            filterCastArray = arrayPohotCast;
            
            
        }
        else if ([title isEqualToString:@"Videos"])
        {
            
            filterCastArray = arrayVideoCast;
            
        }
        
        else if ([title isEqualToString:@"Cast"])
        {
            
            filterCastArray = arrayTextCast;
            
        }
        
        [self.tableViewEventDeatil reloadData];
    }
    else
    {
        
        
        NSMutableDictionary * eventDetailDic = [[NSMutableDictionary alloc]init];
        
        [eventDetailDic setObject:self.labelSelectedEventName.text forKey:@"EventName"];
        
        [eventDetailDic setObject:self.eventId forKey:@"EventId"];
        
        NSData * eventDetailData = [NSKeyedArchiver archivedDataWithRootObject:eventDetailDic];
        
        [[NSUserDefaults standardUserDefaults]setObject:eventDetailData forKey:@"eventDeatils"];
        
        
        if ([title isEqualToString:@"Add Cast"])
        {
            
            CastTextViewController * castTextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CastTextViewController"];
            
            [self.navigationController pushViewController:castTextVC animated:YES];
            
        }
        else if ([title isEqualToString:@"Add Photo"])
        {
            
            
            CastPhotoViewController * castTextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CastPhotoViewController"];
            
            [self.navigationController pushViewController:castTextVC animated:YES];
        }
        else if ([title isEqualToString:@"Add Video"])
        {
            
            CastVideoViewController * castTextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CastVideoViewController"];
            
            [self.navigationController pushViewController:castTextVC animated:YES];
        }
    }
    
    
    if ([title isEqualToString:@"Cancel"])
    {
        [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
        
        
    }
    
    
    
}
#pragma mark - textFiledDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
   
    
   }

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        commentView.frame = CGRectMake(10, 64, commentView.frame.size.width, commentView.frame.size.height);
        
    }];

    
    }
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    commentStringTF = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - ImageMode
-(void)cropimageView:(UIImageView*)imgView
{
    imgView.layer.contents = (__bridge id)(imgView.image.CGImage);
    imgView.layer.contentsGravity = kCAGravityResizeAspectFill;
    imgView.layer.contentsScale = imgView.image.scale;
    imgView.layer.masksToBounds = YES;
}
#pragma mark - ShareHandelarWithAlertViewAction 

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.message isEqualToString:@"Share With"]) {
        SLComposeViewController *controller;
        NSURL * eventUrl;
        NSString * intialiText;
        UIImage * image;
       
        
        
        if (iscastShare == YES) {
            
            if ([[[filterCastArray objectAtIndex:deletedIndex]valueForKey:@"media_type"] isEqualToString:@"photo"]) {
               
                eventUrl = [NSURL URLWithString:@""];
                
                image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[filterCastArray objectAtIndex:deletedIndex]valueForKey:@"photo_url"]]]];
                
                
              intialiText = @"MySportsCast";
            }
            else if ([[[filterCastArray objectAtIndex:deletedIndex]valueForKey:@"media_type"] isEqualToString:@"cast"]){
                
                
                eventUrl = [NSURL URLWithString:@""];
                
                intialiText = [[filterCastArray objectAtIndex:deletedIndex]valueForKey:@"media_data"];
            }
            else if ([[[filterCastArray objectAtIndex:deletedIndex]valueForKey:@"media_type"] isEqualToString:@"video"]){
                
               intialiText = @"MySportsCast";
               eventUrl = [NSURL URLWithString:[[filterCastArray objectAtIndex:deletedIndex]valueForKey:@"video_url"]];
            }
        }
        else{
            
            eventUrl=[NSURL URLWithString:[resultDic valueForKey:@"event_url"]];
            
             image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[resultDic valueForKey:@"event_image"]]]];
        }
        
        if (buttonIndex == 1)
        {
         
                controller=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            
                [controller addURL:eventUrl];
            
                [controller setInitialText:intialiText];
            
                [controller addImage:image];
          
                [self presentViewController:controller animated:YES completion:nil];
         
        }else if (buttonIndex == 2){
            
            
                controller=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                
                [controller addURL:eventUrl];
            
                [controller setInitialText:intialiText];
            
                [controller addImage:image];
         
            
            [self presentViewController:controller animated:YES completion:Nil];
            
            
        }else if (buttonIndex == 3){
            
            UIImageView * imageview = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 350, 350)];
            
           
            if (image) {
                 imageview.image = image;
            }
            else{
                imageview.image = [UIImage imageNamed:@"splash_screen_inner.jpg"];
            }
           
            
            CGFloat cropVal = (imageview.image.size.height > imageview.image.size.width ? imageview.image.size.width : imageview.image.size.height);
           
            
            cropVal *= [imageview.image scale];
            
            CGRect cropRect = (CGRect){.size.height = cropVal, .size.width = cropVal};
            
            CGImageRef imageRef = CGImageCreateWithImageInRect([imageview.image CGImage], cropRect);
            
            NSData *imageData = UIImageJPEGRepresentation([UIImage imageWithCGImage:imageRef], 1.0);
            CGImageRelease(imageRef);
            
            NSString *writePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"instagram.igo"];
            
            if (![imageData writeToFile:writePath atomically:YES]) {
                // failure
                NSLog(@"image save failed to path %@", writePath);
                return;
            } else {
                // success.
            }
            
            // send it to instagram.
            NSURL *fileURL = [NSURL fileURLWithPath:writePath];
            
            self.dicInteractionVC = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
            self.dicInteractionVC.delegate = self;
            [self.dicInteractionVC setUTI:@"com.instagram.MySportsCast"];
            
            // [self.dic setAnnotation:@{@"InstagramCaption" : @"https://play.google.com/store/apps/details?id=idreammedia.ramcharanstar&hl=en"}];
            
            self.dicInteractionVC.annotation = [NSDictionary dictionaryWithObject:@"MySportsCast" forKey:@"InstagramCaption"];
            
            
            [self.dicInteractionVC presentOpenInMenuFromRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) inView:self.view animated:YES];
            
            }
          
        }
    
}


- (UIDocumentInteractionController *) setupControllerWithURL: (NSURL*) fileURL usingDelegate: (id <UIDocumentInteractionControllerDelegate>) interactionDelegate {
    NSLog(@"file url %@",fileURL);
    UIDocumentInteractionController *interactionController = [UIDocumentInteractionController interactionControllerWithURL: fileURL];
    interactionController.delegate = interactionDelegate;
    
    return interactionController;
}



- (void)keyboardWillChange:(NSNotification *)notification {
    
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    [UIView animateWithDuration:0.3 animations:^{
        
        commentView.frame = CGRectMake(10, -keyboardFrameBeginRect.size.height+90, commentView.frame.size.width, commentView.frame.size.height);
    }];
    
}
#pragma mark - googleMapDelegate

- (void)openMapInGoogleMaps {
    GoogleMapDefinition *mapDefinition = [[GoogleMapDefinition alloc] init];
    
    if (mapDefinition.queryString && CLLocationCoordinate2DIsValid(mapDefinition.center)) {
        // Sets some reasonable bounds for the "Pizza near Times Square" types of maps
        mapDefinition.zoomLevel = 15.0f;
    }
    [[OpenInGoogleMapsController sharedInstance] openMap:mapDefinition];
    
}

@end
