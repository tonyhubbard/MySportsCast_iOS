//
//  ImageFilterViewController.m
//  MySportsCast
//
//  Created by Vardhan on 14/09/15.
//  Copyright (c) 2015 SPARSHMAC08. All rights reserved.
//

#import "ImageFilterViewController.h"
#import "GPUImage.h"
#import "AppDelegate.h"
#import "VideoOrPhotoLoadViewController.h"
#import "UIImageView+WebCache.h"
#import "MyPostViewController.h"
@interface ImageFilterViewController ()
{
    UIView * ViewsingleLine;
    UIImage *filteredImage;
    BOOL isButtonClicked;
    AppDelegate * appdelegate;
    
}
@end

@implementation ImageFilterViewController

- (void)viewDidLoad
{
    
    
    appdelegate = [UIApplication sharedApplication].delegate;
    [appdelegate startIndicator];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    
   
    
    self.filterImageView.image = self.imageToEdit;
    [self cropimageView:self.filterImageView];
    
    for (UIScrollView * scrollView in self.viewFilterButton.subviews)
    {
      
        if ([scrollView isKindOfClass:[UIScrollView class]])
        {
            [scrollView removeFromSuperview];
        }
    }
    filterScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 142)];
    [self.viewFilterButton addSubview:filterScrollView];
    
    [self filterButtonCreation:@[@"NORMAL",@"SEPIA",@"KELLY",@"AMATORKA",@"PEARL",@"AMBER",@"MAYFAIR",@"ALICE",@"ROWAN",@"DAISY"]];
    
}


-(void)filterButtonCreation:(NSArray *)filterButtonArray
{
    float xvalue = 10;
    float width = 80;
    UIButton * buttonFilter;
    UILabel * labelFilterName;
    
    
   
    for (int i = 0; i<[filterButtonArray count]; i++)
    {
        buttonFilter = [[UIButton alloc]initWithFrame:CGRectMake(xvalue, 10, width, width+20)];
        buttonFilter.tag = i;
        
       
        [buttonFilter addTarget:self action:@selector(filterButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        labelFilterName = [[UILabel alloc]initWithFrame:CGRectMake(xvalue, CGRectGetMaxY(buttonFilter.frame), width, 20)];
        labelFilterName.text = [NSString stringWithFormat:@"%@",[filterButtonArray objectAtIndex:i]];
        labelFilterName.tag = i;
        labelFilterName.textColor = [UIColor whiteColor];
        labelFilterName.textAlignment = NSTextAlignmentCenter;
        labelFilterName.font = [UIFont systemFontOfSize:14];
         xvalue = xvalue+width+10;
        [self partcularIndex:i selectedButton:buttonFilter];
        [filterScrollView addSubview:buttonFilter];
        [filterScrollView addSubview:labelFilterName];
        buttonFilter = nil;
        labelFilterName = nil;
    }
    
    
    ViewsingleLine = [[UIView alloc]initWithFrame:CGRectMake(10, 130+2, width, 2)];
    ViewsingleLine.backgroundColor = [UIColor blueColor];
    [filterScrollView addSubview:ViewsingleLine];
    
    filterScrollView.contentSize =CGSizeMake(xvalue, filterScrollView.frame.size.height);
    [appdelegate stopIndicators];
    filterScrollView = nil;
}
- (void)didReceiveMemoryWarning
{
    
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    [imageCache clearMemory];
    [imageCache clearDisk];
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)saveButtonClicked:(id)sender {
    
    if (self.isfromMyPostView == YES) {
        
        
        
        appdelegate.editImageForMyProfile = self.filterImageView.image;
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
    else{
        
        
        VideoOrPhotoLoadViewController * videoOrPhotoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"VideoOrPhotoLoadViewController"];
        
        videoOrPhotoVC.imageCast = self.filterImageView.image;
        
        if (self.fromAddMedia == YES)
        {
            videoOrPhotoVC.fromAddMedia = YES;
        }
        else
        {
            videoOrPhotoVC.fromAddMedia = NO;
        }
        
        [self.navigationController pushViewController:videoOrPhotoVC animated:YES];

 
    }
   
    
    
}


- (IBAction)backButton:(id)sender {
  
    self.imageToEdit = nil;
    
    self.filterImageView.image = nil;
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)filterButtonAction:(UIButton * )button
{
    isButtonClicked = YES;
    [self partcularIndex:button.tag selectedButton:button];
}

-(void)partcularIndex:(NSInteger)index selectedButton:(UIButton *)button
{
     UIImage *inputImage = self.imageToEdit;
   
    
    if (button.tag == 0)
    {
        filteredImage = self.imageToEdit;
    }
    else if (button.tag == 1)
    {
//        GPUImageOutput *imageOutPut = [[GPUImageOutput alloc] init];
//        filteredImage = [imageOutPut imageByFilteringImage:inputImage];
        
        GPUImageSepiaFilter * selectedFilter = [[GPUImageSepiaFilter alloc] init];
        filteredImage = [selectedFilter imageByFilteringImage:inputImage];
        selectedFilter = nil;
        
    }
    else if (button.tag == 2)
    {
        
       GPUImageEmbossFilter * selectedFilter = [[GPUImageEmbossFilter alloc] init];
        filteredImage = [selectedFilter imageByFilteringImage:inputImage];
        selectedFilter = nil;
        
    }
    else if (button.tag == 3)
    {
       GPUImageGrayscaleFilter * selectedFilter = [[GPUImageGrayscaleFilter alloc] init];
        filteredImage = [selectedFilter imageByFilteringImage:inputImage];
        selectedFilter = nil;
    }
    else if (button.tag == 4)
    {
        GPUImageAmatorkaFilter * selectedFilter = [[GPUImageAmatorkaFilter alloc] init];
        filteredImage = [selectedFilter imageByFilteringImage:inputImage];
       
        selectedFilter = nil;
    }
    else if (button.tag == 5)
    {
        GPUImageMissEtikateFilter * selectedFilter = [[GPUImageMissEtikateFilter alloc]init];
        filteredImage = [selectedFilter imageByFilteringImage:inputImage];
        selectedFilter = nil;
    }
    


    else if (button.tag == 6)
    {
      GPUImageSoftEleganceFilter *selectedFilter = [[GPUImageSoftEleganceFilter alloc]init];
        filteredImage = [selectedFilter imageByFilteringImage:inputImage];
       
      selectedFilter = nil;
        
    }
   
    else if (button.tag == 7)
    {
        
        
      GPUImageLowPassFilter * selectedFilter = [[GPUImageLowPassFilter alloc]init];
        filteredImage = [selectedFilter imageByFilteringImage:inputImage];
      selectedFilter = nil;
        
    }
   
    else if (button.tag == 8)
    {
        
        
        GPUImageHazeFilter * selectedFilter = [[GPUImageHazeFilter alloc]init];
        filteredImage = [selectedFilter imageByFilteringImage:inputImage];
        selectedFilter = nil;
    }
    
    else if (button.tag == 9)
    {
        GPUImageTiltShiftFilter*selectedFilter = [[GPUImageTiltShiftFilter alloc]init];
        
        filteredImage = [selectedFilter imageByFilteringImage:inputImage];
       selectedFilter = nil;
    }
  
   
    if (isButtonClicked == YES)
    {
        [UIView animateWithDuration:0.3 animations:^{
            
            ViewsingleLine.frame = CGRectMake(button.frame.origin.x, ViewsingleLine.frame.origin.y, ViewsingleLine.frame.size.width, ViewsingleLine.frame.size.height);
            
//            self.filterImageView.image = [self imageResize:filteredImage andResizeTo:self.filterImageView.frame.size];
            self.filterImageView.image = filteredImage;
            //[self cropimageView:self.filterImageView];
        }];
        
      isButtonClicked = NO;
        
    }
    else
    {
       
        [button setImage:[self imageResize:filteredImage andResizeTo:button.frame.size] forState:UIControlStateNormal];
       // [button setImage:filteredImage forState:UIControlStateNormal];

        //[self cropimageView:button.imageView];
    }
    

    filteredImage = nil;
    button  = nil;
    inputImage = nil;
    
   
    
}

-(void)cropimageView:(UIImageView*)imageView
{
    imageView.layer.contents = (__bridge id)(imageView.image.CGImage);
    imageView.layer.contentsGravity = kCAGravityResizeAspectFill;
    imageView.layer.contentsScale = imageView.image.scale;
    imageView.layer.masksToBounds = YES;
   
}


-(UIImage *)imageResize :(UIImage*)img andResizeTo:(CGSize)newSize
{
//    CGFloat scale = [[UIScreen mainScreen]scale];
//    
//    UIGraphicsBeginImageContextWithOptions(newSize, NO, scale);
//    
//    [img drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
//    
//    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
//    
//    UIGraphicsEndImageContext();
//    
//    return newImage;
    
    if (CGSizeEqualToSize(img.size, newSize))
    {
        return img;
    }
    
    //create drawing context
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0f);
    
    //draw
    [img drawInRect:CGRectMake(0.0f, 0.0f, newSize.width, newSize.height)];
    
    //capture resultant image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return image
    return image;
}

@end
