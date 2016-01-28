//
//  EventCell.h
//  MySportsCast
//
//  Created by SPARSHMAC08 on 21/08/15.
//  Copyright (c) 2015 SPARSHMAC08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelCastUserName;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewCastUser;
@property (weak, nonatomic) IBOutlet UITextView *textViewuserCast;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *castaViewHeightConstrain;
@property (weak, nonatomic) IBOutlet UIView *viewMainLayOut;
@property (weak, nonatomic) IBOutlet UILabel *labelEventGameName;
@property (weak, nonatomic) IBOutlet UILabel *labelEventType;
@property (weak, nonatomic) IBOutlet UILabel *labelEventName;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewLocation;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewDistance;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewAddres;
@property (weak, nonatomic) IBOutlet UILabel *labelLocation;
@property (weak, nonatomic) IBOutlet UILabel *labelDistance;
@property (weak, nonatomic) IBOutlet UILabel *labelAddress;
@property (weak, nonatomic) IBOutlet UILabel *labelCherss;
@property (weak, nonatomic) IBOutlet UILabel *labelAttending;
@property (weak, nonatomic) IBOutlet UIImageView *imaeViewEventCoverPic;
@property (weak, nonatomic) IBOutlet UIView *singleLineView;
@property (strong,nonatomic)  IBOutlet UIView * castView;

@property BOOL isCastHeight;
@end
