//
//  VideoOrPhotoLoadViewController.m
//  MySportsCast
//
//  Created by SPARSHMAC08 on 26/08/15.
//  Copyright (c) 2015 SPARSHMAC08. All rights reserved.
//

#import "VideoOrPhotoLoadViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "EventDestialsViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "AddMediaViewController.h"
#import "EventTagViewController.h"
#import "PlayerViewController.h"
#import "TagViewController.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "JsonClass.h"
@interface VideoOrPhotoLoadViewController ()<WebServiceProtocol,UIDocumentInteractionControllerDelegate>
{
    JsonClass *jsonObject;
    NSString *mediaFile;
    AppDelegate * appdelegate;
    NSString * stringTagId;
    UIButton * deleteEvent;
    SLComposeViewController * controller ;
    
    
    
    
}
@property (nonatomic,retain)UIDocumentInteractionController * docController;
@end

@implementation VideoOrPhotoLoadViewController
- (void)viewDidLoad
{
    

    
    
    jsonObject =[[JsonClass alloc]init];
    
    jsonObject.delegate = self;
    
    appdelegate = [UIApplication sharedApplication].delegate;
    
    self.labelPeopleTag.hidden = NO;
    
    stringTagId = [[NSString alloc]init];
    
    
    
    
    if (self.videoPathUrl)
    {
        
        AVAsset *asset = [AVAsset assetWithURL:self.videoPathUrl];
        
        AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
        CMTime time = CMTimeMake(0, 3);
        CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
        UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
        if (thumbnail)
        {
            
            UIImage * image = [self imageResize:thumbnail andResizeTo:self.imageView.frame.size];
            CIImage* coreImage = image.CIImage;
            
            if (!coreImage) {
                coreImage = [CIImage imageWithCGImage:image.CGImage];
            }
            coreImage = [coreImage imageByApplyingTransform:CGAffineTransformMakeRotation(-M_PI/2)];
            self.imageView.image = [UIImage imageWithCIImage:coreImage];
            image = nil;
            thumbnail = nil;
            imageGenerator = nil;
           
            self.imageView = nil;
            self.playButton.hidden = NO;
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:@"video.mp4"];
            
            NSData *imageData =[NSData dataWithContentsOfURL:self.videoPathUrl];
            
            [imageData writeToFile:savedImagePath atomically:NO];
           self.labelUploadTitle.text = @"UPLOAD VIDEO";
        }
        else
        {
            
        }
        
       

    }
    
    else
    {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:@"savedImage.png"];
         // imageView is my image from camera
        NSData *imageData = UIImageJPEGRepresentation(self.imageCast, 0.9f);
        
        [imageData writeToFile:savedImagePath atomically:NO];
        
        self.playButton.hidden = YES;
        
        self.imageView.image = self.imageCast;
        self.labelUploadTitle.text = @"UPLOAD PHOTO";
        
    }
    
    self.navigationController.navigationBar.hidden = YES;
    self.buttonShareFB.layer.cornerRadius = 5;
    self.buttonShareTwitter.layer.cornerRadius = 5;
    self.buttonShareInstagram.layer.cornerRadius = 5;
    self.viewEventTag.layer.borderWidth = 1;
    self.viewEventTag.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.viewPeopleTag.layer.borderWidth = 1;
    self.viewPeopleTag.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    
    
//    self.viewPeopleTag
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewDidLayoutSubviews{
    
    self.scrollviewWithConstrain.constant = self.view.frame.size.width;
    self.scrollContentViewWidth.constant = self.view.frame.size.width;
//    self.scrolviewContentHeight.constant = self.view.frame.size.height;
    
   [self.scrollViewForScroll setContentSize:CGSizeMake(self.view.frame.size.width, CGRectGetMaxY(self.buttonShareInstagram.frame)+100)];
     [self.view layoutSubviews];
}


-(void)viewDidAppear:(BOOL)animated
{
    
   
    
    UITapGestureRecognizer * tapOnPeopleTag = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(peopleTag:)];
    
    [self.viewPeopleTag addGestureRecognizer:tapOnPeopleTag];
    
    tapOnPeopleTag = nil;
    
    labelEventTag = [[UILabel alloc]init];
    
    if (self.fromAddMedia ==YES)
    {
    
        //        [appdelegate.eventDetailsProfile setObject:eventname forKey:@"eventName"];
        //        [appdelegate.eventDetailsProfile setObject:evetnId forKey:@"eventId"];
   
        
        if ([[appdelegate.eventDetailsProfile valueForKey:@"eventName"]isEqual:@""])
        {
            labelEventTag.text = @" Tag Event";
            
            labelEventTag.textColor = [UIColor lightGrayColor];
            
            labelEventTag.frame = CGRectMake(5, 5, self.view.frame.size.width-50, 30);
           
            [self.viewEventTag addSubview:labelEventTag];
            
        }
        else
        {
            //getting selected event info
            labelEventTag.text = [appdelegate.eventDetailsProfile valueForKey:@"eventName"];
            
            labelEventTag.textColor = [UIColor lightGrayColor];
            
            CGSize constraint = CGSizeMake(labelEventTag.frame.size.width, 20000.0f);
            CGSize size;
            
            NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
            
            CGSize boundingBox = [labelEventTag.text boundingRectWithSize:constraint
                                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                                               attributes:@{NSFontAttributeName:labelEventTag.font}
                                                                  context:context].size;
            
            size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
            
            labelEventTag.frame = CGRectMake(5, 7, size.width, size.height);
            
            labelEventTag.layer.cornerRadius = 5;
            
            labelEventTag.layer.borderWidth = 1.0f;
            
            labelEventTag.layer.borderColor = [UIColor lightGrayColor].CGColor;
            
            
            deleteEvent  = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(labelEventTag.frame)-5, 0, 15, 15)];
            
            
            [deleteEvent setImage:[UIImage imageNamed:@"crossround.png"] forState:UIControlStateNormal];
            
            [deleteEvent addTarget:self action:@selector(deleteEventTag:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.viewEventTag addSubview:labelEventTag];
            
            [self.viewEventTag addSubview:deleteEvent];
            
            
            
        }
        
        labelEventTag.userInteractionEnabled = YES;
        
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureAction)];
        
        [labelEventTag addGestureRecognizer:tapGesture];
        
    }
    else
    {
        
        [self.viewEventTag addSubview:labelEventTag];
        
        NSData * data = [[NSUserDefaults standardUserDefaults]valueForKey:@"eventDeatils"];
        
        NSDictionary * eventsdic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        labelEventTag.text = [NSString stringWithFormat:@" %@",[eventsdic valueForKey:@"EventName"]];
        
        labelEventTag.frame = CGRectMake(5, 5, self.view.frame.size.width-50, 30);
        
        eventsdic = nil;
        data = nil;
        
        
    }
    
    
    
    
    
}


-(void)viewDidDisappear:(BOOL)animated

{
    [labelEventTag removeFromSuperview];
    labelEventTag = nil;
    
}


-(void)peopleTag:(UITapGestureRecognizer *)tapgesture

{
    
   
    TagViewController * tagVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TagViewController"];

    tagVC.delegate = self;
    tagVC.headerName = @"TAG PEOPLE";

    [self.navigationController pushViewController:tagVC animated:YES];
    tapgesture = nil;
    
    
}
#pragma mark - tagsDelegate

-(void)TagsSelectedId:(NSArray *)selectedTagIds
{
    NSLog(@"%@",selectedTagIds);
    
    if (selectedTagIds)
    {
        for (int a=0; a<[selectedTagIds count]; a++)
        {
            
            NSString * tempString = [selectedTagIds objectAtIndex:a];
            
            stringTagId = [stringTagId stringByAppendingString:[NSString stringWithFormat:@"%@,",tempString]];
        }
        if (stringTagId.length !=0)
        {
            stringTagId = [stringTagId substringToIndex:[stringTagId length]-1];
        }
        
    }

    
}

-(void)TagsSelectedValues:(NSArray *)selectedValues
{
    
    self.labelPeopleTag.hidden = YES;
    
    for (UIScrollView * scrollview in self.viewPeopleTag.subviews)
    {
        if ([scrollview isKindOfClass:[UIScrollView class]])
        {
            [scrollview removeFromSuperview];
        }
    }
    
    UIScrollView * scrollViewTag = [[UIScrollView alloc]initWithFrame:self.viewPeopleTag.frame];
    
    [self.viewPeopleTag addSubview:scrollViewTag];
    
    float xvalue= 5;
    float yvalue = 5;
    UILabel * labelPeople;
    
    
    
    for (int i = 0; i<[selectedValues count]; i++)
    {
       
        NSString *peopleTag = [selectedValues objectAtIndex:i];
        
        CGFloat width = [peopleTag sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17]}].width;
        
        if (xvalue+width+5<=scrollViewTag.frame.size.width)
        {
            
            labelPeople = [[UILabel alloc]initWithFrame:CGRectMake(xvalue, yvalue, width, 25)];
            xvalue = xvalue+width+5;
        }
        else
        {
            
            yvalue = yvalue+30;
            xvalue = 5;
            labelPeople = [[UILabel alloc]initWithFrame:CGRectMake(xvalue, yvalue, width, 25)];
             xvalue = xvalue+ceilf(width)+10;
            
            
        }
        labelPeople.text = [selectedValues objectAtIndex:i];
        
        labelPeople.textAlignment = NSTextAlignmentCenter;
        
        labelPeople.textColor = [UIColor blackColor];
        
        labelPeople.font = [UIFont systemFontOfSize:15];
        
        labelPeople.layer.cornerRadius = 5;
        labelPeople.layer.borderWidth = 1.0f;
        
        labelPeople.layer.borderColor = [UIColor blackColor].CGColor;
        
        [scrollViewTag addSubview:labelPeople];
        
        
        
    }
    
    scrollViewTag .contentSize = CGSizeMake(scrollViewTag.frame.size.width, yvalue+50);
    
    
    
    
    
}


- (void)viewDidUnload
{
    
}

#pragma mark - imageResize

-(UIImage *)imageResize :(UIImage*)img andResizeTo:(CGSize)newSize
{
    CGFloat scale = [[UIScreen mainScreen]scale];
    
    /*You can remove the below comment if you dont want to scale the image in retina   device .Dont forget to comment UIGraphicsBeginImageContextWithOptions*/
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, scale);
    
    [img drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)BroadCastButtonAction:(id)sender
{
    NSMutableDictionary * postDic;
    
    postDic = [[NSMutableDictionary alloc]init];
    NSString * eventId;
    
    if (self.fromAddMedia == YES)
    {
      eventId = [appdelegate.eventDetailsProfile valueForKey:@"eventId"];
        
    }
    else
    {
        
        
        
        NSData * data = [[NSUserDefaults standardUserDefaults]valueForKey:@"eventDeatils"];
        
        NSDictionary * eventsdic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        eventId = [eventsdic valueForKey:@"EventId"];
      
        
    }
    
    [postDic setObject:eventId forKey:@"event_id"];
    
    [postDic setObject:[[NSUserDefaults standardUserDefaults]valueForKey:@"loginId"] forKey:@"user_id"];
    
    if (self.videoPathUrl)
    {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        mediaFile = [documentsDirectory stringByAppendingPathComponent:@"video.mp4"];
        
        [postDic setObject:@"video" forKey:@"media_type"];
        
        [postDic setObject:mediaFile forKey:@"media_file"];
    }
    else
    {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        mediaFile = [documentsDirectory stringByAppendingPathComponent:@"savedImage.png"];
        
        [postDic setObject:mediaFile forKey:@"media_file"];
        
        [postDic setObject:@"photo" forKey:@"media_type"];
    }
    if (eventId)
    {
        [postDic setObject:@"event" forKey:@"category"];
    }
    else
    {
       [postDic setObject:@"profile" forKey:@"category"];
    }
    
    
    
    [postDic setObject:self.textFiledUploadCapation.text forKey:@"post_content"];
    
    [postDic setObject:stringTagId forKey:@"tagged_users"];
    
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@upload_event_media.php",commonURL]];
    
    if (!mediaFile) {
        
        [self alertViewShow:@"Please add photoOrVideo"];
        
    }
    else{
        
        if ([appdelegate connectedToInternet])
        {
            [appdelegate startIndicator];
            [jsonObject postRegisterDetails:postDic withImageORVideoUrl:url];
        }
        else
        {
            [self alertViewShow:@"No internet connection"];
            
        }
        

    }
        postDic = nil;
    

    
    
}
- (IBAction)shareButtonTwitterAction:(id)sender {
    
    
    controller=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    [controller setInitialText:@"MySportsCast"];
    
    [self presentViewController:controller animated:YES completion:nil];

}

- (IBAction)shareButtonFBAction:(id)sender {
    
    controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    
    [controller setInitialText:@"MySportsCast"];
    
    [self presentViewController:controller animated:YES completion:Nil];
    
}

- (IBAction)shareButtonInstagramAction:(id)sender {
    
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
    self.docController = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
    self.docController.delegate = self;
    [self.docController setUTI:@"com.instagram.MySportsCast"];
    
    // [self.dic setAnnotation:@{@"InstagramCaption" : @"https://play.google.com/store/apps/details?id=idreammedia.ramcharanstar&hl=en"}];
    
    self.docController.annotation = [NSDictionary dictionaryWithObject:@"MySportsCast" forKey:@"InstagramCaption"];
    
    
    [self.docController presentOpenInMenuFromRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) inView:self.view animated:YES];
    
    
}

- (UIDocumentInteractionController *) setupControllerWithURL: (NSURL*) fileURL usingDelegate: (id <UIDocumentInteractionControllerDelegate>) interactionDelegate {
    NSLog(@"file url %@",fileURL);
    UIDocumentInteractionController *interactionController = [UIDocumentInteractionController interactionControllerWithURL: fileURL];
    interactionController.delegate = interactionDelegate;
    
    return interactionController;
}

- (IBAction)backButtonClicked:(id)sender {
    
    self.videoPathUrl = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)playButtonAction:(id)sender {
    
    
    PlayerViewController * playerV  =[self.storyboard instantiateViewControllerWithIdentifier:@"PlayerViewController"];
    playerV.videoUrl = self.videoPathUrl;
    

    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:playerV animated:YES];
    
    
}


#pragma mark - UploadVideoORPhotoServer


-(void)didReceiveResponseFromWebService:(NSDictionary *)responseDictionary
{
    
    
    NSLog(@"%@",responseDictionary);
    
    NSString * responceString = [[responseDictionary valueForKey:@"Response"]valueForKey:@"ResponseInfo"];
    
    if ([responceString isEqualToString:@"SUCCESS"])
    {
        
        
        [appdelegate.eventDetailsProfile setObject:@"" forKey:@"eventName"];
        [appdelegate.eventDetailsProfile setObject:@"" forKey:@"eventId"];
        
        dispatch_queue_t getDbSize = dispatch_queue_create("getDbSize", NULL);
        dispatch_queue_t main = dispatch_get_main_queue();
        dispatch_async(getDbSize, ^(void)
                       {
                           dispatch_async(main, ^{
                               [self alertViewShow:@"Uploaded Successfully"];
                           });
                       });
       
        
    }
    
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - DeleteingButtonAction

-(void)deleteEventTag:(UIButton *)button
{
    [appdelegate.eventDetailsProfile setObject:@"" forKey:@"eventName"];
    [appdelegate.eventDetailsProfile setObject:@"" forKey:@"eventId"];
    
    labelEventTag.text = @" Tag an Event";
    
    labelEventTag.textColor = [UIColor lightGrayColor];
    
    labelEventTag.font = [UIFont systemFontOfSize:14];
    
    labelEventTag.frame = CGRectMake(5, 5, self.view.frame.size.width-50, 30);
    
    labelEventTag.layer.borderWidth = 0.0f;
    
   
    
    
    [button removeFromSuperview];
}


#pragma mark - tapGesture

-(void)tapGestureAction
{
    
    EventTagViewController * eventTagVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EventTagViewController"];
    
    [self.navigationController pushViewController:eventTagVC animated:YES];
}

-(void)alertViewShow:(NSString *)alertMessage
{
    
    UIAlertView *globalAlertView = [[UIAlertView alloc]initWithTitle:@"MySportsCast" message:alertMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [globalAlertView show];
    globalAlertView  = nil;
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.message isEqualToString:@"Uploaded Successfully"])
        
    {
        NSArray * arrayViewController = self.navigationController.viewControllers;
        
        
        for (int i = 0; i<[arrayViewController count]; i++)
        {
            
            if (self.fromAddMedia == YES)
            {
                UIViewController * particularView = [arrayViewController objectAtIndex:i];
                
                if ([particularView isKindOfClass:[AddMediaViewController class]])
                {
                    i = (int)arrayViewController.count;
                    [self.navigationController popToViewController:particularView animated:YES];
                 
                }
                else
                {
                    
                }
            }
            else
            {
                UIViewController * particularView = [arrayViewController objectAtIndex:i];
                
                if ([particularView isKindOfClass:[EventDestialsViewController class]])
                {
                    
                    i = (int)arrayViewController.count;
                    [self.navigationController popToViewController:particularView animated:YES];
                    
                    
                    
                }
                else
                {
                    
                }
            }
            
        }
        
        [appdelegate stopIndicators];
    }
}

@end
