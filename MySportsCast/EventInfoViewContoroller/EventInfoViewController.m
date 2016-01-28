//
//  EventInfoViewController.m
//  MySportsCast
//
//  Created by SPARSHMAC08 on 19/08/15.
//  Copyright (c) 2015 SPARSHMAC08. All rights reserved.
//

#import "EventInfoViewController.h"
#import "LoginViewController.h"

@interface EventInfoViewController ()

@end

@implementation EventInfoViewController


#pragma viewContollerDelegate
- (void)viewDidLoad {
    
    self.navigationController.navigationBar.hidden = YES;
    [self createPageViewOnScrollView];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    
    
    
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)createPageViewOnScrollView
{
    float xValue = 0;
    float yValue = 0;
    float width =self.scrollDetail.frame.size.width;
    
    NSArray * arrayLabelMainText =  @[@"Create Event",@"Find Sports Events!",@"Chek in & track your attendance",@"Buy Tickets",@"Broadcast Your Photo Video & Blog Updates"];
    
    NSArray * arrayLabelSubText =  @[@"Create your local sports event so that fans and friends can find it,add highlights,comments or find out whats happening.",@"Find sports events and meet ups in your area or around the world and see the latest fan updates.",@"Check into or create events you are attending and have a track record and photo history of your personal,local,and professional sports events.",@"Buy tickets to professional sporting events.",@"Capture and share what's happening at your sports event in app and with Facebook and Twitter."];
    
    for (int i = 0; i<5; i++)
    {
        @autoreleasepool {
            
            UIView * tempView = [[UIView alloc]initWithFrame:CGRectMake(xValue, yValue, width, self.scrollDetail.frame.size.height)];
            
            tempView.backgroundColor = [UIColor clearColor];
            
            UIImageView * tempImageView = [[UIImageView alloc]initWithFrame:CGRectMake((width/2)-50, 50, 100, 100)];
            
            tempImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"image%d.png",i]];
            
            UILabel * labelMainTitleTemp = [[UILabel alloc]initWithFrame:CGRectMake((width/2)-150, tempImageView.frame.origin.y+ tempImageView.frame.size.height, 300, 40)];
            
            labelMainTitleTemp.font = [UIFont systemFontOfSize:16];
            
            UILabel * labelSubTemp = [[UILabel alloc]initWithFrame:CGRectMake((width/2)-150, labelMainTitleTemp.frame.origin.y+ labelMainTitleTemp.frame.size.height, 300, 50)];
            
            
            labelSubTemp.font = [UIFont systemFontOfSize:12];
            
            labelMainTitleTemp.text = [arrayLabelMainText objectAtIndex:i];
            
            labelSubTemp.text = [arrayLabelSubText objectAtIndex:i];
            
            [self changeLabelProperties:labelMainTitleTemp];
            
            [self changeLabelProperties:labelSubTemp];
            
            xValue = xValue+width;
            
            [self.scrollDetail addSubview:tempView];
            
            [tempView addSubview:tempImageView];
            
            [tempView addSubview:labelMainTitleTemp];
            
            [tempView addSubview:labelSubTemp];
            
        }
    }
    
    self.scrollDetail.contentSize = CGSizeMake(xValue, self.scrollDetail.frame.size.height);
    self.scrollDetail.pagingEnabled = YES;
   
    
}

-(void)changeLabelProperties:(UILabel *)label
{
    [label setNumberOfLines:6];
    [label setTextColor:[UIColor whiteColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
}
#pragma viewControllerButtonActionMethods

- (IBAction)buttonGetStartClicked:(id)sender
{
    
    LoginViewController * loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    
    [self.navigationController pushViewController:loginVC animated:YES];
    
}


#pragma mark - ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint point = scrollView.contentOffset;
    self.pageControll.currentPage = point.x/scrollView.frame.size.width;
}

@end
