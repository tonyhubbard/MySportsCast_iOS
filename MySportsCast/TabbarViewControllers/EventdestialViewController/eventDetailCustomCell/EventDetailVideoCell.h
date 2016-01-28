//
//  EventDetailVideoCell.h
//  MySportsCast
//
//  Created by SPARSHMAC08 on 08/09/15.
//  Copyright (c) 2015 SPARSHMAC08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventDetailVideoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *viewLayer;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewDpVideo;
@property (weak, nonatomic) IBOutlet UILabel *labelUserNameVideo;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewCastVideo;
@property (weak, nonatomic) IBOutlet UIButton *buttonCheers;
@property (weak, nonatomic) IBOutlet UILabel *labelChrees;
@property (weak, nonatomic) IBOutlet UIButton *buttonComment;
@property (weak, nonatomic) IBOutlet UILabel *labelComment;
@property (weak, nonatomic) IBOutlet UIButton *buttonShare;
@property (weak, nonatomic) IBOutlet UIButton *playButtonClicked;

@end
