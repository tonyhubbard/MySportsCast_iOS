//
//  EventDeatilPhotoCell.m
//  MySportsCast
//
//  Created by SPARSHMAC08 on 08/09/15.
//  Copyright (c) 2015 SPARSHMAC08. All rights reserved.
//

#import "EventDeatilPhotoCell.h"

@implementation EventDeatilPhotoCell

- (void)awakeFromNib {
    // Initialization code
    self.viewLayer.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.viewLayer.layer.borderWidth = 1.0f;
    self.imageViewDp.layer.cornerRadius = self.imageViewDp.frame.size.width/2;
    self.imageViewDp.layer.masksToBounds = YES;
    self.imageViewCast = [[UIImageView alloc]init];
   
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
