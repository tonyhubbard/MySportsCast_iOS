//
//  CastPhotoViewController.h
//  MySportsCast
//
//  Created by SPARSHMAC08 on 09/09/15.
//  Copyright (c) 2015 SPARSHMAC08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CastPhotoViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
- (IBAction)galleryButtonCicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonGallery;
@property (weak, nonatomic) IBOutlet UIButton *buttonCamera;

- (IBAction)cameraButtonClicekd:(id)sender;
@end
