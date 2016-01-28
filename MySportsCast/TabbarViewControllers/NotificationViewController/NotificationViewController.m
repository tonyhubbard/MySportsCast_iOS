//
//  NotificationViewController.m
//  MySportsCast
//
//  Created by SPARSHMAC08 on 24/08/15.
//  Copyright (c) 2015 SPARSHMAC08. All rights reserved.
//
#import "EventDestialsViewController.h"
#import "NotificationViewController.h"
#import "profileViewController.h"
#import "UIImageView+WebCache.h"
#import "MyPostViewController.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "JsonClass.h"

@interface NotificationViewController ()<UITableViewDataSource,UITableViewDelegate,WebServiceProtocol>
{
    AppDelegate * appdelegate;
    JsonClass * jsonObj;
    NSMutableArray * resultArray;
    NSInteger pageIndex;
    NSString * userId;
    BOOL isaccept;
    BOOL isRejected;
    NSInteger selectedIndex;
}
@end

@implementation NotificationViewController
@synthesize notificationsTable;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
    notificationsTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    appdelegate = [UIApplication sharedApplication].delegate;
    jsonObj = [[JsonClass alloc]init];
     resultArray = [[NSMutableArray alloc]init];
    
    jsonObj.delegate = self;
     userId = [[NSUserDefaults standardUserDefaults]valueForKey:@"loginId"];
   
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    pageIndex = 0;
   
    [self serviceCall:userId andPageIndex:pageIndex];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    
//    [resultArray removeAllObjects];
    
}
#pragma mark - UITableview delegate methods


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [resultArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    
    for (UIImageView * imageview in cell.subviews) {
       
        if ([imageview isKindOfClass:[UIImageView class]]) {
            
            [imageview removeFromSuperview];
        }
        
    }
    
    for (UITextView * textview in cell.subviews) {
        
        if ([textview isKindOfClass:[UITextView class]]) {
            
            [textview removeFromSuperview];
        }
        
    }
    for (UILabel * label in cell.subviews) {
        
        if ([label isKindOfClass:[UILabel class]]) {
            
            [label removeFromSuperview];
        }
        
    }
    
    for (UIView * view in cell.subviews) {
        
        if ([view isKindOfClass:[UIView class]]) {
            
            [view removeFromSuperview];
        }
        
    }
    
    UIImageView * pfImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 60, 60)];
    
    [pfImageView sd_setImageWithURL:[NSURL URLWithString: [[resultArray objectAtIndex:indexPath.row]valueForKey:@"image_url"]]placeholderImage:[UIImage imageNamed:@"ProfilePic.png"]];
    
    pfImageView.layer.cornerRadius = pfImageView.frame.size.width/2;
    pfImageView.clipsToBounds = YES;
    
    UILabel * labelNotifierName = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(pfImageView.frame)+2, 5, self.view.frame.size.width-10, 30)];
    
   
    
    
    labelNotifierName.text = [[resultArray objectAtIndex:indexPath.row]valueForKey:@"sender_name"];
    
    labelNotifierName.font= [UIFont systemFontOfSize:15];
    
    UITextView * textViewNotificationMessage = [[UITextView alloc]init];
    
    textViewNotificationMessage.text = [[resultArray objectAtIndex:indexPath.row]valueForKey:@"notification_msg"];
        
    CGSize boundingSize = CGSizeMake(260, 10000000);
    
    CGRect itemTextSize = [textViewNotificationMessage.text boundingRectWithSize:boundingSize
                                                              options:NSStringDrawingUsesLineFragmentOrigin
                                                           attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}
                                                              context:nil];
    
    CGSize size = itemTextSize.size;
    float textHeight = size.height+10;
    
    textViewNotificationMessage.frame = CGRectMake(CGRectGetMaxX(pfImageView.frame)+2, CGRectGetMaxY(labelNotifierName.frame)+2,labelNotifierName.frame.size.width-CGRectGetMaxX(pfImageView.frame)+2, textHeight);
    
    textViewNotificationMessage.scrollEnabled = NO;
    textViewNotificationMessage.editable = NO;
    
    [cell addSubview:pfImageView];
    [cell addSubview:labelNotifierName];
    [cell addSubview:textViewNotificationMessage];
    UIButton * acceptButton;
    UIButton * rejectButton;
    
    if ([[[resultArray objectAtIndex:indexPath.row]valueForKey:@"text"]isEqualToString:@"requested"]) {
        
         acceptButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(pfImageView.frame)+2, CGRectGetMaxY(textViewNotificationMessage.frame)+6, textViewNotificationMessage.frame.size.width/2, 25)];
        
        [acceptButton setTitle:@"ACCEPT" forState:UIControlStateNormal];
        
        acceptButton.layer.cornerRadius = 5;
        rejectButton.layer.borderWidth = 1;
        
        [acceptButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        acceptButton.backgroundColor = [UIColor colorWithRed:135.0f/255.0f green:204.0f/255.0f blue:125.0f/255.0f alpha:1.0f];
        
        rejectButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(acceptButton.frame)+5, CGRectGetMaxY(textViewNotificationMessage.frame)+6, textViewNotificationMessage.frame.size.width/2, 25)];
        
        [rejectButton setTitle:@"REJECT" forState:UIControlStateNormal];
        
        rejectButton.layer.cornerRadius = 5;
        rejectButton.layer.borderWidth = 1;
        
        rejectButton.layer.borderColor = [UIColor colorWithRed:59.0f/255.0f green:89.0f/255.0f blue:152.0f/255.0f alpha:1].CGColor;
        
        rejectButton.backgroundColor = [UIColor whiteColor];
        
        [rejectButton setTitleColor:[UIColor colorWithRed:59.0f/255.0f green:89.0f/255.0f blue:152.0f/255.0f alpha:1] forState:UIControlStateNormal];
        
        UIView * singleLine = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(rejectButton.frame)+1, self.view.frame.size.width, 1)];
        
        [cell addSubview:acceptButton];
        
        [cell addSubview:rejectButton];
        
        singleLine.backgroundColor = [UIColor lightGrayColor];
        
        [cell addSubview:singleLine];
        
        
        rejectButton.tag = indexPath.row;
        acceptButton.tag = indexPath.row;
        
       [acceptButton addTarget:self action:@selector(acceptButtonClicked:) forControlEvents:UIControlEventTouchUpInside
        ];
        
        [rejectButton addTarget:self action:@selector(rejectButtonClicked:) forControlEvents:UIControlEventTouchUpInside
         ];
        
    }
    else{
        UIView * singleLine = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(textViewNotificationMessage.frame)+1, self.view.frame.size.width, 1)];
        
         singleLine.backgroundColor = [UIColor lightGrayColor];
        
         [cell addSubview:singleLine];
    }
    
       return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([[[resultArray objectAtIndex:indexPath.row]valueForKey:@"notification_type"] isEqualToString:@"EVENT_PHOTO_TAGGED_USER"] || [[[resultArray objectAtIndex:indexPath.row]valueForKey:@"notification_type"] isEqualToString:@"EVENT_VIDEO_TAGGED_USER"] ||[[[resultArray objectAtIndex:indexPath.row]valueForKey:@"notification_type"] isEqualToString:@"EVENT_CAST_COMMENT"] || [[[resultArray objectAtIndex:indexPath.row]valueForKey:@"notification_type"] isEqualToString:@"EVENT_CAST_LIKE"] || [[[resultArray objectAtIndex:indexPath.row]valueForKey:@"notification_type"] isEqualToString:@"EVENT_PHOTO_LIKE"] || [[[resultArray objectAtIndex:indexPath.row]valueForKey:@"notification_type"] isEqualToString:@"EVENT_VIDEO_LIKE"] || [[[resultArray objectAtIndex:indexPath.row]valueForKey:@"notification_type"] isEqualToString:@"EVENT_PHOTO_COMMENT"] || [[[resultArray objectAtIndex:indexPath.row]valueForKey:@"notification_type"] isEqualToString:@"EVENT_VIDEO_COMMENT"]) {
        
        
        MyPostViewController * mypostVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyPostViewController"];
        
        
        if ([[[resultArray objectAtIndex:indexPath.row]valueForKey:@"notification_type"] isEqualToString:@"EVENT_PHOTO_TAGGED_USER"] || [[[resultArray objectAtIndex:indexPath.row]valueForKey:@"notification_type"] isEqualToString:@"EVENT_PHOTO_LIKE"] || [[[resultArray objectAtIndex:indexPath.row]valueForKey:@"notification_type"] isEqualToString:@"EVENT_PHOTO_COMMENT"] ) {
            
            mypostVC.notificationMediaType = @"PHOTO";
            
        }
        else if ([[[resultArray objectAtIndex:indexPath.row]valueForKey:@"notification_type"] isEqualToString:@"EVENT_VIDEO_TAGGED_USER"] || [[[resultArray objectAtIndex:indexPath.row]valueForKey:@"notification_type"] isEqualToString:@"EVENT_VIDEO_LIKE"] || [[[resultArray objectAtIndex:indexPath.row]valueForKey:@"notification_type"] isEqualToString:@"EVENT_VIDEO_COMMENT"]){
            
           mypostVC.notificationMediaType = @"VIDEO";
            
        }
        
        else{
            
            mypostVC.notificationMediaType = @"CAST";
        }
        mypostVC.isMediaFromNotification = YES;
        mypostVC.mediaIdFormNotifcationScreen = [[resultArray objectAtIndex:indexPath.row]valueForKey:@"data_id"];
        appdelegate.profileSelectedUSeName =  [[resultArray objectAtIndex:indexPath.row]valueForKey:@"sender_name"];
        [self.navigationController pushViewController:mypostVC animated:YES];
        
      
    }
   else if ([[[resultArray objectAtIndex:indexPath.row]valueForKey:@"notification_type"] isEqualToString:@"FOLLOW_USER"])
   {
       //navigate to profile screen
       
       profileViewController * profileVC  = [self.storyboard instantiateViewControllerWithIdentifier:@"profileViewController"];
       
       profileVC.hidesBottomBarWhenPushed = YES;
       
       appdelegate.isfromNotificationScreen = YES;
       
       appdelegate.notificationSelectedId = [[resultArray objectAtIndex:indexPath.row]valueForKey:@"sender_id"];
//       appdelegate.profileViewNavAccount = appdelegate.profileViewNavAccount+2;
       
       [self.navigationController pushViewController:profileVC animated:YES];
       
       
       NSLog(@"Navigate to profile screen");
       
       
       
   }
   else if ([[[resultArray objectAtIndex:indexPath.row]valueForKey:@"notification_type"] isEqualToString:@"EVENT_INVITE"] || [[[resultArray objectAtIndex:indexPath.row]valueForKey:@"notification_type"] isEqualToString:@"EVENT_LIKE"])
   {
       //navigate to eventDeatilScreen
       
       EventDestialsViewController * eventDetailsScreen  = [self.storyboard instantiateViewControllerWithIdentifier:@"EventDestialsViewController"];
       
       eventDetailsScreen.hidesBottomBarWhenPushed = YES;
       eventDetailsScreen.eventId = [[resultArray objectAtIndex:indexPath.row]valueForKey:@"event_id"];
       [self.navigationController pushViewController:eventDetailsScreen animated:YES];
       
       NSLog(@"Navigate to eventDeatilScreen");
   }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    NSString * textViewString = [[resultArray objectAtIndex:indexPath.row]valueForKey:@"notification_msg"];
    
    
    
    CGSize boundingSize = CGSizeMake(260, 10000000);
    
    CGRect itemTextSize = [textViewString boundingRectWithSize:boundingSize
                                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                                      attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}
                                                                         context:nil];
    
    CGSize size = itemTextSize.size;
    float textHeight = size.height+10;
    
    if ([[[resultArray objectAtIndex:indexPath.row]valueForKey:@"text"]isEqualToString:@"requested"]) {
        
         return 30+textHeight+10+40;
        
    }
    else{
        
        return 30+textHeight+10;
    }
    
    
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)serviceCall:(NSString *)userID andPageIndex:(NSInteger )pageIndexs;
{
    
//  http://182.75.34.62/MySportsShare/web_services/get_notifications.php?user_id=298&page_id=0
    
    [appdelegate startIndicator];
    
    if ([appdelegate connectedToInternet]) {
        
        
        [jsonObj getMethodforServiceRequest:[NSString stringWithFormat:@"%@get_notifications.php?user_id=%@&page_id=%ld",commonURL,userID,(long)pageIndexs]];
        
    }
    else{
        
        [self alertViewShow:@"No inernetconnection"];
    }
    
}

#pragma mark -AlertShow

-(void)alertViewShow:(NSString *)alertMessage
{
    UIAlertView *globalAlertView = [[UIAlertView alloc]initWithTitle:@"MySportsCast" message:alertMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [globalAlertView show];
    globalAlertView  = nil;
    [appdelegate stopIndicators];
    
}

-(void)didReceiveResponseFromWebService:(NSDictionary *)responseDictionary
{
    
    if (isaccept == YES) {
        
        
        isaccept = NO;
        
        if ([[[responseDictionary valueForKey:@"Response"]valueForKey:@"ResponseInfo"] isEqualToString:@"SUCCESS"]) {
            
            NSMutableDictionary * tempDict = [[NSMutableDictionary alloc]init];
            
            tempDict = [[resultArray objectAtIndex:selectedIndex]mutableCopy];
            
            [tempDict setObject:@"follow" forKey:@"text"];
            [tempDict setObject:@"Started following you" forKey:@"notification_msg"];
            
            [resultArray replaceObjectAtIndex:selectedIndex withObject:tempDict];
            [notificationsTable reloadData];
            
        }
    }
    else if (isRejected == YES)
    {
        isRejected = NO;
        if ([[[responseDictionary valueForKey:@"Response"]valueForKey:@"ResponseInfo"] isEqualToString:@"SUCCESS"]) {
            
            NSMutableDictionary * tempDict = [[NSMutableDictionary alloc]init];
            
            tempDict = [[resultArray objectAtIndex:selectedIndex]mutableCopy];
            
            [tempDict setObject:@"rejected" forKey:@"text"];
            [tempDict setObject:@"request is rejected" forKey:@"notification_msg"];
            
            [resultArray replaceObjectAtIndex:selectedIndex withObject:tempDict];
            [notificationsTable reloadData];
            
        }
        
    }
    else{
        if ([[[responseDictionary valueForKey:@"Response"]valueForKey:@"ResponseInfo"] isEqualToString:@"SUCCESS"]) {
            
            
            NSArray * temArray  = [[[responseDictionary valueForKey:@"Response"]valueForKey:@"notifications_list"]mutableCopy];
            
            for (int i = 0; i<[temArray count]; i++) {
                
                [resultArray addObject:[temArray objectAtIndex:i]];
            }
            notificationsTable.delegate = self;
            notificationsTable.dataSource = self;
            
            [notificationsTable reloadData];
        }
        else{
            
//            [self alertViewShow:@"No data found"];
            
        }
    }
   
    [appdelegate stopIndicators];
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    
    CGFloat maxcontentOffSet = scrollView.contentSize.height - scrollView.frame.size.height;
    
    if ((maxcontentOffSet-contentOffsetY)<=50)
        
    {
        pageIndex = pageIndex+1;
        [self serviceCall:userId andPageIndex:pageIndex];
        
    }
  
}

#pragma mark - Accept And RejectButtonAction 

-(void)acceptButtonClicked:(UIButton *)sendar
{
//   http://182.75.34.62/MySportsShare/web_services/follow_accept.php?follower_id=298&following_id=351&status=0
    
    NSString * followerId = [[resultArray objectAtIndex:sendar.tag]valueForKey:@"sender_id"];
    NSString * following = [[resultArray objectAtIndex:sendar.tag]valueForKey:@"data_id"];
    
    if ([appdelegate connectedToInternet]) {
        
        isaccept = YES;
        selectedIndex = sendar.tag;
        [appdelegate startIndicator];
        
        [jsonObj getMethodforServiceRequest:[NSString stringWithFormat:@"%@follow_accept.php?follower_id=%@&following_id=%@&status=1",commonURL,followerId,following]];
    }
    else{
        [self alertViewShow:@"NO Internet Connection"];
    }
    
    
    
}

-(void)rejectButtonClicked:(UIButton *)sendar
{
    NSString * followerId = [[resultArray objectAtIndex:sendar.tag]valueForKey:@"sender_id"];
    NSString * following = [[resultArray objectAtIndex:sendar.tag]valueForKey:@"data_id"];
    
    if ([appdelegate connectedToInternet]) {
        
        isRejected = YES;
        [appdelegate startIndicator];
        
        [jsonObj getMethodforServiceRequest:[NSString stringWithFormat:@"%@follow_accept.php?follower_id=%@&following_id=%@&status=0",commonURL,followerId,following]];
    }
    else{
        [self alertViewShow:@"NO Internet Connection"];
    }
    
    
    
}

@end
