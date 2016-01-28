//
//  CalendarViewController.h
//  MySportsCast
//
//  Created by SPARSHMAC08 on 13/10/15.
//  Copyright © 2015 SPARSHMAC08. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarEventsViewController.h"
@interface CalendarViewController : UIViewController
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarViewHeightConstarin;
@property (weak, nonatomic) IBOutlet UIView *viewCalendarBackGround;
- (IBAction)backButton:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *myEventButton;
@property (weak, nonatomic) IBOutlet UIButton *allEventButton;
@property (nonatomic,strong) UIImage *blueColorImage;
@property BOOL calendarScreenFromHome;
- (IBAction)myEventButtonClicked:(id)sender;
- (IBAction)allEventButtonClicked:(id)sender;
- (IBAction)buttonAddEvent:(id)sender;



@end
