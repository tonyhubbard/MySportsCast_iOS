//
//  MyPostCell.h
//  MySportsCast
//
//  Created by SPARSHMAC08 on 30/09/15.
//  Copyright © 2015 SPARSHMAC08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPostCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *viewBackGround;
@property (weak, nonatomic) IBOutlet UILabel *labelEventName;
@property (weak, nonatomic) IBOutlet UILabel *labelEventType;
@property (weak, nonatomic) IBOutlet UILabel *labelAddress;
@property (weak, nonatomic) IBOutlet UILabel *labelChress;
@property (weak, nonatomic) IBOutlet UIButton *buttonChress;
@property (weak, nonatomic) IBOutlet UILabel *labelCommnet;
@property (weak, nonatomic) IBOutlet UIButton *buttonComment;
@property (weak, nonatomic) IBOutlet UIButton *buttonTrash;
@property (weak, nonatomic) IBOutlet UIButton *buttonEdit;
@property (weak, nonatomic) IBOutlet UIButton *buttonShare;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelEventHeightConstrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelEventTypeHightConstrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelAddressHeightConstrain;

@end
