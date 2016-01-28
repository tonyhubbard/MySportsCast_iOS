//
//  FollowerViewController.h
//  MySportsCast
//
//  Created by Vardhan on 02/10/15.
//  Copyright © 2015 SPARSHMAC08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FollowerViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableViewFollowing;
@property(strong,nonatomic)NSString * followingType;
@property (weak, nonatomic) IBOutlet UILabel *labelFollower;
@property (strong,nonatomic)NSString * userFollowingResponceKey;
@property (strong,nonatomic)NSString * followerRequest;
@end
