//
//  ImageFilterViewController.h
//  MySportsCast
//
//  Created by Vardhan on 14/09/15.
//  Copyright (c) 2015 SPARSHMAC08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageFilterViewController : UIViewController

{
    UIScrollView * filterScrollView;
}


@property(strong,nonatomic)UIImage * imageToEdit;
@property BOOL fromAddMedia;
@property (weak, nonatomic) IBOutlet UIImageView *filterImageView;
- (IBAction)saveButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewFilterButton;

@property BOOL isfromMyPostView;

- (IBAction)backButton:(id)sender;

@end
