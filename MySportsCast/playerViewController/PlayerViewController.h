//
//  PlayerViewController.h
//  MySportsCast
//
//  Created by SPARSHMAC08 on 15/09/15.
//  Copyright (c) 2015 SPARSHMAC08. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
@interface PlayerViewController : UIViewController

@property (strong,nonatomic)NSURL * videoUrl;
@property (strong, nonatomic) MPMoviePlayerController *videoPlayer;
@end
