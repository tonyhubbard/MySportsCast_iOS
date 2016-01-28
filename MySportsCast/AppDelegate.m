//
//  AppDelegate.m
//  MySportsCast
//
//  Created by SPARSHMAC08 on 19/08/15.
//  Copyright (c) 2015 SPARSHMAC08. All rights reserved.
//

#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import "Reachability.h"
#import "HomeViewController.h"
#import "SearchViewController.h"
#import "AddMediaViewController.h"
#import "NotificationViewController.h"
#import "profileViewController.h"
#import "HomeViewController.h"
#import "EventInfoViewController.h"
#import <CoreLocation/CoreLocation.h>


@interface AppDelegate ()<CLLocationManagerDelegate>
{
    UIStoryboard * storyBoard;
    UITabBarController *tabberViewController;
    CLLocationManager *locationManager;
    UINavigationController *initialViewController;
}
@end

@implementation AppDelegate
@synthesize indicator,deviceTokenForPushNotification;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
       // Override point for customization after application launch.
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {

        
    }
    
    if ([launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"]) {
        
        [self application:[UIApplication sharedApplication] didReceiveRemoteNotification:[launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"]];
    }
    
    self.profileViewNavAccount = 1;
    
    self.screenSize = [[UIScreen mainScreen] bounds];
    
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    self.tagSelectedArray = [[NSArray alloc]init];
    self.eventDetailsProfile = [[NSMutableDictionary alloc]init];
    self.stroyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    NSString * userId = [[NSUserDefaults standardUserDefaults]valueForKey:@"loginId"];
    
   
    initialViewController = [self.stroyBoard instantiateInitialViewController];
    if (userId)
    {

        UITabBarController *tabBarController = [self.stroyBoard instantiateViewControllerWithIdentifier:@"MainTabbarViewController"];
        [tabBarController setSelectedIndex:0];
        [initialViewController setViewControllers:@[tabBarController]];
       
    }
    else
    {

        EventInfoViewController * eventInfoVC = [self.stroyBoard instantiateViewControllerWithIdentifier:@"EventInfoViewController"];

        [initialViewController setViewControllers:@[eventInfoVC]];

    }
    
    NSDictionary *apnsBody = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (apnsBody) {
        
        NSLog(@"%@",apnsBody);
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"NotificationRecived" message:@"hello World" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        
        [alert show];
        
        
        // Do your code with apnsBody
    }
    initialViewController.navigationBar.hidden = YES;
    self.window.rootViewController = initialViewController;
    [self.window makeKeyAndVisible];
    [self userCurrentLocation];
    
    
    return YES;
    
    

    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    // Call FBAppCall's handleOpenURL:sourceApplication to handle Facebook app responses
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    
//    NSLog(@"%hhd",[FBSession.activeSession handleOpenURL:url]);
    
    // You can add your app-specific url handling code here if needed
    
    return wasHandled;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



-(void)startIndicator
{
    if (indicator==nil)
    {
        indicator = [[MBProgressHUD alloc] initWithView:self.window];
        [indicator setLabelText:@""];
        [[[UIApplication sharedApplication] keyWindow] addSubview:indicator];
        [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:indicator];
        
    }
    [self.window addSubview:indicator];
    [indicator show:YES];
    
}
-(void)stopIndicators
{
    [indicator hide:YES];
    
}

#pragma mark reachability Method

-(bool)connectedToInternet
{
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.google.com"];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    bool result = false;
    if (internetStatus == ReachableViaWiFi)
    {
        result = true;
    }
    else if(internetStatus==ReachableViaWWAN){
        result = true;
    }
    return result;
    
}

-(void)userCurrentLocation
{
    locationManager = [[CLLocationManager alloc] init];
    
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        
        [locationManager requestWhenInUseAuthorization];
    
    [locationManager startUpdatingLocation];
    locationManager.delegate = self;
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [locationManager stopUpdatingLocation];

    NSString * latitude =  [NSString stringWithFormat:@"%f",locationManager.location.coordinate.latitude];
    
    NSString * longitude = [NSString stringWithFormat:@"%f",locationManager.location.coordinate.longitude];
    
    [[NSUserDefaults standardUserDefaults]setObject:latitude forKey:@"latitude"];
    
    [[NSUserDefaults standardUserDefaults]setObject:longitude forKey:@"longitude"];
}


#pragma mark Push Notifications Delegate Methods



- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

   
    if (deviceToken) {
        
        NSMutableString* encodedToken = [NSMutableString string];
        
        unsigned char* bytes = (unsigned char*)[deviceToken bytes];
        
        for (int i = 0; i < [deviceToken length]; ++i)
        {
            unsigned char ch = bytes[i];
            [encodedToken appendFormat:@"%02X", ch];
        }
      NSString * devToken = [encodedToken copy];

        
        [[NSUserDefaults standardUserDefaults] setObject:devToken forKey:@"deviceToken"];
        
        
    }
    
    
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    NSLog(@"Did Fail to Register for Remote Notifications");
    NSLog(@"%@, %@", error, error.localizedDescription);
    
}
-(void)application:(UIApplication *)app didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //NOTE::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    //No Need to store the push notification if it is in active or in closerd state we can directly navigate to the screens
    //if app is in active state we need to store notification into to coredata to expose the data to user
    NSLog(@"notification didReceive method called");
    
    if([app applicationState] == UIApplicationStateInactive)
    {
        //If the application state was inactive, this means the user pressed an action button
        // from a notification.
        
        //Handle notification
        UITabBarController *tabBarController = [self.stroyBoard instantiateViewControllerWithIdentifier:@"MainTabbarViewController"];
        [tabBarController setSelectedIndex:3];
        [initialViewController setViewControllers:@[tabBarController]];
       
    }
    else if ([app applicationState] == UIApplicationStateActive)
    {
        //Application is in Active state handle the push notification here
        
        
//        UITabBarController *tabBarController = [self.stroyBoard instantiateViewControllerWithIdentifier:@"MainTabbarViewController"];
//        [tabBarController setSelectedIndex:3];
//        [initialViewController setViewControllers:@[tabBarController]];
        
        UIAlertView * notificationAlert = [[UIAlertView alloc]initWithTitle:@"Notification" message:[[userInfo valueForKey:@"aps"]valueForKey:@"alert"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [notificationAlert show];
        
        notificationAlert = nil;
        
    
    }
    
}

#pragma mark device seperator Methods

int isiPhone4(void)
{
    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    if (iOSDeviceScreenSize.height == 480)
        return 1;
    else
        return 0;
}

int isiPhone5(void)
{
    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    if (iOSDeviceScreenSize.height == 568)
        return 1;
    else
        return 0;
}

int isiphone6(void)
{
    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    if (iOSDeviceScreenSize.height == 667)
        return 1;
    else
        return 0;
}

int isiphone6Plus(void)
{
    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    if (iOSDeviceScreenSize.height == 736)
        return 1;
    else
        return 0;
}

int isipad(void)
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        
        return 1;
    else
        return 0;
}
@end

AppDelegate *appDelegate(void)
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

