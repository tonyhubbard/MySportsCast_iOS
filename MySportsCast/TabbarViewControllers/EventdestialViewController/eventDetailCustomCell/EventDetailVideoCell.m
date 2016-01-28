//
//  EventDetailVideoCell.m
//  MySportsCast
//
//  Created by SPARSHMAC08 on 08/09/15.
//  Copyright (c) 2015 SPARSHMAC08. All rights reserved.
//

#import "EventDetailVideoCell.h"

@implementation EventDetailVideoCell

- (void)awakeFromNib {
    self.viewLayer.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.viewLayer.layer.borderWidth = 1.0f;
    self.imageViewDpVideo.layer.cornerRadius = self.imageViewDpVideo.frame.size.width/2;
    self.imageViewDpVideo.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
