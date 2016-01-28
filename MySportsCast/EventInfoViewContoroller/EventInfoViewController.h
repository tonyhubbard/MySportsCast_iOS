//
//  EventInfoViewController.h
//  MySportsCast
//
//  Created by SPARSHMAC08 on 19/08/15.
//  Copyright (c) 2015 SPARSHMAC08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventInfoViewController : UIViewController<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollDetail;
- (IBAction)buttonGetStartClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControll;
@property (weak, nonatomic) IBOutlet UIImageView *imageVIewBackGround;

@end
