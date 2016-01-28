//
//  VideoOrPhotoLoadViewController.h
//  MySportsCast
//
//  Created by SPARSHMAC08 on 26/08/15.
//  Copyright (c) 2015 SPARSHMAC08. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "TagViewController.h"
#import <Social/Social.h>


@interface VideoOrPhotoLoadViewController : UIViewController<TagsCustomDelegate,UITextFieldDelegate>
{
      UILabel *labelEventTag;
}
@property (strong,nonatomic)UIImage * imageCast;

@property (strong,nonatomic)NSURL * videoPathUrl;

@property BOOL fromAddMedia;

@property (weak, nonatomic) IBOutlet UILabel *labelUploadTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *textFiledUploadCapation;
@property (weak, nonatomic) IBOutlet UIView *viewEventTag;
@property (weak, nonatomic) IBOutlet UIView *viewPeopleTag;
- (IBAction)BroadCastButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonShareFB;
@property (weak, nonatomic) IBOutlet UIButton *buttonShareInstagram;
@property (weak, nonatomic) IBOutlet UIButton *buttonShareTwitter;
- (IBAction)shareButtonTwitterAction:(id)sender;
- (IBAction)shareButtonFBAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *labelPeopleTag;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewForScroll;

- (IBAction)shareButtonInstagramAction:(id)sender;
- (IBAction)backButtonClicked:(id)sender;
- (IBAction)playButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (strong,nonatomic)NSString * eventiD;
@property (strong,nonatomic)NSString * eventName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollviewWithConstrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollContentViewWidth;
@property (weak, nonatomic) IBOutlet UIView *scrollcontentView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrolviewContentHeight;

@end
