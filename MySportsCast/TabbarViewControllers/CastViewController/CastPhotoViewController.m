//
//  CastPhotoViewController.m
//  MySportsCast
//
//  Created by SPARSHMAC08 on 09/09/15.
//  Copyright (c) 2015 SPARSHMAC08. All rights reserved.
//

#import "CastPhotoViewController.h"
#import "PhotoTweaksViewController.h"
#import "ImageFilterViewController.h"

@interface CastPhotoViewController ()<PhotoTweaksViewControllerDelegate>
{
    UIImagePickerController*imagePickerController;
    
}

@end

@implementation CastPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    imagePickerController = [[UIImagePickerController alloc]init];
    
    
    
    // Do any additional setup after loading the view.
}

-(void)viewDidDisappear:(BOOL)animated{
    
    self.buttonCamera = nil;
    self.buttonGallery = nil;
    
}
    
    
    


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backbuttonAction:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)galleryButtonCicked:(id)sender
{
    
    
    imagePickerController.delegate = self;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
}

- (IBAction)cameraButtonClicekd:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        imagePickerController.delegate = self;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
    else{
        
        [self alertView:@"There is no camera avilable"];
    }
    
}
#pragma mark - pickerViewControllerDelegate


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
       if (image!= nil)
    {
        
        
        PhotoTweaksViewController *photoTweaksViewController = [[PhotoTweaksViewController alloc] initWithImage:image];
        photoTweaksViewController.delegate = self;
        photoTweaksViewController.autoSaveToLibray = NO;
        
        [picker presentViewController:photoTweaksViewController animated:YES completion:nil];
    }
    else
    {
        
    }
    
    
}




#pragma mark - imageCropViewDelegateMethods

- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)photoTweaksController:(PhotoTweaksViewController *)controller didFinishWithCroppedImage:(UIImage *)croppedImage
{

    [controller dismissViewControllerAnimated:YES completion:^{
        
        [imagePickerController dismissViewControllerAnimated:YES completion:^{
            
            
           
      
            ImageFilterViewController * imageFilterVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ImageFilterViewController"];
            
            imageFilterVC.imageToEdit = croppedImage;
           

            [self.navigationController pushViewController:imageFilterVC animated:YES];
        }];
        
            
    }];
    
    
    
}

- (void)photoTweaksControllerDidCancel:(PhotoTweaksViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - alertViewCreation

-(void)alertView:(NSString *)alertDiscripatio
{
    UIAlertView *globalAlertView = [[UIAlertView alloc]initWithTitle:@"MySportsCast" message:alertDiscripatio delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [globalAlertView show];
  
    globalAlertView  = nil;
}
@end
