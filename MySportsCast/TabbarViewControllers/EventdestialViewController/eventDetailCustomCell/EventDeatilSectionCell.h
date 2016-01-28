//
//  EventDeatilSectionCell.h
//  MySportsCast
//
//  Created by SPARSHMAC08 on 28/08/15.
//  Copyright (c) 2015 SPARSHMAC08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventDeatilSectionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelLocationName;
@property (weak, nonatomic) IBOutlet UILabel *labelDistance;
@property (weak, nonatomic) IBOutlet UILabel *labelSelectedEventName;
@property (strong, nonatomic) UILabel *labelStartAndEndTime;
@property (weak, nonatomic) IBOutlet UILabel *labelSportType;
@property (weak, nonatomic) IBOutlet UILabel *labelEventType;
@property (weak, nonatomic) IBOutlet UIButton *buttonBooTicket;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bookButtonVerticalSpace;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bookButtonHeightConstrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ViewYellowHeightConstrain;
@property (weak, nonatomic) IBOutlet UIView *buttonBackGroundView;
@property (weak, nonatomic) IBOutlet UIView *viewForStartTime;
@property (strong,nonatomic) UIImageView * imageViewForCalendar;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewRightDist;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewLeftDist;

@end
