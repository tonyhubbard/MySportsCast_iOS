//
//  HomeViewController.h
//  MySportsCast
//
//  Created by SPARSHMAC08 on 21/08/15.
//  Copyright (c) 2015 SPARSHMAC08. All rights reserved.
//
@import GoogleMobileAds;
#import <UIKit/UIKit.h>


@interface HomeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *buttonAddEvent;
@property (weak, nonatomic) IBOutlet UILabel *labelEventType;
@property (weak, nonatomic) IBOutlet UIButton *buttonSetting;
@property (weak, nonatomic) IBOutlet UIButton *buttonSearch;
@property (strong,nonatomic) NSString * userPosetedEventResponceKey;
@property BOOL isFromProfileScreen;

- (IBAction)buttonSearchClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *labelEvent;
- (IBAction)buttonFilterClicked:(id)sender;
- (IBAction)buttonAddEvent:(id)sender;
- (IBAction)buttonSettingClicked:(id)sender;
- (IBAction)menuButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableViewEvents;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet UILabel *noEventLabels;

@property (weak, nonatomic) IBOutlet UIButton *buttonFilter;

@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet GADBannerView *googleAdMob;




@end
