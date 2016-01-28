//
//  EventCell.m
//  MySportsCast
//
//  Created by SPARSHMAC08 on 21/08/15.
//  Copyright (c) 2015 SPARSHMAC08. All rights reserved.
//

#import "EventCell.h"

@implementation EventCell

- (void)awakeFromNib {
    
   
    self.viewMainLayOut.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.viewMainLayOut.layer.borderWidth  = 1.0;
    self.imageViewCastUser.layer.cornerRadius = self.imageViewCastUser.frame.size.width/2;
    self.imageViewCastUser.layer.masksToBounds = YES;
       
    
    
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
