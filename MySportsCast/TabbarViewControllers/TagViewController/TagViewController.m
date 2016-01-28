//
//  TagViewController.m
//  MySportsCast
//
//  Created by SPARSHMAC08 on 16/09/15.
//  Copyright (c) 2015 SPARSHMAC08. All rights reserved.
//

#import "TagViewController.h"
#import "AppDelegate.h"
#import "JsonClass.h"
#import "UIImageView+WebCache.h"
#import "Constants.h"

@interface TagViewController ()<WebServiceProtocol>
{
    NSArray * tempArray;
    AppDelegate * appDelegate;
   
    JsonClass * jsonObject;
    
}
@end

@implementation TagViewController
@synthesize selectedValues,tableViewDataArray,selecteTagIds;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    jsonObject = [[JsonClass alloc]init];
    
    jsonObject.delegate = self;
    
    appDelegate = [UIApplication sharedApplication].delegate;
    
    if (selectedValues.count==0)
    {
        selectedValues = [@[] mutableCopy];
        selecteTagIds= [@[] mutableCopy];
       
    }
    else
    {
        
    }
    
    self.collectionViewSelectedHight.constant = 0;
    
    if (selectedValues.count > 0)
    {
        [self animateSelectedCollectionView];
    }
    
    self.labelHeaderTitle.text = self.headerName;
    
    // Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - TableView Delegates

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tableViewDataArray.count;
    //pass service array
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *cell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CustomTableViewCell"];

    for (UIImageView * imageView in cell.contentView.subviews)
    {
        if ([imageView isKindOfClass:[UIImageView class]])
        {
            [imageView removeFromSuperview];
            
        }
    }
    for (UILabel * label in cell.contentView.subviews)
    {
        if ([label isKindOfClass:[UILabel class]])
        {
            [label removeFromSuperview];
            
        }
    }
    UIImageView * imagePeople = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 80, 80)];

    
   
//    [imagePeople setImageWithURL: [[tableViewDataArray objectAtIndex:indexPath.row]valueForKey:@"image"] andResize:CGSizeMake(imagePeople.frame.size.width, imagePeople.frame.size.width) withContentMode:UIViewContentModeScaleAspectFit];
    
    [imagePeople sd_setImageWithURL:[[tableViewDataArray objectAtIndex:indexPath.row]valueForKey:@"image"]  placeholderImage:[UIImage imageNamed:@""]];
    
    
    
    
    
    [cell.contentView addSubview:imagePeople];
    
    UILabel * labelPeopleName = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imagePeople.frame)+10, 25, 200, 40)];
    labelPeopleName.text = [[tableViewDataArray objectAtIndex:indexPath.row]valueForKey:@"name"];
    
    labelPeopleName.textAlignment = NSTextAlignmentLeft;
    
    labelPeopleName.textColor = [UIColor blackColor];
    
    [cell.contentView addSubview:labelPeopleName];
    
    labelPeopleName = nil;
    imagePeople = nil;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
    if (![selectedValues containsObject:[[tableViewDataArray objectAtIndex:indexPath.row]valueForKey:@"name"]])
    {

        [selectedValues addObject:[[tableViewDataArray objectAtIndex:indexPath.row]valueForKey:@"name"]];
        
        [selecteTagIds addObject:[[tableViewDataArray objectAtIndex:indexPath.row]valueForKey:@"id"]];
        
        
        
        [self.collectionViewSelectedTag insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:selectedValues.count-1 inSection:0]]];
        
        [self.collectionViewSelectedTag reloadData];

        
    }
    
    
    
    NSInteger index = indexPath.row;
    if (index==0) {
//         [self.collectionViewSelectedTag scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        
    }else
    {
        index = selectedValues.count-1;
        if (selectedValues.count<=0)
        {
            
        }
        else
        {
            [self.collectionViewSelectedTag scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
        }
        
    }
    
    
    [self animateSelectedCollectionView];
}
#pragma mark - UICollectionview DataSource & Delegate


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    appDelegate.tagSelectedArray = selectedValues;
    
    return  selectedValues.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CustomCollectionViewCell" forIndexPath:indexPath];
    

    for (UILabel * label in cell.subviews)
    {
        if ([label isKindOfClass:[UILabel class]])
        {
            [label removeFromSuperview];
            
        }
    }
    
    for (UIButton * button in cell.subviews)
    {
        if ([button isKindOfClass:[UIButton class]])
        {
            [button removeFromSuperview];
            
        }
    }
    UILabel * labelPeopleName = [[UILabel alloc]init];
     labelPeopleName.text = [selectedValues objectAtIndex:indexPath.row];
    
    CGFloat width = [labelPeopleName.text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17]}].width;
    
    CGFloat height = [labelPeopleName.text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17]}].height;
    
    
    labelPeopleName.frame = CGRectMake(5, 5, width,height+10);
    [labelPeopleName sizeToFit];
    labelPeopleName.textAlignment = NSTextAlignmentCenter;
    labelPeopleName.textColor = [UIColor blackColor];
    labelPeopleName.layer.cornerRadius = 5;
    labelPeopleName.layer.borderWidth = 1.0f;
    labelPeopleName.layer.borderColor = [UIColor blackColor].CGColor;
    
    labelPeopleName.textAlignment = NSTextAlignmentLeft;
    labelPeopleName.textColor = [UIColor blackColor];
    UIButton * cancelbutton =[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(labelPeopleName.frame)-10, 0, 15, 15)];
    
    [cancelbutton setImage:[UIImage imageNamed:@"crossround.png"] forState:UIControlStateNormal];
    
    //cancelbutton.backgroundColor = [UIColor redColor];
    
    cancelbutton.tag = 10000+indexPath.row;
    
    NSLog(@"buttonsTags%ld",(long)cancelbutton.tag);

    [cancelbutton addTarget:self action:@selector(cellRemoveButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:labelPeopleName];
    [cell addSubview:cancelbutton];
    
    labelPeopleName = nil;
    cancelbutton = nil;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath

{
    
}



#pragma mark - Animations
-(void)animateSelectedCollectionView{
    if (selectedValues.count > 0) {
        self.collectionViewSelectedHight.constant = 130;
    }else{
        self.collectionViewSelectedHight.constant = 0;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}


#pragma mark - CellButton Action
-(IBAction)cellRemoveButtonAction:(id)sender
{
    

    UIButton *button = (UIButton *)sender;
    
    NSInteger index = button.tag-10000;

    [self.collectionViewSelectedTag performBatchUpdates:^
    {
       
        [selectedValues removeObjectAtIndex:index];
        [selecteTagIds removeObjectAtIndex:index];
        NSIndexPath *indexPath =[NSIndexPath indexPathForRow:index inSection:0];
        [self.collectionViewSelectedTag deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
        
    }
    completion:^(BOOL finished) {
        [self animateSelectedCollectionView];
        [self.collectionViewSelectedTag reloadData];
    }];

}



- (IBAction)doneButtonClicked:(id)sender {
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(TagsSelectedValues:)]){
        [[self delegate] TagsSelectedValues:selectedValues];
    }
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(TagsSelectedId:)])
    {
        [[self delegate] TagsSelectedId:selecteTagIds];
    }
    
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)backButtonAction:(id)sender
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(TagsSelectedValues:)]){
        [[self delegate] TagsSelectedValues:selectedValues];
    }
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(TagsSelectedId:)])
    {
        [[self delegate] TagsSelectedId:selecteTagIds];
    }
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

#pragma textFiledDelegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
   // http://182.75.34.62/MySportsShare/web_services/search_people_event_info.php?search_title=var&search_flag=people
    
    NSString * stringToRange = [textField.text substringWithRange:NSMakeRange(0,range.location)];
    
    // Appending the currently typed charactor
    stringToRange = [stringToRange stringByAppendingString:string];
    
    
    if ([appDelegate connectedToInternet])
    {
        [jsonObject getMethodforServiceRequest:[NSString stringWithFormat:@"%@search_people_event_info.php?search_title=%@&search_flag=people",commonURL,stringToRange]];
    }
    else
    {
        [self alertShow:@"No internetconnection"];
        
    }
    
   
   
    
    return YES;
}


#pragma mark - webServicedelegate

-(void)didReceiveResponseFromWebService:(NSDictionary *)responseDictionary
{
    
    NSString * responce = [[responseDictionary valueForKey:@"Response"]valueForKey:@"ResponseInfo"];
    
    if ([responce isEqualToString:@"SUCCESS"])
    {
        tableViewDataArray  = [[responseDictionary valueForKey:@"Response"]valueForKey:@"search_list"];
        [self.tableViewTagSearch reloadData];
    }
}

-(void)alertShow:(NSString *)discriation
{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"oops!" message:discriation delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
    alert = nil;
}



@end
