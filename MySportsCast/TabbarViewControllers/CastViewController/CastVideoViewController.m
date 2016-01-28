//
//  CastVideoViewController.m
//  MySportsCast
//
//  Created by SPARSHMAC08 on 09/09/15.
//  Copyright (c) 2015 SPARSHMAC08. All rights reserved.
//

#import "CastVideoViewController.h"
#import "VideoOrPhotoLoadViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
@interface CastVideoViewController ()

@end

@implementation CastVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    
    self.videoButtonClicked = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backButtonAction:(id)sender {
    
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)videoButtonClickedAction:(id)sender {
    
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        
        UIImagePickerController *videoRecorder = [[UIImagePickerController alloc]init];
        
        NSArray *sourceTypes = [UIImagePickerController availableMediaTypesForSourceType:videoRecorder.sourceType];
        NSLog(@"Available types for source as camera = %@", sourceTypes);
        
        if (![sourceTypes containsObject:(NSString*)kUTTypeMovie] )
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"Device Not Supported for video Recording."                                                                       delegate:self
                                                  cancelButtonTitle:@"Yes"
                                                  otherButtonTitles:@"No",nil];
            [alert show];
            alert = nil;
            return;
        }
        videoRecorder.sourceType = UIImagePickerControllerSourceTypeCamera;
        videoRecorder.cameraDevice=UIImagePickerControllerCameraDeviceRear;
       
        videoRecorder.mediaTypes = [NSArray arrayWithObject:(NSString*)kUTTypeMovie];
        
        videoRecorder.videoQuality = UIImagePickerControllerQualityTypeLow;
        
        videoRecorder.videoMaximumDuration = 30;
        
        
        
        self.imagepicker = videoRecorder;
        self.imagepicker.delegate = self;

        [self.navigationController presentViewController:self.imagepicker animated:YES completion:nil];
    }
    
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Video Alert"
                                                        message:@"No Camera in simulator"                                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil,nil];
        [alert show];
        alert = nil;

    }

    
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    
    
//    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
//    NSString *videoPath = [info objectForKey:UIImagePickerControllerMediaURL];
//    if ([mediaType isEqualToString:@"public.movie"])
//    {
//        // Saving the video / // Get the new unique filename
//        NSString *sourcePath = [[info objectForKey:@"UIImagePickerControllerMediaURL"]relativePath];
//        UISaveVideoAtPathToSavedPhotosAlbum(sourcePath,nil,nil,nil);
//        
//    }
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    NSURL *recordedVideoURL= [info objectForKey:UIImagePickerControllerMediaURL];
    
    
    
    if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:recordedVideoURL])
    {
        [library writeVideoAtPathToSavedPhotosAlbum:recordedVideoURL
                                    completionBlock:^(NSURL *assetURL, NSError *error){
             }
         ];
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
        VideoOrPhotoLoadViewController * videoORPhotoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"VideoOrPhotoLoadViewController"];
        
        videoORPhotoVC.videoPathUrl  = recordedVideoURL;
        
        videoORPhotoVC.fromAddMedia = NO;
        
        [self.navigationController pushViewController:videoORPhotoVC animated:YES];
        
        
    }];
    

}


@end
