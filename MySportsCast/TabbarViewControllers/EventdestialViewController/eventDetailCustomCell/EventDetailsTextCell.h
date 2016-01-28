//
//  EventDetailsTextCell.h
//  MySportsCast
//
//  Created by SPARSHMAC08 on 08/09/15.
//  Copyright (c) 2015 SPARSHMAC08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventDetailsTextCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *viewLayer;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewDpText;
@property (weak, nonatomic) IBOutlet UILabel *labelUserNameText;
@property (strong, nonatomic) UITextView *textViewText;
@property (weak, nonatomic) IBOutlet UIButton *buttonCheers;
@property (weak, nonatomic) IBOutlet UILabel *labelCheers;
@property (weak, nonatomic) IBOutlet UIButton *buttoncomment;
@property (weak, nonatomic) IBOutlet UILabel *labelComment;
@property (weak, nonatomic) IBOutlet UIButton *buttonShare;

@end
