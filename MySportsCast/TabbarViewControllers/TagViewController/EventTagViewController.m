//
//  EventTagViewController.m
//  MySportsCast
//
//  Created by Vardhan on 23/09/15.
//  Copyright © 2015 SPARSHMAC08. All rights reserved.
//

#import "EventTagViewController.h"
#import "UIImageView+WebCache.h"
#import "EventTagCell.h"
#import "AppDelegate.h"
#import "JsonClass.h"
#import "Constants.h"

@interface EventTagViewController ()<WebServiceProtocol>
{
    JsonClass * jsonObj;
    AppDelegate * appDelegate;
    NSString * userId;
    NSMutableArray * resultArray;
    CGSize screenSize;
    NSInteger pageIndex;
    NSString * searchString;
    BOOL isSearching;
}
@end

@implementation EventTagViewController

- (void)viewDidLoad {
    
    userId = [[NSString alloc]init];
    
    searchString = [[NSString alloc]init];
    
    userId = [[NSUserDefaults standardUserDefaults]valueForKey:@"loginId"];
    
    appDelegate =[UIApplication sharedApplication].delegate;
    
    
    
    jsonObj = [[JsonClass alloc]init];
    
    screenSize = [[UIScreen mainScreen]bounds].size;
    
    jsonObj.delegate = self;
    
    
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
    
    resultArray = [[NSMutableArray alloc]init];
    pageIndex = 0;
    
    [appDelegate startIndicator];
    
    if ([appDelegate connectedToInternet])
    {
        NSData * locationData =[[NSUserDefaults standardUserDefaults]valueForKey:@"userLocation"];
        // forKey:@"userLocation"];
        NSDictionary * locationDic = [NSKeyedUnarchiver unarchiveObjectWithData:locationData];
        
        [jsonObj getMethodforServiceRequest:[NSString stringWithFormat:@"%@get_user_checkin_events.php?user_id=%@&user_lat=%@&user_lng=%@&page_id=%ld&filter= none&search=",commonURL,userId,[locationDic valueForKey:@"lat"],[locationDic valueForKey:@"lng"],(long)pageIndex]];
    }
    else
    {
        [self alertView:@"Check internet Connetion"];
    }
    
    
    
}
-(void)alertView:(NSString *)discripation
{
    
    UIAlertView *globalAlertView = [[UIAlertView alloc]initWithTitle:@"MySportsCast" message:discripation delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
     [globalAlertView show];
     globalAlertView  = nil;
     [appDelegate stopIndicators];
    
}


- (IBAction)backButtonClicked:(id)sender

{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - ServiceResponceDelegate

-(void)didReceiveResponseFromWebService:(NSDictionary *)responseDictionary
{
    if ([[[responseDictionary valueForKey:@"Response"]valueForKey:@"ResponseInfo"] isEqualToString:@"SUCCESS"])
    {
        
        id responce = [[responseDictionary valueForKey:@"Response"]valueForKey:@"events_list"];
        
        if ([responce isKindOfClass:[NSArray class]])
        {
            
            if (isSearching == YES)
            {
                isSearching = NO;
                [resultArray removeAllObjects];
                for (int i = 0; i<[responce count]; i++)
                {
                    [resultArray addObject:[responce objectAtIndex:i]];
                }
            }
            else
            {
                for (int i = 0; i<[responce count]; i++)
                {
                    [resultArray addObject:[responce objectAtIndex:i]];
                }
            }
            
        }
        else
        {
//            [self alertView:@"No Event Found"];
        }
        
        
    }
    else
    {
        //[self alertView:@"No Records"];
    }
    
    [self.collectionViewSearch reloadData];
    
    [appDelegate stopIndicators];
    
    
}

#pragma mark - CollectionViewDelegates

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [resultArray count];
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    EventTagCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    id imageUrl = [[resultArray objectAtIndex:indexPath.row]valueForKey:@"event_image"];
    
    if ([imageUrl isKindOfClass:[NSNull class]])
    {
       
    }
    else
    {

        
        [cell.imageViewEvent sd_setImageWithURL:[[resultArray objectAtIndex:indexPath.row]valueForKey:@"event_image"]];
        
        
    }
    
    cell.labelEventName.text = [[resultArray objectAtIndex:indexPath.row]valueForKey:@"event_title"];
    cell.labelEventName.numberOfLines = 2;
    cell.labelEventName.font = [UIFont systemFontOfSize:14];
    
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString * eventname = [[resultArray objectAtIndex:indexPath.row]valueForKey:@"event_title"];
    NSString * evetnId = [[resultArray objectAtIndex:indexPath.row]valueForKey:@"event_id"];
    [appDelegate.eventDetailsProfile setObject:eventname forKey:@"eventName"];
    [appDelegate.eventDetailsProfile setObject:evetnId forKey:@"eventId"];
    [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark - TextFiledDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    [resultArray removeAllObjects];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    isSearching = YES;
    NSString * stringToRange = [textField.text substringWithRange:NSMakeRange(0,range.location)];
    
    // Appending the currently typed charactor
    stringToRange = [stringToRange stringByAppendingString:string];
    
    // Processing the last typed word
    NSArray *wordArray       = [stringToRange componentsSeparatedByString:@" "];
    NSString * wordTyped     = [wordArray lastObject];
    
    searchString = wordTyped;
    NSLog(@"SearchString:%@",searchString);
   
    
    [appDelegate startIndicator];
    
    if ([appDelegate connectedToInternet])
    {
        if ([self.textFiledSearch.text isEqualToString:@""])
        {
            
            [appDelegate stopIndicators];
        }
        else
        {
//            http://182.75.34.62/MySportsShare/web_services/get_user_checkin_events.php?user_id=298&user_lat=43.59685959999999&user_lng=3.8502617000000328&page_id=0&filter=%20none&search=sep
            
            NSData * locationData =[[NSUserDefaults standardUserDefaults]valueForKey:@"userLocation"];
            // forKey:@"userLocation"];
            NSDictionary * locationDic = [NSKeyedUnarchiver unarchiveObjectWithData:locationData];
            
            
            
            [jsonObj getMethodforServiceRequest:[NSString stringWithFormat:@"%@get_user_checkin_events.php?user_id=%@&user_lat=%@&user_lng=%@&page_id=%ld&filter= none&search=%@",commonURL,userId,[locationDic valueForKey:@"lat"],[locationDic valueForKey:@"lng"],(long)pageIndex,wordTyped]];
        }
       
        
    }
    else{
        
        [self alertView:@"Check internet Connetion"];
    }
    
    return YES;
}



- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView

{
    
    
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    
    CGFloat maxcontentOffSet = scrollView.contentSize.height - scrollView.frame.size.height;
    
    if ((maxcontentOffSet-contentOffsetY)<=50)
        
    {
        
        pageIndex = pageIndex+1;
        
        NSData * locationData =[[NSUserDefaults standardUserDefaults]valueForKey:@"userLocation"];
        // forKey:@"userLocation"];
        NSDictionary * locationDic = [NSKeyedUnarchiver unarchiveObjectWithData:locationData];
        if ([appDelegate connectedToInternet])
        {
            
        [appDelegate startIndicator];
        [jsonObj getMethodforServiceRequest:[NSString stringWithFormat:@"%@get_user_checkin_events.php?user_id=%@&user_lat=%@&user_lng=%@&page_id=%ld&filter= none&search=%@",commonURL,userId,[locationDic valueForKey:@"lat"],[locationDic valueForKey:@"lng"],(long)pageIndex,searchString]];
        }
       
        
    }
    
}




@end
