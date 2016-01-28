//
//  Constants.h
//  MySportsCast
//
//  Created by SPARSHMAC03 on 01/09/15.
//  Copyright (c) 2015 SPARSHMAC08. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject
#define commonURL @"http://54.175.207.88/web_services/"
#define registrationURL    @"register_email.php?"
#define updateProfileUrl   @"update_profile.php?"
#define upComingEvent @"get_upcoming_events.php?"
#define inProgressEvent @"get_inprogress_events.php?"
#define FineshedEvent @"get_finished_events.php?"
#define calendarEvent @"get_calendar_events.php?"
#define UserSingleDayEvent @"get_user_single_day_events.php?"
#define userPostedEvent @"get_user_post_events.php?"
#define kAppDelegateAccessor  ((AppDelegate *)[[UIApplication sharedApplication] delegate])
//#define baseUrl @"http://www.mysportscast.mobi"
#define userChickenEvent @"get_user_checkin_events.php?"
#define kSportsListUrl @"get_sports_list.php?"
#define registrationURL @"register_email.php?"
#define socialRegister @"register_social.php?"
#define getProfileInfo @"get_profile_info.php?"
#define upDatePassword @"update_password.php?"
#define getUserDetails @"get_user_details.php?"
#define forgetPassword @"forgot_password.php?"
#define loginURL @"user_login.php?"
#define deleteComment @"delete_comment.php?"
#define upDateCast @"update_cast.php"
#define upDateEventMedia @"update_event_media.php"
@end
