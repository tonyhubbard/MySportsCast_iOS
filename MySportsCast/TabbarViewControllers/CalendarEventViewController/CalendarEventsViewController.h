//
//  CalendarEventsViewController.h
//  MySportsCast
//
//  Created by SPARSHMAC08 on 27/10/15.
//  Copyright © 2015 SPARSHMAC08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarEventsViewController : UIViewController

- (IBAction)backButtonClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *labelSelectedDate;
@property (strong,nonatomic)NSString * selectedDate;
- (IBAction)filterButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableviewForEvents;
@property BOOL isAllEvetnCalendar;
@property (weak, nonatomic) IBOutlet UIButton *buttonFilter;


@end
