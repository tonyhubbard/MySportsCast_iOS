

//
//  FollowerViewController.m
//  MySportsCast
//
//  Created by Vardhan on 02/10/15.
//  Copyright © 2015 SPARSHMAC08. All rights reserved.
//

#import "FollowerViewController.h"
#import "UIImageView+WebCache.h"
#import "profileViewController.h"
#import "FollowerCell.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "JsonClass.h"
@interface FollowerViewController ()<WebServiceProtocol>
{
    AppDelegate * appdelegate;
    JsonClass * jsonObj;
    NSString * userId;
    NSMutableArray * resultArray;
    BOOL isfollowButtonClicked;
    NSInteger  selectedIndexforFollow;
  
}

@end

@implementation FollowerViewController

- (void)viewDidLoad {

    appdelegate =[UIApplication sharedApplication].delegate;
    
    jsonObj = [[JsonClass alloc]init];
    
    resultArray = [[NSMutableArray alloc]init];
    
    jsonObj.delegate = self;
    
    self.labelFollower.text = self.followingType;
    
    
    userId = [[NSUserDefaults standardUserDefaults]valueForKey:@"loginId"];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    
    [self webserviceRequest];
    
}

#pragma mark - tabelViewdelegateMethods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return resultArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FollowerCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FollowerCell"];
    
    if (cell == nil)
    {
        cell = [[FollowerCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FollowerCell"];

    }
    if ([[[resultArray objectAtIndex:indexPath.row]valueForKey:@"user_profile_pic"] isKindOfClass:[NSNull class]]) {
        
        
//        [cell.ImageViewfollower setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@""]] placeholderImage:[UIImage imageNamed:@"ProfilePic.png"]];
        [cell.ImageViewfollower sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@""]] placeholderImage:[UIImage imageNamed:@"ProfilePic.png"]];
        
        
        
    }
    else{
        
        
         [cell.ImageViewfollower sd_setImageWithURL:[NSURL URLWithString:[[resultArray objectAtIndex:indexPath.row]valueForKey:@"user_profile_pic"]] placeholderImage:[UIImage imageNamed:@"ProfilePic.png"]];
        
         
        
    }
    if ([[[resultArray objectAtIndex:indexPath.row]valueForKey:@"user_name"] isKindOfClass:[NSNull class]]) {
        
       cell.labelfollowename.text = @"";
        
    }
    else{
        cell.labelfollowename.text = [[resultArray objectAtIndex:indexPath.row]valueForKey:@"user_name"];
    }
    
    if ([[[resultArray objectAtIndex:indexPath.row]valueForKey:@"follow_status"]isEqualToString:@"follow"])
    {
        [cell.buttonFollow setImage:[UIImage imageNamed:@"following.png"]forState:UIControlStateNormal];
        cell.buttonFollow.tag = indexPath.row;
    }
    else if ([[[resultArray objectAtIndex:indexPath.row]valueForKey:@"follow_status"]isEqualToString:@"not_follow"])
    {
        [cell.buttonFollow setImage:[UIImage imageNamed:@"follow.png"]forState:UIControlStateNormal];
        cell.buttonFollow.tag = indexPath.row;
    }
    else if ([[[resultArray objectAtIndex:indexPath.row]valueForKey:@"follow_status"]isEqualToString:@"requested"])
    {
        [cell.buttonFollow setImage:[UIImage imageNamed:@"requested.png"]forState:UIControlStateNormal];
        cell.buttonFollow.tag = indexPath.row;
    }
    else{
        
        cell.buttonFollow.hidden = YES;
    }
    
    
    [cell.buttonFollow addTarget:self action:@selector(FollowORFollowingButtonHandeler:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    profileViewController * profileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"profileViewController"];
    
    
    profileVC.hidesBottomBarWhenPushed = YES;
    appdelegate.profileSelectedUserId = [[resultArray objectAtIndex:indexPath.row]valueForKey:@"user_id"];
    
    if (appdelegate.profileViewNavAccount == 4)
    {
      appdelegate.profileViewNavAccount = appdelegate.profileViewNavAccount-1;
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        if (appdelegate.isfromNotificationScreen == YES) {
            
            appdelegate.isfromNotificationScreen = NO;
        }
        
        appdelegate.profileViewNavAccount = appdelegate.profileViewNavAccount+1;
        [self.navigationController pushViewController:profileVC animated:YES];
    }
   
    
    
    
}


- (IBAction)backButtonClicked:(id)sender {
    
    
    appdelegate.profileViewNavAccount =  appdelegate.profileViewNavAccount-1;
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -  webServiceRequest
-(void)webserviceRequest
{
//    http://182.75.34.62/MySportsShare/web_services/get_following_friends.php?user_id=38&login_user_id=2
    if ([appdelegate connectedToInternet])
    {
        [appdelegate startIndicator];
        if (appdelegate.isfromNotificationScreen == YES) {
            
            [jsonObj getMethodforServiceRequest:[NSString stringWithFormat:@"%@%@user_id=%@&login_user_id=%@",commonURL,self.followerRequest,appdelegate.notificationSelectedId,userId]];
        }
        else{
            if (appdelegate.profileViewNavAccount == 2)
            {
                [jsonObj getMethodforServiceRequest:[NSString stringWithFormat:@"%@%@user_id=%@&login_user_id=%@",commonURL,self.followerRequest,userId,userId]];
            }
            else
            {
                
                [jsonObj getMethodforServiceRequest:[NSString stringWithFormat:@"%@%@user_id=%@&login_user_id=%@",commonURL,self.followerRequest,appdelegate.profileSelectedUserId,userId]];
                
            }
        }
        
        
    }
    else{
        
        [self alertViewShow:@"No internet connection"];
        
    }
    
    
}

#pragma mark - alertViewMethod

-(void)alertViewShow:(NSString *)alertMessage
{
    UIAlertView *globalAlertView = [[UIAlertView alloc]initWithTitle:@"MySportsCast" message:alertMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [globalAlertView show];
    globalAlertView  = nil;
    [appdelegate stopIndicators];
    
}

#pragma mark - WenServiceResponceHandeler

-(void)didReceiveResponseFromWebService:(NSDictionary *)responseDictionary
{
    if (isfollowButtonClicked == YES)
    {
        isfollowButtonClicked = NO;
        
        [self FollowButtonHandlar:responseDictionary];
    }
    else{
        if ([[[responseDictionary valueForKey:@"Response"]valueForKey:@"ResponseInfo"]isEqualToString:@"SUCCESS"]) {
            
            resultArray = [[[responseDictionary valueForKey:@"Response"]valueForKey:self.userFollowingResponceKey]mutableCopy];
            
            [self.tableViewFollowing reloadData];
//            [appdelegate stopIndicators];
            
        }
    }
    
   [appdelegate stopIndicators];
}


#pragma mark - FollowORFollowingButtonHandeler

-(void)FollowORFollowingButtonHandeler:(UIButton *)button
{
   
    isfollowButtonClicked = YES;
    selectedIndexforFollow = button.tag;
    
//    http://182.75.34.62/MySportsShare/web_services/follow_unfollow.php?follower_id=3&following_id=296&status=1&profile_visibility=public
    
    if ([[[resultArray objectAtIndex:button.tag]valueForKey:@"follow_status"]isEqualToString:@"follow"])
    {
        if ([appdelegate connectedToInternet]) {
           
           [jsonObj getMethodforServiceRequest:[NSString stringWithFormat:@"%@follow_unfollow.php?follower_id=%@&following_id=%@&status=0&profile_visibility=%@",commonURL,userId,[[resultArray objectAtIndex:button.tag]valueForKey:@"user_id"],[[resultArray objectAtIndex:button.tag]valueForKey:@"profile_visibility"]]];
        }
        else{
            
        }
    }
    else if ([[[resultArray objectAtIndex:button.tag]valueForKey:@"follow_status"]isEqualToString:@"not_follow"])
    {
        
        
        if ([appdelegate connectedToInternet]) {
        
         [jsonObj getMethodforServiceRequest:[NSString stringWithFormat:@"%@follow_unfollow.php?follower_id=%@&following_id=%@&status=1&profile_visibility=%@",commonURL,userId,[[resultArray objectAtIndex:button.tag]valueForKey:@"user_id"],[[resultArray objectAtIndex:button.tag]valueForKey:@"profile_visibility"]]];
        }
        else
        {
            
        }
    }
    else if ([[[resultArray objectAtIndex:button.tag]valueForKey:@"follow_status"]isEqualToString:@"requested"])
    {
        [jsonObj getMethodforServiceRequest:[NSString stringWithFormat:@"%@follow_unfollow.php?follower_id=%@&following_id=%@&status=0&profile_visibility=%@",commonURL,userId,[[resultArray objectAtIndex:button.tag]valueForKey:@"user_id"],[[resultArray objectAtIndex:button.tag]valueForKey:@"profile_visibility"]]];
    }
    
    
}


#pragma mark - FollowButtonHandlar
-(void)FollowButtonHandlar:(NSDictionary *)dictionary


{
    if ([[[dictionary valueForKey:@"Response"]valueForKey:@"ResponseInfo"]isEqualToString:@"SUCCESS"]) {
        
        NSString * responceStatus = [[dictionary valueForKey:@"Response"]valueForKey:@"follow_status"];
        
        NSMutableDictionary * tempDic = [[resultArray objectAtIndex:selectedIndexforFollow]mutableCopy];
        [tempDic setObject:responceStatus forKey:@"follow_status"];
        
        [resultArray replaceObjectAtIndex:selectedIndexforFollow withObject:tempDic];
        
        [self.tableViewFollowing reloadData];
        [appdelegate stopIndicators];
        
    }
   
}
@end
