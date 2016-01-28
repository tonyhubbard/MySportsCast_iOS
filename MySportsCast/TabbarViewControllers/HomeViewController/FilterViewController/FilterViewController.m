
//
//  FilterViewController.m
//  MySportsCast
//
//  Created by SPARSHMAC08 on 24/08/15.
//  Copyright (c) 2015 SPARSHMAC08. All rights reserved.
//

#import "FilterViewController.h"
#import "AppDelegate.h"
#import "LocationCell.h"
#import "DateCell.h"
#import "sportsCell.h"
#import "AppDelegate.h"
#import "JsonClass.h"
#import "Constants.h"



@interface FilterViewController ()<WebServiceProtocol>
{
    NSIndexPath * particularCellIndex;
    NSMutableArray * arrayImageChange;
    NSMutableArray * arrayButtonItems;
    JsonClass * jsonObj;
    AppDelegate * appDelegate;
    NSMutableArray * resultArray;
    UITableView * searchTableView;
    BOOL isSearchLocation;
    NSArray * arrayPlaceResult;
    UIView * viewBlackLayer;
    NSMutableDictionary * filterDic;
    UIButton * restButton;
    UIButton * applyButton;
    UIButton * buttonSelectAllButton;
    NSString * currentDate;
    NSString * fromDate;
    NSString * toDate;
    UIDatePicker *picker;
    NSString * selectedDate;
    BOOL isClickedFromDate;
    NSMutableArray * sportsIdArray;
    NSMutableArray * selectedSportsId;
    NSString * locationName;
}

@end

@implementation FilterViewController
#pragma mark - ViewControllerDelegate


-(void)viewDidLoad
{
    filterDic = [[NSMutableDictionary alloc]init];
    self.navigationController.navigationBar.hidden = YES;
    appDelegate = [UIApplication sharedApplication].delegate;
    arrayImageChange = [[NSMutableArray alloc]init];
    arrayButtonItems = [[NSMutableArray alloc]init];
    resultArray = [[NSMutableArray alloc]init];
    arrayPlaceResult = [[NSArray alloc]init];
    jsonObj =[[JsonClass alloc]init];
    jsonObj.delegate =self;
    currentDate = [[NSString alloc]init];
    selectedDate = [[NSString alloc]init];
    fromDate = [[NSString alloc]init];
    toDate = [[NSString alloc]init];
    sportsIdArray = [[NSMutableArray alloc]init];
    selectedSportsId = [[[NSMutableArray alloc]init]mutableCopy];
    
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger day = [components day];
    NSInteger week = [components month];
    NSInteger year = [components year];
    
    fromDate = [NSString stringWithFormat:@"%ld/%ld/%ld", (long)week,(long)day, (long)year];
    toDate = [NSString stringWithFormat:@"%ld/%ld/%ld", (long)week,(long)day,  (long)year];
    
    NSData * data = [[NSUserDefaults standardUserDefaults]valueForKey:@"filterValues"];
    
    
    
    if (self.isFromCalendarEvent == YES)
    {
    
       [self filterDefaultVlues];
        
    }
    else{
        
        
        if (data) {
            
            filterDic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            fromDate = [filterDic valueForKey:@"fromDate"];
            toDate = [filterDic valueForKey:@"toDate"];
            selectedSportsId = [filterDic valueForKey:@"sportsId"];
        }
        
        else{
            [self filterDefaultVlues];
        }
        
        
        
    }
    restButton = [[UIButton alloc]init];
    applyButton = [[UIButton alloc]init];
    restButton.frame = CGRectMake(10, 5, (self.view.frame.size.width/2)-20, 40);
    applyButton.frame = CGRectMake(CGRectGetMaxX(restButton.frame)+10, 5, (self.view.frame.size.width/2)-10, 40);
    
    [restButton setTitle:@"RESET" forState:UIControlStateNormal];
    [applyButton setTitle:@"APPLY" forState:UIControlStateNormal];
    [restButton setBackgroundImage:[UIImage imageNamed:@"bg1.png"] forState:UIControlStateNormal];
    [applyButton setBackgroundImage:[UIImage imageNamed:@"bg1.png"] forState:UIControlStateNormal];
    [applyButton addTarget:self action:@selector(applyButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [restButton addTarget:self action:@selector(restButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.footerView addSubview:restButton];
    [self.footerView addSubview:applyButton];
   
}
-(void)filterDefaultVlues{
    
    NSData * locationData =[[NSUserDefaults standardUserDefaults]valueForKey:@"userLocation"];
    // forKey:@"userLocation"];
    NSDictionary * locationDic = [NSKeyedUnarchiver unarchiveObjectWithData:locationData];
    
    NSArray * locationLatAndLan = @[locationDic];
    NSString * isSelectAll = @"YES";
    NSArray * rangeArray = @[@"10",@"50",@"100",@"200",@"All"];
    [filterDic setObject:rangeArray forKey:@"range"];
    [filterDic setObject:isSelectAll forKey:@"SportTypeSelection"];
    [filterDic setObject:locationLatAndLan forKey:@"location"];
    NSString * selectedRanage = @"all";
    [filterDic setObject:selectedRanage forKey:@"selectedRange"];
    NSString * dateButtonSelection = @"YES";
    
    [filterDic setObject:dateButtonSelection forKey:@"dateSelection"];
    [filterDic setObject:fromDate forKey:@"fromDate"];
    [filterDic setObject:toDate forKey:@"toDate"];
    NSArray * sportsId = @[@"0"];
    [filterDic setObject:sportsId forKey:@"sportsId"];
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:filterDic];
    [[NSUserDefaults standardUserDefaults]setObject:data forKey:@"filterValues"];
    
}



-(void)viewDidAppear:(BOOL)animated
{
    
    
//    http://182.75.34.62/MySportsShare/web_services/get_sports_list.php
    
    [appDelegate startIndicator];
    
    if ([appDelegate connectedToInternet])
    {
        
        
        [jsonObj getMethodforServiceRequest:[NSString stringWithFormat:@"%@get_sports_list.php",commonURL]];
        
        
        
    }
    else{
        
        [self alertViewShow:@"Please check internet Connection"];
    }
    
    
    
}

- (IBAction)backButtonClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)alertViewShow:(NSString *)alertMessage
{
    UIAlertView *globalAlertView = [[UIAlertView alloc]initWithTitle:@"MySportsCast" message:alertMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [globalAlertView show];
    globalAlertView  = nil;
    [appDelegate stopIndicators];
    
}

#pragma mark - ServiceResponceDelegate

-(void)didReceiveResponseFromWebService:(NSDictionary *)responseDictionary
{
    if ([[[responseDictionary valueForKey:@"Response"]valueForKey:@"ResponseInfo"] isEqualToString:@"SUCCESS"])
    {
      NSMutableDictionary * tempDic;
      
      NSMutableArray * TempSportsType = [[NSMutableArray alloc]init];
      resultArray = [[responseDictionary valueForKey:@"Response"]valueForKey:@"sprots_list"];
      NSArray * sportsArray = [[NSArray alloc]init];
      sportsArray = [filterDic valueForKey:@"sportType"];
      
   
        if (resultArray.count == sportsArray.count)
        {
          
        }
        else
        {
          for (int i = 0; i<[resultArray count]; i++)
            {
                tempDic = [[NSMutableDictionary alloc]init];
               
                NSString * sportsId = [[resultArray objectAtIndex:i]valueForKey:@"sport_id"];
                [sportsIdArray addObject:sportsId];
                NSString * sportsType = [[resultArray objectAtIndex:i]valueForKey:@"sport_name"];
                [tempDic setObject:@"1" forKey:sportsType];
                [TempSportsType addObject:tempDic];
        }
                    [filterDic setObject:TempSportsType forKey:@"sportType"];
                    [filterDic setObject:sportsIdArray forKey:@"sportsId"];
    }
        TempSportsType = nil;
}
    else
      {
        
         [resultArray removeAllObjects];
          [self alertViewShow:@"No Records"];
      }
   
    [tableViewFilter reloadData];
    
    [appDelegate stopIndicators];
}


#pragma mark - TableViewdelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == searchTableView) {
        return 1;
    }
    else
    {
        if (self.isFromCalendarEvent == YES) {
            return 2;
        }
        else{
          return 3;
        }
        
    }
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == searchTableView)
    {
        return [arrayPlaceResult count];
       
    }
    else{
        
        if (self.isFromCalendarEvent == YES) {
            if (section == 0)
            {
                return 1;
            }
            else{
                return [resultArray count];
            }
            
            
        }
        else{
            if (section == 0)
            {
                return 1;
            }
            else if(section == 1)
            {
                return 1;
            }
            
            return [resultArray count];
        }
       
    }
}
    
  



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == searchTableView)
    {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }

        cell.textLabel.text = [[arrayPlaceResult objectAtIndex:indexPath.row]valueForKey:@"description"];
        cell.textLabel.numberOfLines = 2;
        cell.textLabel.textColor = [UIColor blackColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        if (indexPath.section == 0)
        {
            
            LocationCell  *cell = (LocationCell *)[tableView dequeueReusableCellWithIdentifier:@"LocationCell"];
            for (UIImageView * imageView in cell.viewMiles.subviews)
            {
                if ([imageView isKindOfClass:[UIImageView class]])
                {
                    [imageView removeFromSuperview];
                }
            }
            for (UIButton * button in cell.viewMiles.subviews)
            {
                if ([button isKindOfClass:[UIButton class]])
                {
                    [button removeFromSuperview];
                }
            }
            
            for (UILabel * label in cell.viewMiles.subviews)
            {
                if ([label isKindOfClass:[UILabel class]])
                {
                    [label removeFromSuperview];
                }
            }
            
            NSArray * array = @[@"10",@"50",@"100",@"200",@"All"];
            float xvalue = 2;
            float width = (self.view.frame.size.width/5)-30;
            [arrayImageChange removeAllObjects];
            [arrayButtonItems removeAllObjects];
            NSArray * offlineArray = [filterDic valueForKey:@"range"];
            
            cell.textFiledLocatioSearch.text = [filterDic valueForKey:@"locationName"];
           
            for (int i = 0; i<5; i++)
            {
                NSString * rangeString = [offlineArray objectAtIndex:i];
                UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(xvalue, 15, width, 15)];
                UIButton * buttonMiles = [[UIButton alloc]initWithFrame:CGRectMake(imageView.frame.origin.x+width, 10, 25, 25)];
                
                [buttonMiles addTarget:self action:@selector(milesButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                
                UILabel * labelName = [[UILabel alloc]initWithFrame:CGRectMake(buttonMiles.frame.origin.x-10, CGRectGetMaxY(buttonMiles.frame), width, 20)];
                
                if (i == 3)
                {
                   labelName.text =[NSString stringWithFormat:@"%@",[array objectAtIndex:i]];
                }
                else{
                    labelName.text =[array objectAtIndex:i];
                    
                }
                labelName.font = [UIFont systemFontOfSize:14];
                labelName.textAlignment = NSTextAlignmentCenter;
                if ([rangeString isEqualToString:[array objectAtIndex:i]])
                {
                    imageView.image = [UIImage imageNamed:@"distance-bar1-a.png"];
                    [buttonMiles setImage:[UIImage imageNamed:@"1.png"] forState:UIControlStateNormal];
                }
                else{
                    imageView.image = [UIImage imageNamed:@"distance-bar.png"];
                    [buttonMiles setImage:[UIImage imageNamed:@"2.png"] forState:UIControlStateNormal];
                }
                xvalue = xvalue+width+25;
                buttonMiles.tag = i;
                [cell.viewMiles addSubview:imageView];
                [cell.viewMiles addSubview:buttonMiles];
                [cell.viewMiles addSubview:labelName];
                [arrayImageChange addObject:imageView];
                [arrayButtonItems addObject:buttonMiles];
                
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
        if (self.isFromCalendarEvent == YES) {
            sportsCell* cell = [tableView dequeueReusableCellWithIdentifier:@"sportsCell"];
            if (cell == nil)
            {
                cell = [[sportsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sportsCell"];
            }
            
            cell.labelSportName.text = [[resultArray objectAtIndex:indexPath.row]valueForKey:@"sport_name"];
            
            NSString * StatusString = [[resultArray objectAtIndex:indexPath.row]valueForKey:@"sport_name"];
            
            NSArray * categoryArray = [filterDic valueForKey:@"sportType"];
            
            if ([[[categoryArray objectAtIndex:indexPath.row]valueForKey:StatusString] isEqual:@"1"]) {
                
                cell.imageViewSelectIndicate.image = [UIImage imageNamed:@"4.png"];
                
            }
            else{
                cell.imageViewSelectIndicate.image = [UIImage imageNamed:@"2.png"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else{
            
             if (indexPath.section == 1)
            {
                DateCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DateCell"];
                if (cell == nil)
                {
                    cell = [[DateCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DateCell"];
                }
                [cell.buttonDateselectAll addTarget:self action:@selector(DateAllSectionButton:) forControlEvents:UIControlEventTouchUpInside];
                [cell.buttonFromDate addTarget:self action:@selector(fromButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell.buttonToDate addTarget:self action:@selector(toButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                NSString * isSelection =[filterDic objectForKey:@"dateSelection"];
                if ([isSelection isEqualToString:@"YES"]) {
                    
                    [cell.buttonDateselectAll setImage:[UIImage imageNamed:@"4.png"] forState:UIControlStateNormal];
                    [cell.buttonFromDate setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                    [cell.buttonToDate setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                    [cell.buttonToDate setUserInteractionEnabled:NO];
                    [cell.buttonFromDate setUserInteractionEnabled:NO];
                }
                else
                {
                    [cell.buttonDateselectAll setImage:[UIImage imageNamed:@"2.png"] forState:UIControlStateNormal];
                    [cell.buttonFromDate setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [cell.buttonToDate setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [cell.buttonToDate setUserInteractionEnabled:YES];
                    [cell.buttonFromDate setUserInteractionEnabled:YES];
                }
                particularCellIndex = indexPath;
                
                [cell.buttonFromDate setTitle:fromDate forState:UIControlStateNormal];
                [cell.buttonToDate setTitle:toDate forState:UIControlStateNormal];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
                
            }
             else
             {
                 sportsCell* cell = [tableView dequeueReusableCellWithIdentifier:@"sportsCell"];
                 if (cell == nil)
                 {
                     cell = [[sportsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sportsCell"];
                 }
                 
                 cell.labelSportName.text = [[resultArray objectAtIndex:indexPath.row]valueForKey:@"sport_name"];
                 
                 NSString * StatusString = [[resultArray objectAtIndex:indexPath.row]valueForKey:@"sport_name"];
                 
                 NSArray * categoryArray = [filterDic valueForKey:@"sportType"];
                 
                 if ([[[categoryArray objectAtIndex:indexPath.row]valueForKey:StatusString] isEqual:@"1"]) {
                     
                     cell.imageViewSelectIndicate.image = [UIImage imageNamed:@"4.png"];
                     
                 }
                 else{
                     cell.imageViewSelectIndicate.image = [UIImage imageNamed:@"2.png"];
                 }
                 cell.selectionStyle = UITableViewCellSelectionStyleNone;
                 return cell;
             }
  
            
        }
        
    }
  
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == searchTableView) {
        return 44;
    }
    else
    {
        
        if (self.isFromCalendarEvent == YES) {
            if (indexPath.section ==0)
            {
                return 188;
            }
            
            else
            {
                return 44;
            }
           
        }
        else{
            if (indexPath.section ==0)
            {
                return 188;
            }
            
            else if(indexPath.section == 1)
            {
                return 108;
            }
            else{
                return 44;
            }
        }
      
    }
   
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (tableView == searchTableView) {
        return 0;
    }
    else{
        
        if (self.isFromCalendarEvent == YES) {
            if (section==0)
            {
                return 0;
            }
            
            else{
                return 50;
            }
        }
        
        else{
            if (section==0)
            {
                return 0;
            }
            else if (section ==1)
            {
                return 0;
            }
            else{
                return 50;
            }
        }
        
        

     }
   }

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    
    if (self.isFromCalendarEvent == YES) {
        if (section == 1) {
            
            return [self headerViewCreation];
        }
        else{
            return nil;
        }
    }
    else{
        if (section==2)
        {
           return [self headerViewCreation];
            
        }
        else{
            return nil;
        }
    }
   
    
}


-(UIView *)headerViewCreation
{
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    
    headerView.backgroundColor = [UIColor clearColor];
    
    UIView * tempView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 47)];
    tempView.backgroundColor = [UIColor whiteColor];
    UILabel * labelSport = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
    
    labelSport.text = @"Sports Type";
    
    labelSport.textColor = [UIColor colorWithRed:255.0f/255.0f green:165.0f/255.0f blue:0.0f/255.0f alpha:1];
    
    buttonSelectAllButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-40, 5, 30, 30)];
    
    UILabel * labelAll = [[UILabel alloc]initWithFrame:CGRectMake(buttonSelectAllButton.frame.origin.x-20, 0, 50, 44)];
    labelAll.text = @"All";
    
    labelAll.textColor =[UIColor blackColor];
    UIView * singleLineView = [[UIView alloc]initWithFrame:CGRectMake(0, labelSport.frame.size.height+2, self.view.frame.size.width, 1)];
    NSString * isselected = [filterDic valueForKey:@"SportTypeSelection"];
    
    if ([isselected isEqualToString:@"YES"]) {
        
        [buttonSelectAllButton setImage:[UIImage imageNamed:@"4.png"] forState:UIControlStateNormal];
        
    }
    else
    {
        [buttonSelectAllButton setImage:[UIImage imageNamed:@"2.png"] forState:UIControlStateNormal];
        
    }
    [buttonSelectAllButton addTarget:self action:@selector(selecteAllSportType:) forControlEvents:UIControlEventTouchUpInside];
    singleLineView.backgroundColor = [UIColor lightGrayColor];
    [headerView addSubview:tempView];
    [headerView addSubview:labelSport];
    [headerView addSubview:labelAll];
    [headerView addSubview:buttonSelectAllButton];
    [headerView addSubview:singleLineView];
    
    return headerView;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
    

    NSString * string;
    if (indexPath.section == 0)
    {
        
        CGPoint touchPoint = [searchTableView convertPoint:CGPointZero toView:searchTableView];
        NSIndexPath *zeroIndexPath = [searchTableView indexPathForRowAtPoint:touchPoint];
        LocationCell *cell = (LocationCell*)[tableViewFilter cellForRowAtIndexPath:zeroIndexPath];
        
        if (arrayPlaceResult.count == 0)
        {
            
        }else{
            
         string = [[arrayPlaceResult objectAtIndex:indexPath.row]valueForKey:@"description"];
        }
        
        if (string.length == 0)
        {
            
        }
        else{
            cell.textFiledLocatioSearch.text = string;
            locationName = string;
            [searchTableView removeFromSuperview];
            [viewBlackLayer removeFromSuperview];
            searchTableView = nil;
            viewBlackLayer = nil;
            NSString* placeId = [[arrayPlaceResult objectAtIndex:indexPath.row]valueForKey:@"place_id"];
            
            NSString * placeIdurl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?placeid=%@&sensor=nil&key=AIzaSyAZ-Z1DQ9LlqdlzHgyJpiqlLLRqb8I72_8",placeId];
            
            placeIdurl = [placeIdurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL*Url=[NSURL URLWithString:placeIdurl];
            NSData *jsonData = [[NSData alloc]initWithContentsOfURL:Url];
            [appDelegate startIndicator];
            if(jsonData!= nil)
                
            {
                NSError *error = nil;
                
                id result = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
                NSLog(@"%@",result);
                NSDictionary * tempDic = [result valueForKey:@"result"];
                NSString * lat = [[[tempDic valueForKey:@"geometry"]valueForKey:@"location"]valueForKeyPath:@"lat"];
                NSString * lng = [[[tempDic valueForKeyPath:@"geometry"]valueForKey:@"location"]valueForKeyPath:@"lng"];
                NSLog(@"lat%@",lng);
                NSLog(@"lag%@",lat);
                NSArray * latAndLngArray = @[@{@"lan":lat,@"lng":lng}];
                
                [filterDic setObject:latAndLngArray forKey:@"location"];
                [filterDic setObject:locationName forKey:@"locationName"];
                
            }
            [appDelegate stopIndicators];
        }
       
        
    }
    
    if (self.isFromCalendarEvent== YES) {
        
        if (indexPath.section == 1)
        {
            NSLog(@"section2");
            
            sportsCell *cell = (sportsCell*)[tableViewFilter cellForRowAtIndexPath:indexPath];
            
            NSMutableArray * categoryArray = [filterDic valueForKey:@"sportType"];
            NSString * keyString = cell.labelSportName.text;
            NSMutableDictionary * tempDic = [[NSMutableDictionary alloc]init];
            NSString * sportsId = [[resultArray objectAtIndex:indexPath.row]valueForKey:@"sport_id"];
            
            
            if ([[[categoryArray objectAtIndex:indexPath.row]valueForKey:keyString] isEqual:@"1"]) {
                
                
                [tempDic setObject:@"0" forKey:keyString];
                
                selectedSportsId=[filterDic valueForKey:@"sportsId"];
                
                for (int r = 0; r<[selectedSportsId count]; r++)
                {
                    NSString * savedSportsId = [selectedSportsId objectAtIndex:r];
                    if ([sportsId isEqualToString:savedSportsId])
                    {
                        [selectedSportsId removeObjectAtIndex:r];
                    }
                }
                [filterDic setObject:selectedSportsId forKey:@"sportsId"];
                [categoryArray replaceObjectAtIndex:indexPath.row withObject:tempDic];
                cell.imageViewSelectIndicate.image = [UIImage imageNamed:@"2.png"];
                
            }
            else
            {
                
                [tempDic setObject:@"1" forKey:keyString];
                [categoryArray replaceObjectAtIndex:indexPath.row withObject:tempDic];
                cell.imageViewSelectIndicate.image = [UIImage imageNamed:@"4.png"];
                [selectedSportsId addObject:sportsId];
                
                
            }
            NSString * isSelectAll = @"NO";
            [filterDic setObject:isSelectAll forKey:@"SportTypeSelection"];
            
            [buttonSelectAllButton setImage:[UIImage imageNamed:@"2.png"] forState:UIControlStateNormal];
            
            [filterDic setObject:selectedSportsId forKey:@"sportsId"];
            
            [filterDic setObject:categoryArray forKey:@"sportType"];
            
        }
    }
    else{
      if (indexPath.section == 1)
        {
            NSLog(@"section2");
            
        }
        
        else if (indexPath.section ==2)
        {
            NSLog(@"section3");
            
            sportsCell *cell = (sportsCell*)[tableViewFilter cellForRowAtIndexPath:indexPath];
            
            NSMutableArray * categoryArray = [filterDic valueForKey:@"sportType"];
            NSString * keyString = cell.labelSportName.text;
            NSMutableDictionary * tempDic = [[NSMutableDictionary alloc]init];
            
            NSString * sportsId = [[resultArray objectAtIndex:indexPath.row]valueForKey:@"sport_id"];
            
            
            if ([[[categoryArray objectAtIndex:indexPath.row]valueForKey:keyString] isEqual:@"1"]) {
                
                
                [tempDic setObject:@"0" forKey:keyString];
                
                selectedSportsId=[filterDic valueForKey:@"sportsId"];
                
                for (int r = 0; r<[selectedSportsId count]; r++)
                {
                    
                    
                    
                    NSString * savedSportsId = [selectedSportsId objectAtIndex:r];
                    if ([sportsId isEqualToString:savedSportsId]|| [savedSportsId isEqualToString:@"0"])
                    {
                        
                        [selectedSportsId removeObjectAtIndex:r];
                    }
                }
                [filterDic setObject:selectedSportsId forKey:@"sportsId"];
                [categoryArray replaceObjectAtIndex:indexPath.row withObject:tempDic];
                cell.imageViewSelectIndicate.image = [UIImage imageNamed:@"2.png"];
                
            }
            else
            {
                
                [tempDic setObject:@"1" forKey:keyString];
                [categoryArray replaceObjectAtIndex:indexPath.row withObject:tempDic];
                cell.imageViewSelectIndicate.image = [UIImage imageNamed:@"4.png"];
                [selectedSportsId addObject:sportsId];
                
                
            }
            NSString * isSelectAll = @"NO";
            [filterDic setObject:isSelectAll forKey:@"SportTypeSelection"];
            
            [buttonSelectAllButton setImage:[UIImage imageNamed:@"2.png"] forState:UIControlStateNormal];
            
            [filterDic setObject:selectedSportsId forKey:@"sportsId"];
            
            [filterDic setObject:categoryArray forKey:@"sportType"];
            
        }
    }
    
    [tableViewFilter deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - buttonActionForSelectAll

-(void)selecteAllSportType:(UIButton *)button

{
    NSMutableDictionary * tempDic;
    NSMutableArray * TempSportsType = [[NSMutableArray alloc]init];
    NSString * isSelected = [filterDic valueForKey:@"SportTypeSelection"];
    [sportsIdArray removeAllObjects];
    [selectedSportsId removeAllObjects];
    [filterDic removeObjectForKey:@"sportsId"];
    
    
    if ([isSelected isEqualToString:@"YES"])
    {
        
        for (int i = 0; i<[resultArray count]; i++)
        {
            tempDic = [[NSMutableDictionary alloc]init];
            NSString * sportsType = [[resultArray objectAtIndex:i]valueForKey:@"sport_name"];
            [tempDic setObject:@"0" forKey:sportsType];
           
            [TempSportsType addObject:tempDic];
        }
        [filterDic setObject:TempSportsType forKey:@"sportType"];
        NSString * isSelectAll = @"NO";
        [sportsIdArray addObject:@"0"];
        [filterDic setObject:sportsIdArray forKey:@"sportsId"];
        [filterDic setObject:isSelectAll forKey:@"SportTypeSelection"];
        [button setImage:[UIImage imageNamed:@"4.png"] forState:UIControlStateNormal];
    }
    else{
       
        
        for (int i = 0; i<[resultArray count]; i++)
        {
            
            tempDic = [[NSMutableDictionary alloc]init];
            NSString * sportsType = [[resultArray objectAtIndex:i]valueForKey:@"sport_name"];
            [tempDic setObject:@"1" forKey:sportsType];
            
             NSString * sportsId = [[resultArray objectAtIndex:i]valueForKey:@"sport_id"];
            [sportsIdArray addObject:sportsId];
            [filterDic setObject:sportsIdArray forKey:@"sportsId"];
            [TempSportsType addObject:tempDic];
            
        }
        
        NSString * isSelectAll = @"YES";
        [filterDic setObject:isSelectAll forKey:@"SportTypeSelection"];
        [filterDic setObject:TempSportsType forKey:@"sportType"];
        [button setImage:[UIImage imageNamed:@"2.png"] forState:UIControlStateNormal];
    }
   
    [tableViewFilter reloadData];
}

#pragma mark - miles ButtonAction


-(void)milesButtonClicked:(UIButton *)milesButton
{
    NSArray * selectedMileKey;
    NSInteger selectedtag;
    NSString * selectedRanage;
    
   
    if (milesButton.tag == 0) {
         selectedRanage = @"10";
         selectedMileKey = @[@"10",@"",@"",@"",@""];
    }
    else if (milesButton.tag == 1)
    {
        selectedRanage = @"50";
        selectedMileKey = @[@"10",@"50",@"",@"",@""];
    }
    else if (milesButton.tag == 2)
    {
        selectedRanage = @"100";
        selectedMileKey = @[@"10",@"50",@"100",@"",@""];
    }
    else if (milesButton.tag == 3)
    {
        selectedRanage = @"200";
        selectedMileKey = @[@"10",@"50",@"100",@"200",@""];
    }
    
    else if (milesButton.tag == 4)
    {
        selectedRanage = @"all";
        selectedMileKey = @[@"10",@"50",@"100",@"200",@"All"];
    }
     [filterDic setObject:selectedRanage forKey:@"selectedRange"];
    [filterDic setObject:selectedMileKey forKey:@"range"];
    for ( selectedtag=0 ; selectedtag<=milesButton.tag; selectedtag++)
    {
        
        UIImageView * imageView = [arrayImageChange objectAtIndex:selectedtag];
        imageView.image = [UIImage imageNamed:@"distance-bar1-a.png"];
        UIButton * button = [arrayButtonItems objectAtIndex:selectedtag];
        [button setImage:[UIImage imageNamed:@"1.png"] forState:UIControlStateNormal];
        
    }

    
    if (selectedtag != arrayImageChange.count)
    {
        for (selectedtag =(arrayImageChange.count-1) ; selectedtag>milesButton.tag; selectedtag--) {
            UIImageView * imageView = [arrayImageChange objectAtIndex:selectedtag];
            imageView.image = [UIImage imageNamed:@"distance-bar.png"];
            UIButton * button = [arrayButtonItems objectAtIndex:selectedtag];
            [button setImage:[UIImage imageNamed:@"2.png"] forState:UIControlStateNormal];
        }
    }
    
   
    
    
    
}
#pragma mark - FormAndToSelectionAction

-(void)fromButtonAction:(UIButton *)FromButton
{
   
    isClickedFromDate = YES;
    [self datePickerCreation:@"start Date"];
    
    
}

-(void)toButtonAction:(UIButton *)FromButton
{
    isClickedFromDate = NO;
    [self datePickerCreation:@"End Date"];

}
-(void)DateAllSectionButton:(UIButton *)allButton
{
    
    DateCell * cell = (DateCell *)[tableViewFilter cellForRowAtIndexPath:particularCellIndex];
    
    NSString * isSelection =[filterDic objectForKey:@"dateSelection"];
    
    if ([isSelection isEqualToString:@"YES"]) {
        [allButton setImage:[UIImage imageNamed:@"2.png"] forState:UIControlStateNormal];
        isSelection = @"NO";
        [cell.buttonFromDate setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cell.buttonToDate setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cell.buttonToDate setUserInteractionEnabled:YES];
        [cell.buttonFromDate setUserInteractionEnabled:YES];
        [filterDic setObject:isSelection forKey:@"dateSelection"];
    }
    else{
        [allButton setImage:[UIImage imageNamed:@"4.png"] forState:UIControlStateNormal];
        isSelection = @"YES";
        [cell.buttonFromDate setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [cell.buttonToDate setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [cell.buttonToDate setUserInteractionEnabled:NO];
        [cell.buttonFromDate setUserInteractionEnabled:NO];
        [filterDic setObject:isSelection forKey:@"dateSelection"];
    }

}

#pragma mark - DatePickerCreation

-(void)datePickerCreation:(NSString *)alertDiscriation
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"FILTER" message:alertDiscriation delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    
    picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(10, alert.bounds.size.height, 200, 216)];
    
    picker.datePickerMode = UIDatePickerModeDate;
    
    [alert addSubview:picker];
    
    alert.bounds = CGRectMake(10, 0, self.view.frame.size.width-20, alert.bounds.size.height + 216 + 20);
    [picker addTarget:self
                   action:@selector(LabelChange:)
         forControlEvents:UIControlEventValueChanged];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    
    NSDate *date = [dateFormat dateFromString:fromDate];
    
    if (isClickedFromDate == NO) {
        
        
        picker.minimumDate = date;
        [picker setDate:date];

    }
    else{
        
       [picker setDate:date];
        
    }
  
    [alert setValue:picker forKey:@"accessoryView"];
    [alert show];
    alert = nil;
}


- (void)LabelChange:(UIButton*)sender
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyyy"];
    if ([picker.date isEqual:@""]) {
      
        selectedDate = fromDate;
    }
    {
       selectedDate = [NSString stringWithFormat:@"%@",[df stringFromDate:picker.date]];
    }
    
    
    
}

#pragma mark - AlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        if ([alertView.message isEqualToString:@"Applyed Successfully"]|| [alertView.message isEqualToString:@"Reset Successfully"])
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    
    }
    else
    {
        if (isClickedFromDate == YES)
        {
            
            if ([selectedDate isEqualToString:@""]) {
                selectedDate = fromDate;
            }
            
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            
            [dateFormat setDateFormat:@"MM/dd/yyyy"];
            
            NSDate *comparsionToDate = [dateFormat dateFromString:toDate];
            
            NSDate * TempPickeDate = [dateFormat dateFromString:selectedDate];
            
          
           if ([TempPickeDate compare: comparsionToDate] == NSOrderedDescending) {
                    
               toDate = selectedDate;
               fromDate = selectedDate;
               [filterDic setObject:fromDate forKey:@"fromDate"];
               [filterDic setObject:toDate forKey:@"toDate"];
            }
           else{
                fromDate = selectedDate;
               [filterDic setObject:fromDate forKey:@"fromDate"];
           }
        
        }
        else{
            
            toDate = selectedDate;
            [filterDic setObject:toDate forKey:@"toDate"];
        }
        [tableViewFilter reloadData];
    }
}


#pragma mark - textFiledDelegate

-(void)textFieldDidBeginEditing:(UITextField *)textField{
   
    }


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSString * stringToRange = [textField.text substringWithRange:NSMakeRange(0,range.location)];
    
    // Appending the currently typed charactor
    stringToRange = [stringToRange stringByAppendingString:string];
    
    // Processing the last typed word
    NSArray *wordArray       = [stringToRange componentsSeparatedByString:@" "];
    NSString * wordTyped     = [wordArray lastObject];
    if (searchTableView == nil)
    {
        
        isSearchLocation = YES;
        viewBlackLayer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        viewBlackLayer.backgroundColor = [UIColor blackColor];
        
        viewBlackLayer.alpha = 0.3;
        
        searchTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 135, self.view.frame.size.width-20, 300)];
        
        
        
        [self.view addSubview:viewBlackLayer];
        [self.view addSubview:searchTableView];
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAview)];
        [viewBlackLayer addGestureRecognizer:tapGesture];
        searchTableView.delegate = self;
        searchTableView.dataSource = self;
        
    }
    
    [appDelegate startIndicator];
   
    NSString * placeSearchResultString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&sensor=nil&key=AIzaSyAZ-Z1DQ9LlqdlzHgyJpiqlLLRqb8I72_8",wordTyped];
    
    placeSearchResultString = [placeSearchResultString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL*Url=[NSURL URLWithString:placeSearchResultString];
    NSData *jsonData = [[NSData alloc]initWithContentsOfURL:Url];
    
    if(jsonData!= nil)
        
    {
        NSError *error = nil;
        
        id result = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        NSLog(@"%@",result);
        
      arrayPlaceResult = [result valueForKey:@"predictions"];
        
      [searchTableView reloadData];
        
    }
    else
    {
        
    }
    [appDelegate stopIndicators];
    
    return YES;
}

-(void)tapAview
{
    [searchTableView removeFromSuperview];
    [viewBlackLayer removeFromSuperview];
    searchTableView = nil;
    viewBlackLayer = nil;
}


#pragma mark - RestAndApplyButtonAction



- (IBAction)applyButtonAction:(id)sender {
    
    [appDelegate startIndicator];
    NSData * data= [NSKeyedArchiver archivedDataWithRootObject:filterDic];
    [[NSUserDefaults standardUserDefaults]setObject:data forKey:@"filterValues"];
    
    NSArray * sportsIdsArray = [filterDic valueForKey:@"sportsId"];
    
    if ([sportsIdsArray count]>=1 || sportsIdsArray.count == 0) {
       
        if (sportsIdsArray.count == 0) {
            
            [self alertViewShow:@"Please select sport type"];
        }
        else{
            
            NSString * sportsIdForTest = [sportsIdsArray objectAtIndex:0];
            
            if ([sportsIdForTest isEqualToString:@"0"]) {
                
                [self alertViewShow:@"Please select sport type"];
            }
            else{
                
                [self alertViewShow:@"Applyed Successfully"];
            }
        }
       
        
    }
      else{
        
        selectedSportsId = nil;
        [self alertViewShow:@"Applyed Successfully"];

       }
   
    }

- (IBAction)restButtonAction:(id)sender {
    
    [appDelegate startIndicator];
    [appDelegate userCurrentLocation];
    NSString * latitude= [[NSUserDefaults standardUserDefaults] valueForKey:@"latitude"];
    NSString * longitude =  [[NSUserDefaults standardUserDefaults]valueForKey:@"longitude"];
    NSArray * locationLatAndLan = @[@{@"lan":latitude,@"lng":longitude}];
    [filterDic setObject:locationLatAndLan forKey:@"location"];
    
    NSString * isSelectAll = @"YES";
    [filterDic setObject:isSelectAll forKey:@"SportTypeSelection"];
    NSString * dateButtonSelection = @"YES";
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger day = [components day];
    NSInteger week = [components month];
    NSInteger year = [components year];
    fromDate = [NSString stringWithFormat:@"%ld/%ld/%ld",(long)week, (long)day,  (long)year];
    toDate = [NSString stringWithFormat:@"%ld/%ld/%ld", (long)week,(long)day,  (long)year];
    
    [filterDic setObject:fromDate forKey:@"fromDate"];
    [filterDic setObject:toDate forKey:@"toDate"];
    [filterDic setObject:dateButtonSelection forKey:@"dateSelection"];
    NSArray * rangeArray = @[@"10",@"50",@"100",@"200",@"All"];
    NSString * selectedRanage = @"all";
    [filterDic setObject:selectedRanage forKey:@"selectedRange"];
    
    [filterDic setObject:rangeArray forKey:@"range"];
    
    NSMutableDictionary *tempDic;
    NSMutableArray * TempSportsType = [[NSMutableArray alloc]init];
    
    for (int i = 0; i<[resultArray count]; i++)
    {
        tempDic = [[NSMutableDictionary alloc]init];
        NSString * sportsType = [[resultArray objectAtIndex:i]valueForKey:@"sport_name"];
        [tempDic setObject:@"1" forKey:sportsType];
        
        [TempSportsType addObject:tempDic];
    }
    NSMutableArray  * sportsId = [[NSMutableArray alloc]init];
    [sportsId addObject:@"0"];
    [filterDic setObject:sportsId forKey:@"sportsId"];
    [filterDic setObject:TempSportsType forKey:@"sportType"];
    TempSportsType = nil;
    
    NSData * data= [NSKeyedArchiver archivedDataWithRootObject:filterDic];
    [[NSUserDefaults standardUserDefaults]setObject:data forKey:@"filterValues"];
    [self alertViewShow:@"Reset Successfully"];
    [tableViewFilter reloadData];
    
    
}
@end
