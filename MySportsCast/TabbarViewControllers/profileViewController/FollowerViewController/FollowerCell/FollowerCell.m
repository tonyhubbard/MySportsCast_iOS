//
//  FollowerCell.m
//  MySportsCast
//
//  Created by Vardhan on 02/10/15.
//  Copyright © 2015 SPARSHMAC08. All rights reserved.
//

#import "FollowerCell.h"

@implementation FollowerCell

- (void)awakeFromNib {
    
    
    self.ImageViewfollower.layer.cornerRadius =  self.ImageViewfollower.frame.size.width/2;
    
    self.ImageViewfollower.layer.masksToBounds = YES;
    
    self.buttonFollow.layer.cornerRadius = 5;
    
    
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
