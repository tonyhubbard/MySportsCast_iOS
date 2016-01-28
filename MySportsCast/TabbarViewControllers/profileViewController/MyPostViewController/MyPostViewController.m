//
//  MyPostViewController.m
//  MySportsCast
//
//  Created by SPARSHMAC08 on 30/09/15.
//  Copyright © 2015 SPARSHMAC08. All rights reserved.
//
#define kKeyboardOffsetY 80.0f
#import "MyPostViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"
#import "JsonClass.h"
#import "MyPostCell.h"
#import "UIImageView+WebCache.h"
#import "PlayerViewController.h"
#import "ImageFilterViewController.h"
#import "Constants.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>


@interface MyPostViewController ()<WebServiceProtocol,UITextFieldDelegate,UIAlertViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate>
{
    UIImageView * imageForPhoto;
    UIImagePickerController *imagePickController;
    AppDelegate * appdelegate;
    JsonClass * jsonobjc;
    NSMutableArray * resultArray;
    NSInteger pageId;
    NSString * isLikedString;
    BOOL ischeers;
    NSInteger cheeresIndex;
    NSInteger  likeCount;
    NSString * commentMediaId;
    NSString * commentMediaType;
    NSString * categorytype;
    BOOL isComment;
    UIView * commentView;
    UIButton * buttonClose;
    UIView * viewBlackLayer;
    NSMutableArray * arrayComment;
    UITableView * tableCommnet;
    NSInteger deletedIndex;
    BOOL isCommnetDelete;
    NSString * commentStringTF;
    NSString * userProfileUrl;
    NSString * userProfileName;
    BOOL isSendButtonClicked;
    BOOL isEventDelete;
    NSString * mediaType;
    NSString * mediaId;
    UIImageView * imageViewEdit;
    BOOL iscellPostEdit;
    UIView * editView;
    UIView * tempBackGround;
    UILabel * labelForEditTitle;
    NSString * mediaFile;
    NSString * postcontent;
    BOOL isEventEditDone;
    UITextView * castTextView;
   
    
}
@property (weak, nonatomic) IBOutlet UILabel *labelNavTitle;
@end

@implementation MyPostViewController

- (void)viewDidLoad {
    
    appdelegate = [UIApplication sharedApplication].delegate;
    
    jsonobjc =[[JsonClass alloc]init];
    
    jsonobjc.delegate =self;
    pageId = 0;
    NSData * data = [[NSUserDefaults standardUserDefaults]valueForKey:@"profileInfo"];
    
    NSDictionary * userInfoDic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    userProfileUrl = [userInfoDic valueForKey:@"userPic"];
    
    userProfileName = [userInfoDic valueForKey:@"userName"];
    arrayComment = [[NSMutableArray alloc]init];
   
    if (appdelegate.isfromNotificationScreen == YES) {
        
        self.labelNavTitle.text = [NSString stringWithFormat:@"%@ posts",appdelegate.profileSelectedUSeName];
        
        self.labelNavTitle.text = [self.labelNavTitle.text uppercaseString];
        
    }
    else if (self.isMediaFromNotification == YES)
    {
        self.labelNavTitle.text = self.notificationMediaType;

    }
    
    else{
        
        if (appdelegate.profileViewNavAccount == 3)
        {
            self.labelNavTitle.text = [NSString stringWithFormat:@"%@ posts",appdelegate.profileSelectedUSeName];
            
            self.labelNavTitle.text = [self.labelNavTitle.text uppercaseString];
        }
        else{
            
            self.labelNavTitle.text = @"MY POSTS";
        }
    }
  
    [super viewDidLoad];
    imagePickController = [[UIImagePickerController alloc]init];
    imagePickController.delegate =self;
    
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    if (appdelegate.editImageForMyProfile)
    {
  
        imageViewEdit.image = appdelegate.editImageForMyProfile;
        
    }
    
}
-(void)viewDidAppear:(BOOL)animated
{
    
    [self webServiceRequest];
}

-(void)viewDidDisappear:(BOOL)animated
{
    
    resultArray = nil;
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    [imageCache clearMemory];
    [imageCache clearDisk];
    // Dispose of any resources that can be recreated.
}


#pragma mark - ServiceRequest

-(void)serviceRequestForSelecteTyped:(NSString *)selectedType WithUserId:(NSString*)userId WithLoginId:(NSString *)loginId andPageIndex:(NSInteger)pageIndex
{
    if ([appdelegate connectedToInternet])
    {
        [appdelegate startIndicator];
        
        [jsonobjc getMethodforServiceRequest:[NSString stringWithFormat:@"%@%@user_id=%@&page_id=%ld&login_user_id=%@",commonURL,selectedType,userId,(long)pageIndex,loginId]];
    }
    else
    {
        [self alertViewShow:@"No internet Connection"];
        
    }
    
    
//   http://182.75.34.62/MySportsShare/web_services/get_profile_user_all.php?user_id=298&page_id=0&login_user_id=2 
    
 
    
}

#pragma mark - WebServiceDelegate

-(void)didReceiveResponseFromWebService:(NSDictionary *)responseDictionary
{

    
    if (ischeers == YES)
    {
        ischeers = NO;
        
        [self cheeresResponceHandeler:responseDictionary];
    }
    
    else if (isComment == YES)
    {
        ischeers = NO;
        
        
        [self commentServiceResponceHandler:responseDictionary];
        
    }
    else if (isSendButtonClicked == YES)
    {
//        isSendButtonClicked = NO;
        [self sendButtonRespoceHandler:responseDictionary];
        
        
    }
    else if (isCommnetDelete == YES)
    {
//        isCommnetDelete = NO;
        [self commnetDeleteRespoceHandeler:responseDictionary];
    }
    else if (isEventDelete == YES)
    {
        
        [self cellDeleteButtonResponceHandeler:responseDictionary];
    }
    else if (isEventEditDone == YES)
    {
        
        [self eventEditResponce:responseDictionary];
    }
    else if (self.isMediaFromNotification == YES){
        
       if ([[[responseDictionary valueForKey:@"Response"]valueForKey:@"ResponseInfo"] isEqualToString:@"SUCCESS"]){
            
            
            [resultArray addObject:[[[responseDictionary valueForKey:@"Response"]valueForKey:@"user_pfofile_all"]mutableCopy]];
            [appdelegate stopIndicators];
        }
    }
    
    else{
        if ([[[responseDictionary valueForKey:@"Response"]valueForKey:@"ResponseInfo"] isEqualToString:@"SUCCESS"]) {
            NSArray * tempArray = [[[responseDictionary valueForKey:@"Response"]valueForKey:self.eventResponceKey]mutableCopy];
            
            for (int i = 0; i<[tempArray count]; i++)
            {
                [resultArray addObject:[tempArray objectAtIndex:i]];
            }
            
            [appdelegate stopIndicators];
        }
        else{
            
//          [self alertViewShow:@"No Data"];
          [appdelegate stopIndicators];
        }
        
    }
    [self.tableViewMyPost reloadData];
    
    
}
#pragma mark - editEventResponceHandlar

-(void)eventEditResponce:(NSDictionary*)editResponceDic
{
    if ([[[editResponceDic valueForKey:@"Response"]valueForKey:@"ResponseInfo"]isEqualToString:@"SUCCESS"]) {
       
        
        dispatch_async(dispatch_get_main_queue(), ^{
                        // code here
                        [self alertViewShow:@"Updated Successfully"];
                    });
        
       
    }
    
}
#pragma commnetDeleteRespoceHandeler

-(void)commnetDeleteRespoceHandeler:(NSDictionary *)responceDic
{
    NSString * responceString =[[responceDic valueForKey:@"Response"]valueForKey:@"ResponseInfo"];
    if ([responceString isEqualToString:@"SUCCESS"])
        
    {
        
        NSIndexPath *indexpath  = [NSIndexPath indexPathForRow:deletedIndex inSection:0];

        
        [tableCommnet scrollToRowAtIndexPath:indexpath
                            atScrollPosition:UITableViewScrollPositionTop
                                    animated:YES];
        
        [arrayComment removeObjectAtIndex:deletedIndex];
        
        [tableCommnet reloadData];
        [appdelegate stopIndicators];
        
    }
    else
    {
        [self alertViewShow:@"UnableToDelete"];
    }
}

-(void)cheeresResponceHandeler:(NSDictionary *)dictornary
{
   if ([[[dictornary valueForKey:@"Response"]valueForKey:@"ResponseInfo"] isEqualToString:@"SUCCESS"]) {
       
       NSMutableDictionary * tempDic = [[NSMutableDictionary alloc]init];
       
       tempDic = [[resultArray objectAtIndex:cheeresIndex]mutableCopy];
       
       [tempDic setObject:isLikedString forKey:@"is_user_liked"];
       
       [tempDic setObject:[NSString stringWithFormat:@"%ld",(long)likeCount] forKey:@"likes_count"];
       
       [resultArray replaceObjectAtIndex:cheeresIndex withObject:tempDic];
       tempDic = nil;
   }
    else
    {
        [self alertViewShow:@"unableToCheers"];
    }
    
    [appdelegate stopIndicators];
}

-(void)commentServiceResponceHandler:(NSDictionary *)responceDic
{
    NSString * responceString =[[responceDic valueForKey:@"Response"]valueForKey:@"ResponseInfo"];
    if ([responceString isEqualToString:@"SUCCESS"])
    {
        arrayComment = [[[responceDic valueForKey:@"Response"]valueForKey:@"search_list"] mutableCopy];
        
        arrayComment = [[[arrayComment reverseObjectEnumerator] allObjects]mutableCopy];
        
        
        
    }
    else
    {
        
        [arrayComment removeAllObjects];
        
        
    }
    
    tableCommnet.delegate = self;
    tableCommnet.dataSource = self;
    
    [tableCommnet reloadData];
    [appdelegate stopIndicators];
    
}

-(void)sendButtonRespoceHandler:(NSDictionary *)respoceDic
{
    
    NSString * responceString =[[respoceDic valueForKey:@"Response"]valueForKey:@"ResponseInfo"];
    if ([responceString isEqualToString:@"SUCCESS"])
    {
        
        NSString * commnetId = [[respoceDic valueForKey:@"Response"]valueForKey:@"comment_id"];
        NSMutableDictionary * recentCommentDic = [[NSMutableDictionary alloc]init];
        
        
        [recentCommentDic setObject:userProfileName forKey:@"first_name"];
        [recentCommentDic setObject:userProfileUrl forKey:@"image"];
        [recentCommentDic setObject:[[NSUserDefaults standardUserDefaults]valueForKey:@"loginId"] forKey:@"user_id"];
        [recentCommentDic setObject:commentStringTF forKey:@"comment_content"];
        [recentCommentDic setObject:commnetId forKey:@"comment_id"];
        
        [arrayComment addObject:recentCommentDic];
        arrayComment = [[[arrayComment reverseObjectEnumerator] allObjects]mutableCopy];
        
        [tableCommnet reloadData];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [tableCommnet scrollToRowAtIndexPath:indexPath
                            atScrollPosition:UITableViewScrollPositionBottom
                                    animated:YES];
        
    }
    [appdelegate stopIndicators];
    
}


-(void)alertViewShow:(NSString *)alertMessage
{
    
    UIAlertView *globalAlertView;
   
    
    
    if ([alertMessage isEqualToString:@"Are you sure want to delete photo?"] || [alertMessage isEqualToString:@"Are you sure want to delete video?"] ||[alertMessage isEqualToString:@"Are you sure want to delete cast?"])
    {
        globalAlertView = [[UIAlertView alloc]initWithTitle:@"MySportsCast" message:alertMessage delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: @"Ok", nil];
    
        
    }
    
   /*
    else if ([alertMessage isEqualToString:@"Edit your media"] || [alertMessage isEqualToString:@"Edit your cast"])
    {
        globalAlertView = [[UIAlertView alloc]initWithTitle:@"MySportsCast" message:alertMessage delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: @"Ok", nil];
        
        if ([[[resultArray objectAtIndex:deletedIndex]valueForKey:@"category"] isEqualToString:@"user_photos_data"]) {
            
            imageViewEdit =[[UIImageView alloc]initWithFrame:CGRectMake(10, globalAlertView.bounds.size.height, globalAlertView.frame.size.width, 216)];
            imageViewEdit.backgroundColor = [UIColor redColor];
            
//            [imageViewEdit sd_setImageWithURL:[NSURL URLWithString:[[resultArray objectAtIndex:deletedIndex]valueForKey:@"media_url"]]];
            imageViewEdit.image = imageForPhoto.image;
            
            [globalAlertView textFieldAtIndex:0];
            
            globalAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            
            [globalAlertView addSubview:imageViewEdit];
            
           
            
             globalAlertView.bounds = CGRectMake(10, 0, self.view.frame.size.width-20, globalAlertView.bounds.size.height + 216 + 20);
            
            [globalAlertView setValue:imageViewEdit forKey:@"accessoryView"];
            
        }
        else if ([[[resultArray objectAtIndex:deletedIndex]valueForKey:@"category"] isEqualToString:@"user_videos_data"])
        {
           
           
            
            
        }
        
        else
        {
            
            
        }

      
        
        
        
        
    }
    */
    else{
        
       globalAlertView = [[UIAlertView alloc]initWithTitle:@"MySportsCast" message:alertMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
      
    }
    
    [globalAlertView show];
    globalAlertView  = nil;
    [appdelegate stopIndicators];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.message isEqualToString:@"Are you sure want to delete photo?"] || [alertView.message isEqualToString:@"Are you sure want to delete video?"] ||[alertView.message isEqualToString:@"Are you sure want to delete cast?"])
    {
        if (buttonIndex == 0)
        {
            isEventDelete = NO;
        }
        else if (buttonIndex == 1)
        {
            
            [appdelegate startIndicator];
            if ([appdelegate connectedToInternet]) {
                
              
                
                [jsonobjc getMethodforServiceRequest:[NSString stringWithFormat:@"%@delete_media.php?media_id=%@&media_type=%@",commonURL,mediaId,mediaType]];
            }
            else{
                
                [self alertViewShow:@"No Internet Connection"];
                
            }
        }
        
    }
    else if ([alertView.message isEqualToString:@"Share With"])
    {
        
        NSURL * eventUrl;
        NSString * intialiText;
        UIImage * image;
        
        if ([[[resultArray objectAtIndex:deletedIndex]valueForKey:@"category"] isEqualToString:@"user_photos_data"]) {
            
            eventUrl = [NSURL URLWithString:@""];
            
            image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[resultArray objectAtIndex:deletedIndex]valueForKey:@"media_url"]]]];
            
            
            intialiText = @"MySportsCast";
        }
        else if ([[[resultArray objectAtIndex:deletedIndex]valueForKey:@"category"] isEqualToString:@"user_casts_data"]){
            
            
            eventUrl = [NSURL URLWithString:@""];
            
            intialiText = [[resultArray objectAtIndex:deletedIndex]valueForKey:@"caption"];
        }
        else if ([[[resultArray objectAtIndex:deletedIndex]valueForKey:@"category"] isEqualToString:@"user_videos_data"]){
            
            intialiText = @"MySportsCast";
            
            eventUrl = [NSURL URLWithString:[[resultArray objectAtIndex:deletedIndex]valueForKey:@"media_url"]];
        }
        
        if (buttonIndex == 1)
        {
            Composercontroller=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            
            [Composercontroller addURL:eventUrl];
            
            [Composercontroller setInitialText:intialiText];
            
            [Composercontroller addImage:image];
            
            [self presentViewController:Composercontroller animated:YES completion:nil];
            
            
            
        }else if (buttonIndex == 2){
            
            
            Composercontroller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            
            [Composercontroller addURL:eventUrl];
            
            [Composercontroller setInitialText:intialiText];
            
            [Composercontroller addImage:image];

            
            [self presentViewController:Composercontroller animated:YES completion:Nil];
            
            
            
        }else if (buttonIndex == 3){
            
            UIImageView * imageview = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 350, 350)];
            
            if (image) {
                imageview.image = image;
            }
            else{
                imageview.image = [UIImage imageNamed:@"splash_screen_inner.jpg"];
            }
            
            
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
        
        
    }
    else if (isEventEditDone == YES)
    {
        isEventEditDone = NO;
        [self removeingEditView];
        
        pageId = 0;
        [self webServiceRequest];
        
       [appdelegate stopIndicators];
      
    }
    
}


-(void)shareButtonClicked:(UIButton *)Button
{
    
    deletedIndex = Button.tag;
    UIAlertView *AlertView = [[UIAlertView alloc]initWithTitle:@"MySportsCast" message:@"Share With" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"TWITTER",@"FACEBOOK",@"INSTAGRAM",nil];
    [AlertView show];
    AlertView  = nil;
}



#pragma mark - tableViewDelegate


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == tableCommnet) {
        return arrayComment.count;
    }
    else{
        return resultArray.count;
    }
    
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (tableView == tableCommnet)
    {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell"];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"commentCell"];
        }
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
        for (UITextView * textview in cell.contentView.subviews)
        {
            if ([textview isKindOfClass:[UITextView class]])
            {
                [textview removeFromSuperview];
            }
        }
        for (UIButton * button in cell.contentView.subviews)
        {
            if ([button isKindOfClass:[UIButton class]])
            {
                [button removeFromSuperview];
            }
        }
        for (UIView * view in cell.contentView.subviews)
        {
            if ([view isKindOfClass:[UIView class]])
            {
                [view removeFromSuperview];
            }
        }
        
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 50, 50)];
        

        
        [imageView sd_setImageWithURL:[[arrayComment objectAtIndex:indexPath.row]valueForKey:@"image"] placeholderImage:[UIImage imageNamed:@""]];
        
        
        
        imageView.layer.cornerRadius = imageView.frame.size.width/2;
        imageView.layer.masksToBounds = YES;
        
        
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"loginId" ] isEqualToString:[[arrayComment objectAtIndex:indexPath.row]valueForKey:@"user_id"]])
        {
            UIButton * commentDeleteButton = [[UIButton alloc]initWithFrame:CGRectMake(tableCommnet.frame.size.width-25, 10, 25, 25)];
            [commentDeleteButton setImage:[UIImage imageNamed:@"trash.png"] forState:UIControlStateNormal];
            
            [commentDeleteButton addTarget:self action:@selector(commentDeleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            commentDeleteButton.tag = indexPath.row;
            [cell.contentView addSubview:commentDeleteButton];
            commentDeleteButton = nil;
            
        }
        
        UILabel * labelUserName = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(imageView.frame)+5+50, 5, 200, 40)];
        
        labelUserName.text = [[arrayComment objectAtIndex:indexPath.row]valueForKey:@"first_name"];
        
        labelUserName.textAlignment =NSTextAlignmentLeft;
        
        labelUserName.textColor =[UIColor blackColor];
        
        UITextView * commentTextLabel = [[UITextView alloc]init];
        if ([[[arrayComment objectAtIndex:indexPath.row]valueForKey:@"comment_content"] isKindOfClass:[NSNull class]]) {
            commentTextLabel.text = @"";
        }
        else{
            commentTextLabel.text = [[arrayComment objectAtIndex:indexPath.row]valueForKey:@"comment_content"];
        }
        
        
        
        
        CGSize boundingSize = CGSizeMake(260, 10000000);
        
        CGRect itemTextSize = [commentTextLabel.text boundingRectWithSize:boundingSize
                                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                                               attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}
                                                                  context:nil];
        
        CGSize size = itemTextSize.size;
        float textHeight = size.height+10;
        
        commentTextLabel.frame = CGRectMake(5, CGRectGetMaxY(labelUserName.frame)+15,commentView.frame.size.width-10, textHeight);
        
        
        commentTextLabel.textAlignment =NSTextAlignmentLeft;
        commentTextLabel.textColor =[UIColor blackColor];
        commentTextLabel.font = [UIFont systemFontOfSize:14];
        commentTextLabel.scrollEnabled = NO;
        commentTextLabel.editable = NO;
        
        
        UIView * singleLineView =[[UIView alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(commentTextLabel.frame)+3, commentView.frame.size.width-10, 1)];
        
        singleLineView.backgroundColor = [UIColor lightGrayColor];
        
        
        
        
        [cell.contentView addSubview:imageView];
        [cell.contentView addSubview:labelUserName];
        [cell.contentView addSubview:commentTextLabel];
        [cell.contentView addSubview:singleLineView];
        
        imageView = nil;
        labelUserName = nil;
        commentTextLabel = nil;
        singleLineView = nil;
        return cell;
 
    }
    else{
        
        
#pragma mark - MyPostCell
        
        MyPostCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (cell == nil)
        {
            cell = [[MyPostCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        
        for (UITextView * txtView in cell.viewBackGround.subviews)
        {
            if ([txtView isKindOfClass:[UITextView class]])
            {
                [txtView removeFromSuperview];
            }
        }
        for (UIImageView * imgView in cell.viewBackGround.subviews)
        {
            if ([imgView isKindOfClass:[UIImageView class]])
            {
                [imgView removeFromSuperview];
            }
        }
        NSString * category = [[resultArray objectAtIndex:indexPath.row]valueForKey:@"category"];
        
        
        
        if ([category isEqualToString:@"user_photos_data"])
        {
            
            UITextView * userDiscripation = [[UITextView alloc]init];
            if ([[[resultArray objectAtIndex:indexPath.row]valueForKey:@"caption"]isKindOfClass:[NSNull class]])
            {
                userDiscripation.text = @"";
            }
            else
            {
                userDiscripation.text = [[resultArray objectAtIndex:indexPath.row]valueForKey:@"caption"];
            }
            
            
            CGSize boundingSize = CGSizeMake(260, 10000000);
            
            CGRect itemTextSize = [userDiscripation.text boundingRectWithSize:boundingSize
                                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                                   attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}
                                                                      context:nil];
            
            CGSize size = itemTextSize.size;
            
            float textHeight = size.height+10;
             imageForPhoto = [[UIImageView alloc]init];
            
            if ([[[resultArray objectAtIndex:indexPath.row]valueForKey:@"event_title"] isKindOfClass:[NSNull class]] || [[[resultArray objectAtIndex:indexPath.row]valueForKey:@"event_title"] isEqualToString:@""])
            {
                cell.labelEventName.text = @" --";
                userDiscripation.frame = CGRectMake(5, 5,self.view.frame.size.width-20, textHeight);
            }
            else{
                userDiscripation.frame = CGRectMake(5, CGRectGetMaxY(cell.labelEventType.frame),self.view.frame.size.width-26, textHeight);
            }
            
            [cell.viewBackGround addSubview:userDiscripation];
           
            
            if ([[[resultArray objectAtIndex:indexPath.row]valueForKey:@"media_url"]isKindOfClass:[NSNull class]] ) {
                
            }
            else
            {
            
            [imageForPhoto sd_setImageWithURL:[NSURL URLWithString:[[resultArray objectAtIndex:indexPath.row]valueForKey:@"media_url"]] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
                
            }
            
           //adding user comment to cast photo
            if ([[[resultArray objectAtIndex:indexPath.row]valueForKey:@"comment_data"] isKindOfClass:[NSDictionary class]]) {
                
                
                //dynamic Height for commenttextview
                NSString * tepmString = [NSString stringWithFormat:@"%@:%@",[[[resultArray objectAtIndex:indexPath.row]valueForKey:@"comment_data"]valueForKey:@"latest_commented_by"], [[[resultArray objectAtIndex:indexPath.row]valueForKey:@"comment_data"]valueForKey:@"latest_comment"]];
                
                CGSize boundingSize = CGSizeMake(260, 10000000);
                
                CGRect itemTextSize = [tepmString boundingRectWithSize:boundingSize
                                                               options:NSStringDrawingUsesLineFragmentOrigin
                                                            attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]}
                                                               context:nil];
                
                
                CGSize size = itemTextSize.size;
                float texttextHeight = size.height;
                
                
                if (self.view.frame.size.width == 768) {
                    
                    if ([[[resultArray objectAtIndex:indexPath.row]valueForKey:@"event_title"] isKindOfClass:[NSNull class]] || [[[resultArray objectAtIndex:indexPath.row]valueForKey:@"event_title"] isEqualToString:@""])
                    {
                       
                        imageForPhoto.frame = CGRectMake(5, CGRectGetMaxY(userDiscripation.frame), self.view.frame.size.width-20, 504+50);
                    }
                    else{
                       imageForPhoto.frame = CGRectMake(5, CGRectGetMaxY(userDiscripation.frame)+5, self.view.frame.size.width-20, 504);
                    }
                    
                    
                }
                else{
                    
                    if ([[[resultArray objectAtIndex:indexPath.row]valueForKey:@"event_title"] isKindOfClass:[NSNull class]] || [[[resultArray objectAtIndex:indexPath.row]valueForKey:@"event_title"] isEqualToString:@""])
                    {
                        
                        imageForPhoto.frame = CGRectMake(5, CGRectGetMaxY(userDiscripation.frame)+5, self.view.frame.size.width-20, 304+50);
                    }
                    else{
                       imageForPhoto.frame = CGRectMake(5, CGRectGetMaxY(userDiscripation.frame)+5, self.view.frame.size.width-20, 304);
                    }
                    
                }
                UITextView * commentTextView= [[UITextView alloc]init];
                
                commentTextView.frame =  CGRectMake(3, CGRectGetMaxY(imageForPhoto.frame)+1, self.view.frame.size.width-16, texttextHeight+15);
                
                [cell.viewBackGround addSubview:commentTextView];
                commentTextView.text = tepmString;
                
                commentTextView.backgroundColor =[UIColor clearColor];
                
                commentTextView.font = [UIFont systemFontOfSize:12];
                
                commentTextView.scrollEnabled = NO;
                
                commentTextView.editable = NO;

               
            }
            
            //no comment data for pohot
            else{
                
                
                if (self.view.frame.size.width == 768) {
                    
                    
                    if ([[[resultArray objectAtIndex:indexPath.row]valueForKey:@"event_title"] isKindOfClass:[NSNull class]] || [[[resultArray objectAtIndex:indexPath.row]valueForKey:@"event_title"] isEqualToString:@""])
                    {
                        
                        imageForPhoto.frame = CGRectMake(5, CGRectGetMaxY(userDiscripation.frame)+5, self.view.frame.size.width-20, 504+50);
                    }
                    else{
                        imageForPhoto.frame = CGRectMake(5, CGRectGetMaxY(userDiscripation.frame)+5, self.view.frame.size.width-20, 504);
                    }
                   
                    
                }
                else{
                    
                    
                    
                    if ([[[resultArray objectAtIndex:indexPath.row]valueForKey:@"event_title"] isKindOfClass:[NSNull class]] || [[[resultArray objectAtIndex:indexPath.row]valueForKey:@"event_title"] isEqualToString:@""])
                    {
                        
                        imageForPhoto.frame = CGRectMake(5, CGRectGetMaxY(userDiscripation.frame)+5, self.view.frame.size.width-20, 304+50);
                    }
                    else{
                        imageForPhoto.frame = CGRectMake(5, CGRectGetMaxY(userDiscripation.frame)+5, self.view.frame.size.width-20, 304);
                    }
                }
                
                
            }
            
          
            
            [cell.viewBackGround addSubview:imageForPhoto];
            cell.playButton.hidden = YES;
            userDiscripation.scrollEnabled = NO;
            userDiscripation = nil;
        }
        
        else if ([category isEqualToString:@"user_videos_data"])
        {
            
            cell.playButton.hidden = NO;
            cell.playButton.tag = indexPath.row;
            [cell.playButton addTarget:self action:@selector(playeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            UITextView * userDiscripation = [[UITextView alloc]init];
            
            userDiscripation.text = [[resultArray objectAtIndex:indexPath.row]valueForKey:@"caption"];
            
            CGSize boundingSize = CGSizeMake(260, 10000000);
            
            CGRect itemTextSize = [userDiscripation.text boundingRectWithSize:boundingSize
                                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                                   attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}
                                                                      context:nil];
            
            CGSize size = itemTextSize.size;
            
            float textHeight = size.height+10;
            if ([[[resultArray objectAtIndex:indexPath.row]valueForKey:@"event_title"] isKindOfClass:[NSNull class]] || [[[resultArray objectAtIndex:indexPath.row]valueForKey:@"event_title"] isEqualToString:@""])
            {
                cell.labelEventName.text = @" --";
                userDiscripation.frame = CGRectMake(5, 5,self.view.frame.size.width-20, textHeight);
            }
            else{
                userDiscripation.frame = CGRectMake(5, CGRectGetMaxY(cell.labelEventType.frame),self.view.frame.size.width-26, textHeight);
            }

            
            imageForPhoto = [[UIImageView alloc]init];
            

            [imageForPhoto sd_setImageWithURL:[NSURL URLWithString:[[resultArray objectAtIndex:indexPath.row]valueForKey:@"media_thumb_url"]] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
          
            if (self.view.frame.size.width == 768) {
                
                if ([[[resultArray objectAtIndex:indexPath.row]valueForKey:@"event_title"] isKindOfClass:[NSNull class]] || [[[resultArray objectAtIndex:indexPath.row]valueForKey:@"event_title"] isEqualToString:@""])
                {
                    
                    imageForPhoto.frame = CGRectMake(5, CGRectGetMaxY(userDiscripation.frame), self.view.frame.size.width-20, 504+50);
                }
                else{
                    imageForPhoto.frame = CGRectMake(5, CGRectGetMaxY(userDiscripation.frame)+5, self.view.frame.size.width-20, 504);
                }
                
                
            }
            else{
                
                if ([[[resultArray objectAtIndex:indexPath.row]valueForKey:@"event_title"] isKindOfClass:[NSNull class]] || [[[resultArray objectAtIndex:indexPath.row]valueForKey:@"event_title"] isEqualToString:@""])
                {
                    
                    imageForPhoto.frame = CGRectMake(5, CGRectGetMaxY(userDiscripation.frame)+5, self.view.frame.size.width-20, 304+50);
                }
                else{
                    imageForPhoto.frame = CGRectMake(5, CGRectGetMaxY(userDiscripation.frame)+5, self.view.frame.size.width-20, 304);
                }
                
            }

            
            userDiscripation.scrollEnabled = NO;
            
            [cell.viewBackGround addSubview:userDiscripation];
            
            [cell.viewBackGround addSubview:imageForPhoto];
            
            userDiscripation = nil;
            
            
        }
        else if ([category isEqualToString:@"user_casts_data"])
        {
            
            
            UITextView * userDiscripation = [[UITextView alloc]init];
            
            userDiscripation.text = [[resultArray objectAtIndex:indexPath.row]valueForKey:@"caption"];
            
            CGSize boundingSize = CGSizeMake(260, 10000000);
            
            CGRect itemTextSize = [userDiscripation.text boundingRectWithSize:boundingSize
                                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                                   attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}
                                                                      context:nil];
            
            CGSize size = itemTextSize.size;
            
            float textHeight = size.height+10;
            
            userDiscripation.frame = CGRectMake(5, CGRectGetMaxY(cell.labelEventType.frame),self.view.frame.size.width-26, textHeight);
            userDiscripation.scrollEnabled = NO;
            [cell.viewBackGround addSubview:userDiscripation];
            userDiscripation = nil;
            cell.playButton.hidden = YES;
            
        }
        
        
        [self cropimageView:imageForPhoto];
        
        imageForPhoto = nil;
        
       
        if ([[[resultArray objectAtIndex:indexPath.row]valueForKey:@"is_user_liked"] isEqualToString:@"0"])
        {
            [cell.buttonChress setImage:[UIImage imageNamed:@"mega_phone120X120.png"] forState:UIControlStateNormal];
        }
        else
        {
            [cell.buttonChress setImage:[UIImage imageNamed:@"mega_phone_cheer120X120.png"] forState:UIControlStateNormal];
        }
        
        if (appdelegate.isfromNotificationScreen == YES || (appdelegate.profileViewNavAccount == 3) || self.isMediaFromNotification == YES) {
            cell.buttonEdit.hidden = YES;
            cell.buttonTrash.hidden = YES;
            cell.buttonShare.hidden = YES;

        }
        
       
        else{
            
            
            cell.buttonTrash.tag  = indexPath.row;
            cell.buttonEdit.tag = indexPath.row;
            cell.buttonShare.tag = indexPath.row;
            
            [cell.buttonEdit addTarget:self action:@selector(cellEditButtonClicekd:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.buttonTrash addTarget:self action:@selector(cellDeleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            
             [cell.buttonShare addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
        cell.buttonChress.tag = indexPath.row;
        cell.buttonComment.tag = indexPath.row;
        
        [cell.buttonChress addTarget:self action:@selector(cheersButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.buttonComment addTarget:self action:@selector(commentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        //cellButton Targe Action
        if ([[[resultArray objectAtIndex:indexPath.row]valueForKey:@"formatted_address"] isKindOfClass:[NSNull class]] || [[[resultArray objectAtIndex:indexPath.row]valueForKey:@"formatted_address"] isEqualToString:@""])
        {
            cell.labelAddress.text = @" --";
           
        }
        else{
            cell.labelAddress.text = [[resultArray objectAtIndex:indexPath.row]valueForKey:@"formatted_address"];
            
        }
        if ([[[resultArray objectAtIndex:indexPath.row]valueForKey:@"event_title"] isKindOfClass:[NSNull class]] || [[[resultArray objectAtIndex:indexPath.row]valueForKey:@"event_title"] isEqualToString:@""])
        {
            cell.labelEventName.text = @" --";
           
        }
        else{
            cell.labelEventName.text = [[resultArray objectAtIndex:indexPath.row]valueForKey:@"event_title"];
            
        }
        if ([[[resultArray objectAtIndex:indexPath.row]valueForKey:@"sport_name"] isKindOfClass:[NSNull class]] || [[[resultArray objectAtIndex:indexPath.row]valueForKey:@"sport_name"] isEqualToString:@""])
        {
            cell.labelEventType.text = @" --";
            
        }
        
        else{
            
            cell.labelEventType.text = [[resultArray objectAtIndex:indexPath.row]valueForKey:@"sport_name"];
           
        }
        
        
        cell.labelChress.text = [NSString stringWithFormat:@"%@ Cheers",[[resultArray objectAtIndex:indexPath.row]valueForKey:@"likes_count"]];
        
        cell.labelCommnet.text = [NSString stringWithFormat:@"%@ Comments",[[resultArray objectAtIndex:indexPath.row]valueForKey:@"comments_count"]];
        
        
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor = [UIColor clearColor];
        return cell;

    }
    
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == tableCommnet)
    {
        
        NSString *messageText;
        if ([[[arrayComment objectAtIndex:indexPath.row]valueForKey:@"comment_content"] isKindOfClass:[NSNull class]]){
            messageText = @"";
        }
        else{
            messageText =[[arrayComment objectAtIndex:indexPath.row]valueForKey:@"comment_content"];
        }
        CGSize boundingSize = CGSizeMake(260, 10000000);
        
        CGRect itemTextSize = [messageText boundingRectWithSize:boundingSize
                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                     attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}
                                                        context:nil];
        
        CGSize size = itemTextSize.size;
        
        float textHeight = size.height+1+50+5+20;
        
        return textHeight;
        
    }
    
    else {
        NSString *messageText;
        float textHeight;
//        MyPostCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        
        if ([[[resultArray objectAtIndex:indexPath.row]valueForKey:@"caption"]isKindOfClass:[NSNull class]])
        {
            messageText =@"";
        }
        else
        {
            messageText = [[resultArray objectAtIndex:indexPath.row]valueForKey:@"caption"];
        }
        
        
        NSString * category = [[resultArray objectAtIndex:indexPath.row]valueForKey:@"category"];
        
        
        CGSize boundingSize = CGSizeMake(260, 10000000);
        
        CGRect itemTextSize = [messageText boundingRectWithSize:boundingSize
                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                     attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}
                                                        context:nil];
        
        CGSize size = itemTextSize.size;
        
        if ([category isEqualToString:@"user_photos_data"]) {
            
            float commenttextHeight;
            
            if ([[[resultArray objectAtIndex:indexPath.row]valueForKey:@"comment_data"] isKindOfClass:[NSDictionary class]]) {
               
                NSString * tepmString = [NSString stringWithFormat:@"%@:%@",[[[resultArray objectAtIndex:indexPath.row]valueForKey:@"comment_data"]valueForKey:@"latest_commented_by"], [[[resultArray objectAtIndex:indexPath.row]valueForKey:@"comment_data"]valueForKey:@"latest_comment"]];
                
                CGSize boundingSize = CGSizeMake(260, 10000000);
                
                CGRect itemTextSize = [tepmString boundingRectWithSize:boundingSize
                                                               options:NSStringDrawingUsesLineFragmentOrigin
                                                            attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]}
                                                               context:nil];
                
                CGSize commentsize = itemTextSize.size;
                
                commenttextHeight = commentsize.height+15;
                if (self.view.frame.size.width == 768) {
                    textHeight = size.height+31+21+504+30+30+commenttextHeight;
                }
                else{
                    textHeight = size.height+31+21+304+30+30+commenttextHeight;
                }
                
            }
            else{
                
                if (self.view.frame.size.width == 768) {
                   textHeight = size.height+31+21+504+30+30;
                }
                else{
                   textHeight = size.height+31+21+304+30+30;
                }
                
                
            }
            
            
        }
        else if ([category isEqualToString:@"user_casts_data"]){
            textHeight = size.height+40+70;
        }
        else if ([category isEqualToString:@"user_videos_data"])
        {
            
            if (self.view.frame.size.width == 768) {
                textHeight = size.height+31+21+504+30+30;
            }
            else{
                textHeight = size.height+31+21+304+30+30;
            }
            

//            textHeight = size.height+31+21+304+30+30;
        }
        
        
        return textHeight;
        
    }
    
   
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)backButtonClicked:(id)sender {
    
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)cropimageView:(UIImageView*)imageView
{
    imageView.layer.contents = (__bridge id)(imageView.image.CGImage);
    imageView.layer.contentsGravity = kCAGravityResizeAspectFill;
    imageView.layer.contentsScale = imageView.image.scale;
    imageView.layer.masksToBounds = YES;
    
    
}

#pragma mark - scrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView

{
    if (isComment == YES||isSendButtonClicked == YES || isCommnetDelete == YES)
    {
        
    }
    else
    {
        CGFloat contentOffsetY = scrollView.contentOffset.y;
        
        CGFloat maxcontentOffSet = scrollView.contentSize.height - scrollView.frame.size.height;
        
        if ((maxcontentOffSet-contentOffsetY)<=50)
            
        {
            
            pageId = pageId+1;
         
            if (appdelegate.isfromNotificationScreen ==  YES) {
                
               [self serviceRequestForSelecteTyped:self.eventCastType WithUserId:appdelegate.notificationSelectedId WithLoginId:[[NSUserDefaults standardUserDefaults]valueForKey:@"loginId"] andPageIndex:pageId];
                
            }
            else{
                
                if (appdelegate.profileViewNavAccount == 3)
                {
                    [self serviceRequestForSelecteTyped:self.eventCastType WithUserId:appdelegate.profileSelectedUserId WithLoginId:[[NSUserDefaults standardUserDefaults]valueForKey:@"loginId"] andPageIndex:pageId];
                    
                }
                else if (self.isMediaFromNotification == YES){
                    
                }
                else{
                    
                    [self serviceRequestForSelecteTyped:self.eventCastType WithUserId:[[NSUserDefaults standardUserDefaults]valueForKey:@"loginId"] WithLoginId:[[NSUserDefaults standardUserDefaults]valueForKey:@"loginId"] andPageIndex:pageId];
                    
                }
            }
          
        }
    }
  
}

#pragma mark - buttonActions

-(void)playeButtonClicked:(UIButton *)button
{
   
    PlayerViewController * playerVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PlayerViewController"];
    if (button.tag) {
       playerVC.videoUrl = [NSURL URLWithString:[[resultArray objectAtIndex:button.tag]valueForKey:@"media_url"]];
    }
    else{
        
        playerVC.videoUrl = [NSURL URLWithString:[[resultArray objectAtIndex:0]valueForKey:@"media_url"]];
    }
    
    self.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:playerVC animated:YES];
 
}


-(void)cheersButtonClicked:(UIButton *)button
{
    
    
    ischeers = YES;
    
    cheeresIndex = button.tag;
    
    NSString * category = [[resultArray objectAtIndex:button.tag]valueForKey:@"category"];
    NSString * castType ;
   
    
    
    if ([category isEqualToString:@"user_photos_data"])
    {
        castType = @"photo";
        mediaType = @"event_post";
    }
    else if ([category isEqualToString:@"user_casts_data"])
    {
        castType = @"cast";
        mediaType = @"cast";
    }
    else if ([category isEqualToString:@"user_videos_data"])
    {
        castType = @"video";
        mediaType = @"event_post";
    }
    
    
    
    likeCount = [[[resultArray objectAtIndex:button.tag]valueForKey:@"likes_count"]integerValue];
    
    if ([[[resultArray objectAtIndex:button.tag]valueForKey:@"is_user_liked"] isEqualToString:@"0"])
    {
        isLikedString = @"1";
   
        if ([appdelegate connectedToInternet])
        {
            [appdelegate startIndicator];
            
        
                
                if (appdelegate.profileViewNavAccount == 3 || self.isMediaFromNotification == YES || appdelegate.isfromNotificationScreen == YES )
                {
                   [jsonobjc getMethodforServiceRequest:[NSString stringWithFormat:@"%@update_event_media_cheer.php?user_id=%@&pn_user_id=%@&media_id=%@&media_type=%@&cheer_status=true&category=event&category_type=%@",commonURL,[[NSUserDefaults standardUserDefaults]valueForKey:@"loginId"],appdelegate.profileSelectedUserId,[[resultArray objectAtIndex:button.tag]valueForKey:@"media_id"],mediaType,castType]];
                }
                else{
                    
                     [jsonobjc getMethodforServiceRequest:[NSString stringWithFormat:@"%@update_event_media_cheer.php?user_id=%@&pn_user_id=%@&media_id=%@&media_type=%@&cheer_status=true&category=event&category_type=%@",commonURL,[[NSUserDefaults standardUserDefaults]valueForKey:@"loginId"],[[NSUserDefaults standardUserDefaults]valueForKey:@"loginId"],[[resultArray objectAtIndex:button.tag]valueForKey:@"media_id"],mediaType,castType]];
                }
            }
       
        
        [button setImage:[UIImage imageNamed:@"mega_phone_cheer120X120.png"] forState:UIControlStateNormal];
        likeCount = likeCount+1;
    }
    else
    {
        isLikedString = @"0";
        
        [appdelegate startIndicator];
        
        if (appdelegate.profileViewNavAccount == 3 || self.isMediaFromNotification == YES || appdelegate.isfromNotificationScreen == YES )
        {
            [jsonobjc getMethodforServiceRequest:[NSString stringWithFormat:@"%@update_event_media_cheer.php?user_id=%@&pn_user_id=%@&media_id=%@&media_type=%@&cheer_status=false&category=event&category_type=%@",commonURL,[[NSUserDefaults standardUserDefaults]valueForKey:@"loginId"],appdelegate.profileSelectedUserId,[[resultArray objectAtIndex:button.tag]valueForKey:@"media_id"],mediaType,castType]];
        }
        else{
            
            [jsonobjc getMethodforServiceRequest:[NSString stringWithFormat:@"%@update_event_media_cheer.php?user_id=%@&pn_user_id=%@&media_id=%@&media_type=%@&cheer_status=false&category=event&category_type=%@",commonURL,[[NSUserDefaults standardUserDefaults]valueForKey:@"loginId"],[[NSUserDefaults standardUserDefaults]valueForKey:@"loginId"],[[resultArray objectAtIndex:button.tag]valueForKey:@"media_id"],mediaType,castType]];
        }
        
        
        
        [button setImage:[UIImage imageNamed:@"mega_phone120X120.png"] forState:UIControlStateNormal];
        likeCount = likeCount-1;
       
    }
   
    
    
    
    
    
    
}

-(void)commentButtonClicked:(UIButton *)button
{
     commentMediaId = [[resultArray objectAtIndex:button.tag]valueForKey:@"media_id"];
     mediaType = [[resultArray objectAtIndex:button.tag]valueForKey:@"category"];
    
    if ([mediaType isEqualToString:@"user_casts_data"])
    {
        commentMediaType = @"cast";
        categorytype = @"cast";
    }
    else{
        if ([mediaType isEqualToString:@"user_photos_data"])
        {
            categorytype = @"photo";
            
        }
        else
        {
            categorytype = @"video";
            
        }
        commentMediaType = @"event_post";
    }
    
    isComment = YES;
    
    viewBlackLayer = [[UIView alloc]init];
    viewBlackLayer.frame = self.view.frame;
    [self.view addSubview:viewBlackLayer];
    viewBlackLayer.backgroundColor = [UIColor blackColor];
    viewBlackLayer.alpha = 0.5;
    
    commentView = [[UIView alloc]initWithFrame:CGRectMake(10, 62, self.view.frame.size.width-20, self.view.frame.size.height-124)];
    commentView.layer.cornerRadius = 15;
    commentView.backgroundColor = [UIColor whiteColor];
    
    buttonClose = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    
    [buttonClose setImage:[UIImage imageNamed:@"crossround.png"] forState:UIControlStateNormal];
    [buttonClose setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonClose addTarget:self action:@selector(closeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    UITextField * textFiledComment = [[UITextField alloc]initWithFrame:CGRectMake(10, CGRectGetHeight(commentView.frame)-40, CGRectGetWidth(commentView.frame)-60, 30)];
    textFiledComment.placeholder = @"Enter comment";
    textFiledComment.borderStyle = UITextBorderStyleBezel;
    UIButton * buttonSend = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(textFiledComment.frame)+10, CGRectGetHeight(commentView.frame)-50, 50, 50)];
    
    textFiledComment.delegate = self;
    
    [buttonSend setImage:[UIImage imageNamed:@"send.png"] forState:UIControlStateNormal];
    [buttonSend addTarget:self action:@selector(sendButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [commentView addSubview:buttonSend];
    [commentView addSubview:textFiledComment];
    [commentView addSubview:buttonClose];
    [self.view addSubview:commentView];
    
    //   http://182.75.34.62/MySportsShare/web_services/get_event_media_comments.php?media_id=376&media_type=cast
    if (tableCommnet == nil)
    {
        tableCommnet = [[UITableView alloc]initWithFrame:CGRectMake(5, 30, commentView.frame.size.width-10, commentView.frame.size.height-75)];
        
        tableCommnet.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    else
    {
        
    }
    
    if ([appdelegate connectedToInternet])
    {
        [jsonobjc getMethodforServiceRequest:[NSString stringWithFormat:@"%@get_event_media_comments.php?media_id=%@&media_type=%@",commonURL,commentMediaId,commentMediaType]];
    }
    else
    {
        [self alertViewShow:@"No internet Connection"];
    }
    
    [commentView addSubview:tableCommnet];
    buttonSend = nil;
    textFiledComment = nil;
    
    
    
}

-(void)closeButtonAction
{
    [commentView removeFromSuperview];
    [viewBlackLayer removeFromSuperview];
    viewBlackLayer = nil;
    commentView = nil;
    buttonClose = nil;
    ischeers = NO;
    isSendButtonClicked = NO;
    isComment = NO;
    isCommnetDelete = NO;
    commentStringTF = @"";
    [self removingObjectsFromCastArrays];
    
    [self webServiceRequest];
    pageId = 0;
    
    
}

-(void)webServiceRequest
{
    resultArray =[[NSMutableArray alloc]init];
    
    [appdelegate startIndicator];
    
    if (appdelegate.isfromNotificationScreen == YES) {
      
        [self serviceRequestForSelecteTyped:self.eventCastType WithUserId:appdelegate.notificationSelectedId WithLoginId:[[NSUserDefaults standardUserDefaults]valueForKey:@"loginId"] andPageIndex:0];
        
    }
    else if (self.isMediaFromNotification == YES)
    {
//       http://182.75.34.62/MySportsShare/web_services/get_media_detail.php?user_id=298&media_id=26&media_type=cast&resource_type=profile
        
        
        [jsonobjc getMethodforServiceRequest:[NSString stringWithFormat:@"%@get_media_detail.php?user_id=%@&media_id=%@&media_type=%@&resource_type=event",commonURL,[[NSUserDefaults standardUserDefaults]valueForKey:@"loginId"],self.mediaIdFormNotifcationScreen,[self.labelNavTitle.text lowercaseString]]];
        
        
    }
   
    else{
        
        if (appdelegate.profileViewNavAccount == 3)
          {
            
            [self serviceRequestForSelecteTyped:self.eventCastType WithUserId:appdelegate.profileSelectedUserId WithLoginId:[[NSUserDefaults standardUserDefaults]valueForKey:@"loginId"] andPageIndex:0];
            
               }
        
        else{
            
            [self serviceRequestForSelecteTyped:self.eventCastType WithUserId:[[NSUserDefaults standardUserDefaults]valueForKey:@"loginId"] WithLoginId:[[NSUserDefaults standardUserDefaults]valueForKey:@"loginId"] andPageIndex:0];
        }
    }
  
}

-(void)removingObjectsFromCastArrays
{
    [resultArray removeAllObjects];
}
-(void)sendButtonClicked
{
    isComment = NO;
    isSendButtonClicked =YES;
    
   
    
    
    // http://182.75.34.62/MySportsShare/web_services/add_event_media_comment.php
    
    if (commentStringTF.length == 0)
    {
        [self alertViewShow:@"Please enter Comment"];
    }
    else
    {
        NSString * parameterString;
        
        if (appdelegate.profileViewNavAccount == 3 || self.isMediaFromNotification == YES || appdelegate.isfromNotificationScreen == YES )
        {
            parameterString = [NSString stringWithFormat:@"user_id=%@&pn_user_id=%@&media_type=%@&media_id=%@&comment_content=%@&category=event&category_type=%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"loginId"],appdelegate.profileSelectedUserId,commentMediaType,commentMediaId,commentStringTF,categorytype];
        }
        else{
            parameterString = [NSString stringWithFormat:@"user_id=%@&pn_user_id=%@&media_type=%@&media_id=%@&comment_content=%@&category=event&category_type=%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"loginId"],[[NSUserDefaults standardUserDefaults]valueForKey:@"loginId"],commentMediaType,commentMediaId,commentStringTF,categorytype];
            
        }
        
        
        parameterString = [parameterString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSData* data = [parameterString dataUsingEncoding:NSUTF8StringEncoding];
        
        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@add_event_media_comment.php",commonURL]];
        
        [jsonobjc postMethodForServiceRequestWithPostData:data andWithPostUrl:url];

      }
   }

-(void)commentDeleteButtonClicked:(UIButton *)button
{
    
    
    //    http://182.75.34.62/MySportsShare/web_services/delete_comment.php?media_id=66&media_type=event_post
    
    deletedIndex =button.tag;
    
    isCommnetDelete = YES;
    ischeers = NO;
    isComment = NO;
    isSendButtonClicked = NO;
   
    commentMediaId = [[arrayComment objectAtIndex:button.tag]valueForKey:@"comment_id"];
    
    
    if ([appdelegate connectedToInternet])
    {
//        [jsonobjc getMethodforServiceRequest:[NSString stringWithFormat:@"http://182.75.34.62/MySportsShare/web_services/delete_comment.php?media_id=%@&media_type=%@",commentMediaId,commentMediaType]];
        
        
        [jsonobjc getMethodforServiceRequest:[NSString stringWithFormat:@"%@%@media_id=%@&media_type=%@",commonURL,deleteComment,commentMediaId,commentMediaType]];
    }
    else
    {
        [self alertViewShow:@"UnableToDelete"];
    }
    
}

#pragma mark - textFiledDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (iscellPostEdit == YES)
    {
        [UIView animateWithDuration:0.3 animations:^{
            
            editView.frame = CGRectMake(10, -kKeyboardOffsetY+30, editView.frame.size.width, editView.frame.size.height);
        }];
    }
    else{
        [UIView animateWithDuration:0.3 animations:^{
            
            commentView.frame = CGRectMake(10, -kKeyboardOffsetY, commentView.frame.size.width, commentView.frame.size.height);
        }];
    }
    
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    
    if (iscellPostEdit == YES)
    {
        [UIView animateWithDuration:0.3 animations:^{
            
            editView.frame = CGRectMake(10, self.view.frame.size.height/2-(self.view.frame.size.height/2)/2, editView.frame.size.width, editView.frame.size.height);
        }];
    }
    else{
        [UIView animateWithDuration:0.3 animations:^{
            
            commentView.frame = CGRectMake(10, 64, commentView.frame.size.width, commentView.frame.size.height);
        }];
    }
    
    
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    commentStringTF = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - DeleteAndEditButtonActions

-(void)cellEditButtonClicekd:(UIButton *)button
{
    iscellPostEdit = YES;
    
    deletedIndex = button.tag;
    
    UIButton * playButton;
    
    UITextField * textFiledCapation;
    
    UIButton * cancelButon;
    
    UIButton * doneButton;
    
    
    mediaId = [[resultArray objectAtIndex:button.tag]valueForKey:@"media_id"];
   
    tempBackGround = [[UIView alloc]initWithFrame:self.view.frame];
    
    tempBackGround.backgroundColor = [UIColor blackColor];
    
    tempBackGround.alpha = 0.5;
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeingEditView)];
    
    [tempBackGround addGestureRecognizer:tapGesture];
    
     editView = [[UIView alloc]initWithFrame:CGRectMake(10, self.view.frame.size.height/2-(self.view.frame.size.height/2)/2, self.view.frame.size.width-20, self.view.frame.size.height/2+120)];
    
    editView.layer.cornerRadius = 10;
    
    [editView setBackgroundColor:[UIColor whiteColor]];
    
    
    UIButton * closeButtonForEdit = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    
    [closeButtonForEdit setImage:[UIImage imageNamed:@"crossround.png"] forState:UIControlStateNormal];
    
    [closeButtonForEdit addTarget:self action:@selector(removeingEditView) forControlEvents:UIControlEventTouchUpInside];
    labelForEditTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, editView.frame.size.width-20, 43)];
    
    labelForEditTitle.textColor = [UIColor blackColor];
    
    labelForEditTitle.textAlignment = NSTextAlignmentCenter;
    
    if ([[[resultArray objectAtIndex:button.tag]valueForKey:@"category"] isEqualToString:@"user_photos_data"] ) {
        
        mediaType = @"event_post";
        
        
        labelForEditTitle.text = @"Edit photo";
        imageViewEdit = [[UIImageView alloc]initWithFrame:CGRectMake(10, 45, editView.frame.size.width-20, (editView.frame.size.height)-150)];
        
        [imageViewEdit sd_setImageWithURL:[NSURL URLWithString:[[resultArray objectAtIndex:deletedIndex]valueForKey:@"media_url"]]];
        
        
        textFiledCapation = [[UITextField alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(imageViewEdit.frame)+5, editView.frame.size.width-20, 40)];
        
        if ([[[resultArray objectAtIndex:deletedIndex]valueForKey:@"caption"]isKindOfClass:[NSNull class]])
        {
            textFiledCapation.text = @"";
        }
        else
        {
            textFiledCapation.text = [[resultArray objectAtIndex:deletedIndex]valueForKey:@"caption"];
            
            
        }
        
        textFiledCapation.textColor = [UIColor blackColor];
        
        textFiledCapation.borderStyle = UITextBorderStyleBezel;
        
        cancelButon = [[UIButton alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(textFiledCapation.frame)+5, (editView.frame.size.width/2)-10, 40)];
        
        doneButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(cancelButon.frame)+5, CGRectGetMaxY(textFiledCapation.frame)+5, (editView.frame.size.width/2)-15, 40)];
        
        cancelButon.backgroundColor = [UIColor blackColor];
        doneButton.backgroundColor = [UIColor blackColor];
        
        [cancelButon addTarget:self action:@selector(editEvetnViewCancelButtonCliceked) forControlEvents:UIControlEventTouchUpInside];
        
        [doneButton addTarget:self action:@selector(editEvetViewnDoneButtonClicekd) forControlEvents:UIControlEventTouchUpInside];
       
        
    }
    else if ([[[resultArray objectAtIndex:button.tag]valueForKey:@"category"] isEqualToString:@"user_videos_data"])
    {
        labelForEditTitle.text = @"Edit video";
        mediaType = @"event_post";
        
        imageViewEdit = [[UIImageView alloc]initWithFrame:CGRectMake(10, 45, editView.frame.size.width-20, (editView.frame.size.height)-150)];
        
        [imageViewEdit sd_setImageWithURL:[NSURL URLWithString:[[resultArray objectAtIndex:deletedIndex]valueForKey:@"media_url"]]];
        
        playButton = [[UIButton alloc]initWithFrame:CGRectMake(imageViewEdit.frame.size.width/2-20, imageViewEdit.frame.size.height/2-20, 40, 40)];
        
        [playButton setImage:[UIImage imageNamed:@"playvideo120X120.png"] forState:UIControlStateNormal];
        
        playButton.tag = button.tag;
        
        [playButton addTarget:self action:@selector(playeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        textFiledCapation = [[UITextField alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(imageViewEdit.frame)+5, editView.frame.size.width-20, 40)];
        
        if ([[[resultArray objectAtIndex:deletedIndex]valueForKey:@"caption"]isKindOfClass:[NSNull class]])
        {
            textFiledCapation.text = @"";
        }
        else
        {
            textFiledCapation.text = [[resultArray objectAtIndex:deletedIndex]valueForKey:@"caption"];
        }
        
        textFiledCapation.textColor = [UIColor blackColor];
        
        textFiledCapation.borderStyle = UITextBorderStyleBezel;
        
        cancelButon = [[UIButton alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(textFiledCapation.frame)+5, (editView.frame.size.width/2)-10, 40)];
        
        doneButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(cancelButon.frame)+5, CGRectGetMaxY(textFiledCapation.frame)+5, (editView.frame.size.width/2)-15, 40)];
        
        cancelButon.backgroundColor = [UIColor blackColor];
        doneButton.backgroundColor = [UIColor blackColor];
        
        [cancelButon addTarget:self action:@selector(editEvetnViewCancelButtonCliceked) forControlEvents:UIControlEventTouchUpInside];
        
        [doneButton addTarget:self action:@selector(editEvetViewnDoneButtonClicekd) forControlEvents:UIControlEventTouchUpInside];
       
    }
    else{
        
        
        mediaType = @"cast";
        
        labelForEditTitle.text = @"Edit cast";
        
        UILabel * infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(labelForEditTitle.frame),editView.frame.size.width-20, 40)];
        
        infoLabel.text = @"Add your own 140 characters comment and cast it";
        
        infoLabel.textColor =[UIColor blackColor];
        
        infoLabel.font = [UIFont systemFontOfSize:14];
        
        
         castTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(infoLabel.frame)+5, editView.frame.size.width-20, (editView.frame.size.height)-150)];
        castTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        castTextView.layer.borderWidth = 1.0f;
        castTextView.delegate = self;
        
        if ([[[resultArray objectAtIndex:deletedIndex]valueForKey:@"caption"]isKindOfClass:[NSNull class]])
        {
            castTextView.text = @"";
        }
        else
        {
            castTextView.text = [[resultArray objectAtIndex:deletedIndex]valueForKey:@"caption"];
        }
        
        
        cancelButon = [[UIButton alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(castTextView.frame)+5, (editView.frame.size.width/2)-10, 40)];
        
        doneButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(cancelButon.frame)+5, CGRectGetMaxY(castTextView.frame)+5, (editView.frame.size.width/2)-15, 40)];
        
        cancelButon.backgroundColor = [UIColor blackColor];
        doneButton.backgroundColor = [UIColor blackColor];
        [cancelButon addTarget:self action:@selector(editEvetnViewCancelButtonCliceked) forControlEvents:UIControlEventTouchUpInside];
       
        
        [editView addSubview:infoLabel];
        [editView addSubview:castTextView];
        
       
      
    }
    textFiledCapation.delegate = self;
    [cancelButon addTarget:self action:@selector(editEvetnViewCancelButtonCliceked) forControlEvents:UIControlEventTouchUpInside];
    
    [doneButton addTarget:self action:@selector(editEvetViewnDoneButtonClicekd) forControlEvents:UIControlEventTouchUpInside];
    [cancelButon setTitle:@"CLOSE" forState:UIControlStateNormal];
    
    [doneButton setTitle:@"DONE" forState:UIControlStateNormal];
    
    labelForEditTitle.text = [labelForEditTitle.text uppercaseString];
    
    [editView addSubview:closeButtonForEdit];
    
    [editView addSubview:imageViewEdit];
    
    [imageViewEdit addSubview:playButton];
    
    [editView addSubview:labelForEditTitle];
    
    [editView addSubview: textFiledCapation];
    
    [editView addSubview:cancelButon];
    
    [editView addSubview:doneButton];
    
    [self.view addSubview:tempBackGround];
    
    [self.view addSubview:editView];
    
    UITapGestureRecognizer * gestureForPic = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imagesGestureMethod)];
    
    imageViewEdit.userInteractionEnabled = YES;
    
    [imageViewEdit addGestureRecognizer:gestureForPic];
    
    commentStringTF = textFiledCapation.text;
    
    
    
//    imageViewEdit = nil;
    cancelButon = nil;
    doneButton = nil;
    
    
   
    
}

-(void)removeingEditView {
    
    [tempBackGround removeFromSuperview];
    
    [editView removeFromSuperview];
    editView = nil;
    imageViewEdit = nil;
    appdelegate.editImageForMyProfile = nil;
    
}

-(void)cellDeleteButtonClicked:(UIButton *)button
{
   
    
    isEventDelete = YES;
    
    deletedIndex =button.tag;
   
    mediaId = [[resultArray objectAtIndex:button.tag]valueForKey:@"media_id"];
    
    mediaType = [[resultArray objectAtIndex:button.tag]valueForKey:@"category"];
    
    if ([mediaType isEqualToString:@"user_photos_data"]  ) {
        
        mediaType = @"event_post";
        [self alertViewShow:@"Are you sure want to delete photo?"];
        
        
    }
    else if ( [mediaType isEqualToString:@"user_videos_data"])
    {
        
        mediaType = @"event_post";
        [self alertViewShow:@"Are you sure want to delete video?"];

    }
    else{
        mediaType = @"cast";
        [self alertViewShow:@"Are you sure want to delete cast?"];
    }
    
    
    
//    http://182.75.34.62/MySportsShare/web_services/delete_media.php?media_id=4346&media_type=cast
 
}


-(void)cellDeleteButtonResponceHandeler:(NSDictionary *)responceDict
{
   
    [appdelegate stopIndicators];
    
    isEventDelete = NO;
    
    if ([[[responceDict valueForKey:@"Response"]valueForKey:@"ResponseInfo"]isEqualToString:@"SUCCESS"]) {
        
        [resultArray removeObjectAtIndex:deletedIndex];
        
        NSIndexPath * indexpath = [NSIndexPath indexPathForRow:deletedIndex inSection:0];
        
        [self.tableViewMyPost cellForRowAtIndexPath:indexpath];
        
       
        
    }
    else{
        
        [self alertViewShow:@"Unable TO Delete"];
        
    }
    
    
    
}

#pragma mark - imageGesture


-(void)imagesGestureMethod
{
    
    if ([labelForEditTitle.text isEqualToString:@"EDIT VIDEO"])
    {
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            
            
            NSArray *sourceTypes = [UIImagePickerController availableMediaTypesForSourceType:imagePickController.sourceType];
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
            imagePickController.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePickController.cameraDevice=UIImagePickerControllerCameraDeviceRear;
            
            imagePickController.mediaTypes = [NSArray arrayWithObject:(NSString*)kUTTypeMovie];
            
            imagePickController.videoQuality = UIImagePickerControllerQualityTypeLow;
            
            imagePickController.videoMaximumDuration = 30;
            
            [self.navigationController presentViewController:imagePickController animated:YES completion:nil];
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
    
    else{
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"My SportsCast"
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleActionSheet]; //
        UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Take A Picture"
                                                              style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                  NSLog(@"You pressed button one");
                                                                  [self addCameraActioninMyPost];
                                                              }]; // 2
        UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"Select From Gallery"
                                                               style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                   NSLog(@"You pressed button two");
                                                                   [self addPhotoActioninMyPost];
                                                               }]; // 3
        
        UIAlertAction *thirdAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                              style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                  [alert dismissViewControllerAnimated:YES completion:nil];
                                                              }];
        
        [alert addAction:firstAction];
        [alert addAction:secondAction]; // 5
        [alert addAction:thirdAction];
        
        if (isipad()) {
            UIPopoverPresentationController *popPC = alert.popoverPresentationController;
            popPC.permittedArrowDirections = UIPopoverArrowDirectionAny;
            popPC.sourceView =editView;
            popPC.sourceRect = editView.bounds;
            [self presentViewController:alert animated:YES completion:nil];
        }else
        {
            [self presentViewController:alert animated:YES completion:nil]; //
        }
    }
}

-(void)addCameraActioninMyPost{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        imagePickController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePickController animated:YES completion:nil];
    }
}
-(void)addPhotoActioninMyPost{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        imagePickController.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickController animated:YES completion:nil];
    }
    
}

#pragma mark - imagePickerController

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex)
    {
        
        // Enable Camera to take a Snap.
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            imagePickController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePickController animated:YES completion:nil];
        }
    }
    else if (1 == buttonIndex)
    {
        // Open photo gallery to choose a picture.
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        {
            imagePickController.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePickController animated:YES completion:nil];
        }
    }
}


#pragma mark - UIPickerControllerDelegate


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    if ([labelForEditTitle.text isEqualToString:@"EDIT VIDEO"])
    {
        
        
        
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            NSURL *recordedVideoURL= [info objectForKey:UIImagePickerControllerMediaURL];
            
            
            
            if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:recordedVideoURL])
            {
                [library writeVideoAtPathToSavedPhotosAlbum:recordedVideoURL
                                            completionBlock:^(NSURL *assetURL, NSError *error){
                                            }
                 ];
            }
            
            AVAsset *asset = [AVAsset assetWithURL:recordedVideoURL];
            
            AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
            CMTime time = CMTimeMake(0, 3);
            CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
            UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
            if (thumbnail)
            {
                
                UIImage * image = [self imageResize:thumbnail andResizeTo:imageViewEdit.frame.size];
                CIImage* coreImage = image.CIImage;
                
                if (!coreImage) {
                    coreImage = [CIImage imageWithCGImage:image.CGImage];
                }
                coreImage = [coreImage imageByApplyingTransform:CGAffineTransformMakeRotation(-M_PI/2)];
                
                image = nil;
                thumbnail = nil;
                imageGenerator = nil;
                
                
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:@"video.mp4"];
                
                NSData *imageData =[NSData dataWithContentsOfURL:recordedVideoURL];
                
                [imageData writeToFile:savedImagePath atomically:NO];
                
                imageViewEdit.image = [UIImage imageWithCIImage:coreImage];
            }

        }];
        
    }
    else{
        UIImage *eventPic = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        if (eventPic!= nil)
        {
            
            
            PhotoTweaksViewController *photoTweaksViewController = [[PhotoTweaksViewController alloc] initWithImage:eventPic];
            photoTweaksViewController.delegate = self;
            photoTweaksViewController.autoSaveToLibray = NO;
            
            [picker presentViewController:photoTweaksViewController animated:YES completion:nil];
        }
        else
        {
            [self alertViewShow:@"Somthing Worng"];
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
        
        [imagePickController dismissViewControllerAnimated:YES completion:^{
            
       
            ImageFilterViewController * imageFilterVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ImageFilterViewController"];
            
            imageFilterVC.imageToEdit = croppedImage;
            imageFilterVC.isfromMyPostView = YES;
            
            
            [self.navigationController pushViewController:imageFilterVC animated:YES];
        }];
        
        
    }];
    
    
    
}

- (void)photoTweaksControllerDidCancel:(PhotoTweaksViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:nil];
    
}


#pragma mark - textViewDelegate

#define MAX_LENGTH 140


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
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


#pragma mark - DoneAndEditButtonClicked

-(void)editEvetViewnDoneButtonClicekd
{
//    media_id*, media_type*= photo or video, post_content*, category* = profile / event , media_file
    
    isEventEditDone = YES;
    if ([labelForEditTitle.text isEqualToString:@"EDIT CAST"])
    {
        if (castTextView.text.length==0) {
            
            [self alertViewShow:@"please enter comment"];
        }
        else{
            
            
            if ([appdelegate connectedToInternet])
            {
                [appdelegate startIndicator];
//                Cast_id=294&cast_info=updated
                
                NSString * postString  =[NSString stringWithFormat:@"cast_id=%@&cast_info=%@",mediaId,castTextView.text];
                NSData * postdata = [postString dataUsingEncoding:NSUTF8StringEncoding];
                
                NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",commonURL,upDateCast]];
                [jsonobjc postMethodForServiceRequestWithPostData:postdata andWithPostUrl:url];
                
                
                
                
                
            }
        }
    }
    else{
        NSMutableDictionary * postDic;
        
        postDic = [[NSMutableDictionary alloc]init];
        
        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",commonURL,upDateEventMedia]];
        
        if ([labelForEditTitle.text isEqualToString:@"EDIT VIDEO"])
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
            NSData *imageData;
            // imageView is my image from camera
            if (appdelegate.editImageForMyProfile) {
                
               imageData = UIImageJPEGRepresentation(appdelegate.editImageForMyProfile, 0.9f);
                
                
            }
            else{
                
               imageData = UIImageJPEGRepresentation(imageViewEdit.image, 0.9f);
            }
            
           [imageData writeToFile:mediaFile atomically:NO];
            
            
//            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//            NSString *documentsDirectory = [paths objectAtIndex:0];
//            mediaFile = [documentsDirectory stringByAppendingPathComponent:@"savedImage.png"];
            
            [postDic setObject:mediaFile forKey:@"media_file"];
            
            [postDic setObject:@"photo" forKey:@"media_type"];
        }
        [postDic setObject:mediaId forKey:@"media_id"];
        
        
        [postDic setObject:@"profile" forKey:@"category"];
        
        if (commentStringTF.length == 0) {
            
            [self alertViewShow:@"Please post content"];
        }
        else if (mediaId.length == 0)
        {
            [self alertViewShow:@"media id not found"];
        }
        else if (mediaFile.length == 0)
        {
            [self alertViewShow:@"media file path not found"];
        }
        else{
            
            
            
            [postDic setObject:commentStringTF forKey:@"post_content"];
            
            
            
            if ([appdelegate connectedToInternet]) {
                
                [appdelegate startIndicator];
                
                [jsonobjc postRegisterDetails:postDic withImageORVideoUrl:url];
                
                postDic = nil;
                
                
                NSFileManager *fileManager = [NSFileManager defaultManager];
                
                NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                
                NSString *filePath = [documentsPath stringByAppendingPathComponent:@"savedImage.png"];
                NSError *error;
                
                if(![fileManager removeItemAtPath: filePath error:&error]) {
                    NSLog(@"Delete failed:%@", error);
                } else {
                    NSLog(@"image removed: %@", filePath);
                }
                
                
            }
            else{
                
                [self alertViewShow:@"No internet connection"];
            }
        }
    }
   
    
}

-(void)editEvetnViewCancelButtonCliceked
{
    [self removeingEditView];
    
}


@end
