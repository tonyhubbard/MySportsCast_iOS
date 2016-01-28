//
//  AddMediaViewController.m
//  MySportsCast
//
//  Created by SPARSHMAC08 on 24/08/15.
//  Copyright (c) 2015 SPARSHMAC08. All rights reserved.
//
#import "VideoOrPhotoLoadViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PhotoTweaksViewController.h"
#import "ImageFilterViewController.h"
#import "EventTagViewController.h"
#import "AddMediaViewController.h"
#import "SearchViewController.h"
#import "AppDelegate.h"
#import "JsonClass.h"
#import "Constants.h"

@interface AddMediaViewController ()<UIScrollViewDelegate,WebServiceProtocol,PhotoTweaksViewControllerDelegate,UIDocumentInteractionControllerDelegate>
{
    NSArray * arrayChannel;
    NSInteger globelIndex;
    NSMutableArray * arrayButtonItem;
    CGFloat previousContentOffset;
    UIView * singleLineView;
    UITextView * textViewCastMessage;
    UILabel * LabelselectedEvent;
    UIView * searchView;
    AppDelegate * appdelegate;
    NSString * castTextString;
    JsonClass * jsonObject;
    UIButton * deleteEvent;
    BOOL isvideoButton;
    BOOL isCameraButton;
    BOOL isPhotoButton;
    UIButton * buttonPhoto;
    UILabel * galleryLabel;
    UIButton * buttonCamera;
    
    
    
}
@end

@implementation AddMediaViewController

- (void)viewDidLoad {
    
    appdelegate = [UIApplication sharedApplication].delegate;
    
    imagepicker = [[UIImagePickerController alloc]init];
    
    imagepicker.delegate = self;
    
    arrayChannel = @[@"CAST",@"VIDEOS",@"PHOTOS"];
    
    arrayButtonItem = [NSMutableArray new];
    singleLineView = [[UIView alloc]init];
    
    
    jsonObject = [[JsonClass alloc]init];
    
    jsonObject.delegate = self;
    
    scrollViewBottom = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64+44, self.view.frame.size.width, self.view.frame.size.height-(64))];
    
    [self.view addSubview:scrollViewBottom];
    
    singleLineView.backgroundColor = [UIColor colorWithRed:60.0f/255.0f green:142.0f/255.0f blue:249.0f/255.0f alpha:1];
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}

-(void)viewDidAppear:(BOOL)animated


{
    for (UIView * view in scrollViewBottom.subviews)
    {
        if ([view isKindOfClass:[UIView class]])
        {
            [view removeFromSuperview];
            
        }
    }
    
    for (UIView * view in self.scrollViewTop.subviews)
    {
        if ([view isKindOfClass:[UIView class]])
        {
            [view removeFromSuperview];
            
        }
    }
    
    
    [self addingButtonsToTopScrollView:arrayChannel];
    
    
    
}
-(void)viewDidDisappear:(BOOL)animated{
    
    
    
}

#pragma mark - addingCastAndVideoAndPhotoButtonsToTopScroll

-(void)addingButtonsToTopScrollView :(NSArray *)buttonArray
{
    
    
    
    CGFloat val = 0;
    CGFloat xValu =  val;
    CGFloat wid = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    CGFloat viewXValue = 0;
    
    
    for (int  i  = 0; i<[buttonArray count]; i++)
    {
        UIButton * button  = [[UIButton alloc]initWithFrame:CGRectMake(xValu, 0, self.view.frame.size.width/3, 42)];
        button.backgroundColor = [UIColor whiteColor];
        button.titleLabel.font =[UIFont fontWithName:@"AvenirNext-Regular" size:17];
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.scrollViewTop addSubview:button];
        [button setTitle:[buttonArray objectAtIndex:i]forState:UIControlStateNormal];
        [button addTarget:self action:@selector(topScrollViewButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView * tempView = [[UIView alloc]initWithFrame:CGRectMake(viewXValue, 0, wid, height-(64+44))];
        tempView.tag= i;
        
        if (tempView.tag == 0)
        {
            CGPoint  tempViewPoint = tempView.frame.origin;
            CGSize tempSize = tempView.frame.size;
            
            UIScrollView * scrollCast = [[UIScrollView alloc]initWithFrame:CGRectMake(tempViewPoint.x, tempViewPoint.y, tempSize.width, tempSize.height)];
            
            UILabel * labelCastMaxChar = [[UILabel alloc]initWithFrame:CGRectMake(tempViewPoint.x, 10, tempSize.width, 25)];
           
            labelCastMaxChar.text = @"Add your own 140 characters comment and cast it";
            if (self.view.frame.size.width == 768)
            {
                labelCastMaxChar.font = [UIFont systemFontOfSize:24];
            }
            else
            {
                labelCastMaxChar.font = [UIFont systemFontOfSize:12];
            }
            textViewCastMessage = [[UITextView alloc]initWithFrame:CGRectMake(10, labelCastMaxChar.frame.size.height+10, tempSize.width-20, 160)];
            if ([castTextString isEqualToString:@""] || (!castTextString))
            {
                
                textViewCastMessage.text = @"Type comment here.";
                textViewCastMessage.textColor = [UIColor lightGrayColor];
                
            }
            else
            {
                textViewCastMessage.text = castTextString;
            }
            
            
            textViewCastMessage.layer.borderColor = [UIColor lightGrayColor].CGColor;
            textViewCastMessage.layer.borderWidth = 1.0f;
            textViewCastMessage.delegate =self;
            labelCastMaxChar.textAlignment = NSTextAlignmentCenter;
            
            searchView = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(textViewCastMessage.frame)+10, tempSize.width-20, 40)];
            searchView.layer.borderColor = [UIColor lightGrayColor].CGColor;
            searchView.layer.borderWidth = 1.0f;
            
            NSString * eventName = [appdelegate.eventDetailsProfile valueForKey:@"eventName"];
            LabelselectedEvent = [[UILabel alloc]init];
            
            if ([eventName isEqualToString:@""] || (!eventName))
            {
                LabelselectedEvent.text = @"TaganEvent";
                LabelselectedEvent.frame = CGRectMake(5, 5, tempSize.width-50, 30);
                [searchView addSubview:LabelselectedEvent];
            }
            else
            {
                
                LabelselectedEvent.text = [NSString stringWithFormat:@" %@",eventName];
                CGSize constraint = CGSizeMake(LabelselectedEvent.frame.size.width, 20000.0f);
                CGSize size;
                
                NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
                CGSize boundingBox = [LabelselectedEvent.text boundingRectWithSize:constraint
                                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                                        attributes:@{NSFontAttributeName:LabelselectedEvent.font}
                                                                           context:context].size;
                
                size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
                
                LabelselectedEvent.frame = CGRectMake(5, 10, size.width, size.height);
                
                LabelselectedEvent.layer.borderColor = [UIColor lightGrayColor].CGColor;
                
                LabelselectedEvent.layer.borderWidth = 1.0f;
                
                LabelselectedEvent.layer.cornerRadius = 5;
                
                [searchView addSubview:LabelselectedEvent];
                
                deleteEvent = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(LabelselectedEvent.frame)-10, 5, 15, 15)];
                
                [deleteEvent setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
                
                [searchView addSubview:deleteEvent];
                
                [deleteEvent addTarget:self action:@selector(deleteEventTag:) forControlEvents:UIControlEventTouchUpInside];
                
                
                
                
                
            }
            
            
            
            LabelselectedEvent.textColor =[UIColor lightGrayColor];
            LabelselectedEvent.font = [UIFont systemFontOfSize:12];
            LabelselectedEvent.userInteractionEnabled = YES;
            
            UITapGestureRecognizer * tapGestur =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapgestureForEventLabel)];
            
            [LabelselectedEvent addGestureRecognizer:tapGestur];
            
            
            UIImageView * imageViewSearch = [[UIImageView alloc]initWithFrame:CGRectMake(searchView.frame.size.width-35, 5, 30, 30)];
            
            UIButton * buttonTwitterShare = [[UIButton alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(searchView.frame)+10, tempSize.width-20, 40)];
            [buttonTwitterShare setTitle:@"Share With Twitter" forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            buttonTwitterShare.backgroundColor = [UIColor colorWithRed:60.0f/255.0f green:142.0f/255.0f blue:249.0f/255.0f alpha:1];
            
            buttonTwitterShare.layer.cornerRadius = 5;
            
            UIButton * buttonFaceBookShare = [[UIButton alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(buttonTwitterShare.frame)+10, tempSize.width-20, 40)];
            [buttonFaceBookShare setTitle:@"Share With FaceBook" forState:UIControlStateNormal];
            [buttonFaceBookShare setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            buttonFaceBookShare.backgroundColor = [UIColor colorWithRed:60.0f/255.0f green:142.0f/255.0f blue:249.0f/255.0f alpha:1];
            
            buttonFaceBookShare.layer.cornerRadius = 5;
            
            UIButton * buttonInstaGramShare = [[UIButton alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(buttonFaceBookShare.frame)+10, tempSize.width-20, 40)];
            [buttonInstaGramShare setTitle:@"Share With Instagram" forState:UIControlStateNormal];
            [buttonInstaGramShare setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            buttonInstaGramShare.backgroundColor = [UIColor colorWithRed:60.0f/255.0f green:142.0f/255.0f blue:249.0f/255.0f alpha:1];
            
            buttonInstaGramShare.layer.cornerRadius = 5;
            
            UIButton * buttonBroadCast = [[UIButton alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(buttonInstaGramShare.frame)+10, tempSize.width-20, 40)];
            [buttonBroadCast setTitle:@"BROADCAST" forState:UIControlStateNormal];
            [buttonBroadCast setBackgroundImage:[UIImage imageNamed:@"bg1.png"] forState:UIControlStateNormal];
            //            buttonBroadCast.backgroundColor = [UIColor colorWithRed:60.0f/255.0f green:142.0f/255.0f blue:249.0f/255.0f alpha:1];
            
            [buttonBroadCast addTarget:self action:@selector(broadCastButton:) forControlEvents:UIControlEventTouchUpInside];
            
            
            
            [buttonFaceBookShare addTarget:self action:@selector(faceBookShare) forControlEvents:UIControlEventTouchUpInside];
            [buttonTwitterShare addTarget:self action:@selector(twitterShare) forControlEvents:UIControlEventTouchUpInside];
            [buttonInstaGramShare addTarget:self action:@selector(instagramShare) forControlEvents:UIControlEventTouchUpInside];
            
            
            imageViewSearch.image = [UIImage imageNamed:@"search_addcast.png"];
            [scrollCast addSubview:labelCastMaxChar];
            [scrollCast addSubview:textViewCastMessage];
            [tempView addSubview:scrollCast];
            [scrollCast addSubview:searchView];
            [searchView addSubview:imageViewSearch];
            [scrollCast addSubview:buttonTwitterShare];
            [scrollCast addSubview:buttonFaceBookShare];
            [scrollCast addSubview:buttonInstaGramShare];
            [scrollCast addSubview:buttonBroadCast];
            
            scrollCast.contentSize = CGSizeMake(tempSize.width,CGRectGetMaxY(buttonBroadCast.frame)+30);
            
        }
        else if (tempView.tag == 1)
        {
            
            
            
            UIButton * buttonVideo =[[UIButton alloc]initWithFrame:CGRectMake((wid/2)-((wid/2))/3, (wid/2)-60, wid/3, wid/3)];
            
            [buttonVideo setImage:[UIImage imageNamed:@"media_video.png"] forState:UIControlStateNormal];
            
            [buttonVideo addTarget:self action:@selector(videoButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            [tempView addSubview:buttonVideo];
            
            UILabel * labelAddVideo = [[UILabel alloc]initWithFrame:CGRectMake(0, buttonVideo.frame.origin.y-43, self.view.frame.size.width, 20)];
            
            labelAddVideo.text = @"ADD VIDEO";
            labelAddVideo.textColor = [UIColor blackColor];
            labelAddVideo.textAlignment = NSTextAlignmentCenter;
            labelAddVideo.font = [UIFont systemFontOfSize:20];
            [tempView addSubview:labelAddVideo];
            
            UILabel * VideoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, buttonVideo.frame.origin.y+wid/3+5, self.view.frame.size.width, 20)];
            VideoLabel.text = @"Video";
            VideoLabel.textColor = [UIColor lightGrayColor];
            VideoLabel.textAlignment = NSTextAlignmentCenter;
            VideoLabel.font = [UIFont systemFontOfSize:20];
            
            [tempView addSubview:VideoLabel];
            
            
        }
        else if(tempView.tag == 2)
        {
            
            if (isipad()) {
                buttonPhoto =[[UIButton alloc]initWithFrame:CGRectMake(wid/2.5-(wid/2.5)/2-(20), (wid/2)-60, (wid/3)-20, (wid/3)-20)];
                buttonCamera =[[UIButton alloc]initWithFrame:CGRectMake(buttonPhoto.frame.size.width+buttonPhoto.frame.origin.x+5, (wid/2)-60, (wid/3)-20, (wid/3)-20)];
            }else{
                buttonPhoto =[[UIButton alloc]initWithFrame:CGRectMake(wid/2-(wid/2)/2-(20), (wid/2)-60, (wid/3)-10, (wid/3)-10)];
                buttonCamera =[[UIButton alloc]initWithFrame:CGRectMake(buttonPhoto.frame.size.width+buttonPhoto.frame.origin.x+5, (wid/2)-60, (wid/3)-10, (wid/3)-10)];
            }
            
            
            [buttonPhoto setImage:[UIImage imageNamed:@"media_gallery.png"] forState:UIControlStateNormal];
            
            [tempView addSubview:buttonPhoto];
            
            
            
            if (isipad()) {
                galleryLabel = [[UILabel alloc]initWithFrame:CGRectMake(wid/2-(wid/2)/1.75-(30), buttonPhoto.frame.origin.y+wid/3+5,(wid/3)-10, 20)];
            }else{
                galleryLabel = [[UILabel alloc]initWithFrame:CGRectMake(wid/2-(wid/2)/2-(20), buttonPhoto.frame.origin.y+wid/3+5,(wid/3)-10, 20)];
            }
            
            galleryLabel.text = @"Gallery";
            galleryLabel.textColor = [UIColor lightGrayColor];
            galleryLabel.textAlignment = NSTextAlignmentCenter;
            galleryLabel.font = [UIFont systemFontOfSize:20];
            
            UILabel * CameraLabel = [[UILabel alloc]initWithFrame:CGRectMake(buttonCamera.frame.origin.x, buttonPhoto.frame.origin.y+wid/3+5, (wid/3)-10, 20)];
            CameraLabel.text = @"Camera";
            CameraLabel.textColor = [UIColor lightGrayColor];
            CameraLabel.textAlignment = NSTextAlignmentCenter;
            CameraLabel.font = [UIFont systemFontOfSize:20];
            
            UILabel * labelAddPhoto = [[UILabel alloc]initWithFrame:CGRectMake(0, buttonPhoto.frame.origin.y-43, self.view.frame.size.width, 20)];
            
            labelAddPhoto.text = @"ADD PHOTO";
            labelAddPhoto.textAlignment = NSTextAlignmentCenter;
            
            labelAddPhoto.textColor = [UIColor blackColor];
            
            labelAddPhoto.font = [UIFont systemFontOfSize:20];
            
            [tempView addSubview:labelAddPhoto];
            
            [buttonCamera setImage:[UIImage imageNamed:@"media_camera.png"] forState:UIControlStateNormal];
            
            [buttonPhoto addTarget:self action:@selector(photoButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            
            [buttonCamera addTarget:self action:@selector(cameraButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            
            [tempView addSubview:buttonCamera];
            
            [tempView addSubview:buttonPhoto];
            [tempView addSubview:galleryLabel];
            [tempView addSubview:CameraLabel];
            
            
        }
        [scrollViewBottom addSubview:tempView];
        
        if (i==globelIndex)
        {
            button.alpha=1.0;
        }
        else button.alpha=0.6;
        
        xValu  = xValu+button.frame.size.width;
        viewXValue = viewXValue+wid;
        button.tag = i;
        
        
        singleLineView.frame = CGRectMake(0, button.frame.origin.y+42, wid/3, 2);
        [self.scrollViewTop addSubview:singleLineView];
        [arrayButtonItem addObject:button];
        
    }
    
    self.scrollViewTop.contentSize = CGSizeMake(xValu, 60);
    scrollViewBottom.contentSize = CGSizeMake(viewXValue, scrollViewBottom.frame.size.height);
    self.scrollViewTop.delegate = self;
    scrollViewBottom.delegate = self;
    self.scrollViewTop.scrollEnabled = NO;
    scrollViewBottom.pagingEnabled=YES;
    [self particulerIndex:globelIndex andAnimationValue:0.3];
    
}

-(void)topScrollViewButtonAction :(UIButton*)sender
{
    scrollViewBottom.pagingEnabled=YES;
    scrollViewBottom.pagingEnabled=NO;
    [self particulerIndex:sender.tag andAnimationValue:0.3];
    
}

- (void)particulerIndex:(NSInteger)index andAnimationValue:(NSInteger)value
{
    
    UIButton *prevSelectdItem1, *nextSelectdItem1;
    prevSelectdItem1=(UIButton*)[arrayButtonItem objectAtIndex:globelIndex];
    nextSelectdItem1=(UIButton*)[arrayButtonItem objectAtIndex:index];
    
    if ((labs(globelIndex) - labs(index))<= 1)
    {
        [UIView animateWithDuration:0.1 animations:^{
            
            singleLineView.frame = CGRectMake(nextSelectdItem1.frame.origin.x, nextSelectdItem1.frame.origin.y+nextSelectdItem1.frame.size.height, self.view.frame.size.width/3, 2);
            
        }];
        
        prevSelectdItem1.alpha=1;
        nextSelectdItem1.alpha = 0.6;
        if (index == globelIndex)
        {
            
            [UIView animateWithDuration:value animations:^{
                scrollViewBottom.contentOffset = CGPointMake(index * scrollViewBottom.frame.size.width, 0);
                
            }];
            nextSelectdItem1.alpha=0.6;
            prevSelectdItem1.alpha =1;
            
        }else
        {
            
            [UIView animateWithDuration:value animations:^{
                
                scrollViewBottom.contentOffset = CGPointMake(index * scrollViewBottom.frame.size.width, 0);
                
            }];
            
            int j = 0;
            for (j=0; j<arrayButtonItem.count; j++)
            {
                
                UIButton *btnNext = (UIButton *)[arrayButtonItem objectAtIndex:j];
                if (j == index)
                {
                    
                    btnNext.alpha = 1.0;
                    
                }else
                {
                    btnNext.alpha = 0.6;
                }
                
            }
            prevSelectdItem1.alpha=0.6;
            nextSelectdItem1.alpha=1;
            
            
        }
    }else {
        [UIView animateWithDuration:value animations:^{
            
            scrollViewBottom.contentOffset = CGPointMake(index *scrollViewBottom.frame.size.width, 0);
            //            [self.scrollViewTop setContentOffset:[self contentOffsetForSelectedItemAtIndex:index] animated:NO];
            
        }];
        prevSelectdItem1.alpha=0.6;
        nextSelectdItem1.alpha=1;
        
    }
    
    globelIndex=index;
    
}

#pragma mark - mediaAction

-(void)videoButtonClicked
{
    isvideoButton = YES;
    
    [appdelegate.eventDetailsProfile setObject:@"" forKey:@"eventName"];
    [appdelegate.eventDetailsProfile setObject:@"" forKey:@"eventId"];
    
    [self PickerControllerSession];
    
    //    [self alertViewShow:@"Yet be implement"];
    
    
    
    //    VideoOrPhotoLoadViewController * videoViewVC = [self.storyboard instantiateViewControllerWithIdentifier:@"VideoOrPhotoLoadViewController"];
    //    [self.navigationController pushViewController:videoViewVC animated:YES];
}

-(void)PickerControllerSession
{
    
    if (isvideoButton == YES)
    {
        
        [self VideoSession];
    }
    else if (isPhotoButton == YES)
    {
        
    }
    else
    {
        
    }
    
    
}

-(void)VideoSession

{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        
        
        
        NSArray *sourceTypes = [UIImagePickerController availableMediaTypesForSourceType:imagepicker.sourceType];
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
        imagepicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagepicker.cameraDevice=UIImagePickerControllerCameraDeviceRear;
        
        imagepicker.mediaTypes = [NSArray arrayWithObject:(NSString*)kUTTypeMovie];
        
        imagepicker.videoQuality = UIImagePickerControllerQualityTypeLow;
        
        imagepicker.videoMaximumDuration = 30;
        
        
        
        [self.navigationController presentViewController:imagepicker animated:YES completion:nil];
    }
    
    else
    {
        
        [self alertViewShow:@"There is no camera avilable"];
        
        
    }
}

-(void)photoSession
{
    
    
    imagepicker.sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    imagepicker.mediaTypes = [NSArray arrayWithObject:(NSString*)kUTTypeImage];
    
    [self.navigationController presentViewController:imagepicker animated:YES completion:nil];
    
}

-(void)cameraSession
{
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        
        imagepicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagepicker.mediaTypes = [NSArray arrayWithObject:(NSString*)kUTTypeImage];
        
        [self.navigationController presentViewController:imagepicker animated:YES completion:nil];
    }
    else{
        
        [self alertViewShow:@"There is no camera avilable"];
    }
}


#pragma mark - PickerViewDelegateMethods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    
    if (isvideoButton == YES)
    {
        
        isvideoButton = NO;
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        NSURL *recordedVideoURL= [info objectForKey:UIImagePickerControllerMediaURL];
        
        
        
        if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:recordedVideoURL])
        {
            [library writeVideoAtPathToSavedPhotosAlbum:recordedVideoURL
                                        completionBlock:^(NSURL *assetURL, NSError *error)
             {
             }
             ];
        }
        
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
            VideoOrPhotoLoadViewController * videoORPhotoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"VideoOrPhotoLoadViewController"];
            
            videoORPhotoVC.videoPathUrl  = recordedVideoURL;
            
            videoORPhotoVC.fromAddMedia = YES;
            
            [self.navigationController pushViewController:videoORPhotoVC animated:YES];
            
        }];
    }
    else
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
    
    
    
}




#pragma mark - imageCropViewDelegateMethods

- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)photoTweaksController:(PhotoTweaksViewController *)controller didFinishWithCroppedImage:(UIImage *)croppedImage
{
    
    [controller dismissViewControllerAnimated:YES completion:^{
        
        [imagepicker dismissViewControllerAnimated:YES completion:^{
            
            ImageFilterViewController * imageFilterVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ImageFilterViewController"];
            
            imageFilterVC.imageToEdit = croppedImage;
            imageFilterVC.fromAddMedia = YES;
            
            [self.navigationController pushViewController:imageFilterVC animated:YES];
            
        }];
        
        
    }];
    
    
    
}

- (void)photoTweaksControllerDidCancel:(PhotoTweaksViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)photoButtonClicked
{
    
    [appdelegate.eventDetailsProfile setObject:@"" forKey:@"eventName"];
    [appdelegate.eventDetailsProfile setObject:@"" forKey:@"eventId"];
    
    isPhotoButton = YES;
    [self photoSession];
    
    //    [self alertViewShow:@"Yet be implement"];
}

-(void)cameraButtonClicked
{
    
    [appdelegate.eventDetailsProfile setObject:@"" forKey:@"eventName"];
    [appdelegate.eventDetailsProfile setObject:@"" forKey:@"eventId"];
    
    isCameraButton = YES;
    
    [self cameraSession];
    //    [self alertViewShow:@"Yet be implement"];
    
}
#pragma mark - ChangingScrollViewContentOffset

-(CGPoint)contentOffsetForSelectedItemAtIndex:(NSInteger)index
{
    if (([arrayButtonItem count] < index) || (arrayButtonItem.count == 1))
    {
        return CGPointZero;
        
    } else
    {
        CGFloat totalOffset  = self.scrollViewTop.contentSize.width - CGRectGetWidth(self.scrollViewTop.frame) + 32;
        CGPoint center   = [(UIView *)[arrayButtonItem objectAtIndex:index] center];
        CGPoint centerOrig = [(UIView *)[arrayButtonItem objectAtIndex:0] center];
        
        CGFloat div;
        
        if (index == 0 ){
            div = 1;
        }else if (index == 1 ){
            div = totalOffset / (center.x - centerOrig.x) ;//2.3
        }else if (index == 2) {
            div = (totalOffset / (center.x - centerOrig.x)) * 2; //2.27
        }else if (index == 3) {
            div = (totalOffset / (center.x - centerOrig.x)) * 3;
        }else {
            div = (totalOffset / (center.x - centerOrig.x)) * 4;// 2.11
        }
        
        return CGPointMake((index)  * totalOffset / div ,0);
    }
    
    
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    scrollViewBottom.pagingEnabled=YES;
    
    if (scrollView == scrollViewBottom)
    {
        if (scrollViewBottom.contentOffset.x > 0)
        {
            NSInteger prevIndex = 0;
            if (previousContentOffset > scrollViewBottom.contentOffset.x)
            {
                if (globelIndex == 0)
                {
                    prevIndex = globelIndex;
                }
                else
                {
                    prevIndex = globelIndex - 1;
                    
                }
                
            }
            else if (previousContentOffset < scrollView.contentOffset.x)
            {
                
                if (globelIndex >= (arrayButtonItem.count - 1))
                {
                    prevIndex = globelIndex;
                }else {
                    prevIndex = globelIndex + 1;
                    
                }
            }
            
            if (scrollView.contentOffset.x > 0)
            {
                if (prevIndex > globelIndex)
                {
                    //                    self.scrollViewTop.contentOffset = CGPointMake(self.scrollViewBottom.contentOffset.x/3, 0);
                }
                else
                {
                    //                    self.scrollViewTop.contentOffset = CGPointMake(self.scrollViewBottom.contentOffset.x/3, 0);
                    
                }
                
            }
            
        }
        previousContentOffset = scrollViewBottom.contentOffset.x;
        
        
    }
    
    
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    if (scrollView == scrollViewBottom)
    {
        
        NSInteger selectedIndex1 = scrollView.contentOffset.x/scrollViewBottom.frame.size.width;
        [self particulerIndex:selectedIndex1 andAnimationValue:0.3];//particulerIndex:selectedIndex1];
        scrollViewBottom.userInteractionEnabled = YES;
        
        
    }
    
}

-(void)alertViewShow:(NSString *)alertMessage
{
    
    UIAlertView *globalAlertView = [[UIAlertView alloc]initWithTitle:@"MySportsCast" message:alertMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [globalAlertView show];
    globalAlertView  = nil;
    
    
}


#pragma mark - tabgestureHandler

-(void)tapgestureForEventLabel
{
    castTextString = textViewCastMessage.text;
    
    EventTagViewController * eventTagVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EventTagViewController"];
    
    [self.navigationController pushViewController:eventTagVC animated:YES];
    
}


#pragma mark - deleteEventTag

-(void)deleteEventTag:(UIButton *)button
{
    [appdelegate.eventDetailsProfile setObject:@"" forKey:@"eventName"];
    [appdelegate.eventDetailsProfile setObject:@"" forKey:@"eventId"];
    LabelselectedEvent.text = @"TaganEvent";
    LabelselectedEvent.frame = CGRectMake(5, 5, self.view.frame.size.width-50, 30);
    LabelselectedEvent.layer.borderWidth = 0.0f;
    [button removeFromSuperview];
}

#pragma mark - TextDelegateMethods

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
#define MAX_LENGTH 140
    
    
//    NSString * stringToRange = [textView.text substringWithRange:NSMakeRange(0,range.location)];
//    
//    // Appending the currently typed charactor
//    stringToRange = [stringToRange stringByAppendingString:text];
//    
//    // Processing the last typed word
//    NSArray *wordArray       = [stringToRange componentsSeparatedByString:@" "];
//    NSString * wordTyped     = [wordArray lastObject];
    
    castTextString = textView.text;
    
    if([text isEqualToString:@"\n"])
    {
        
        [textView resignFirstResponder];
        return NO;
    }
    if (textView.text.length >= MAX_LENGTH && range.length == 0)
    {
        
        return NO; // return NO to not change text
    }
    
    else
    {
        
        return YES;
    }
    
   
    
}


- (void)textViewDidBeginEditing:(UITextView *)textView

{
    if ([textView.text isEqualToString:@"Type comment here."]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""])
    {
        textView.text = @"Type comment here.";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}

#pragma mark - broadCastButtonClicked

-(void)broadCastButton:(UIButton *)button

{
    if (!castTextString ||[castTextString isEqualToString:@""] || [castTextString isEqualToString:@"Type comment here"])
    {
        [self alertViewShow:@"Please Enter Comment Cast"];
        
    }
    else{
        NSString * userId = [[NSUserDefaults standardUserDefaults]valueForKey:@"loginId"];
        
        
        if ([appdelegate connectedToInternet])
        {
            [appdelegate startIndicator];
            
            //puttingEmpty eventId
            [appdelegate.eventDetailsProfile setObject:@"" forKey:@"eventName"];
            
            [jsonObject getMethodforServiceRequest:[NSString stringWithFormat:@"%@add_cast_to_event.php?user_id=%@&event_id=%@&cast_info=%@",commonURL,userId,[appdelegate.eventDetailsProfile valueForKey:@"eventId"],castTextString]];
            
            
            //puttingEmpty eventId
            [appdelegate.eventDetailsProfile setObject:@"" forKey:@"eventId"];
        }
        else
        {
            [appdelegate stopIndicators];
            [self alertViewShow:@"check Internet Connection"];
        }
        
        
    }
    
    
    
    
}

#pragma mark - WebServiceDelegate

-(void)didReceiveResponseFromWebService:(NSDictionary *)responseDictionary
{
    
    if ([[[responseDictionary valueForKey:@"Response"]valueForKey:@"ResponseInfo"] isEqualToString:@"SUCCESS"])
    {
        
        textViewCastMessage.text = @"";
        castTextString = @"";
        [appdelegate.eventDetailsProfile setObject:@"" forKey:@"eventName"];
        [appdelegate.eventDetailsProfile setObject:@"" forKey:@"eventId"];
        LabelselectedEvent.text = @"TaganEvent";
        LabelselectedEvent.frame = CGRectMake(5, 5, self.view.frame.size.width-50, 30);
        LabelselectedEvent.layer.borderWidth = 0.0f;
        [deleteEvent removeFromSuperview];
        
        [appdelegate stopIndicators];
        [self alertViewShow:@"Success"];
        
    }
    
    
    
    
    
}

#pragma shareMethodsForSocialSharing 

-(void)faceBookShare
{
    slController=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    
    if (!castTextString ||[castTextString isEqualToString:@""] || [castTextString isEqualToString:@"Type comment here"])
    {
        [self alertViewShow:@"Please Enter Comment Cast"];
        
    }
    else{
        
        [slController setInitialText:castTextString];
        
        [self presentViewController:slController animated:YES completion:nil];
    }
}

-(void)twitterShare
{
    slController=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    if (!castTextString ||[castTextString isEqualToString:@""] || [castTextString isEqualToString:@"Type comment here"])
    {
        [self alertViewShow:@"Please Enter Comment Cast"];
        
    }
    else{
        
        [slController setInitialText:castTextString];
        
        [self presentViewController:slController animated:YES completion:nil];
    }
    
    
}

-(void)instagramShare
{
    UIImageView * imageview = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 350, 350)];
    
    imageview.image = [UIImage imageNamed:@"splash_screen_inner.jpg"];
    
    CGFloat cropVal = (imageview.image.size.height > imageview.image.size.width ? imageview.image.size.width : imageview.image.size.height);
    
    
    cropVal *= [imageview.image scale];
    
    CGRect cropRect = (CGRect){.size.height = cropVal, .size.width = cropVal};
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([imageview.image CGImage], cropRect);
    
    NSData *imageData = UIImageJPEGRepresentation([UIImage imageWithCGImage:imageRef], 1.0);
    CGImageRelease(imageRef);
    
    NSString *writePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"instagram.igo"];
    
    if (![imageData writeToFile:writePath atomically:YES]) {
        // failure
        NSLog(@"image save failed to path %@", writePath);
        return;
    } else {
        // success.
    }
    
    // send it to instagram.
    NSURL *fileURL = [NSURL fileURLWithPath:writePath];
    self.dicInteractionVC = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
    self.dicInteractionVC.delegate = self;
    [self.dicInteractionVC setUTI:@"com.instagram.MySportsCast"];
    
    // [self.dic setAnnotation:@{@"InstagramCaption" : @"https://play.google.com/store/apps/details?id=idreammedia.ramcharanstar&hl=en"}];
    
    self.dicInteractionVC.annotation = [NSDictionary dictionaryWithObject:@"MySportsCast" forKey:@"InstagramCaption"];
    
    
    [self.dicInteractionVC presentOpenInMenuFromRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) inView:self.view animated:YES];
}

- (UIDocumentInteractionController *) setupControllerWithURL: (NSURL*) fileURL usingDelegate: (id <UIDocumentInteractionControllerDelegate>) interactionDelegate {
    NSLog(@"file url %@",fileURL);
    UIDocumentInteractionController *interactionController = [UIDocumentInteractionController interactionControllerWithURL: fileURL];
    interactionController.delegate = interactionDelegate;
    
    return interactionController;
}



@end
