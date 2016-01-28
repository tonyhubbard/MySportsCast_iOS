//
//  EventDetailsTextCell.m
//  MySportsCast
//
//  Created by SPARSHMAC08 on 08/09/15.
//  Copyright (c) 2015 SPARSHMAC08. All rights reserved.
//

#import "EventDetailsTextCell.h"

@implementation EventDetailsTextCell

- (void)awakeFromNib {
    // Initialization code
    self.viewLayer.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.viewLayer.layer.borderWidth = 1.0f;
    self.imageViewDpText.layer.cornerRadius = self.imageViewDpText.frame.size.width/2;
    self.imageViewDpText.layer.masksToBounds = YES;
    self.textViewText = [[UITextView alloc]init];
    [self addSubview:self.textViewText];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
