//
//  EventDeatilPhotoCell.h
//  MySportsCast
//
//  Created by SPARSHMAC08 on 08/09/15.
//  Copyright (c) 2015 SPARSHMAC08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventDeatilPhotoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *viewLayer;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewDp;
@property (weak, nonatomic) IBOutlet UILabel *labelUserName;
@property (strong, nonatomic) UIImageView *imageViewCast;
@property (weak, nonatomic) IBOutlet UIButton *buttonCheers;
@property (weak, nonatomic) IBOutlet UILabel *labelCheers;
@property (weak, nonatomic) IBOutlet UIButton *buttonComment;
@property (weak, nonatomic) IBOutlet UILabel *labelComment;
@property (weak, nonatomic) IBOutlet UIButton *buttonShare;
@property (strong,nonatomic)UITextView * LabelcommentLast;
@property (weak, nonatomic) IBOutlet UIView *viewCheersBG;

@end
