//
//  EventDeatilSectionCell.m
//  MySportsCast
//
//  Created by SPARSHMAC08 on 28/08/15.
//  Copyright (c) 2015 SPARSHMAC08. All rights reserved.
//

#import "EventDeatilSectionCell.h"

@implementation EventDeatilSectionCell

- (void)awakeFromNib {
    // Initialization code
    
    self.labelStartAndEndTime = [[UILabel alloc]init];
    self.imageViewForCalendar = [[UIImageView alloc]init];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
