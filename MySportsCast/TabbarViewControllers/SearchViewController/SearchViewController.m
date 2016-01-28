//
//  SearchViewController.m
//  MySportsCast
//
//  Created by SPARSHMAC08 on 24/08/15.
//  Copyright (c) 2015 SPARSHMAC08. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchCollectionCell.h"
#import "JsonClass.h"
#import "AppDelegate.h"
#import "EventDestialsViewController.h"
#import "profileViewController.h"
#import "UIImageView+WebCache.h"
#import "Constants.h"

@interface SearchViewController ()<WebServiceProtocol>
{
    CGSize screenSize;
    BOOL isEventButtonCliceked;
    JsonClass * jsonObj;
    AppDelegate * appDelegate;
    NSMutableArray * resultArray;
    NSString * userId;
}
@end

@implementation SearchViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    appDelegate =[UIApplication sharedApplication].delegate;
    jsonObj = [[JsonClass alloc]init];
    jsonObj.delegate = self;
    resultArray = [[NSMutableArray alloc]init];
    screenSize = [[UIScreen mainScreen]bounds].size;
    self.textFiledSearch.layer.cornerRadius = 15;
    self.textFiledSearch.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textFiledSearch.layer.borderWidth = 1.0f;
    eventButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 1, screenSize.width/2, 40)];
    peopleButton = [[UIButton alloc]initWithFrame:CGRectMake(eventButton.frame.size.width, 1, screenSize.width/2, 40)];
    singleLineView = [[UIView alloc]initWithFrame:CGRectMake(0, eventButton.frame.origin.y+41, screenSize.width/2, 2)];
    
    [self.viewButtonBackGround addSubview:eventButton];
    [self.viewButtonBackGround addSubview:peopleButton];
    [self.viewButtonBackGround addSubview:singleLineView];
    
    [eventButton setTitle:@"EVENTS" forState:UIControlStateNormal];
    
    [peopleButton setTitle:@"PEOPLE" forState:UIControlStateNormal];
    
    singleLineView.backgroundColor = [UIColor colorWithRed:60.0f/255.0f green:142.0f/255.0f blue:249.0f/255.0f alpha:1];
    
    [eventButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [peopleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [eventButton addTarget:self action:@selector(eventButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [peopleButton addTarget:self action:@selector(peopleButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self shadowEffectForView:self.viewButtonBackGround];
    
     userId = [[NSUserDefaults standardUserDefaults]valueForKey:@"loginId"];
    
    isEventButtonCliceked = YES;
    
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated{
    
    [appDelegate startIndicator];
    if ([appDelegate connectedToInternet])
    {
        if (isEventButtonCliceked == YES) {
           [jsonObj getMethodforServiceRequest:[NSString stringWithFormat:@"%@default_search_people_event_info.php?user_id=%@&search_flag=event&page_id=0",commonURL,userId]];
        }
        else{
           [jsonObj getMethodforServiceRequest:[NSString stringWithFormat:@"%@default_search_people_event_info.php?user_id=%@&search_flag=people&page_id=0",commonURL,userId]];
        }
        
    }
    else{
        
        [self alertViewShow:@"Check internet Connetion"];
        
    }
    
    
    
}

- (void)didReceiveMemoryWarning
{
    
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    [imageCache clearMemory];
    [imageCache clearDisk];
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - ShowAlertView

-(void)alertViewShow:(NSString *)alertMessage
{
    UIAlertView *globalAlertView = [[UIAlertView alloc]initWithTitle:@"MySportsCast" message:alertMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [globalAlertView show];
    globalAlertView  = nil;
    [appDelegate stopIndicators];

}
#pragma mark - viewControllerButtonAction
-(void)eventButtonClicked
{
    isEventButtonCliceked = YES;
    
    [appDelegate startIndicator];
    if ([appDelegate connectedToInternet])
    {
        [jsonObj getMethodforServiceRequest:[NSString stringWithFormat:@"%@default_search_people_event_info.php?user_id=205&search_flag=event&page_id=0",commonURL]];
    }
    else{
        [self alertViewShow:@"Check internet Connetion"];
        
    }

    
    [UIView animateWithDuration:0.2 animations:^{
        singleLineView.frame = CGRectMake(0, eventButton.frame.origin.y+41, screenSize.width/2, 2);
        eventButton.alpha = 1;
        peopleButton.alpha = 0.3;
    }];
    [self.collectionVIewSearchData reloadData];
}
-(void)peopleButtonClicked
{
    isEventButtonCliceked = NO;
    
    [appDelegate startIndicator];
    if ([appDelegate connectedToInternet])
    {
         [jsonObj getMethodforServiceRequest:[NSString stringWithFormat:@"%@default_search_people_event_info.php?user_id=%@&search_flag=people&page_id=0",commonURL,userId]];
    }
    else{
        [self alertViewShow:@"Check internet Connetion"];
        
    }

    [UIView animateWithDuration:0.2 animations:^{
        singleLineView.frame = CGRectMake(screenSize.width/2, eventButton.frame.origin.y+41, screenSize.width/2, 2);
        eventButton.alpha = 0.3;
        peopleButton.alpha = 1;
    }];
    [self.collectionVIewSearchData reloadData];
   
}


- (IBAction)SearchButtonClicked:(id)sender {
  

    if (isEventButtonCliceked == YES) {
        
        [appDelegate startIndicator];
        if ([appDelegate connectedToInternet])
        {
            if ([self.textFiledSearch.text isEqualToString:@""])
            {
               [self alertViewShow:@"please Enter Search Text"];
               [appDelegate stopIndicators];
            }
            else{
                
                [jsonObj getMethodforServiceRequest:[NSString stringWithFormat:@"%@search_people_event_info.php?search_title=%@&search_flag=event",commonURL,self.textFiledSearch.text]];
            }
            
        }
        else{
            
            [self alertViewShow:@"Check internet Connetion"];
        }
 
    }
    else{
        [appDelegate startIndicator];
        if ([appDelegate connectedToInternet])
        {
            if ([self.textFiledSearch.text isEqualToString:@""])
            {
                [self alertViewShow:@"please Enter Search Text"];
                [appDelegate stopIndicators];
            }
            else{
                
                [jsonObj getMethodforServiceRequest:[NSString stringWithFormat:@"%@search_people_event_info.php?search_title=%@&search_flag=people",commonURL,self.textFiledSearch.text]];
            }
            
        }
        else{
            [self alertViewShow:@"Check internet Connetion"];
            
        }
    }
    
    
    
    
//  http://182.75.34.62/MySportsShare/web_services/search_people_event_info.php?search_title=a&search_flag=people
    
    
    
}

#pragma mark - ServiceResponceDelegate

-(void)didReceiveResponseFromWebService:(NSDictionary *)responseDictionary
{
    if ([[[responseDictionary valueForKey:@"Response"]valueForKey:@"ResponseInfo"] isEqualToString:@"SUCCESS"])
    {
        
        
        resultArray = [[[responseDictionary valueForKey:@"Response"]valueForKey:@"search_list"]mutableCopy];
    }
    else{
        
        [resultArray removeAllObjects];
        [self alertViewShow:@"No Records"];
    }
    [self.collectionVIewSearchData reloadData];
    [appDelegate stopIndicators];
}


#pragma mark - shadowEffectToView

-(void)shadowEffectForView:(UIView*)view
{
    UIColor *color=[UIColor blackColor];
    view.layer.shadowColor=[color CGColor];
    view.layer.shadowOpacity = 1;
    view.layer.shadowRadius = 2;
    view.layer.shadowOffset = CGSizeMake(1,1);
    view.layer.masksToBounds = false;
    
}

#pragma mark - CollectionViewDelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [resultArray count];
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    SearchCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    
//        [cell.imageViewEvent loagImageFromURL:[[resultArray objectAtIndex:indexPath.row]valueForKey:@"image"]];
    
//    [cell.imageViewEvent setImageWithURL:[[resultArray objectAtIndex:indexPath.row]valueForKey:@"image"]];
    
    [cell.imageViewEvent sd_setImageWithURL:[[resultArray objectAtIndex:indexPath.row]valueForKey:@"image"] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
    
    [self cropimageView:cell.imageViewEvent];
    
        cell.labelEventName.text = [[resultArray objectAtIndex:indexPath.row]valueForKey:@"name"];
        cell.labelEventName.numberOfLines = 2;
        cell.labelEventName.font = [UIFont systemFontOfSize:14];
   
        return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (isEventButtonCliceked == YES)
    {
        EventDestialsViewController* eventDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EventDestialsViewController"];
        
        eventDetailVC.selectedEventType=@"";
        eventDetailVC.eventId = [[resultArray objectAtIndex:indexPath.row]valueForKey:@"id"];
        
        eventDetailVC.eventCreatedId = [[resultArray objectAtIndex:indexPath.row]valueForKey:@"event_creator_id"];
        
        
        [self.navigationController pushViewController:eventDetailVC animated:YES];
    }
    else
    {
        appDelegate.profileSelectedUserId = [[resultArray objectAtIndex:indexPath.row]valueForKey:@"id"];
        
        appDelegate.profileViewNavAccount = appDelegate.profileViewNavAccount+2;
        
        
        profileViewController * profileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"profileViewController"];
        appDelegate.isfromSearchScreen = YES;
        profileVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:profileVC animated:YES];
        
        
    }
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (screenSize.width == 768)
    {
        return CGSizeMake((screenSize.width/3)-10, (screenSize.width/3)-5);
    }
    else{
        return CGSizeMake((screenSize.width/2)-8,(screenSize.width/2)-5);
    }
    
}

#pragma textFiledDelegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)cropimageView:(UIImageView*)imageView
{
    imageView.layer.contents = (__bridge id)(imageView.image.CGImage);
    imageView.layer.contentsGravity = kCAGravityResizeAspectFill;
    imageView.layer.contentsScale = imageView.image.scale;
    imageView.layer.masksToBounds = YES;
    
}


@end
