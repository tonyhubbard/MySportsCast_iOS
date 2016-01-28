//
//  PlayerViewController.m
//  MySportsCast
//
//  Created by SPARSHMAC08 on 15/09/15.
//  Copyright (c) 2015 SPARSHMAC08. All rights reserved.
//

#import "PlayerViewController.h"
//#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"

@interface PlayerViewController ()
{
    AppDelegate * appdelegate;
}
//@property (nonatomic, retain) AVPlayerViewController *avPlayerViewcontroller;
@end

@implementation PlayerViewController

- (void)viewDidLoad {
    
   
    appdelegate = [UIApplication sharedApplication].delegate;
    
    [super viewDidLoad];
    
    if ([appdelegate connectedToInternet]) {
        
        
        [appdelegate startIndicator];
     
        _videoPlayer =  [[MPMoviePlayerController alloc]
                         initWithContentURL:self.videoUrl];
       
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(MPMoviePlayerPlaybackStateDidChange:)
                                                     name:MPMoviePlayerPlaybackStateDidChangeNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(doneButtonClick:)
                                                     name:MPMoviePlayerWillExitFullscreenNotification
                                                   object:nil];
        
        // Set control style tp default
        _videoPlayer.controlStyle = MPMovieControlStyleDefault;
        
        _videoPlayer.view.frame = self.view.frame;
        
        // Set shouldAutoplay to YES
        _videoPlayer.shouldAutoplay = YES;
        
        // Add _videoPlayer's view as subview to current view.
        [self.view addSubview:_videoPlayer.view];
        
        // Set the screen to full.
        [_videoPlayer setFullscreen:YES animated:YES];
        [_videoPlayer play];

    }
    else
    {
        [self showAlertView:@"Check internet Connection"];
    }
 
    
   
    // Do any additional setup after loading the view.

    
    
    
}



- (void)MPMoviePlayerPlaybackStateDidChange:(NSNotification *)notification
{
    
    

    if (_videoPlayer.loadState == MPMovieLoadStatePlayable) {
        NSLog(@"loadState... MPMovieLoadStatePlayable");
         [appdelegate stopIndicators];
    }
    
    if (_videoPlayer.loadState == MPMovieLoadStatePlaythroughOK) {
        NSLog(@"loadState... MPMovieLoadStatePlaythroughOK");
    }
    
    if (_videoPlayer.loadState == MPMovieLoadStateStalled) {
        NSLog(@"loadState... MPMovieLoadStateStalled");
    }
    
    if (_videoPlayer.loadState == MPMovieLoadStateUnknown) {
        NSLog(@"loadState... MPMovieLoadStateUnknown");
        [appdelegate stopIndicators];
        [_videoPlayer prepareToPlay];
    }
    if (_videoPlayer.loadState == MPMovieFinishReasonPlaybackError) {
        
    }
    
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void) moviePlayBackDidFinish:(NSNotification*)notification
//{
//    
//    if ([videoplayer
//         respondsToSelector:@selector(setFullscreen:animated:)])
//    {
////        [videoplayer.view removeFromSuperview];
//        // remove the video player from superview.
//    }
//    
//    [self.navigationController popViewControllerAnimated:YES];
//}

-(void)doneButtonClick:(NSNotification*)aNotification{
    NSNumber *reason = [aNotification.userInfo objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    
    if ([reason intValue] == MPMovieFinishReasonUserExited)
    {
        // Your done button action here
      
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:_videoPlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerWillExitFullscreenNotification object:nil];
    [_videoPlayer.view removeFromSuperview];
    _videoPlayer = nil;
    [self.navigationController popViewControllerAnimated:YES];
   

}


-(void)showAlertView:(NSString *)discripation
{
    UIAlertView *globalAlertView = [[UIAlertView alloc]initWithTitle:@"MySportsCast" message:discripation delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [globalAlertView show];
    globalAlertView  = nil;
   

    
}




@end
