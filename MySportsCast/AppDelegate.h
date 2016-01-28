//
//  AppDelegate.h
//  MySportsCast
//
//  Created by SPARSHMAC08 on 19/08/15.
//  Copyright (c) 2015 SPARSHMAC08. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    MBProgressHUD *indicator;
   
}
@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic)UIStoryboard * stroyBoard;
@property (strong, nonatomic) MBProgressHUD *indicator;
@property (strong,nonatomic)NSArray * tagSelectedArray;
@property (strong,nonatomic)NSMutableDictionary * eventDetailsProfile;
@property int profileViewNavAccount;
@property (strong,nonatomic)NSString * profileSelectedUserId;
@property (strong,nonatomic)NSString * notificationSelectedId;
@property (strong,nonatomic)NSString * profileSelectedUSeName;
@property (strong,nonatomic)UIImage * editImageForMyProfile;
#pragma mark - PushNotificationDeviceToken
@property (strong,nonatomic)NSDate * selectedCalendarDate;
@property(strong,nonatomic) NSString *deviceTokenForPushNotification;
@property  NSInteger previousTimerSec;
@property CGRect screenSize;
@property BOOL isUserCheckin;
@property BOOL isfromSearchScreen;
@property BOOL isfromNotificationScreen;
-(void)startIndicator;
-(void)stopIndicators;
-(bool)connectedToInternet;
-(void)userCurrentLocation;

@end

int isiPhone4(void);
int isiPhone5(void);
int isipad(void);
int isiphone6(void);
int isiphone6Plus(void);


