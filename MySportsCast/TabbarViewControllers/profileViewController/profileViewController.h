//
//  profileViewController.h
//  MySportsCast
//
//  Created by SPARSHMAC08 on 24/08/15.
//  Copyright (c) 2015 SPARSHMAC08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface profileViewController : UIViewController
@property (weak, nonatomic) IBOutlet UICollectionView *myProfileCollectionView;
@property BOOL isfromNotification;

- (IBAction)backButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *backButtonClicekd;

@property (weak, nonatomic) IBOutlet UILabel *profileNavTitle;


@end
