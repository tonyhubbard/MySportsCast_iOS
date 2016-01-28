//
//  profileViewController.m
//  MySportsCast
//
//  Created by SPARSHMAC08 on 24/08/15.
//  Copyright (c) 2015 SPARSHMAC08. All rights reserved.
//

#import "profileViewController.h"
#import "ProfileCollectionViewCell.h"
#import "JsonClass.h"
#import "ProfileInfoModelClases.h"
#import "ProfileInfoModelClases.h"
#import "EditProfileViewController.h"
#import "MyPostViewController.h"
#import "HomeViewController.h"
#import "FollowerViewController.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "CalendarViewController.h"
#import "CalendarEventsViewController.h"
#import "Constants.h"

#define Uservideos @"get_profile_user_videos.php?"
#define UserPhotos @"get_profile_user_photos.php?"
#define UserCast @"get_profile_user_casts.php?"
#define UserTags @"get_profile_user_tags.php?"
#define UserPostEvent @"get_user_post_events.php?"
#define UserCheckins @"get_user_checkin_events.php?"
#define UserAllPost @"get_profile_user_all.php?"
#define userAllResponceKey @"user_pfofile_all"
#define userVideoResponceKey @"user_videos_data"
#define userPhotoResponceKey @"user_photos_data"
#define userCastResponceKey @"user_casts_data"
#define userTagResponceKey @"user_tagged_data"
#define userPostEvetn @"uset_post_events"
#define userFollowers @"user_followers"
#define getfollowingFrinds @"GetFollowingFriends"
#define getfollowingFriendsList @"get_following_friends.php?"
#define getfollowerFriendsList @"get_follower_friends.php?"

#define button_height 45


@interface profileViewController ()<WebServiceProtocol>
{
    NSArray *eventMediaTypeImgArray;
    NSArray *eventMediaTypeNamesArray;
    float viewWidth;
    JsonClass * jsonObject;
    NSMutableAttributedString *followingCountTxt;
    NSMutableAttributedString *followersCountTxt;
    NSMutableAttributedString *checkInsTxt;
    NSString *profileUrl;
    ProfileInfoModelClases *profileInfoModel;
    NSString *userNameTxt;
    NSArray * userEventCastType;
    NSArray * userResponceKey;
    AppDelegate * appdelegate;
    BOOL isFollowButtonClicked;
    UIImageView * imageMediaType;
    UIView *staticHeader;
    UIView *collectionViewHeader;
    UIImageView  *profilePicImg;
    UILabel *userName;
    UIView *followersView;
    UIButton *followersButton;
    UIImageView *followersImgView;
    UIButton *followingButton ;
    UIImageView *followingImgView;
    UIButton *checkInsButton;
    UIView *editProfileView;
    UIButton *calendarBtn;
    
}

@end

@implementation profileViewController
@synthesize myProfileCollectionView;


- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden  = YES;
    self.navigationController.navigationBar.translucent = YES;
    
    userEventCastType = @[UserAllPost,Uservideos,UserPhotos,UserCast,UserTags,@""];
    userResponceKey = @[userAllResponceKey,userVideoResponceKey,userPhotoResponceKey,userCastResponceKey,userTagResponceKey,userPostEvetn];
    
    eventMediaTypeImgArray = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"user_profile_all.png"],[UIImage imageNamed:@"user_profile_videos.png"],[UIImage imageNamed:@"user_profile_photos.png"],[UIImage imageNamed:@"user_profile_casts.png"],[UIImage imageNamed:@"user_profile_yourtags.png"],[UIImage imageNamed:@"user_profile_yourevents.png"], nil];
    eventMediaTypeNamesArray = [[NSArray alloc]initWithObjects:@"All",@"Videos",@"Photos",@"Casts",@"Your Tags",@"Your Events", nil];
    viewWidth = [[UIScreen mainScreen]bounds].size.width;
    
    [myProfileCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    profileUrl = @"";
    jsonObject = [[JsonClass alloc] init];
    jsonObject.delegate = self;
    appdelegate = [UIApplication sharedApplication].delegate;
    
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    
    if (appdelegate.isfromNotificationScreen == YES)
    {
        
        [jsonObject getMethodforServiceRequest:[NSString stringWithFormat:@"%@get_profile_info.php?user_id=%@&login_user_id=%@",commonURL,appdelegate.notificationSelectedId,[[NSUserDefaults standardUserDefaults] objectForKey:@"loginId"]]];
        
        self.backButtonClicekd.hidden = NO;
        
    }
    else{
        if (appdelegate.profileViewNavAccount == 1)
        {
            
            self.backButtonClicekd.hidden = YES;
            [jsonObject getMethodforServiceRequest:[NSString stringWithFormat:@"%@get_profile_info.php?user_id=%@&login_user_id=%@",commonURL,[[NSUserDefaults standardUserDefaults] objectForKey:@"loginId"],[[NSUserDefaults standardUserDefaults] objectForKey:@"loginId"]]];
        }
        else
        {
            
            [jsonObject getMethodforServiceRequest:[NSString stringWithFormat:@"%@get_profile_info.php?user_id=%@&login_user_id=%@",commonURL,appdelegate.profileSelectedUserId,[[NSUserDefaults standardUserDefaults] objectForKey:@"loginId"]]];
            
            self.backButtonClicekd.hidden = NO;
            
        }
    }
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIView *)headerFramesCreation{
    
    
    if (appdelegate.profileViewNavAccount == 1)
    {
        if (appdelegate.isfromNotificationScreen == YES) {
            
            NSArray * compentsString = [profileInfoModel.user_name componentsSeparatedByString:@" "];
            appdelegate.profileSelectedUSeName = [compentsString objectAtIndex:0];
            
            self.profileNavTitle.text =[NSString stringWithFormat:@"%@ %@",[compentsString objectAtIndex:0],@"Profile"];
            
            self.profileNavTitle.text = [self.profileNavTitle.text uppercaseString];
            
        }
        else{
            
            self.profileNavTitle.text = @"MY PROFILE";
        }
        
    }
    else
    {
        
        NSArray * compentsString = [profileInfoModel.user_name componentsSeparatedByString:@" "];
        appdelegate.profileSelectedUSeName = [compentsString objectAtIndex:0];
        
        self.profileNavTitle.text =[NSString stringWithFormat:@"%@ %@",[compentsString objectAtIndex:0],@"Profile"];
        
        self.profileNavTitle.text = [self.profileNavTitle.text uppercaseString];
        
    }
    
    if (isipad()) { // designing for ipad
        
        staticHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 150)];
        staticHeader.backgroundColor = [UIColor clearColor];
        collectionViewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 100)];
        collectionViewHeader.backgroundColor = [UIColor colorWithRed:208/255.0f green:117/255.0f blue:28/255.0f alpha:1.0f];
        
        profilePicImg = [[UIImageView alloc] initWithFrame:CGRectMake(20, (collectionViewHeader.frame.size.height-80)/2, 80, 80)];
        if ([profileUrl isEqualToString:@""])
        {
            profilePicImg.image = [UIImage imageNamed:@"ProfilePic.png"];
        }else{
            
            [profilePicImg sd_setImageWithURL:[NSURL URLWithString:profileUrl] placeholderImage:[UIImage imageNamed:@"ProfilePic.png"]];
        }
        profilePicImg.layer.cornerRadius = profilePicImg.frame.size.width/2;
        profilePicImg.clipsToBounds = YES;
        [collectionViewHeader addSubview:profilePicImg];
        
        //username label
        userName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(profilePicImg.frame)+10, ((profilePicImg.frame.size.height-30)/2)+9, 250, 40)];
        userName.text = userNameTxt;
        userName.textColor = [UIColor whiteColor];
        [userName setFont:[UIFont systemFontOfSize:22]];
        [collectionViewHeader addSubview:userName];
        [staticHeader addSubview:collectionViewHeader];
        
        followersView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(collectionViewHeader.frame), viewWidth, 70)];
        followersView.backgroundColor = [UIColor whiteColor];
        //followers button
        followersButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, (viewWidth/3)-1,followersView.frame.size.height)];
        [followersButton setAttributedTitle:followersCountTxt forState:UIControlStateNormal];
        //    [followersButton setTitle:followersCountTxt forState:UIControlStateNormal];
        [followersButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        followersButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [followersButton.titleLabel setTextAlignment: NSTextAlignmentCenter];
        followersButton.titleLabel.numberOfLines = 0;
        [followersView addSubview:followersButton];
        
        [followersButton addTarget:self action:@selector(followerButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        
        //followersImageView
        followersImgView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(followersButton.frame),0, 1, followersButton.frame.size.height)];
        followersImgView.backgroundColor = [UIColor lightGrayColor];
        [followersView addSubview:followersImgView];
        //following button
        followingButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(followersButton.frame), 0, (viewWidth/3)-1, followersView.frame.size.height)];
        [followingButton setAttributedTitle:followingCountTxt forState:UIControlStateNormal];
        [followingButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        followingButton.titleLabel.font = [UIFont systemFontOfSize:18];
        followingButton.titleLabel.numberOfLines = 0;
        [followingButton.titleLabel setTextAlignment: NSTextAlignmentCenter];
        [followersView addSubview:followingButton];
        
        [followingButton addTarget:self action:@selector(followingButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        
        //followingImageView
        followingImgView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(followingButton.frame), 0, 1, followingButton.frame.size.height)];
        followingImgView.backgroundColor = [UIColor lightGrayColor];
        [followersView addSubview:followingImgView];
        
        //checkins button
        checkInsButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(followingButton.frame), 0, (viewWidth/3)-1, followersView.frame.size.height)];
        [checkInsButton setAttributedTitle:checkInsTxt forState:UIControlStateNormal];
        checkInsButton.titleLabel.numberOfLines = 0;
        [checkInsButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        [checkInsButton.titleLabel setTextAlignment: NSTextAlignmentCenter];
        [checkInsButton addTarget:self action:@selector(checkInButtonClicekd) forControlEvents:UIControlEventTouchUpInside];
        [followersView addSubview:checkInsButton];
        
        checkInsButton.titleLabel.font = [UIFont systemFontOfSize:18];
        
        editProfileView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(followersView.frame), viewWidth, 75)];
        editProfileView.backgroundColor = [UIColor whiteColor];
        editProfileView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        editProfileView.layer.borderWidth = 1.0f;
        
    }else{  // Desigining for iphone
        
        staticHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 180)];
        staticHeader.backgroundColor = [UIColor clearColor];
        collectionViewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 80)];
        collectionViewHeader.backgroundColor = [UIColor colorWithRed:208/255.0f green:117/255.0f blue:28/255.0f alpha:1.0f];
        
        profilePicImg = [[UIImageView alloc] initWithFrame:CGRectMake(30, (collectionViewHeader.frame.size.height-60)/2, 60, 60)];
        if ([profileUrl isEqualToString:@""])
        {
            profilePicImg.image = [UIImage imageNamed:@"ProfilePic.png"];
        }else{
            
            [profilePicImg sd_setImageWithURL:[NSURL URLWithString:profileUrl] placeholderImage:[UIImage imageNamed:@"ProfilePic.png"]];
        }
        profilePicImg.layer.cornerRadius = profilePicImg.frame.size.width/2;
        profilePicImg.clipsToBounds = YES;
        [collectionViewHeader addSubview:profilePicImg];
        
        //username label
        userName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(profilePicImg.frame)+10, ((profilePicImg.frame.size.height-30)/2)+10, 150, 30)];
        userName.text = userNameTxt;
        userName.textColor = [UIColor whiteColor];
        [userName setFont:[UIFont systemFontOfSize:14]];
        [collectionViewHeader addSubview:userName];
        [staticHeader addSubview:collectionViewHeader];
        
        followersView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(collectionViewHeader.frame), viewWidth, 60)];
        followersView.backgroundColor = [UIColor whiteColor];
        //followers button
        followersButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, (viewWidth/3)-1,followersView.frame.size.height)];
        [followersButton setAttributedTitle:followersCountTxt forState:UIControlStateNormal];
        //    [followersButton setTitle:followersCountTxt forState:UIControlStateNormal];
        [followersButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [followersButton.titleLabel setTextAlignment: NSTextAlignmentCenter];
        followersButton.titleLabel.numberOfLines = 0;
        [followersView addSubview:followersButton];
        
        [followersButton addTarget:self action:@selector(followerButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        
        //followersImageView
        followersImgView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(followersButton.frame),0, 1, followersButton.frame.size.height)];
        followersImgView.backgroundColor = [UIColor lightGrayColor];
        [followersView addSubview:followersImgView];
        //following button
        followingButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(followersButton.frame), 0, (viewWidth/3)-1, followersView.frame.size.height)];
        [followingButton setAttributedTitle:followingCountTxt forState:UIControlStateNormal];
        [followingButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        followingButton.titleLabel.numberOfLines = 0;
        [followingButton.titleLabel setTextAlignment: NSTextAlignmentCenter];
        [followersView addSubview:followingButton];
        
        [followingButton addTarget:self action:@selector(followingButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        
        //followingImageView
        followingImgView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(followingButton.frame), 0, 1, followingButton.frame.size.height)];
        followingImgView.backgroundColor = [UIColor lightGrayColor];
        [followersView addSubview:followingImgView];
        
        //checkins button
        checkInsButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(followingButton.frame), 0, (viewWidth/3)-1, followersView.frame.size.height)];
        [checkInsButton setAttributedTitle:checkInsTxt forState:UIControlStateNormal];
        checkInsButton.titleLabel.numberOfLines = 0;
        [checkInsButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [checkInsButton.titleLabel setTextAlignment: NSTextAlignmentCenter];
        
        [checkInsButton addTarget:self action:@selector(checkInButtonClicekd) forControlEvents:UIControlEventTouchUpInside];
        [followersView addSubview:checkInsButton];
        
        checkInsButton.titleLabel.font = [UIFont systemFontOfSize:14];
        followingButton.titleLabel.font = [UIFont systemFontOfSize:14];
        followersButton.titleLabel.font = [UIFont systemFontOfSize:14];
        
        editProfileView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(followersView.frame), viewWidth, 65)];
        editProfileView.backgroundColor = [UIColor whiteColor];
        editProfileView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        editProfileView.layer.borderWidth = 1.0f;
        
    }
    
    UIButton *editProfileBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, (editProfileView.frame.size.height-40)/2, editProfileView.frame.size.width-(60+30), 36)];
    [editProfileBtn addTarget:self action:@selector(editProfileButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([profileInfoModel.follow_status isEqualToString:@"follow"]) {
        
        editProfileBtn.layer.cornerRadius = 5;
        
        editProfileBtn.backgroundColor = [UIColor colorWithRed:135.0f/255.0f green:204.0f/255.0f blue:125.0f/255.0f alpha:1];
        
        [editProfileBtn setTitle:@"FOLLOWING" forState:UIControlStateNormal];
        UIImageView * buttonImageView  = [[UIImageView alloc]initWithFrame:CGRectMake((editProfileBtn.frame.size.width/2)-80, 7, 20, 20)];
        [buttonImageView setImage:[UIImage imageNamed:@"checkmark.png"]];
        
        [editProfileBtn addSubview:buttonImageView];
        buttonImageView = nil;
        
    }
    else if ([profileInfoModel.follow_status isEqualToString:@"not_follow"])
    {
        
        editProfileBtn.layer.cornerRadius = 5;
        editProfileBtn.layer.borderColor = [UIColor colorWithRed:59.0f/255.0f green:89.0f/255.0f blue:152.0f/255.0f alpha:1].CGColor;
        editProfileBtn.layer.borderWidth = 1.0f;
        editProfileBtn.backgroundColor = [UIColor whiteColor];
        [editProfileBtn setTitle:@"FOLLOW" forState:UIControlStateNormal];
        [editProfileBtn setTitleColor:[UIColor colorWithRed:59.0f/255.0f green:89.0f/255.0f blue:152.0f/255.0f alpha:1] forState:UIControlStateNormal];
        UIImageView * buttonImageView  = [[UIImageView alloc]initWithFrame:CGRectMake((editProfileBtn.frame.size.width/2)-65, 7, 20, 20)];
        [buttonImageView setImage:[UIImage imageNamed:@"plus.png"]];
        [editProfileBtn addSubview:buttonImageView];
        buttonImageView = nil;
    }
    else if ([profileInfoModel.follow_status isEqualToString:@"requested"])
    {
        
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"loginId"] isEqualToString:appdelegate.profileSelectedUserId]) {
            
            [editProfileBtn setTitle:@"Edit Your Profile" forState:UIControlStateNormal];
        }
        else{
            
            editProfileBtn.layer.cornerRadius = 5;
            editProfileBtn.layer.borderColor = [UIColor colorWithRed:191.0f/255.0f green:191.0f/255.0f blue:191.0f/255.0f alpha:1].CGColor;
            editProfileBtn.layer.borderWidth = 1.0f;
            editProfileBtn.backgroundColor = [UIColor colorWithRed:191.0f/255.0f green:191.0f/255.0f blue:191.0f/255.0f alpha:1];
            [editProfileBtn setTitle:@"REQUESTED" forState:UIControlStateNormal];
            [editProfileBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            UIImageView * buttonImageView  = [[UIImageView alloc]initWithFrame:CGRectMake((editProfileBtn.frame.size.width/2)-75, 9, 18, 18)];
            [buttonImageView setImage:[UIImage imageNamed:@"clock.png"]];
            [editProfileBtn addSubview:buttonImageView];
            buttonImageView = nil;
            
        }
    }
    else{
        
        editProfileBtn.backgroundColor = [UIColor colorWithRed:1/255.0f green:72/255.0f blue:148/255.0f alpha:1.0f];
        [editProfileBtn setTitle:@"Edit Your Profile" forState:UIControlStateNormal];
        [editProfileBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }
    
    //    [editProfileBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [editProfileView addSubview:editProfileBtn];
    
    //calendar button
    if (isipad()) {
        calendarBtn = [[UIButton alloc] initWithFrame:CGRectMake(editProfileView.frame.size.width-53, (editProfileView.frame.size.height-55)/2, 55, 55)];
    }else{
        calendarBtn = [[UIButton alloc] initWithFrame:CGRectMake(editProfileView.frame.size.width-50, (editProfileView.frame.size.height-55)/2, 50, 50)];
    }
    calendarBtn.backgroundColor = [UIColor clearColor];
    
    [calendarBtn setImage:[UIImage imageNamed:@"user_profile_calendar.png"] forState:UIControlStateNormal];
    [calendarBtn setImageEdgeInsets:UIEdgeInsetsMake(10,10, 10, 10)];
    [calendarBtn addTarget:self action:@selector(calendarEventClicked) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [editProfileView addSubview:calendarBtn];
    [staticHeader addSubview:editProfileView];
    [staticHeader addSubview:followersView];
    [self.view addSubview:staticHeader];
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"loginId"]!=appdelegate.profileSelectedUserId && [profileInfoModel.profile_visibility isEqualToString:@"friends"] ) {
        
        if ([profileInfoModel.follow_status isEqualToString:@"not_follow"] || [profileInfoModel.follow_status isEqualToString:@"requested"]) {
            
            followersButton.userInteractionEnabled = NO;
            followingButton.userInteractionEnabled = NO;
            checkInsButton.userInteractionEnabled =  NO;
            calendarBtn.userInteractionEnabled = NO;
        }
        else{
            followersButton.userInteractionEnabled = YES;
            followingButton.userInteractionEnabled = YES;
            checkInsButton.userInteractionEnabled =  YES;
            calendarBtn.userInteractionEnabled = YES;

        }
    }
    else{
        followersButton.userInteractionEnabled = YES;
        followingButton.userInteractionEnabled = YES;
        checkInsButton.userInteractionEnabled =  YES;
        calendarBtn.userInteractionEnabled = YES;
 
        
    }
    return staticHeader;
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section

{
    
    UIView * viewForPrivate;
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"loginId"]!=appdelegate.profileSelectedUserId && [profileInfoModel.profile_visibility isEqualToString:@"friends"]) {
        
        
        
        if ([profileInfoModel.follow_status isEqualToString:@"not_follow"] || [profileInfoModel.follow_status isEqualToString:@"requested"]) {
            
            
            viewForPrivate = [[UIView alloc]init];
            if (isipad()) {
                
                viewForPrivate.frame = CGRectMake(0, 247, collectionView.frame.size.width,  collectionView.frame.size.height);
 
            }else{
                
            viewForPrivate.frame = CGRectMake(0, 207, collectionView.frame.size.width,  collectionView.frame.size.height);
           
            }
            
            viewForPrivate.backgroundColor = [UIColor whiteColor];
            
            UIImageView * imageViewPrivate = [[UIImageView alloc]initWithFrame:CGRectMake(collectionView.frame.size.width/2-(40),10, 80, 80)];
            imageViewPrivate.image = [UIImage imageNamed:@"ProfilePic.png"];
            
            
            UILabel * labelForPrivate = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageViewPrivate.frame)+10, collectionView.frame.size.width, 40)];
            
            labelForPrivate.text = @"This user is private";
            
            labelForPrivate.textColor =[UIColor colorWithRed:191.0f/255.0f green:191.0f/255.0f blue:191.0f/255.0f alpha:1];
            
            labelForPrivate.textAlignment = NSTextAlignmentCenter;
            
            
            [viewForPrivate addSubview:imageViewPrivate];
            [viewForPrivate addSubview:labelForPrivate];
            [collectionView addSubview:viewForPrivate];
            
            return 0;
         
        }
        else{
            [viewForPrivate removeFromSuperview];
            return eventMediaTypeImgArray.count;
        }
    }
    else{
        [viewForPrivate removeFromSuperview];
        return eventMediaTypeImgArray.count;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProfileCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"profileCell" forIndexPath:indexPath];
    
    for (UIImageView * imageView in cell.contentView.subviews)
    {
        if ([imageView isKindOfClass:[UIImageView class]])
        {
            [imageView removeFromSuperview];
        }
    }
    
    if (isipad()) {
        imageMediaType = [[UIImageView alloc]initWithFrame:CGRectMake((cell.frame.size.width/2.5)-(cell.frame.size.width/2)/2-5, 10, (cell.frame.size.width/1.5)+20,(cell.frame.size.width/1.5)+20)];
        [cell.eventMediaTypeText setFont:[UIFont systemFontOfSize:16]];
    }else{
        imageMediaType = [[UIImageView alloc]initWithFrame:CGRectMake((cell.frame.size.width/2)-(cell.frame.size.width/2)/2-10, 10, (cell.frame.size.width/2)+20,(cell.frame.size.width/2)+20)];
        [cell.eventMediaTypeText setFont:[UIFont systemFontOfSize:14]];
    }
    
    imageMediaType.image = [eventMediaTypeImgArray objectAtIndex:indexPath.row];
    
    imageMediaType.layer.cornerRadius = imageMediaType.frame.size.width/2;
    
    imageMediaType.clipsToBounds = YES;
    
    [cell.contentView addSubview:imageMediaType];
    
    cell.eventMediaTypeText.text = [eventMediaTypeNamesArray objectAtIndex:indexPath.row];
    cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    cell.layer.borderWidth = 1.0f;
    
//    imageMediaType = nil;
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (appdelegate.profileViewNavAccount == 2) {
        
        appdelegate.profileViewNavAccount = appdelegate.profileViewNavAccount+1;
    }
    
    
    if ([[userEventCastType objectAtIndex:indexPath.row] isEqualToString:@""])
    {
        
        if (appdelegate.profileViewNavAccount == 1) {
            
            appdelegate.profileSelectedUserId = [[NSUserDefaults standardUserDefaults]valueForKey:@"loginId"];
        }
        CalendarViewController * calendarVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CalendarViewController"];
        
        calendarVC.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:calendarVC animated:YES];
        
    }
    else{
        
        MyPostViewController * mypostVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyPostViewController"];
        
        mypostVC.eventCastType = [userEventCastType objectAtIndex:indexPath.row];
        
        mypostVC.eventResponceKey = [userResponceKey objectAtIndex:indexPath.row];
        
        [self.navigationController pushViewController:mypostVC animated:YES];
        
        
        
    }
    
    
    
    
    
}
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
//    return CGSizeMake(collectionView.frame.size.width, 180.0f);
//}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (isipad()) {
        return CGSizeMake(collectionView.frame.size.width, 240);
    }else{
        return CGSizeMake(collectionView.frame.size.width, 200);
    }
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        
        reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        
        UIView *headerView = [self headerFramesCreation];
        
        headerView.frame = reusableview.bounds;
        
        [reusableview addSubview:headerView];
    }
    return reusableview;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(((self.myProfileCollectionView.frame.size.width)/3)-5, ((self.myProfileCollectionView.frame.size.width)/3));
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}


#pragma mark - calendarButtonClicked
-(void)calendarEventClicked
{
    
    if (appdelegate.profileViewNavAccount == 1) {
        
        if (appdelegate.isfromNotificationScreen == YES) {
            
            
        }
        else{
            appdelegate.profileSelectedUserId = [[NSUserDefaults standardUserDefaults]valueForKey:@"loginId"];
        }
        
        
    }
    CalendarViewController * calendarVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CalendarViewController"];
    
    calendarVC.hidesBottomBarWhenPushed = YES;
    
    
    [self.navigationController pushViewController:calendarVC animated:YES];
    
}

#pragma mark - editButtonClicekd
- (void)editProfileButtonAction:(UIButton *)sender
{
    
    isFollowButtonClicked = YES;
    
    if ([profileInfoModel.follow_status isEqualToString:@"follow"]) {
        
        if ([appdelegate connectedToInternet])
        {
            
            [jsonObject getMethodforServiceRequest:[NSString stringWithFormat:@"%@follow_unfollow.php?follower_id=%@&following_id=%@&status=0&profile_visibility=%@",commonURL,[[NSUserDefaults standardUserDefaults] objectForKey:@"loginId"],appdelegate.profileSelectedUserId,profileInfoModel.profile_visibility]];
        }
        else
        {
            
        }
    }
    else if ([profileInfoModel.follow_status isEqualToString:@"not_follow"])
    {
        
        
        [jsonObject getMethodforServiceRequest:[NSString stringWithFormat:@"%@follow_unfollow.php?follower_id=%@&following_id=%@&status=1&profile_visibility=%@",commonURL,[[NSUserDefaults standardUserDefaults] objectForKey:@"loginId"],appdelegate.profileSelectedUserId,profileInfoModel.profile_visibility]];
        
    }
    else if ([profileInfoModel.follow_status isEqualToString:@"requested"])
    {
        [jsonObject getMethodforServiceRequest:[NSString stringWithFormat:@"%@follow_unfollow.php?follower_id=%@&following_id=%@&status=0&profile_visibility=%@",commonURL,[[NSUserDefaults standardUserDefaults] objectForKey:@"loginId"],appdelegate.profileSelectedUserId,profileInfoModel.profile_visibility]];
        
    }
    else
    {
        
        [self performSegueWithIdentifier:@"editProfileSegue" sender:sender];
        
    }
    
    
}

#pragma mark - FollowingORFollowResponceHandlar

-(void)FollowingORFollowResponceHandlar:(NSDictionary *)respoceDic
{
    
    if ([[[respoceDic valueForKey:@"Response"]valueForKey:@"ResponseInfo"]isEqualToString:@"SUCCESS"]) {
        
        
        NSString * responceStatus = [[respoceDic valueForKey:@"Response"]valueForKey:@"follow_status"];
        
        profileInfoModel.follow_status = responceStatus;
        
        [myProfileCollectionView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 1)]];
        
    }
    
}

#pragma mark - WebServiceDelegateMethod

- (void)didReceiveResponseFromWebService:(NSDictionary *)responseDictionary
{
    
    if(isFollowButtonClicked == YES)
    {
        
        isFollowButtonClicked = NO;
        [self FollowingORFollowResponceHandlar:responseDictionary];
    }
    else{
        profileInfoModel = [[ProfileInfoModelClases alloc]init];
        
        //for checkins
        if ([[[[responseDictionary objectForKey:@"Response"] objectForKey:@"ProfileInfo"]objectForKey:@"event_checkin"]isEqual:[NSNull null]])
            profileInfoModel.event_checkin = @"";
        else
            profileInfoModel.event_checkin = [[[responseDictionary objectForKey:@"Response"] objectForKey:@"ProfileInfo"]objectForKey:@"event_checkin"];
        //for firstname
        if ([[[[responseDictionary objectForKey:@"Response"] objectForKey:@"ProfileInfo"]objectForKey:@"first_name"]isEqual:[NSNull null]])
            profileInfoModel.first_name = @"";
        else
            profileInfoModel.first_name = [[[responseDictionary objectForKey:@"Response"] objectForKey:@"ProfileInfo"] objectForKey:@"first_name"];
        //for followStatus
        if ([[[[responseDictionary objectForKey:@"Response"] objectForKey:@"ProfileInfo"]objectForKey:@"follow_status"] isEqual:[NSNull null]])
            profileInfoModel.follow_status = @"";
        else
            profileInfoModel.follow_status = [[[responseDictionary objectForKey:@"Response"] objectForKey:@"ProfileInfo"] objectForKey:@"follow_status"];
        //for followers
        if ([[[[responseDictionary objectForKey:@"Response"] objectForKey:@"ProfileInfo"]objectForKey:@"followers"] isEqual:[NSNull null]])
            profileInfoModel.followers = @"";
        else
            profileInfoModel.followers = [[[responseDictionary objectForKey:@"Response"] objectForKey:@"ProfileInfo"] objectForKey:@"followers"];
        //for iam following
        if ([[[[responseDictionary objectForKey:@"Response"] objectForKey:@"ProfileInfo"]objectForKey:@"iam_following"] isEqual:[NSNull null]])
            profileInfoModel.iam_following = @"";
        else
            profileInfoModel.iam_following = [[[responseDictionary objectForKey:@"Response"] objectForKey:@"ProfileInfo"] objectForKey:@"iam_following"];
        
        //for no_friends
        if ([[[[responseDictionary objectForKey:@"Response"] objectForKey:@"ProfileInfo"]objectForKey:@"no_friends"] isEqual:[NSNull null]])
            profileInfoModel.no_friends = @"";
        else
            profileInfoModel.no_friends = [[[responseDictionary objectForKey:@"Response"] objectForKey:@"ProfileInfo"] objectForKey:@"no_friends"];
        //for profile_visibility
        if ([[[[responseDictionary objectForKey:@"Response"] objectForKey:@"ProfileInfo"]objectForKey:@"profile_visibility"] isEqual:[NSNull null]])
            profileInfoModel.profile_visibility = @"";
        else
            profileInfoModel.profile_visibility = [[[responseDictionary objectForKey:@"Response"] objectForKey:@"ProfileInfo"] objectForKey:@"profile_visibility"];
        //for username
        if ([[[[responseDictionary objectForKey:@"Response"] objectForKey:@"ProfileInfo"]objectForKey:@"user_name"]isEqual:[NSNull null]])
            profileInfoModel.user_name = @"";
        else
            profileInfoModel.user_name = [[[responseDictionary objectForKey:@"Response"] objectForKey:@"ProfileInfo"] objectForKey:@"user_name"];
        //for username
        if ([[[[responseDictionary objectForKey:@"Response"] objectForKey:@"ProfileInfo"]objectForKey:@"user_profile_pic"]isEqual:[NSNull null]])
            
            profileInfoModel.user_profile_pic = @"";
        else
            profileInfoModel.user_profile_pic = [[[responseDictionary objectForKey:@"Response"] objectForKey:@"ProfileInfo"] objectForKey:@"user_profile_pic"];
        
        [self upDateButtonTitles:profileInfoModel];
        
    }
    
    
    
}
- (void)upDateButtonTitles:(ProfileInfoModelClases *)profileInfo
{
    followersCountTxt = [self attributedStringResult:profileInfo.followers withStaticString:@"followers"];
    
    followingCountTxt = [self attributedStringResult:profileInfo.iam_following withStaticString:@"following"];
    
    checkInsTxt = [self attributedStringResult:profileInfo.event_checkin withStaticString:@"check ins"];
    
    profileUrl = profileInfo.user_profile_pic;
    
    userNameTxt = profileInfoModel.user_name;
    
    //    [profilePicImg loagImageFromURL:profileInfo.user_profile_pic];
    [myProfileCollectionView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 1)]];
}
- (NSMutableAttributedString *)attributedStringResult:(NSString *)countStr withStaticString:(NSString *)staticStr
{
    NSMutableAttributedString *followersAttributedText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@",countStr,staticStr]];
    [followersAttributedText beginEditing];
    if (isipad()) {
        [followersAttributedText addAttribute:NSFontAttributeName
                                        value:[UIFont boldSystemFontOfSize:18]
                                        range:NSMakeRange(0,countStr.length)];
        [followersAttributedText addAttribute:NSForegroundColorAttributeName
                                        value:[UIColor blackColor]
                                        range:NSMakeRange(0,countStr.length)];
        [followersAttributedText addAttribute:NSFontAttributeName
                                        value:[UIFont boldSystemFontOfSize:18]
                                        range:NSMakeRange(countStr.length+1,staticStr.length)];
    }else{
        [followersAttributedText addAttribute:NSFontAttributeName
                                        value:[UIFont boldSystemFontOfSize:14]
                                        range:NSMakeRange(0,countStr.length)];
        [followersAttributedText addAttribute:NSForegroundColorAttributeName
                                        value:[UIColor blackColor]
                                        range:NSMakeRange(0,countStr.length)];
        [followersAttributedText addAttribute:NSFontAttributeName
                                        value:[UIFont boldSystemFontOfSize:14]
                                        range:NSMakeRange(countStr.length+1,staticStr.length)];
        
    }
    [followersAttributedText addAttribute:NSForegroundColorAttributeName
                                    value:[UIColor lightGrayColor]
                                    range:NSMakeRange(countStr.length+1,staticStr.length)];
    [followersAttributedText endEditing];
    return followersAttributedText;
}


-(void)followerButtonClicked
{
    
    FollowerViewController * folloerVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FollowerViewController"];
    
    folloerVC.followingType = @"FOLLOWERS";
    folloerVC.userFollowingResponceKey = userFollowers;
    folloerVC.followerRequest = getfollowerFriendsList;
    
    appdelegate.profileViewNavAccount = appdelegate.profileViewNavAccount+1;
    
    
    [self.navigationController pushViewController:folloerVC animated:YES];
    
}

-(void)followingButtonClicked
{
    
    FollowerViewController * folloerVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FollowerViewController"];
    folloerVC.followingType = @"FOLLOWING";
    folloerVC.followerRequest = getfollowingFriendsList;
    folloerVC.userFollowingResponceKey = getfollowingFrinds;
    
    appdelegate.profileViewNavAccount = appdelegate.profileViewNavAccount+1;
    
    [self.navigationController pushViewController:folloerVC animated:YES];
    
}

-(void)checkInButtonClicekd
{
    appdelegate.isUserCheckin = YES;
    CalendarEventsViewController * calendarEventVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CalendarEventsViewController"];
    
    
    if (appdelegate.profileViewNavAccount == 1) {
        
        if (appdelegate.isfromNotificationScreen == YES) {
            
            
        }
        else{
            appdelegate.profileSelectedUserId = [[NSUserDefaults standardUserDefaults]valueForKey:@"loginId"];
        }
        
    }
    calendarEventVC.hidesBottomBarWhenPushed =YES;
    [self.navigationController pushViewController:calendarEventVC animated:YES];
    
}

- (IBAction)backButtonAction:(id)sender {
    
    if (appdelegate.isfromNotificationScreen == YES) {
        appdelegate.notificationSelectedId = nil;
        appdelegate.isfromNotificationScreen = NO;
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    else{
        
        if (appdelegate.isfromSearchScreen == YES)
        {
            appdelegate.isfromSearchScreen = NO;
            appdelegate.profileViewNavAccount = appdelegate.profileViewNavAccount-2;
        }
        else{
            
            if (appdelegate.notificationSelectedId) {
                
                appdelegate.isfromNotificationScreen = YES;
                //                appdelegate.notificationSelectedId = nil;
            }
            else
            {
                appdelegate.isfromNotificationScreen = NO;
            }
            //            appdelegate.isfromNotificationScreen = YES;
            appdelegate.profileViewNavAccount = appdelegate.profileViewNavAccount-1;
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
    
    
    
}
@end
